import os
import sys
import numpy as np
import nibabel as nib
import logging
logging.basicConfig(level=logging.DEBUG)

subPath = os.path.abspath(sys.argv[1])
subDerPath = os.path.abspath(sys.argv[2])
subAtlasName = os.path.abspath(sys.argv[3])
# logging.info(subPath)

subAtlasImg = nib.load(subAtlasName)
subAtlasData = subAtlasImg.get_fdata()
nRegion = int(np.max(subAtlasData[:]))
for i in range(nRegion):
    tmpData = np.zeros(shape = subAtlasData.shape)
    tmpData[subAtlasData == (i + 1)] = 1
    nib.save(nib.Nifti1Image(tmpData, subAtlasImg.affine), os.path.join(subDerPath, 'tmp', f'tmp_atlas_roi_{i+1}.nii.gz'))