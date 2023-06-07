import os
from os.path import join as opj
from glob import glob
import gzip
import logging
logging.basicConfig(level=logging.INFO)

def ungz(src, dst):
    fileGz = gzip.GzipFile(src)
    with open(dst, "wb") as f:
        f.writelines(fileGz)
    return dst

if __name__ == "__main__":
    raw = "rawdata"
    for i in glob(opj(raw, "sub-*", "*", "*.nii.gz")):
        logging.info(i)

        ungz(i, i.replace(".nii.gz", ".nii"))
