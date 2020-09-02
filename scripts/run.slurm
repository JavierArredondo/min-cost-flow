#!/bin/bash
#SBATCH -J met
#SBATCH -p general
#SBATCH -n 1
#SBATCH --array=1-50%50
#SBATCH --output=/home/jarredondo/projects/min-cost-flow/logs/pipes/%a_%A.txt
#SBATCH --error=/home/jarredondo/projects/QAP/min-cost-flow/pipes/%a_%A.err
#SBATCH --mail-user=javier.arredondo.c@usach.cl
#SBATCH --mail-type=ALL


ml R/4.0.0

workdir='/home/jarredondo/projects/min-cost-flow/'
file='stndrd10'
algorithm=1


Rscript --vanilla main.R $workdir $file $algorithm ${SLURM_ARRAY_TASK_ID} 