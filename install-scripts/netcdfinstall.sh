#!/bin/bash
 cd netcdf-c-4.7.0
 cp ../netcdfsc.sh netcdfsc.sh
 cp ../make.sh make.sh
  export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
  export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
 ./netcdfsc.sh
 ./make.sh
 cd ..
