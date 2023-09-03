'''
 # @ Author: feng
 # @ Create Time: 2022-11-02 18:20:07
 # @ Modified by: feng
 # @ Modified time: 2022-11-02 18:20:58
 # @ Description: Inversing the length matrix, and generating the fn/length matrix
 '''

import os
from os.path import join as opj
import numpy as np
from glob import glob
import logging
logging.basicConfig(level=logging.DEBUG)

proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration_multiple_network'
der = opj(proj, 'derivatives', 'ResGRETNA')

atlas = "BN_Atlas_246_1mm_246"
# inverse length
logging.info('Inverse length matrix')
for i in glob(opj(der, f"Length_{atlas}", 'data', '*.txt')):
    tmpDstPath = opj(der, f'Length_inv_{atlas}', 'data')
    if not os.path.exists(tmpDstPath):
        os.makedirs(tmpDstPath)
    tmpMat = np.loadtxt(i)
    tmpNewMat = 1 / tmpMat
    tmpNewMat[tmpMat == 0] = 0
    np.savetxt(opj(tmpDstPath, os.path.split(i)[-1]), tmpNewMat, delimiter='\t', fmt='%.7e')

# fn/length
logging.info('FN/Length')
for i in glob(opj(der, f"Length_{atlas}", 'data', '*.txt')):
    tmpFile = os.path.split(i)[-1]
    tmpDstPath = opj(der, f'FNrLength_{atlas}', 'data')
    if not os.path.exists(tmpDstPath):
        os.makedirs(tmpDstPath)
        
    tmpLenMat = np.loadtxt(i)
    tmpFnMat = np.loadtxt(opj(der, f'FN_{atlas}', 'data', tmpFile))
    tmpNewMat = tmpFnMat / tmpLenMat
    tmpNewMat[tmpLenMat == 0] = 0
    tmpNewMat[np.isnan(tmpNewMat)] = 0
    np.savetxt(opj(tmpDstPath, os.path.split(i)[-1]), tmpNewMat, delimiter='\t', fmt='%.7e')
    
logging.info('Done.')