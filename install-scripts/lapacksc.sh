#!/bin/bash
tar -zxvf ../environment/lapack-3.8.0.tar.gz
cd lapack-3.8.0
cp make.inc.example make.inc
make
cp *.a /home/jlucesm_env
cd ..
