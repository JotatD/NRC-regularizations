#!/bin/bash
#SBATCH --verbose
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --mem=16GB
#SBATCH --mail-type=ALL # select which email types will be sent
#SBATCH --mail-user=NetID@nyu.edu # NOTE: put your netid here if you want emails

#SBATCH --array=0-2 # here the number depends on number of tasks in the array, e.g. 0-11 will create 12 tasks
#SBATCH --output=../logs/%A_%a.out # Location of the output files. %A is SLURM_ARRAY_JOB_ID, %a is SLURM_ARRAY_TASK_ID,
#SBATCH --error=../logs/%A_%a.err # Location of the error files. MAKE SURE WHEN YOU RUN THIS, ../logs IS A VALID PATH

# #####################################################
# #SBATCH --gres=gpu:1 # uncomment this line to request a gpu
#SBATCH --cpus-per-task=1

sleep $(( (RANDOM%10) + 1 )) # to avoid issues when submitting large amounts of jobs

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

echo "Job ID: ${SLURM_ARRAY_TASK_ID}"

source /share/apps/NYUAD5/miniconda/3-4.11.0/bin/activate # to initialize conda on computation node
conda activate nrc # launch your virtual environment for this project
export PYTHONPATH=$PYTHONPATH:$SCRATCH/NC_regression # add project root folder so that python import works fine. $SCRATCH is the environment variable pointing to /scratch/netID/.
cd $SCRATCH/NC_regression # start from the project root folder, since default data folder is ./dataset/mujoco in test.py
python main/exp/case1/test.py --setting ${SLURM_ARRAY_TASK_ID} # execute corresponding python file
