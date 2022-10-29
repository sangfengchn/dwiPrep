import os
from os.path import join as opj
from glob import glob
import sys
import re
import numpy as np
import logging
logging.basicConfig(level=logging.DEBUG)

subPath = os.path.abspath(sys.argv[1])
subDerPath = os.path.abspath(sys.argv[2])

nRegion = len(glob(opj(subDerPath, 'tmp', 'tmp_atlas_roi_*.nii.gz')))
fnMat = np.zeros(shape = [nRegion, nRegion])
flMat = np.zeros(shape = [nRegion, nRegion])
faMat = np.zeros(shape = [nRegion, nRegion])
mdMat = np.zeros(shape = [nRegion, nRegion])
l1Mat = np.zeros(shape = [nRegion, nRegion])
rdMat = np.zeros(shape = [nRegion, nRegion])

for i in range(nRegion):
    for j in range(nRegion):
        with open(opj(subDerPath, 'tmp', f'tmp_tracks_filtered_roi-{i+1}-{j+1}.log'), 'r') as f:
            lines = f.readlines()
        for line in lines:
            if re.search('Number of tracks to render:', line):
                fnMat[i, j] = float(re.sub('Number of tracks to render:', '', line))
            elif re.search('Mean track length: ', line):
                flMat[i, j] = float(re.sub('Mean track length: ', '', line).split('+/-')[0])
        tmpFA = np.loadtxt(opj(subDerPath, 'tmp', f'tmp_tracks_filtered_roi-{i+1}-{j+1}_FA.log'))
        faMat[i, j] = tmpFA[2]
       
        tmpMD = np.loadtxt(opj(subDerPath, 'tmp', f'tmp_tracks_filtered_roi-{i+1}-{j+1}_MD.log'))
        mdMat[i, j] = tmpMD[2]
        
        tmpL1 = np.loadtxt(opj(subDerPath, 'tmp', f'tmp_tracks_filtered_roi-{i+1}-{j+1}_L1.log'))
        l1Mat[i, j] = tmpL1[2]
        
        tmpRD = np.loadtxt(opj(subDerPath, 'tmp', f'tmp_tracks_filtered_roi-{i+1}-{j+1}_RD.log'))
        rdMat[i, j] = tmpRD[2]
        

fnMat = (fnMat + fnMat.T) / 2
flMat = (flMat + flMat.T) / 2
faMat = (faMat + faMat.T) / 2
mdMat = (mdMat + mdMat.T) / 2
l1Mat = (l1Mat + l1Mat.T) / 2
rdMat = (rdMat + rdMat.T) / 2

np.savetxt(opj(subDerPath, 'FN_matrix.txt'), fnMat)
np.savetxt(opj(subDerPath, 'Length_matrix.txt'), flMat)
np.savetxt(opj(subDerPath, 'FA_matrix.txt'), faMat)
np.savetxt(opj(subDerPath, 'MD_matrix.txt'), mdMat)
np.savetxt(opj(subDerPath, 'L1_matrix.txt'), l1Mat)
np.savetxt(opj(subDerPath, 'RD_matrix.txt'), rdMat)