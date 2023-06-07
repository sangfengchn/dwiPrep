import os
from os.path import join as opj
from glob import glob
import logging
logging.basicConfig(level=logging.INFO)

if __name__ == "__main__":
     
    src = "test"
    dst = "rawdata"
    
    for i in glob(opj(src, "sub-*")):
        subId = os.path.split(i)[-1]
        logging.info(subId)
        if os.path.exists(opj(dst, subId)): continue
        tmpCmd = f"dcm2bids -d {os.path.abspath(i)} -p {subId.replace('sub-', '')} -c dcm2bids_config_bnuold.json"
        os.system(tmpCmd)
        