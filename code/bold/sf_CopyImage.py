'''
 # @ Author: feng
 # @ Create Time: 2023-05-23 12:40:38
 # @ Modified by: feng
 # @ Modified time: 2023-05-23 12:40:40
 # @ Description:
 '''

import os
from os.path import join as opj
import re
import shutil
from glob import glob
import pandas as pd
import logging
logging.basicConfig(level=logging.DEBUG)

proj = '.'
der = opj(proj, 'toLZL', 'fmriprep')

df = pd.read_csv('subinfo_toLZL.csv', header=0)
print(df)

subIdKey = {}
for i in glob(opj(der, 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = re.sub(r'[a-zA-Z]', '', tmpKey)
    subIdKey[f'BNU{tmpKey}'] = os.path.abspath(i)

tbssPath = opj(proj, 'toLZL', 'ResZFc_roi16')
if not os.path.exists(tbssPath):
    os.makedirs(opj(tbssPath, 'data'))

df = df.set_index('MRINumber')
for k, v in subIdKey.items():
    # logging.info(f'{k}, {v}')
    if k in df.index.values:
        tmpGroup = df.loc[k, 'GROUP']
        tmpPath = f'G{tmpGroup}_{df.loc[k, "Number"]}.nii.gz'
        logging.info(tmpPath)
        
        if not os.path.exists(opj(v, 'func', f'sub-{k}_task-rest_space-MNI152NLin6Asym_desc-zfc_roi-16_bold.nii.gz')):
            shutil.copyfile(opj(v, 'func', f'sub-{k}_task-rest_run-1_space-MNI152NLin6Asym_desc-zfc_roi-16_bold.nii.gz'), opj(tbssPath, 'data', tmpPath))
        else:
            shutil.copyfile(opj(v, 'func', f'sub-{k}_task-rest_space-MNI152NLin6Asym_desc-zfc_roi-16_bold.nii.gz'), opj(tbssPath, 'data', tmpPath))

logging.info('Done.')