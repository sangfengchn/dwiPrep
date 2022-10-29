#! /bin/bash
#PBS -N lz_tbss
#PBS -l nodes=1:ppn=24
#PBS -q fat8
#PBS -o log/tbss.log
#PBS -e log/tbss.err
#PBS -V

set -eux

proj=/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration
tbss=$proj/derivatives/tbss_fa/data

cd $tbss

# step: 1
tbss_1_preproc *.nii.gz

# # step: 2
# tbss_2_reg -T

# # step: 3
# tbss_3_postreg -T

# # step: 4
# tbss_4_prestats 0.2

echo 'Done.'