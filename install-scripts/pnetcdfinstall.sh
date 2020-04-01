#!/bin/bash
  cd pnetcdf-1.11.2
  cp ../pnetcdfsc.sh pnetcdfsc.sh
  cp ../make.sh make.sh
  export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
  export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
  ./pnetcdfsc.sh
  ./make.sh
  cd ..
