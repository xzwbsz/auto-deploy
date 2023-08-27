# HiRM: Hierarchical Resource Management for Earth System Models on Many-core Clusters
This is the python version of HiRM.
## auto-deploy
Deploy the CESM environment automaticly and use HiRM to output the best performance layout for many-core HPC clusters.
To automaticaly deploy the scripts, use such command:

bash install-scripts/installing.sh

To construct running time environment, user should firstly step into the scripts dir of CESM, and then use such command:

bash install-scripts/experiment.sh

bash install-scripts/exptest.sh

To implement HiRM, use such command:

python HiRM

Note that user should install xlrd (version 1.2) and numpy before implemention.

## Experiment
![image](https://github.com/xzwbsz/auto-deploy/assets/44642002/69fe95af-c2c3-4c7e-93b3-d1448d7788f4)


