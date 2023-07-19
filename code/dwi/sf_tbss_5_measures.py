'''
 # @ Author: feng
 # @ Create Time: 2022-11-09 10:43:07
 # @ Modified by: feng
 # @ Modified time: 2022-11-09 10:43:19
 # @ Description: Get diffusion measures in ske
'''

import os
from os.path import join as opj
import nibabel as nib
import numpy as np
import pandas as pd
import logging
logging.basicConfig(level=logging.DEBUG)

# project path
proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration'
der = opj(proj, 'derivatives', 'tbss_renew', 'data', 'stats')
outPath = opj(der, 'Mean_lz_MDt_tfce_corrp_tstat12_pos_sig_mask_20230719.xlsx')

# inputs
aPath = opj(proj, 'resource', 'atlas', 'JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz')
aInfoPath = opj(proj, 'resource', 'atlas', 'JHU-tracts.csv')
pPath = opj(der, 'lz_MDt_tfce_corrp_tstat12_pos_sig_mask.nii.gz')
skePath = opj(der, 'all_MDt_skeletonised.nii.gz')


# atlas information
aInfo = pd.read_csv(aInfoPath, header=0, index_col=0)
aData = nib.load(aPath).get_fdata()

# binarlized p map
pData = nib.load(pPath).get_fdata()
pData[np.isnan(pData)] = 0
pData[pData < 0.95] = 0
pData[pData != 0] = 1

# load skeletonised data, and get mean values within significant region
skeData = nib.load(skePath).get_fdata()
# logging.info(skeData.shape)
resDf = pd.DataFrame()
for i in range(skeData.shape[3]):
    logging.info(f'Processing sub-{i+1}')
    tmpSkeData = skeData[:, :, :, i]
    tmpSkeData[np.isnan(tmpSkeData)] = 0

    tmpSkeDataMask = np.zeros(shape = tmpSkeData.shape)
    tmpSkeDataMask[tmpSkeData != 0] = 1
    tmpSkeDataSigMask = tmpSkeDataMask * pData

    tmpRow = {'SUBORDER': [i+1]}
    for j in aInfo.index.values:
        tmpAtlasData = np.zeros(aData.shape)
        tmpAtlasData[aData == j] = 1
        tmpAtlasSkeSigMask = tmpAtlasData * tmpSkeDataSigMask

        tmpRow[aInfo.loc[j, 'Abbr']] = [np.nanmean(tmpSkeData[tmpAtlasSkeSigMask == 1])]

    resDf = pd.concat([resDf, pd.DataFrame(tmpRow)])

# save result
resDf.to_excel(outPath, index=False)
logging.info('Done.')
