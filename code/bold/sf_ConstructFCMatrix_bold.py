'''
 # @ Author: Feng Sang
 # @ Create Time: 2022-06-16 22:37:05
 # @ Modified by: Feng Sang, Shaokun Zhao
 # @ Modified time: 2022-06-16 22:50:08
 # @ Description: Generating the voxel-based fc.
 '''
import os
from glob import glob
import numpy as np
import pandas as pd
import nibabel as nib
from nilearn.maskers import NiftiLabelsMasker
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

derRoot = 'fmriprep'
rois_name = pd.read_csv('resource/atlas/BNA_subregions.csv', header=0, index_col=1)
rois_name = rois_name['Name'].values
atlaPrefix = "bna246"
low_pass=0.08
high_pass=0.009
t_r=2
# remove_time = 10

masker = NiftiLabelsMasker('resource/atlas/BN_Atlas_246_2mm.nii.gz', labels=rois_name, standardize=True, low_pass=low_pass, high_pass=high_pass, t_r=t_r)

for i in glob(os.path.join(derRoot, 'sub-*')):
    subId = os.path.split(i)[-1]
    for j in glob(os.path.join(derRoot, subId, 'func', '*space-MNI152NLin6Asym_desc-denosied_bold.nii.gz')):
        func_path = j
        if not os.path.exists(func_path):
            continue
        
        # if os.path.exists(func_path.replace('denosied_bold.nii.gz', f'fc_atl-{atlaPrefix}.txt')):
        #     continue
        
        logging.info(subId)
        func_img = nib.load(func_path)
        
        TimeSeries = masker.fit_transform(func_img)
        
        CorCoefVoxel = np.corrcoef(TimeSeries.T)
        CorCoefVoxelZ = np.log((1 + CorCoefVoxel) / (1 - CorCoefVoxel)) / 2

        # define self connection in ZFC equals to 0
        np.fill_diagonal(CorCoefVoxel, 0)
        np.fill_diagonal(CorCoefVoxelZ, 0)

        np.savetxt(func_path.replace('denosied_bold.nii.gz', f'fc_atl-{atlaPrefix}.txt'), CorCoefVoxel, delimiter='\t')
        np.savetxt(func_path.replace('denosied_bold.nii.gz', f'zfc_atl-{atlaPrefix}.txt'), CorCoefVoxelZ, delimiter='\t')

        ## select top 10% value in every row for gradient compute (brainspace can compute this)
        # CorCoefVoxelZ_posionly = CorCoefVoxelZ
        # CorCoefVoxelZ_posionly[CorCoefVoxelZ_posionly < 0] = 0
        # for x in range(1000):
        #     row_tem = CorCoefVoxelZ_posionly[x, :]
        #     thre = np.max(row_tem) - 0.1*(np.max(row_tem) - np.min(row_tem))
        #     for y in range(1000):
        #         row_tem[row_tem < thre] = 0
        #     CorCoefVoxelZ_posionly[x, :] = row_tem
        #
        # np.savetxt(os.path.join(derRoot, subId, 'func', f'{subId}_task-rest_space-MNI152NLin6Asym_desc-zfc_positopten_atl-Schaefer2018_1000.txt'), CorCoefVoxelZ_posionly, delimiter='\t')

logging.info('Done.')