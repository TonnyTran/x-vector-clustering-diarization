#!/usr/bin/env bash

LD_LIBRARY_PATH="/home3/theanhtran/env/anaconda/envs/dihard_baseline/lib:$LD_LIBRARY_PATH"
cmd="/home3/theanhtran/slurm.pl --quiet --nodelist=node06 --gpu 1 --nodelist=node06 --gpu 1" #  --nodelist=node06 --gpu 1

. /home3/theanhtran/env/anaconda/etc/profile.d/conda.sh
conda activate dihard_baseline

$cmd log/track2.log \
./run.sh