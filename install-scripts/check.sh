#!/bin/bash
  echo "check for enviroment"
  k=0
   cd /home/jlucesm_env
   if [ ! -d "openmpi-arm" ];then
      echo "openmpi lack!"
   fi
   if [ ! -d "szip-arm" ];then
     echo "szip lack!"
   fi
   if [ ! -d "zlib-arm" ];then
      echo "zlib lack!"
   fi
   if [ ! -d "hdf5-arm" ];then
      echo "hdf5 lack!"
   fi
   if [ ! -d "pnet-arm" ];then
      echo "pnetcdf lack!"
   fi
   if [ ! -d "netcdf-arm" ];then
      echo "netcdf lack!"
   fi
   if [ -d "openmpi-arm"  ];then
      if [ -d "szip-arm" ];then
       if [ -d "zlib-arm" ];then
        if [ -d "hdf5-arm" ];then
         if [ -d "pnet-arm" ];then
          if [ -d "netcdf-arm" ];then
             echo "ok"
          fi
         fi
        fi
       fi
      fi
   fi
