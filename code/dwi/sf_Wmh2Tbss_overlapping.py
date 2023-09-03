import os
from os.path import join as opj
from glob import glob
import nibabel as nib
import numpy as np
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

proj = '.'
der = opj(proj, 'derivatives', 'wmh2tbss')

tmpSumDat = np.zeros(shape=[182, 218, 182])
tmpCount = 0
for i in glob(opj(der, 'G*.nii.gz')):
    logging.info(i)
    
    tmpDatImg = nib.load(i)
    tmpDat = tmpDatImg.get_fdata()
    tmpSumDat += tmpDat
    tmpCount += 1

nib.save(nib.Nifti1Image(tmpSumDat, tmpDatImg.affine), opj(der, 'wmh_overlapping.nii.gz'))
nib.save(nib.Nifti1Image(tmpSumDat/tmpCount, tmpDatImg.affine), opj(der, 'wmh_overlapping_rate.nii.gz'))
