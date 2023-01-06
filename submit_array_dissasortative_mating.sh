#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --job-name=slim
#SBATCH --output=log_random_mating-%J.out
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-10
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#---------------------------#
#activate environmenet
source /local/env/envconda3.sh
#load slim if necessary
#---------------------------#

#External variable
interval=interval #$1 #arguments from 1 to 10 (or more) specifying the repetition ID
mig=$1 #1e-4 1e-8 1e-6
assortF=$2
LAF=$3

assort="disassortative" #assortative #random or dissasortative

rep=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $interval )


#---------------------------#
if [[ $assort == "disassortative" ]]
then
    ./00_scripts/run_slim_dissasortative_mating.sh $rep $mig $assortF $LAF
elif [[ $assort == "assortative" ]]
then
echo "model assumed is assortative mating"
    ./00_scripts/run_slim_random_mating.sh $rep $mig $assortF $LAF
else 
echo "model assumied is random mating" 
    ./00_scripts/run_slim_random_mating.sh $rep $mig $assortF $LAF
fi
