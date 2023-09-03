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
proj = '.'
der = opj(proj, 'toLZL', 'cat')
# meaPrefix = 'GM'
atlasName = 'AAL_brain.nii.gz'
atlasInfo = pd.read_csv('AAL_brain.csv', header=0, index_col=0)
atlasData = nib.load(opj(proj, atlasName)).get_fdata()

resultPath = opj(proj, 'toLZL', 'GMV_AAL_brain.csv')
result = pd.DataFrame()
for subPath in sorted(glob(opj(der, 'sub-*'))):
    subId = os.path.split(subPath)[-1]
    logging.info(subId)
    
    subMeaData = nib.load(opj(subPath, 'mri', f'smwp1{subId}_T1w.nii')).get_fdata()
    subRow = {'subid': [subId]}
    for idxRegion in atlasInfo.index.values:
        # logging.info(idxRegion)
        subRow[atlasInfo.loc[idxRegion, 'Name']] = [np.nansum(subMeaData[atlasData==idxRegion])]
    with open(opj(subPath, "report", "TIV.txt"), "r") as f:
        lines = f.readlines()
    subRow["TIV"] = (lines[0].split())[0]
    logging.info(subRow)
    result = pd.concat([result, pd.DataFrame(subRow)])
    # break
    
result.to_csv(resultPath, index=False)
logging.info('Done.')