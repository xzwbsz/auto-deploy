#!/bin/bash 

echo `pwd`

counter=$1
Max=$2
echo $counter
echo $Max

while [[ $counter -le $Max ]]
do
        export PATH=/home/jlucesm_env/openmpi-arm/bin:/home/jlucesm_env/netcdf-arm/bin:$PATH
        export LD_LIBRARY_PATH=/home/jlucesm_env/hdf5-arm/lib:/home/jlucesm_env/openmpi-arm/lib:/home/jlucesm_env/netcdf-arm/lib:$LD_LIBRARY_PATH
	#Foldername = "/timingtest_"+$counter
	echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
	if [ ! -d "Btimetest_"+$counter ];then
	./create_newcase -case Btimetest_$counter -res f19_g16 -compset BC5 -mach HUAWEI-arm
	#./create_newcase -case timingtest_$counter -res f19_g16 -compset F_2000_CAM5 -mach tfyVirtual
	else
        echo 'case existed!'
        fi
	cd ./Btimetest_$counter
	echo `pwd`
        mkdir ../../../exp
        mkdir ../../../exp/exp_"$counter"

	
#	./cesm_setup -clean
#	./cesm_setup || exit -3
	echo 'begining to change the xmls!'
	echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
	./xmlchange -file env_mach_pes.xml -id NTASKS_ATM -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_LND -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_ICE -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_OCN -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_CPL -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_GLC -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_ROF -val $counter
	./xmlchange -file env_mach_pes.xml -id NTASKS_WAV -val $counter
	./xmlchange -file env_mach_pes.xml -id TOTALPES -val $counter
	./xmlchange -file env_run.xml -id DOUT_S -val TRUE
	./xmlchange -file env_run.xml -id DOUT_S_SAVE_INT_REST_FILES -val TRUE
	./xmlchange -file env_run.xml -id DOUT_L_MS -val TRUE
	./xmlchange -file env_run.xml -id DOUT_L_MSROOT -val '$CASEROOT/Long_archive/$CASE'
	./xmlchange -file env_run.xml -id DOUT_L_HTAR -val TRUE
	./xmlchange -file env_run.xml -id RUNDIR -val '$CASEROOT/run/$CASE'
	./xmlchange -file env_run.xml -id DOUT_S_ROOT -val '$CASEROOT/archive/$CASE'
	./xmlchange -file env_run.xml -id LOGDIR  -val '$CASEROOT/Logs/$CASE'
	./xmlchange -file env_build.xml -id EXEROOT -val '$CASEROOT/bld/$CASE'
	
#	./cesm_setup -clean
	./cesm_setup || exit -3
	cp ../Btimetest_144/Macros ./Macros || exit -1
	./Btimetest_$counter.build || exit -2
        sed -i  's#mpirun#mpirun -hostfile /home/mach #g' Btimetest_"$counter".run
        ./Btimetest_"$counter".run
        ##rundir=./run
        if [ ! -d "run" ];then
         cd ..
         echo 'the Case /Btimetest_' $counter ' test failed!!!'
        elif [ ! -d "time" ];then
            rm -rf run
            echo 'the Case /Btimetest_' $counter' test failed without time.'
         else 
          cp timing/ccsm* ../../../exp/exp_$counter/
	  cd ../
	  echo 'the Case /Btimetest_' $counter' test finished'
         fi
	echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
done
