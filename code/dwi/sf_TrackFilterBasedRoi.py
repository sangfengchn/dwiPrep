'''
 # @ Author: feng
 # @ Create Time: 2023-05-18 23:06:24
 # @ Modified by: feng
 # @ Modified time: 2023-05-18 23:06:26
 # @ Description: 生成roi的mask，并且保存穿过这个roi的纤维束trk文件。
 '''

import os
from os.path import join as opj
from glob import glob
import nibabel as nib
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")

proj = "."
der = opj(proj, "derivatives", "preprocess_dwi")
# 测试用，具体需要待会儿跟栗子确认
roiIndex = 16

for i in glob(opj(der, "sub-*")):
    subId = os.path.split(i)[-1]
    logging.info(subId)
    
    # 创建roi的mask
    subAtlasPath = opj(i, "AAL_brain.nii.gz")
    subAtlasImg = nib.load(subAtlasPath)
    subAtlasData = subAtlasImg.get_fdata()
    subAtlasData[subAtlasData != roiIndex] = 0
    subAtlasData[subAtlasData != 0] = 1
    
    nib.save(nib.Nifti1Image(subAtlasData, subAtlasImg.affine), opj(i, f"AAL_brain_roi-{roiIndex}.nii.gz"))
    break

logging.info("Done.")