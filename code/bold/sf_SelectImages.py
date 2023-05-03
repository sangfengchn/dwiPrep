'''
 # @ Author: feng
 # @ Create Time: 2023-04-17 12:21:08
 # @ Modified by: feng
 # @ Modified time: 2023-04-17 12:23:00
 # @ Description: Copy data from sf's database.
 '''

import os
from os.path import join as opj
import re
import pandas as pd
import shutil
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")

der = "derivatives/fmriprep"

df = pd.read_csv("sourcedata/participants.csv", header=0)
df = df.set_index("OLDID")
df = df.loc[df.Site == "BNUOLD"]
logging.info(df.head())

newDf = pd.read_excel("all_beh_686.xlsx", header=0, index_col=0)
logging.info(newDf)

for i in newDf.index.values:
    subNewId = df.loc[i, "participant_id"]
    if not os.path.exists(opj(der, subNewId, "func")):
        logging.info(f"OLDID {i}, NEWID {subNewId}")

# for i in os.listdir(der):
#     subOldId = re.sub(r"[A-Za-z]", "", i.replace(".tar.gz", ""))
#     subOldId = f"sub-BNU{subOldId}"
#     subNewId = df.loc[subOldId, "participant_id"]
#     shutil.copy(opj(der, i), opj("append", f"{subNewId}.tar.gz"))

logging.info("Done.")

