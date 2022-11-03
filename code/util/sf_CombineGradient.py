import os
from os.path import join as opj
from glob import glob
import numpy as np
import sys
import logging
logging.basicConfig(level=logging.DEBUG)

# subPath = os.path.abspath(sys.argv[1])
# subDerPath = os.path.abspath(sys.argv[2])
subPath = os.path.abspath('test/sub-44JIANGHONGXIAN')
subDerPath = os.path.abspath('test/der/')
# logging.info(subPath)

# combine bval
bval = []
bvec = []
nSample = 0
for i in sorted(glob(opj(subPath, 'dwi', '*.bval'))):
    logging.info(i)
    bval.append(np.loadtxt(i))
    bvec.append(np.loadtxt(i.replace('.bval', '.bvec')))
    nSample += bval[-1].shape[0]
    logging.info(bval[-1].shape)
    logging.info(bvec[-1].shape)

bvalComb = np.zeros(shape = [1, nSample])
bvecComb = np.zeros(shape = [3, nSample])
curIndex = 0
for i in range(len(bvec)):
    tmpBval = bval[i]
    # logging.info(tmpBval.shape)
    bvalComb[0, curIndex:curIndex+tmpBval.shape[0]] = tmpBval
    tmpBvec = bvec[i]
    # logging.info(tmpBvec.shape)
    bvecComb[:, curIndex:curIndex+tmpBvec.shape[1]] = tmpBvec
    curIndex += tmpBval.shape[0]

# comGradientMatrix = np.concatenate((bvecComb, bvalComb), axis=0).T
np.savetxt(opj(subDerPath, 'dwi.bval'), bvalComb)
np.savetxt(opj(subDerPath, 'dwi.bvec'), bvecComb)
np.savetxt(opj(subDerPath, 'dwi.GradientMatrix'), bvecComb.T)