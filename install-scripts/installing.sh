#!/bin/bash

    tar -zxvf ../environment/openmpi-4.0.1.tar.gz
    cp openmpisc.sh  openmpi-4.0.1/openmpisc.sh
    cp make.sh openmpi-4.0.1/make.sh
    cd openmpi-4.0.1
    ./openmpisc.sh 
    ./make.sh 
    cd ..
    export PATH=/home/jlucesm_env/openmpi-arm/bin:$PATH
    export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:$LD_LIBRARY_PATH
    tar -zxvf  ../environment/zlib-1.2.11.tar.gz
    ./zlibinstall.sh 
    tar -zxvf  ../environment/szip-2.1.1.tar
    ./szipinstall.sh  
    tar -zxvf ../environment/hdf5-1.10.5.tar.gz
    ./hdf51105install.sh 
    export LD_LIBRARY_PATH=/home/jlucesm_env/hdf5-arm/lib:$LD_LIBRARY_PATH
    tar -zxvf ../environment/curl-7.62.0.tar.gz
    ./curlinstall.sh  
    tar -zxvf ../environment/pnetcdf-1.11.2.tar.gz
    ./pnetcdfinstall.sh 
    tar -zxvf ../environment/netcdf-c-4.7.0.tar.gz
    ./netcdfinstall.sh 
    tar -zxvf ../environment/netcdf-fortran-4.4.4.tar.gz
    ./netcdfforinstall.sh 
    export PATH=/home/jlucesm_env/openmpi-arm/bin:/home/jlucesm_env/netcdf-arm/bin:$PATH
    export LD_LIBRARY_PATH=/home/jlucesm_env/openmpi-arm/lib:/home/jlucesm_env/netcdf-arm/lib:$LD_LIBRARY_PATH
    ./lapacksc.sh
