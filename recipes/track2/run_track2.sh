#!/usr/bin/env bash

cmd="/home3/theanhtran/slurm.pl --quiet --gpu 1 --nodelist=node08" #  --nodelist=node06 --gpu 1

. /home3/theanhtran/env/anaconda/etc/profile.d/conda.sh
conda activate xvector_diarization

$cmd log/track2_v2b.log \
./run.sh --stage 5