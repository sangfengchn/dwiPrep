'''
 # @ Author: feng
 # @ Create Time: 2023-04-17 12:21:08
 # @ Modified by: feng
 # @ Modified time: 2023-04-17 12:23:00
 # @ Description: Copy data from sf's database.
 '''

import os
from os.path import join as opj
import shutil
import pandas as pd
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")

der = "./derivatives/fmriprep"
dst = "./toLZL/fmriprep"
if not os.path.exists(dst): os.makedirs(dst)

df = pd.read_csv("./sourcedata/participants.csv", header=0, index_col=3)
newDf = pd.read_csv("./subinfo_toLZL.csv", header=0, index_col=0)
for i in df.index.values:
    subMriId = df.loc[i, "OLDID"]
    if subMriId in newDf.index.values:
        logging.info(subMriId)
        subSrcPath = opj(der, i, "func")
        subDstPath = opj(dst, i)
        if not os.path.exists(subDstPath): os.makedirs(subDstPath)
        subDstPath = opj(subDstPath, "func")
        shutil.copytree(subSrcPath, subDstPath)

logging.info("Done")