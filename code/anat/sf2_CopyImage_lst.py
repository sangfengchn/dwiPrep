import os
from os.path import join as opj
from glob import glob
import shutil
import nibabel as nib
import logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s: %(message)s'
)

bids = 'bids_bnu'
rawdata = opj(bids, 'rawdata')
derivatives = opj(bids, 'derivatives', 'wmh')

for i in glob(opj(rawdata, 'sub-*')):
    subId = os.path.split(i)[-1]
    
    logging.info(subId)
    subFlairPath = opj(i, 'anat', f'{subId}_FLAIR.nii.gz')
    if not os.path.exists(subFlairPath):
        logging.warning(f'{subId} has not flair image.')
        continue
    
    subT1wPath = opj(i, 'anat', f'{subId}_T1w.nii.gz')
    if not os.path.exists(subT1wPath):
        logging.warning(f'{subId} has not t1w image.')
        continue
    
    subDstPath = opj(derivatives, subId)
    if not os.path.exists(subDstPath):
        os.makedirs(subDstPath)
        
    nib.save(nib.load(subT1wPath), opj(subDstPath, 't1w.nii'))
    nib.save(nib.load(subFlairPath), opj(subDstPath, 'flair.nii'))

logging.info('Done.')