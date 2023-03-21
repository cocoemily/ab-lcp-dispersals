#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=8:00:00
#SBATCH --mem=20GB
#SBATCH --job-name=levy-5km
#SBATCH --mail-type=END
#SBATCH --mail-user=ec3307@nyu.edu

module purge
module load jdk/11.0.9 

##MODEL_PATH=/home/ec3307/ab-lcp-dispersals/net-logo-code
PATH=$PATH:/home/ec3307/NetLogo-linux
##cd $MODEL_PATH

RUN_NO=1
EXP_NAME="test_MIS3_levy-walks-2"

export _JAVA_OPTIONS='-Dcom.sun.media.jai.disableMediaLib=true -Xmx20480m'

bash /home/ec3307/NetLogo-linux/netlogo-headless.sh  --model "ab-lcp-Levy_v1_hpc.nlogo" --experiment $EXP_NAME
