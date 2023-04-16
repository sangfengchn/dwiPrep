import os
from os.path import join as opj
import shutil
from glob import glob
import logging

logging.basicConfig(level = logging.INFO, format = "%(asctime)s %(message)s")

proj = "/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration_multiple_network"
der = opj(proj, "derivatives", "preprocess_dwi")

for i in glob(opj(der, "sub-*")):
    subId = os.path.split(i)[-1]
    # logging.info(subId)
    if not os.path.exists(opj(i, "Network", "Deterministic", "tracks_filtered_ROIVoxelSize_BN_Atlas_246_1mm_246.txt")):
        logging.info(subId)
        shutil.rmtree(i)

logging.info("Done.")
