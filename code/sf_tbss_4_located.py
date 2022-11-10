'''
 # @ Author: feng
 # @ Create Time: 2022-11-03 16:30:41
 # @ Modified by: feng
 # @ Modified time: 2022-11-03 16:45:18
 # @ Description: Summary the significant region location.
 '''

import os
from os.path import join as opj
import pandas as pd
import nibabel as nib
import numpy as np
import logging
logging.basicConfig(level=logging.DEBUG)

proj = '.'
statPath = opj(proj, 'derivatives', 'tbss_fa', 'data', 'stats', 'lz_tfce_corrp_tstat3_pos.nii.gz')

atlasInfo = pd.read_csv(opj(proj, 'resource', 'atlas', 'JHU-tracts.csv'), header=0, index_col=0)
# logging.info(atlasInfo)
atlasImg = nib.load(opj(proj, 'resource', 'atlas', 'JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz'))
atlasData = atlasImg.get_fdata()
# logging.info(atlasData.shape)

statData = nib.load(statPath).get_fdata()
statData[statData < 0.95] = 0
statData[statData != 0] = 1

for i in atlasInfo.index.values:
    tmpAtlasData = np.zeros(atlasData.shape)
    tmpAtlasData[atlasData == i] = 1
    tmpAtlasStatData = tmpAtlasData * statData
    atlasInfo.loc[i, 'TotalNumVoxel'] = np.sum(tmpAtlasData)
    atlasInfo.loc[i, 'SigNumVoxel'] = np.sum(tmpAtlasStatData)
    atlasInfo.loc[i, 'Rate_Sig2Total'] = np.sum(tmpAtlasStatData) / np.sum(tmpAtlasData)
logging.info(atlasInfo)
atlasInfo.to_excel(statPath.replace('.nii.gz', '_summary.xlsx'))