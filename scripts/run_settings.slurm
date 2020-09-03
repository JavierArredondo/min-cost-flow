#!/bin/bash
#SBATCH -J met_settings
#SBATCH -p general
#SBATCH -n 1
#SBATCH --array=1
#SBATCH --output=/home/jarredondo/projects/min-cost-flow/logs/pipes/%a_%A.txt
#SBATCH --error=/home/jarredondo/projects/min-cost-flow/logs/pipes/%a_%A.err
#SBATCH --mail-user=javier.arredondo.c@usach.cl
#SBATCH --mail-type=ALL


ml R/4.0.0

workdir='/home/jarredondo/projects/min-cost-flow/'
file='stndrd10'

Rscript --vanilla run_settings.R $workdir $file
