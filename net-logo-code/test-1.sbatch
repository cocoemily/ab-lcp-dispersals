#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --mem=3GB
#SBATCH --job-name=ab-lcp-test
#SBATCH --mail-type=END
#SBATCH --mail-user=ec3307@nyu.edu

module purge

MODEL_PATH=/home/ec3307/ab-lcp-dispersals/net-logo-code
PATH=$PATH:/home/ec3307/NetLogo
cd $MODEL_PATH

RUN_NO=1
EXP_NAME=test-1

./netlogo-headless.sh \
  --model $MODEL_PATH/ab-lcp_v1.nlogo \
  --experiment $EXP_NAME\
