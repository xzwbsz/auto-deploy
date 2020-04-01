#!/bin/bash
  cd hdf5-1.10.5
  cp ../hdf51105sc.sh hdf51105sc.sh
  cp ../make.sh make.sh
   export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
  export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
  ./hdf51105sc.sh
  ./make.sh
  cd ..
