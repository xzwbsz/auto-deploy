#!/bin/bash
 cd netcdf-fortran-4.4.4
 cp ../netcdfforsc.sh netcdfforsc.sh
 cp ../make.sh make.sh
 export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
  export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
 ./netcdfforsc.sh
 ./make.sh
 cd ..
