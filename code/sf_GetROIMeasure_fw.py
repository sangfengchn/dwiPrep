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
from this import d
import nibabel as nib
import pandas as pd
import numpy as np
import logging
logging.basicConfig(level=logging.DEBUG)

# >>>>>>>>>>>>>>>>>> run <<<<<<<<<<<<<<<<
proj = '/Users/fengsang/Library/CloudStorage/OneDrive-mail.bnu.edu.cn/Learning/L_task-dmri'
der = opj(proj, 'derivatives', 'freewater', 'rawdata')
meaPrefix = 'fwc_wls_dti_FA_warp.nii.gz'
atlasName = 'resource/atlas/JHU-ICBM-labels-1mm.nii.gz'
atlasInfo = pd.read_csv(opj(proj, 'resource', 'atlas', 'JHU-labels.csv'), header=0, index_col=0)

resultPath = opj(proj, 'derivatives', 'preprocess', 'ROI_fwc_fa_jhuicbmlabels.csv')

result = pd.DataFrame()
for subId in sorted(os.listdir(der)):
    logging.info(subId)
    
    subAtlasData = nib.load(atlasName).get_fdata()
    for runId in os.listdir(opj(der, subId)):
        subMeaData = nib.load(opj(der, subId, runId, 'ResFW', meaPrefix)).get_fdata()
        subRow = {'SUBID': [subId], 'RUNID': [runId]}
        for idxRegion in atlasInfo.index.values:
            subRow[atlasInfo.loc[idxRegion, 'Abbr']] = [np.nanmean(subMeaData[subAtlasData==idxRegion])]
        result = pd.concat([result, pd.DataFrame(subRow)])
        
result.to_csv(resultPath, index=False)
logging.info('Done.')