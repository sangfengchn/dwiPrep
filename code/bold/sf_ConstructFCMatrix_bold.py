'''
 # @ Author: feng
 # @ Create Time: 2023-04-17 12:15:19
 # @ Modified by: feng
 # @ Modified time: 2023-04-17 12:15:21
 # @ Description: Construct the fc matrix of bold.
 '''

import os
from os.path import join as opj
from glob import glob
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")

proj = ""
der = opj(proj, "derivatives", "fmriprep")

for i in glob(opj(der, "sub-*")):
    subId = os.path.split(i)[-1]
    logging.info(subId)
    
    subBoldPath = opj(i, "func", f"{subId}_task-rest_space-MNI152NLin6Asym_desc-denosied_bold.nii.gz")
    pass