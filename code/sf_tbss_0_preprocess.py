import os
from os.path import join as opj
import re
import shutil
from glob import glob
import pandas as pd
import logging
logging.basicConfig(level=logging.DEBUG)

proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration'
derBnuOld = opj(proj, 'derivatives', 'preprocess_dwi_bnuold')
derBnuNew = opj(proj, 'derivatives', 'preprocess_dwi_bnunew')
derTt = opj(proj, 'derivatives', 'preprocess_dwi_tt')

df = pd.read_excel('sourcedata/allparticipants(deleted).xlsx', sheet_name='allparticipants(deleted)', header=0)
df = df.dropna(subset=['MRINumber'])
print(df)

subIdKey = {}
for i in glob(opj(derBnuOld, 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = re.sub(r'[a-zA-Z]', '', tmpKey)
    subIdKey[f'BNU{tmpKey}'] = os.path.abspath(i)
for i in glob(opj(derBnuNew, 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = tmpKey[0:5]
    subIdKey[tmpKey] = os.path.abspath(i)
for i in glob(opj(derTt, 'sub-*')):
    tmpKey = os.path.split(i)[-1]
    tmpKey = re.sub(r'sub-', '', tmpKey)
    tmpKey = re.sub(r'[a-zA-Z]', '', tmpKey)
    subIdKey[f'TT{tmpKey}'] = os.path.abspath(i)
# logging.info(subIdKey)

tbssPath = opj(proj, 'derivatives', 'tbss_fa')
if not os.path.exists(tbssPath):
    os.makedirs(opj(tbssPath, 'data'))

df = df.set_index('MRINumber')
newDf = []
for k, v in subIdKey.items():
    # logging.info(f'{k}, {v}')
    if k in df.index.values:
        tmpGroup = df.loc[k, 'GROUP']
        tmpPath = f'G{tmpGroup}_{df.loc[k, "Number"]}.nii.gz'
        logging.info(tmpPath)
        shutil.copyfile(opj(v, 'dtifit_FA.nii.gz'), opj(tbssPath, 'data', tmpPath))
        newDf.append(k)
newDf = pd.DataFrame({'MRINumber': newDf})
newDf = newDf.set_index('MRINumber')
df = newDf.join(df, how = 'left', on = 'MRINumber')
df.to_csv(opj(tbssPath, 'participants.csv'))
logging.info('Done.')