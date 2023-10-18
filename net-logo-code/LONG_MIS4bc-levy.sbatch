#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=1
#SBATCH --time=160:00:00
#SBATCH --mem=350GB
#SBATCH --job-name=long_MIS4bc
#SBATCH --mail-type=END
#SBATCH --mail-user=ec3307@nyu.edu

module purge
module load jdk/11.0.9 

##MODEL_PATH=/home/ec3307/ab-lcp-dispersals/net-logo-code
PATH=$PATH:/home/ec3307/NetLogo
##cd $MODEL_PATH

RUN_NO=1
EXP_NAME="MIS4bc_levy-walks_LONG"
echo $EXP_NAME

export _JAVA_OPTIONS='-Dcom.sun.media.jai.disableMediaLib=true -Xmx358400m'

bash /home/ec3307/NetLogo/netlogo-headless.sh  --model "ab-lcp-Levy_v1_hpc.nlogo" --experiment $EXP_NAME --threads 10
