'''
 # @ Author: feng
 # @ Create Time: 2022-08-17 14:00:15
 # @ Modified by: feng
 # @ Modified time: 2022-09-05 14:59:27
 # @ Description: Extract mean value for the results of PANDA.
 '''
import os
from os.path import join as opj
from glob import glob
import numpy as np
import logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s: %(message)s'
)

if __name__ == '__main__':
    data = 'data'
    resPath = 'results_tiv.csv'
    
    resStr = ['SUBID,TIV,GM,WM,CSF\n']
    for i in sorted(glob(opj(data, 'sub-*'))):
        subId = os.path.split(i)[-1]
        logging.info(subId)
        
        if not os.path.exists(opj(i, 'report', 'TIV.txt')):
            logging.error(f'{subId} has not tiv file.')
            continue
            
        subTiv = np.loadtxt(opj(i, 'report', 'TIV.txt'))
        resStr.append(f'{subId},{subTiv[0]},{subTiv[1]},{subTiv[2]},{subTiv[3]}\n')
        
    with open(resPath, 'w') as f:
        f.writelines(resStr)
    logging.info('Done.')
