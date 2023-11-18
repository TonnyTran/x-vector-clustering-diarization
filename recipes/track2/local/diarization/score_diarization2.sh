#!/usr/bin/env bash

set -e -u -o pipefail

################################################################################
# Configuration
################################################################################
# Use a no scoring collar of +/ "collar" seconds around each boundary.
collar=0.0

# Step size in seconds to use in computation of JER.
step=0.010

# If provided, output full scoring logs to this directory. It will contain the
# following files:
# - metrics_full.stdout  --  per-file and overall metrics for full test set; see
#   dscore documentation for explanation
# - metrics_full.stderr  --  warnings/errors produced by dscore for full test set
# - metrics_core.stdout  --  per-file and overall metrics for core test set
# - metrics_core.stderr  --  warnings/errors produced by dscore for full test set
scores_dir=


################################################################################
# Parse options, etc.
################################################################################
if [ -f path.sh ]; then
    . ./path.sh;
fi
if [ -f cmd.sh ]; then
    . ./cmd.sh;
fi
. utils/parse_options.sh || exit 1;
if [ $# != 3 ]; then
  echo "usage: $0 <release-dir> <rttm-dir>"
  echo "e.g.: $0 /data/corpora/LDC2020E12 exp/diarization_dev/rttms"
  exit 1;
fi

# Root of official LDC release; e.g., /data/corpora/LDC2020E12.
release_dir=$1

refer_rttm=$2

# Directory containing RTTMs to be scored.
sys_rttm=$3


################################################################################
# Score.
################################################################################
# Create temp directory for dscore outputs.
tmpdir=$(mktemp -d -t dh3-dscore-XXXXXXXX)

echo "usage: $0 score CORE set"
# Score CORE test set.
score.py \
  -u $release_dir/data/uem_scoring/core/all.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_core.stdout \
  2> $tmpdir/metrics_core.stderr
core_der=$(grep OVERALL $tmpdir/metrics_core.stdout | awk '{print $4}')

# Score CORE audiobooks set.
score.py \
  -u $release_dir/data/uem_scoring/core/audiobooks.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_audiobooks.stdout \
  2> $tmpdir/metrics_audiobooks.stderr
audiobooks_der=$(grep OVERALL $tmpdir/metrics_audiobooks.stdout | awk '{print $4}')

# Score CORE broadcast_interview set.
score.py \
  -u $release_dir/data/uem_scoring/core/broadcast_interview.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_broadcast_interview.stdout \
  2> $tmpdir/metrics_broadcast_interview.stderr
broadcast_interview_der=$(grep OVERALL $tmpdir/metrics_broadcast_interview.stdout | awk '{print $4}')

# Score CORE clinical set.
score.py \
  -u $release_dir/data/uem_scoring/core/clinical.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_clinical.stdout \
  2> $tmpdir/metrics_clinical.stderr
clinical_der=$(grep OVERALL $tmpdir/metrics_clinical.stdout | awk '{print $4}')

# Score CORE court set.
score.py \
  -u $release_dir/data/uem_scoring/core/court.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_court.stdout \
  2> $tmpdir/metrics_court.stderr
court_der=$(grep OVERALL $tmpdir/metrics_court.stdout | awk '{print $4}')

# Score CORE cts set.
score.py \
  -u $release_dir/data/uem_scoring/core/cts.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_cts.stdout \
  2> $tmpdir/metrics_cts.stderr
cts_der=$(grep OVERALL $tmpdir/metrics_cts.stdout | awk '{print $4}')

# Score CORE maptask set.
score.py \
  -u $release_dir/data/uem_scoring/core/maptask.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_maptask.stdout \
  2> $tmpdir/metrics_maptask.stderr
maptask_der=$(grep OVERALL $tmpdir/metrics_maptask.stdout | awk '{print $4}')

# Score CORE meeting set.
score.py \
  -u $release_dir/data/uem_scoring/core/meeting.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_meeting.stdout \
  2> $tmpdir/metrics_meeting.stderr
meeting_der=$(grep OVERALL $tmpdir/metrics_meeting.stdout | awk '{print $4}')

# Score CORE restaurant set.
score.py \
  -u $release_dir/data/uem_scoring/core/restaurant.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_restaurant.stdout \
  2> $tmpdir/metrics_restaurant.stderr
restaurant_der=$(grep OVERALL $tmpdir/metrics_restaurant.stdout | awk '{print $4}')

# Score CORE socio_field set.
score.py \
  -u $release_dir/data/uem_scoring/core/socio_field.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_socio_field.stdout \
  2> $tmpdir/metrics_socio_field.stderr
socio_field_der=$(grep OVERALL $tmpdir/metrics_socio_field.stdout | awk '{print $4}')

# Score CORE socio_lab set.
score.py \
  -u $release_dir/data/uem_scoring/core/socio_lab.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_socio_lab.stdout \
  2> $tmpdir/metrics_socio_lab.stderr
socio_lab_der=$(grep OVERALL $tmpdir/metrics_socio_lab.stdout | awk '{print $4}')

# Score CORE webvideo set.
score.py \
  -u $release_dir/data/uem_scoring/core/webvideo.uem \
  -r $refer_rttm \
  -s $sys_rttm \
  >  $tmpdir/metrics_webvideo.stdout \
  2> $tmpdir/metrics_webvideo.stderr
webvideo_der=$(grep OVERALL $tmpdir/metrics_webvideo.stdout | awk '{print $4}')


# Report.
echo "$0: ******* SCORING RESULTS *******"
echo "$0: *** DER (core) - audiobooks:          ${audiobooks_der}"
echo "$0: *** DER (core) - broadcast_interview: ${broadcast_interview_der}"
echo "$0: *** DER (core) - clinical:            ${clinical_der}"
echo "$0: *** DER (core) - court:               ${court_der}"
echo "$0: *** DER (core) - cts:                 ${cts_der}"
echo "$0: *** DER (core) - maptask:             ${maptask_der}"
echo "$0: *** DER (core) - meeting:             ${meeting_der}"
echo "$0: *** DER (core) - restaurant:          ${restaurant_der}"
echo "$0: *** DER (core) - socio_field:         ${socio_field_der}"
echo "$0: *** DER (core) - socio_lab:           ${socio_lab_der}"
echo "$0: *** DER (core) - webvideo:            ${webvideo_der}"
echo "------------------------------------------------------------------------------------------"
echo "$0: *** DER (core) - All:                 ${core_der}"


if [ ! -z "scores_dir" ]; then
 echo "$0: ***"
 echo "$0: *** Full results are located at: ${scores_dir}"
fi

# Clean up.
if [ ! -z "scores_dir" ]; then
  mkdir -p $scores_dir
  cp $tmpdir/* $scores_dir
fi
rm -fr $tmpdir
