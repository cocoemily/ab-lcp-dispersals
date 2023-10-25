#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=165:00:00
#SBATCH --mem=70GB
#SBATCH --job-name=MIS6bk-levy
#SBATCH --mail-type=END
#SBATCH --mail-user=ec3307@nyu.edu

module purge
module load jdk/11.0.9 

##MODEL_PATH=/home/ec3307/ab-lcp-dispersals/net-logo-code
PATH=$PATH:/home/ec3307/NetLogo
##cd $MODEL_PATH

RUN_NO=1
EXP_NAME="MIS6bk_levy-walks_LONG"
echo $EXP_NAME

export _JAVA_OPTIONS='-Dcom.sun.media.jai.disableMediaLib=true -Xmx71680m'

bash /home/ec3307/NetLogo/netlogo-headless.sh  --model "ab-lcp-Levy_v1_hpc.nlogo" --experiment $EXP_NAME