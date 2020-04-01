#!/bin/bash 
  cp zlibsc.sh zlib-1.2.11/zlibsc.sh
  cp make.sh zlib-1.2.11/make.sh
  export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
  export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
  cd zlib-1.2.11/
  ./zlibsc.sh
  ./make.sh
  cd ..
