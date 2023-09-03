import os
from os.path import join as opj
from glob import glob
import shutil
import re
import pandas as pd
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

proj = '.'
srcPath = opj(proj, 'derivatives')
dstPath = opj(srcPath, 'wmh2tbss')
dat = pd.read_csv(opj(dstPath, 'participants.csv'), header=0, index_col=0)

subIdKey = {}
for i in glob(opj(srcPath, 'wmh2tbss_bnuold', 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = re.sub(r'[a-zA-Z]', '', tmpKey)
    subIdKey[f'BNU{tmpKey}'] = os.path.abspath(i)
for i in glob(opj(srcPath, 'wmh2tbss_bnunew', 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = tmpKey[0:5]
    subIdKey[tmpKey] = os.path.abspath(i)

for i in dat.index.values:
    logging.info(i)
    
    tmpSrcPath = opj(subIdKey[i], 'ples_lpa_mrflair_mni_mask.nii.gz')
        
    tmpGroup = dat.loc[i, 'GROUP']
    tmpNumber = dat.loc[i, 'Number']
    tmpDstPath = opj(dstPath, f'G{tmpGroup}_{tmpNumber}.nii.gz')
    if not os.path.exists(tmpSrcPath): logging.info(tmpSrcPath)
    
    shutil.copyfile(tmpSrcPath, tmpDstPath)
    
logging.info('Done.')