#!/bin/bash
 cd  curl-7.62.0
 cp ../curlsc.sh curlsc.sh
 cp ../make.sh make.sh
 export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
  export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
 ./curlsc.sh
 ./make.sh
 cd ..

