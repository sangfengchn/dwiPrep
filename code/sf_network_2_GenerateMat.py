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

proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration'
der = opj(proj, 'derivatives', 'ResGRETNA')

# inverse length
logging.info('Inverse length matrix')
for i in glob(opj(der, 'Length', 'data', 'G*')):
    tmpDstPath = opj(der, 'Length_inv', 'data')
    if not os.path.exists(tmpDstPath):
        os.makedirs(tmpDstPath)
    tmpMat = np.loadtxt(i)
    tmpNewMat = 1 / tmpMat
    tmpNewMat[tmpMat == 0] = 0
    np.savetxt(opj(tmpDstPath, os.path.split(i)[-1]), tmpNewMat, delimiter='\t', fmt='%.7e')

# fn/length
logging.info('FN/Length')
for i in glob(opj(der, 'Length', 'data', 'G*')):
    tmpFile = os.path.split(i)[-1]
    tmpDstPath = opj(der, 'FNrLength', 'data')
    if not os.path.exists(tmpDstPath):
        os.makedirs(tmpDstPath)
        
    tmpLenMat = np.loadtxt(i)
    tmpFnMat = np.loadtxt(opj(der, 'FN', 'data', tmpFile))
    tmpNewMat = tmpFnMat / tmpLenMat
    tmpNewMat[tmpMat == 0] = 0
    np.savetxt(opj(tmpDstPath, os.path.split(i)[-1]), tmpNewMat, delimiter='\t', fmt='%.7e')
    
logging.info('Done.')