'''
 # @ Author: feng
 # @ Create Time: 2022-11-06 19:46:44
 # @ Modified by: feng
 # @ Modified time: 2022-11-06 19:46:46
 # @ Description: Get mean strength and density of a network.
 '''

import os
from os.path import join as opj
from glob import glob
import numpy as np
import pandas as pd
import logging
logging.basicConfig(level=logging.DEBUG)

der = 'derivatives/ResGRETNA'
mea = 'FA'
df = pd.DataFrame()
for i in sorted(glob(opj(der, mea, 'data', 'G*.txt'))):
    tmpFileName = os.path.split(i)[-1]
    tmpMat = np.loadtxt(i)
    np.fill_diagonal(tmpMat, 0)
    tmpMean = np.mean(tmpMat[tmpMat > 0])
    tmpDensity = np.sum(tmpMat > 0) / (tmpMat.shape[0] * tmpMat.shape[1] - tmpMat.shape[1])
    tmpDf = pd.DataFrame({'SUBID': [tmpFileName.replace('.mat', '')], 'MeanStrength': [tmpMean], 'Density': [tmpDensity]})
    df = pd.concat([df, tmpDf])

# logging.info(df.head())
df.to_excel(opj(der, mea, 'StrengthAndDensity.xlsx'), index=False)