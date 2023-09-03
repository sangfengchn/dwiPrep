#! /bin/bash

#PBS -N #JOBNAME#
#PBS -l nodes=1:ppn=#PPN#
#PBS -q #QUENAME#
#PBS -o #TMPPATH#/preprocessing.log
#PBS -e #TMPPATH#/preprocessing.err
#PBS -V

set -exu

WMHDER=#WMHDER#
DTIDER=#DTIDER#
SUBID=#SUBID#
RESOURCE=#RESOURCE#

mv $WMHDER/$SUBID/submited $WMHDER/$SUBID/running

# robustfov -v -i $WMHDER/$SUBID/t1w.nii -r $WMHDER/$SUBID/t1w_crop.nii.gz
# robustfov -v -i $WMHDER/$SUBID/ples_lpa_mrflair.nii -r $WMHDER/$SUBID/ples_lpa_mrflair_crop.nii.gz
# fast -v -o $WMHDER/$SUBID/t1w -B $WMHDER/$SUBID/t1w_crop.nii.gz
# bet $WMHDER/$SUBID/t1w_restore.nii.gz $WMHDER/$SUBID/t1wwmh_brain.nii.gz -R -f 0.4 -v
# flirt -in $WMHDER/$SUBID/t1wwmh_brain.nii.gz -ref $DTIDER/$SUBID/t1w_brain.nii.gz -omat $WMHDER/$SUBID/t1wwmh2t1w.mat

flirt -in $WMHDER/$SUBID/mrflair.nii  -ref  $DTIDER/$SUBID/t1w.nii.gz -omat $WMHDER/$SUBID/mrflair2t1w.mat
flirt -in $WMHDER/$SUBID/ples_lpa_mrflair.nii -ref $DTIDER/$SUBID/t1w.nii.gz -applyxfm -init $WMHDER/$SUBID/mrflair2t1w.mat -out $WMHDER/$SUBID/ples_lpa_mrflair_t1w.nii.gz
applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$WMHDER/$SUBID/ples_lpa_mrflair_t1w.nii.gz --warp=$DTIDER/$SUBID/t1w2mniWarp.nii.gz --out=$WMHDER/$SUBID/ples_lpa_mrflair_mni.nii.gz
# applywarp --ref=/Users/fengsang/Downloads/wmh2tbss/resource/MNI152_T1_1mm_brain.nii.gz --in=/Users/fengsang/Downloads/wmh2tbss/sub-P0146LIAIHUA_wmh2tbss/ples_lpa_mrflair_t1w.nii.gz --warp=/Users/fengsang/Downloads/wmh2tbss/sub-P0146LIAIHUA_dti/t1w2mniWarp.nii.gz --out=/Users/fengsang/Downloads/wmh2tbss/sub-P0146LIAIHUA_wmh2tbss/ples_lpa_mrflair_mni.nii.gz
fslmaths $WMHDER/$SUBID/ples_lpa_mrflair_mni.nii.gz -thr 0.5 -bin $WMHDER/$SUBID/ples_lpa_mrflair_mni_mask.nii.gz

mv $WMHDER/$SUBID/running $WMHDER/$SUBID/finished

echo "Done."