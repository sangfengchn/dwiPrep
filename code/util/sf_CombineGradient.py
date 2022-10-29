import os
from os.path import join as opj
from glob import glob
import numpy as np
import sys
import logging
logging.basicConfig(level=logging.DEBUG)

subPath = os.path.abspath(sys.argv[1])
subDerPath = os.path.abspath(sys.argv[2])
# logging.info(subPath)

# combine bval
bval = []
bvec = []
nSample = 0
for i in sorted(glob(opj(subPath, 'dwi', '*.bval'))):
    # logging.info(i)
    bval.append(np.loadtxt(i))
    bvec.append(np.loadtxt(i.replace('.bval', '.bvec')))
    nSample += bval[-1].shape[0]

bvalComb = np.zeros(shape = [1, nSample])
bvecComb = np.zeros(shape = [3, nSample])
for i in range(len(bvec)):
    tmpBval = bval[i]
    bvalComb[0, i*tmpBval.shape[0]:(i+1)*tmpBval.shape[0]] = tmpBval
    tmpBvec = bvec[i]
    bvecComb[:, i*tmpBvec.shape[1]:(i+1)*tmpBvec.shape[1]] = tmpBvec

# comGradientMatrix = np.concatenate((bvecComb, bvalComb), axis=0).T
np.savetxt(opj(subDerPath, 'dwi.bval'), bvalComb)
np.savetxt(opj(subDerPath, 'dwi.bvec'), bvecComb)
np.savetxt(opj(subDerPath, 'dwi.GradientMatrix'), bvecComb.T)