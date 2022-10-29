'''
 # @ Author: feng
 # @ Create Time: 2022-10-19 16:01:13
 # @ Modified by: feng
 # @ Modified time: 2022-10-19 16:01:14
 # @ Description: Get ROI measures.
 '''

import os
from os.path import join as opj
from glob import glob
import nibabel as nib
import pandas as pd
import numpy as np
import logging
logging.basicConfig(level=logging.DEBUG)

# >>>>>>>>>>>>>>>>>> run <<<<<<<<<<<<<<<<
proj = '/Users/fengsang/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Learning/L_task-dmri'
der = opj(proj, 'derivatives', 'preprocess')
meaPrefix = 'FA'
atlasName = 'jhu-icbm-labels.nii.gz'
atlasInfo = pd.read_csv(opj(proj, 'resource', 'atlas', 'JHU-labels.csv'), header=0, index_col=0)
resultPath = opj(proj, 'derivatives', 'preprocess', 'ROI_FA_jhuicbmlabels.csv')

result = pd.DataFrame()
for subPath in sorted(glob(opj(der, 'sub-*'))):
    subId = os.path.split(subPath)[-1]
    logging.info(subId)
    
    subAtlasData = nib.load(opj(subPath, atlasName)).get_fdata()
    subMeaData = nib.load(opj(subPath, 'dtifit_FA.nii.gz')).get_fdata()
    subRow = {'SUBID': [subId]}
    for idxRegion in atlasInfo.index.values:
        subRow[atlasInfo.loc[idxRegion, 'Abbr']] = [np.nanmean(subMeaData[subAtlasData==idxRegion])]
    result = pd.concat([result, pd.DataFrame(subRow)])

result.to_csv(resultPath, index=False)
logging.info('Done.')