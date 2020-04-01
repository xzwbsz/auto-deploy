NFDIR=/home/jlucesm_env/netcdf-arm
NCDIR=/home/jlucesm_env/netcdf-arm
H5DIR=/home/jlucesm_env/hdf5-arm
PNDIR=/home/jlucesm_env/pnet-arm
MPIDIR=/home/jlucesm_env/openmpi-arm
export LD_LIBRARY_PATH=${NCDIR}/lib:${LD_LIBRARY_PATH}
CC=mpicc F77=mpif77 F90=mpif90 F77=mpif77 FCFLAGS=" -fPIC -lm "  FFLAGS="-fPIC -lm " CFLAGS=" -fPIC -lm" CPPFLAGS="-fPIC -lm -I${MPIDIR}/include -I${H5DIR}/include -I${PNDIR}/include -I${NCDIR}/include" LDFLAGS="-L${MPIDIR}/lib -L${PNDIR}/lib -lmpi -L${H5DIR}/lib -L${NCDIR}/lib" ./configure --prefix=${NFDIR} --enable-netcdf-4 --enable-largefile --disable-dap --enable-parallel-tests --enable-pnetcdf
