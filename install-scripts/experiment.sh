#!/bin/bash
 rm -f ../cesm1_2_1/scripts/ccsm_utils/Machines/*.xml
 cp config_compilers.xml ../cesm1_2_1/scripts/ccsm_utils/Machines/config_compilers.xml
 cp config_machines.xml ../cesm1_2_1/scripts/ccsm_utils/Machines/config_machines.xml
 cp config_pes.xml ../cesm1_2_1/scripts/ccsm_utils/Machines/config_pes.xml
 rm -f ../cesm1_2_1/scripts/ccsm_utils/Machines/*.HUAWEI-arm
 cp env_mach_specific.HUAWEI-arm ../cesm1_2_1/scripts/ccsm_utils/Machines/env_mach_specific.HUAWEI-arm
 cp mkbatch.HUAWEI.HUAWEI-arm ../cesm1_2_1/scripts/ccsm_utils/Machines/mkbatch.HUAWEI.HUAWEI-arm
 cp exptest.sh ../cesm1_2_1/scripts/exptest.sh
 cd ../cesm1_2_1/scripts
 for ((i=1;i<96;i+))
 do
 counter=i*4
  ./exptest.sh $counter $counter 
 echo "test $counter done"
 done
 echo "Testing done,3QU" 

