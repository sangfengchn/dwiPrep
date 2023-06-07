import tarfile
import os
from os.path import join as opj
from glob import glob
import logging
logging.basicConfig(level=logging.INFO)

def untar(fname, dirs):
    t = tarfile.open(fname)
    t.extractall(path = dirs) 

if __name__ == "__main__":
    
    src = "sourcedata"
    dst = "test"
    
    for i in glob(opj(src, "NBACK", "*.tar.gz")):
        subId = os.path.split(i)[-1].replace(".tar.gz", "")
        logging.info(subId)
        
        # tmpDst = opj(dst, f"sub-{subId}")
        # if not os.path\\\.exists(tmpDst): untar(i, tmpDst)
        