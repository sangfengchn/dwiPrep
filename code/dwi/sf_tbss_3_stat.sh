#! /bin/bash
set -eux

# Text2Vest design.txt design.mat

randomise -i all_FA_skeletonised_RemovedNa.nii.gz -o lz_covAgeSexEdu -m mean_FA_skeleton_mask.nii.gz -d design_covAgeSexEdu.mat -t design_covAgeSexEdu.con -f design.fts -n 1000 --T2