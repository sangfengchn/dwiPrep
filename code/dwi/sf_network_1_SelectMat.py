'''
 # @ Author: feng
 # @ Create Time: 2022-11-02 13:44:59
 # @ Modified by: feng
 # @ Modified time: 2022-11-02 13:45:02
 # @ Description: Selecting and copying matrix.
 '''

import os
from os.path import join as opj
import shutil
from glob import glob
import re
import pandas as pd
import logging
logging.basicConfig(level=logging.DEBUG)

proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration_multiple_network'
derBnuOld = opj(proj, 'derivatives', 'preprocess_dwi')
# derBnuNew = opj(proj, 'derivatives', 'preprocess_dwi_bnunew')
# derTt = opj(proj, 'derivatives', 'preprocess_dwi_tt')

df = pd.read_excel('sourcedata/all_beh_686.xlsx', sheet_name='Sheet1', header=0)
df = df.dropna(subset=['MRINumber'])
print(df)

subIdKey = {}
for i in glob(opj(derBnuOld, 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = re.sub(r'[a-zA-Z]', '', tmpKey)
    subIdKey[f'BNU{tmpKey}'] = os.path.abspath(i)
# for i in glob(opj(derBnuNew, 'sub-*')):
#     tmpKey = os.path.split(i)[-1]
#     tmpKey = re.sub(r'sub-', '', tmpKey)
#     tmpKey = tmpKey[0:5]
#     subIdKey[tmpKey] = os.path.abspath(i)
# for i in glob(opj(derTt, 'sub-*')):
#     tmpKey = os.path.split(i)[-1]
#     tmpKey = re.sub(r'sub-', '', tmpKey)
#     tmpKey = re.sub(r'[a-zA-Z]', '', tmpKey)
#     subIdKey[f'TT{tmpKey}'] = os.path.abspath(i)
# logging.info(subIdKey)

prefix = 'FN'
atlas = 'AAL_brain_90'
tbssPath = opj(proj, 'derivatives', 'ResGRENTA', f"{prefix}_{atlas}")
if not os.path.exists(tbssPath):
    os.makedirs(opj(tbssPath, f'data'))

df = df.set_index('MRINumber')
newDf = []
for k, v in subIdKey.items():
    # logging.info(f'{k}, {v}')
    if k in df.index.values:
        # tmpGroup = df.loc[k, 'GROUP']
        # tmpPath = f'G{tmpGroup}_{df.loc[k, "Number"]}.txt'
        tmpPath = f"{df.loc[k, 'Number']}.txt"

        logging.info(tmpPath)
        tmpSrcPath = opj(v, 'Network', 'Deterministic', f'tracks_filtered_Matrix_{prefix}_{atlas}.txt')
        if os.path.exists(tmpSrcPath):
            shutil.copyfile(tmpSrcPath, opj(tbssPath, 'data', tmpPath))
            newDf.append(k)
newDf = pd.DataFrame({'MRINumber': newDf})
newDf = newDf.set_index('MRINumber')
df = newDf.join(df, how = 'left', on = 'MRINumber')
df.to_csv(opj(tbssPath, 'participants.csv'))
logging.info('Done.')
