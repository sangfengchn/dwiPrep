'''
 # @ Author: feng
 # @ Create Time: 2023-05-21 20:55:30
 # @ Modified by: feng
 # @ Modified time: 2023-05-21 20:55:31
 # @ Description:
 '''

import os
from os.path import join as opj
from glob import glob
import nibabel as nib
import numpy as np
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")

proj = "/brain/babri_in/sangf/Data/D_desc-babri"
der = opj(proj, "toLZL", "fmriprep")

atlasPath = opj(proj, "AAL_brain_2mm.nii.gz")
atlasImg = nib.load(atlasPath) 
atlasImgData = atlasImg.get_fdata()
roiIndex = 15

for tmpPath in glob(opj(der, "sub-*", "func", "*space-MNI152NLin6Asym_desc-denosied_bold.nii.gz")):
    if (os.path.exists(tmpPath.replace(".nii.gz", f".fc{roiIndex}.log")) or
        os.path.exists(tmpPath.replace("desc-denosied", f"desc-zfc_roi-{roiIndex}"))):
        continue
    with open(tmpPath.replace(".nii.gz", f".fc{roiIndex}.log"), "w") as f: f.writelines("")
    logging.info(tmpPath)
    tmpImg = nib.load(tmpPath)
    tmpImgData = tmpImg.get_fdata()
    dims = tmpImgData.shape

    tmpSeedMeanSingle = np.zeros((dims[3],))
    for i in range(dims[3]):
        tmpData = tmpImgData[:, :, :, i]
        tmpSeedMeanSingle[i] = np.nanmean(tmpData[atlasImgData == roiIndex])

    tmpCorrMat = np.zeros((dims[0], dims[1], dims[2]))
    for i in range(dims[0]):
        for j in range(dims[1]):
            for k in range(dims[2]):
                tmpData = tmpImgData[i, j, k, :]
                tmpCorrcoef = np.corrcoef(tmpSeedMeanSingle, tmpData)
                tmpCorrMat[i, j, k] = tmpCorrcoef[0, 1]
    tmpCorrMat[np.isnan(tmpCorrMat)] = 0
    tmpCorrMatZ = (np.log(1 + tmpCorrMat) - np.log(1 - tmpCorrMat)) / 2
    nib.save(nib.Nifti1Image(tmpCorrMat, tmpImg.affine), tmpPath.replace("desc-denosied", f"desc-fc_roi-{roiIndex}"))
    nib.save(nib.Nifti1Image(tmpCorrMatZ, tmpImg.affine), tmpPath.replace("desc-denosied", f"desc-zfc_roi-{roiIndex}"))
    
logging.info("Done.")