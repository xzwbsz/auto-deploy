import xlrd
import numpy as np
import sympy as sp
#import random

env_mach_pes = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]] #用三行六列数组代表模块的排布状态，第1行是层数，第2行是起始进程位置,第3行是核数需求
#默认定义item_id顺序为LND,ICE,WAV,GLC,ATM,OCN对应0,1,2,3,4,5
shuffle0 = []
layer_num = 0 #初始化层数
capacity_left = []#初始化每层剩余空间


lambda_1 = 5 #计算开销系数，由测试给出
lambda_1 = 2 #通信开销洗漱，由测试给出
cons = 10 #初始化及其他时间，由测试给出

def load(fname):
    table = xlrd.open_workbook(fname).sheets()[0]   # 获取第一个sheet表
    row = table.nrows                               # 行数
    col = table.ncols                               # 列数
    datamatrix = np.zeros([row, col])               # 生成一个nrows行ncols列，且元素均为0的初始矩阵
    for x in range(col):
        try:
            cols = np.matrix(table.col_values(x))   # 把list转换为矩阵进行矩阵操作
            datamatrix[:, x] = cols                 # 按列把数据存进矩阵中
        except:
            print('error while trying load datamatrix in', x,' col.')
            
    # print(datamatrix.shape)
    return datamatrix

def grad(num_core,item_id,datamatrix_left,delta):
    gradient = (datamatrix_left[num_core, item_id] - datamatrix_left[num_core-1, item_id]) / delta # 默认定义item_id顺序为LND,ICE,WAV,GLC,ATM,OCN对应0,1,2,3,4,5,6
    return gradient 

def init(datamatrix_left):    #初始化当前待排入矩阵
    global env_mach_pes
    global shuffle0
    item_num = datamatrix_left.shape[1] + 1
    min = [] #创建空数组
    for x in range(0,item_num-1):
        temp = np.min(datamatrix_left, axis=1)
        min[x] = temp[x]     #找到每个模块的最佳并行度（此处包含所有模块）
        env_mach_pes[2,x] = np.argmin(datamatrix_left[:,x]) #给出每个模块最佳并行度
    min1 = min[0:3] #取前四个，即LND,ICE,WAV,GLC
    shuffle0 = np.lexsort(min1)   #按从小到大排列并输出索引编号

def get_layer_item(layer):
    # global env_mach_pes
    layer_item = np.array([]) #初始化每层的item列表
    for x in range(env_mach_pes.shape[1]): 
        if layer == env_mach_pes[0,x]: #对于在这一层的item加入进去
            if layer_item is not None:
                layer_item_temp = layer_item #确定layer_item的顺序，按起始核心号从小到大顺序排序
                iter = layer_item.shape[1] # 接下来要对layer_item操作，所以先保留一下当前这一层的模块数字
                for y in range(iter):
                    min_start = env_mach_pes[1,layer_item[0,0]]
                    for z in range(layer_item.shape[1]): #找到layer_item里起始进程号最小的模块
                        if env_mach_pes[1,layer_item[0,z]] <= min_start: #循环地将起始进程号最小的那个模块放到暂存空间的第一个，并删掉layer_item中这一列以便递归地进行该操作
                            min_start = env_mach_pes[1,layer_item[0,z]]
                            min_z = z
                    layer_item_temp[0,y] = layer_item[0,min_z] #起始进程号最小的模块重置到layer_item的第一个,先放到一个暂存空间里去
                    layer_item_temp[1,y] = layer_item[1,min_z]
                    layer_item = np.delete(layer_item, z, axis=1) #删除layer_item中对应的那一列
                layer_item = layer_item_temp #最后就生成出来排好序的layer_item了
            else:    
                np.c_(layer_item, [x,env_mach_pes[2,x]])  #从env_mach_pes中获取当前层应该有哪些模块
    return layer_item

def whether_next_layer(layer_item, datamatrix):#判断是否到下一层搜索
    judge = 0
    temp = np.array(layer_item) #两行，分别是item号和对应核数；多列，每列代表一个item
    for x in range(0,temp.shape[1]): 
        if datamatrix[temp[1,x],temp[0,x]] > datamatrix[temp[1,0],temp[0,x]]: #判断任何一个item是否超过了第一个的高度
            judge = 1
    return judge

def put_into_layer(datamatrix, item_left, delta): #当前层塞入item定义
    global env_mach_pes
    global layer_num
    global capacity_left
    item_put = 0 #标记该模块是否被放入了
    for layer in range(layer_num):
        grad1 = np.array([]) #当前层的梯度都初始化重置
        layer_item = get_layer_item(layer) #每一层都有自己的模块列表
        if layer_item is not None:
            if capacity_left[layer] > env_mach_pes[2,item_left[0]]: #判断当前层是否能容下
                #layer_item.append([item_left[0],env_mach_pes[2,item_left[0]],layer])
                #del item_left[0] #将塞入的item放进layer列表中，并从item列表里移除
                np.c_(layer_item,[item_left[0],env_mach_pes[2,item_left[0]]]) #当前层的模块信息记录
                capacity_left[layer] = capacity_left[layer] - env_mach_pes[2,item_left[0]] #占用掉该层一定资源
                env_mach_pes[0,item_left[0]] = layer #模块层数更新
                env_mach_pes[1,item_left[0]] = np.sum(layer_item,axis=0)[1] #模块起始位置更新
                item_put = 1 #修改以下标记
                break #只要放入了item，循环就会终止
            else:
                while not whether_next_layer(layer_item, datamatrix):
                    temp_pes = env_mach_pes #临时全局记录
                    layer_item_temp = layer_item # 临时层内记录
                    np.c_(layer_item_temp,[item_left[0],temp_pes[2,item_left[0]]])
                    if layer_item_temp.shape[1] == 1: #一层只有一个模块，则不可插入该层直接插入下一层
                        break
                    else:
                        for item in range(1,layer_item_temp.shape[1]): #计算层内除了第一个外的所有模块的梯度
                            item_id = layer_item_temp[0,item]
                            grad1[item] = grad(temp_pes[2,item_id],item_id,datamatrix,delta) #将梯度存入grad1数组中 array格式
                        temp = layer_item_temp.shape[1]
                        while temp > 1: #临时变量用于帮助不出现0以下资源分配问题
                            if temp_pes[2,layer_item[0,np.argmin(grad1)]] - delta > 0: #不能分配小于0个资源
                                temp_pes[2,layer_item[0,np.argmin(grad1)]] -= delta #梯度最小的模块减少delta个资源分配
                                layer_item_temp[1,layer_item[0,np.argmin(grad1)]] = temp_pes[2,layer_item[0,np.argmin(grad1)]]
                                break
                            else:
                                del grad[np.argmin(grad1)]
                                temp -= 1
                    if capacity_left[layer] > (np.sum(layer_item_temp,axis=1) - np.sum(layer_item,axis=1)): #如果变换后这一层能容的下的话
                        layer_item = layer_item_temp #保留变换
                        env_mach_pes = temp_pes
                        item_put = 1
                        break
        else:
            if capacity_left[layer] > env_mach_pes[2,item_left[0]]: #判断当前层是否能容下
                np.c_(layer_item,[item_left[0],env_mach_pes[2,item_left[0]]]) #当前层的模块信息记录
                capacity_left[layer] = capacity_left[layer] - env_mach_pes[2,item_left[0]] #占用掉该层一定资源
                env_mach_pes[0,item_left[0]] = layer #模块层数更新
                env_mach_pes[1,item_left[0]] = 0 #模块起始位置更新
                item_put = 1 #修改标记
                break
            else:
                env_mach_pes[0,item_left[0]] = layer #模块层数更新
                env_mach_pes[1,item_left[0]] = 0 #模块起始位置更新
                env_mach_pes[2,item_left[0]] = capacity_left[layer] #模块给予该层全部资源
                np.c_(layer_item,[item_left[0],env_mach_pes[2,item_left[0]]]) #当前层的模块信息记录
                item_put = 1 #修改标记
                break
    if not item_put:
        layer_num += 1 #所有层都没放下，总层数+1，并在新的层上放入
        put_into_layer(datamatrix, item_left, delta) #递归放入操作

def CPS():
    fname = 'abcd.excel' #并行度曲线的excel路径
    delta = 1 #定义梯度步长
    capacity = 256 #总核数为256
    datamatrix = load(fname) #读取文件，将并行度曲线读入矩阵中存储
    init(datamatrix)  #初始对每个模块运行时间最小值进行排序（排除ATM和OCN），给出item的顺序，写入item_left矩阵中
    item_left = shuffle0 #将上一步修改的条件变量数值传入待排入模块队列中

    if capacity > env_mach_pes[3,5]: #判断海洋能不能放进去，能放就放，否则变为总进程数-1的核数
        env_mach_pes[1,5]= capacity - env_mach_pes[2,5] #海洋起始进程未知
        capacity_left[0] = capacity - env_mach_pes[2,5] #第一层可用资源数
    else:
        env_mach_pes[2,5] = capacity_left - 1
        capacity_left[0] = 1

    while datamatrix[env_mach_pes[2,5],5] < datamatrix[env_mach_pes[2,4],4]: #当T_OCN<T_ATM时执行算法
        while item_left is not None: #模块都塞没了结束算法
            #for layer in range(layer_num): #逐层进行coodrinate操作塞入模块
                #layer_item = get_layer_item(layer)
            put_into_layer(datamatrix, item_left, delta)
            del item_left[0]
            CTP(env_mach_pes[3,5]) #对海洋实施CTP算法，任务再排序
    
    np.save('env.npy', env_mach_pes) #输出结果

def hessian(f, variables): #求海森矩阵
    """
    Compute the Hessian matrix of a function f with respect to variables.
    """
    n = variables.shape[0]
    hessian = np.zeros((n, n))
    for i in range(n):
        for j in range(i, n):
            hessian[i][j] = f(*variables, i, j)
            hessian[j][i] = hessian[i][j]
    return hessian

def jacobi(f,b):
    x = sp.symbols('x')
    x_1 = lon*lat/(x*p_node)
    for idx in range(p_node):
        T_ar = lambda_1*x_1*x + lambda_2*(x_1+b)
    y = T_ar
    dy = sp.diff(y,x)
    FF = float(zx.evalf(subs={x:b,y:f}))
    return FF

def T_exec(b,lambda_1,lambda_2,p_node):
    a = lon*lat/(b*p_node)
    for idx in range(p_node):
        T_ar = lambda_1*a*b
        T_comm = lambda_2*(a+b)
        T_exec += T_ar + T_comm
    T_exec = T_exec - lambda_2*288 +cons
    return T_exec

def Newton(x0):
    epsilon=1e-5
    x=x0
    gval= jacobi(T_exec(b,lambda_1,lambda_2,p_node),b)
    hval= hessian(T_exec(b,lambda_1,lambda_2,p_node),b)
    iter=0
    theta = 1
    while ((gval>epsilon)and(iter<10000)):
       iter=iter+1
       b=b-theta(hval/gval)
       if (hval < 0):
           printf('iter= %2d,hessian is not positive definite',iter)
       printf('iter= %2d f(x)=%10.10f\n',iter,f(x))
       gval= sp.diff(T_exec(b,lambda_1,lambda_2,p_node),b)
       hval= hessian(T_exec(b,lambda_1,lambda_2,p_node),b)
    end
    if (iter==10000):
        fprintf('did not converge')
    return b
    

def CTP(p_node): #对海洋任务再排序
    lon = 144 #网格经度
    lat = 96  #网格纬度
    b = lat // p_node     #默认从默认任务划分开始
    b = Newton(b) #使用牛顿法找到最优解


if __name__ == '__main__':
    CPS()
