H5DIR=/home/jlucesm_env/hdf5-arm
MPIDIR=/home/jlucesm_env/openmpi-arm
PNDIR=/home/jlucesm_env/pnet-arm
CURLDIR=/home/jlucesm_env/curl-arm
CC=mpicc CXX=mpic++ FC=mpif90 CFLAGS=" -fPIC -lm " FFLAGS=" -fPIC -lm " CPPFLAGS=" -fPIC -I${PNDIR}/include -I${MPIDIR}/include -I${H5DIR}/include -I${CURLDIR}/include " LDFLAGS="-L${MPIDIR}/lib -L${PNDIR}/lib -lmpi -L${H5DIR}/lib -L${CURLDIR}/lib " ./configure --prefix=/home/jlucesm_env/netcdf-arm --enable-netcdf-4 --enable-largefile -disable-dap 
