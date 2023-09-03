import os
from os.path import join as opj
from glob import glob
import nibabel as nib
import numpy as np
import pandas as pd
import logging
logging.basicConfig(level=logging.INFO)

# project path
proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration'
der = opj(proj, 'derivatives', 'tbss_renew', 'data', 'stats')

# inputs
aPath = opj(proj, 'resource', 'atlas', 'JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz')
aInfoPath = opj(proj, 'resource', 'atlas', 'JHU-tracts.csv')
pPath = opj(der, 'lz_FA_tfce_corrp_tstat2_pos.nii.gz')
skePath = opj(der, 'all_FA_skeletonised.nii.gz')
outPath = opj(der, 'Mean_FA_lz_tfce_corrp_tstat2_pos_20230904.xlsx')
wmhPaths = sorted(glob(opj(proj, 'derivatives', 'wmh2tbss', 'G*.nii.gz')))
# logging.info(wmhPath)

# atlas information
aInfo = pd.read_csv(aInfoPath, header=0, index_col=0)
aData = nib.load(aPath).get_fdata()

# binarlized p map
pData = nib.load(pPath).get_fdata()
pData[pData < 0.95] = 0
pData[pData != 0] = 1

# load skeletonised data, and get mean values within significant region
skeData = nib.load(skePath).get_fdata()
# logging.info(skeData.shape)
resDf = pd.DataFrame()
for i in range(skeData.shape[3]):
    logging.info(f'Processing sub-{i+1}')
    tmpWmhMaskData = nib.load(wmhPaths[i]).get_fdata()
    # wmh mask中0变1，1变0
    tmpWmhMaskData = np.ones(shape=tmpWmhMaskData.shape) - tmpWmhMaskData
    
    tmpSkeData = skeData[:, :, :, i]
    tmpSkeDataSig = tmpSkeData * pData * tmpWmhMaskData

    tmpRow = {'SUBORDER': [i+1]}
    for j in aInfo.index.values:
        tmpAtlasData = np.zeros(aData.shape)
        tmpAtlasData[aData == j] = 1
        tmpRow[aInfo.loc[j, 'Abbr']] = [np.mean(tmpAtlasData * tmpSkeDataSig)]
    resDf = pd.concat([resDf, pd.DataFrame(tmpRow)])
    break

logging.info(resDf)
# save result
# resDf.to_excel(outPath, index=False)
logging.info('Done.')