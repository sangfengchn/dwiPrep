'''
 # @ Author: feng
 # @ Create Time: 2023-05-19 11:32:27
 # @ Modified by: feng
 # @ Modified time: 2023-05-19 11:32:29
 # @ Description: 将每一个人的结果文件合并为一个表格。
 '''

import os
from os.path import join as opj
from glob import glob
import pandas as pd
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")

proj = "."
der = opj(proj, "derivatives", "preprocess_dwi")
# 测试用，具体需要待会儿跟栗子确认
roiIndex = 16

resDf = pd.DataFrame()
for i in glob(opj(der, "sub-*", "TracksMeasure*.csv")):
    subMea = os.path.split(i)[-1]
    _, tmpMea, tmpRoi = subMea.split("_")
    
    subId = os.path.split(os.path.split(i)[-2])[-1]
    logging.info(subId)
    
    subDf = pd.read_csv(i, header=0)
    subDf["SUBID"] = subId
    subDf["Measure"] = tmpMea.replace("mea-", "")
    subDf["ROI"] = tmpMea.replace(".csv", "").replace("roi-", "")
    
    resDf = pd.concat([resDf, subDf])
    
resDf.to_csv("MergedTrackMeasure.csv", index=False)
logging.info("Done.")