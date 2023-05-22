# Prerequisites

The following packages are required to run the baseline.

- [Python](https://www.python.org/) = 3.9
- [Kaldi](https://github.com/kaldi-asr/kaldi)
- [dscore](https://github.com/nryant/dscore)

The code was test on CUDA-11 version.

Dataset:

- DIHARD III development set (**LDC2020E12**)

- DIHARD III evaluation set (**LDC2021E02**)


# Installation

## Step 1: Clone the repo and create a new virtual environment

Clone the repo:

```bash
git clone https://github.com/TonnyTran/x-vector-clustering-diarization.git
cd x-vector-clustering-diarization
```


Using conda to create a fresh virtual environment, and activate it:

```bash
conda create -n xvector-clustering python=3.9
conda activate xvector-clustering
```

## Step 2: Installing Python dependencies

Run the following command to install the required Python packages:

```bash
pip install -r requirements.txt
```

## Step 3: Installing remaining dependencies

We also need to install [Kaldi](https://github.com/kaldi-asr/kaldi) and [dscore](https://github.com/nryant/dscore). To do so, run the the installation scripts in the ``tools/`` directory:

```bash
cd tools
./install_kaldi.sh
./install_dscore.sh
cd ..
```
Note: we can indentify CUDA_HOME and MKL_ROOT while install kaldi, otherwise these parameters are set by default. (CUDA_HOME=/usr/local/cuda, MKL_ROOT=/opt/intel/mkl)
```bash
export CUDA_HOME=/opt/ohpc/pub/cuda/11.1
export MKL_ROOT=/opt/intel/oneapi/mkl
```


Please check the output of these scripts to ensure that installation has succeeded. If succesful, you should see ``Successfully installed {Kaldi,dscore}.`` printed at the end. If installation of a component fails, please consult the output of the relevant installation script for additional details.




# Running the baseline

The package includes the code of:
- **Track 2**  —  Diarization from scratch (i.e., using system produced SAD).


## Running the Track 2 recipe

To run the recipe, switch to ``recipes/track2/``:

```bash
cd recipes/track2
```

edit the variables ``DIHARD_DEV_DIR`` and ``DIHARD_EVAL_DIR``, and run:

```bash
./run.sh
```

As before, status updates will periodically be printed to STDOUT and a failure at any stage will result in the script immediately exiting with status 1.


### Error may occur while running

1. If you get the error of "Out of memory" while training SAD model, you can:
- change the batch size in recipes/track2/local/segmentation/train_stats_sad_1a.sh line 164
- resume training from predefine state by setting parameter ``sad_train_stage`` in run.sh file


### Scoring

DER on the EVAL set will be printed to STDOUT:

```bash
./run.sh: Scoring VB-HMM resegmentation on EVAL...
usage: local/diarization/score_diarization.sh score CORE set
local/diarization/score_diarization.sh: ******* SCORING RESULTS *******
local/diarization/score_diarization.sh: *** DER (core) - audiobooks:          3.06
local/diarization/score_diarization.sh: *** DER (core) - broadcast_interview: 10.31
local/diarization/score_diarization.sh: *** DER (core) - clinical:            25.86
local/diarization/score_diarization.sh: *** DER (core) - court:               15.91
local/diarization/score_diarization.sh: *** DER (core) - cts:                 17.91
local/diarization/score_diarization.sh: *** DER (core) - maptask:             12.94
local/diarization/score_diarization.sh: *** DER (core) - meeting:             41.46
local/diarization/score_diarization.sh: *** DER (core) - restaurant:          58.84
local/diarization/score_diarization.sh: *** DER (core) - socio_field:         21.37
local/diarization/score_diarization.sh: *** DER (core) - socio_lab:           12.65
local/diarization/score_diarization.sh: *** DER (core) - webvideo:            53.30
-----------------------------------------------------------------------------------
local/diarization/score_diarization.sh: *** DER (core) - All:                 26.87
```
