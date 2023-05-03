'''
 # @ Author: Feng Sang
 # @ Create Time: 2022-06-16 13:21:03
 # @ Modified by: Feng Sang
 # @ Modified time: 2022-06-16 13:21:28
 # @ Description: 保存经过ICA-AROMA（因为这个文件本身就去掉了ICA-AROMA的信号）和其他无关变量（load_confounds中的ica_aroma，包括线性漂移、白质-脑脊液信号）。
 '''

import os
import glob
import nibabel as nib
from nilearn import image
from nilearn.interfaces.fmriprep import load_confounds_strategy
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

derRoot = 'toLIZIlin/fmriprep'
remove_time = 10

# derRoot = 'test'
for i in glob.glob(os.path.join(derRoot, 'sub-*')):
    subId = os.path.split(i)[-1]
    
    for j in glob.glob(os.path.join(derRoot, subId, 'func', '*space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii.gz')):
        tmpAromaFile = j
        
        if os.path.exists(tmpAromaFile.replace('smoothAROMAnonaggr', 'denosied')): continue
        
        logging.info(subId)
            
        """regression global single"""
        # tmpData = nib.load(tmpAromaFile)
        # tmpConfound, tmpSampleMask = load_confounds_strategy(
        #     img_files=tmpAromaFile,
        #     denoise_strategy='ica_aroma',
        #     global_signal='basic'
        # )
        # tmpDataDenoised = image.clean_img(tmpData, confounds=tmpConfound, detrend=False, standardize=False)
        # tmpOutput = tmpAromaFile.replace('smoothAROMAnonaggr', 'denosiedGlobal')
        # nib.save(tmpDataDenoised, os.path.join(tmpOutput))
        
        """regression withnot global single"""
        tmpConfound, tmpSampleMask = load_confounds_strategy(
            img_files=tmpAromaFile,
            denoise_strategy='ica_aroma'
        )
        tmpData = nib.load(tmpAromaFile)
        total_time = tmpData.shape[-1]

        # for some subs not delete first 10 times volume
        if total_time == 240:
            tmpData = image.index_img(tmpData, slice(remove_time, total_time))
            tmpConfound = tmpConfound.tail(total_time - remove_time)

            tmpDataDenoised = image.clean_img(tmpData, confounds=tmpConfound, detrend=False, standardize=False)
        elif total_time == 230:
            tmpDataDenoised = image.clean_img(tmpData, confounds=tmpConfound, detrend=False, standardize=False)
        else:
            logging.info('ERROR: TIME SERIES IS ' + str(total_time))
            continue


        tmpOutput = tmpAromaFile.replace('smoothAROMAnonaggr', 'denosied')
        nib.save(tmpDataDenoised, os.path.join(tmpOutput))
            
logging.info('Done.')