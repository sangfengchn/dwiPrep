import os
from os.path import join as opj
import shutil
from glob import glob
import logging
logging.basicConfig(level=logging.DEBUG)

raw = '/brain/babri_group/Desktop/LIUChen/SES/SES_BIDS'
der = '/brain/babri_group/Desktop/LIUChen/SES/derivatives'

# for i in glob(opj(raw, 'sub-*')):
#     subId = os.path.split(i)[-1]
#     if subId not in os.listdir(der):
#         logging.info(subId)

for i in glob(opj(der, 'sub-*')):
    if len(os.listdir(i)) < 40:
        # shutil.rmtree(opj(i))
        logging.info(i)

# for i in glob(opj(raw, 'sub-*')):
#     subId = os.path.split(i)[-1]
    