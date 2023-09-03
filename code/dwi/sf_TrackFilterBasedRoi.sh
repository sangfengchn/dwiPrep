#! /bin/bash

set -eux

proj=/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration_multiple_network
der=$proj/derivatives/preprocess_dwi
cd $der

for subId in `ls $der`
do
    [ ! -f $subId/AAL_brain_roi-16.nii.gz ] && continue
    echo $subId
    cd $subId
    track_vis tracks_filtered.trk -roi AAL_brain_roi-16.nii.gz -o tracks_filtered_roi-16.trk -nr
    cd ..
    break
done