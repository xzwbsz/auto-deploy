#!/bin/bash
      cd szip-2.1.1
      cp ../szipsc.sh szipsc.sh
      cp ../make.sh make.sh
      export PATH= /home/jlucesm_env/openmpi-arm/bin$PATH
      export LD_LIBRARY_PATH:/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
      ./szipsc.sh
      ./make.sh
      cd ..

