'''
 # @ Author: feng
 # @ Create Time: 2022-08-12 09:50:01
 # @ Modified by: feng
 # @ Modified time: 2022-08-12 10:08:48
 # @ Description: submit job for each image.
 '''
import os
from os.path import join as opj
from glob import glob
import time
import re
import subprocess
import logging
logging.basicConfig(
    format='%(asctime)s: %(message)s',
    level=logging.INFO
)

def func_jobNumber(server='zhang'):
    cli = f'qstat | grep {server}'
    resCli = os.popen(cli).readlines()
    return len(resCli)

def func_jobIsExists(subId):
    cli = f'qstat | grep {subId}'
    resCli = os.popen(cli).readlines()
    if len(resCli) == 0:
        return False
    else:
        return True

def submit(templateScriptPath, jobName, ppn, queName, tmpPath, proj, rawPath, derPath, subId):
    with open(templateScriptPath, 'r', encoding='utf-8') as f:
        newScript = f.readlines()
    newScript = [re.sub('#JOBNAME#', jobName, i) for i in newScript]
    newScript = [re.sub('#PPN#', str(ppn), i) for i in newScript]
    newScript = [re.sub('#QUENAME#', queName, i) for i in newScript]
    newScript = [re.sub('#TMPPATH#', tmpPath, i) for i in newScript]
    newScript = [re.sub('#PROJ#', proj, i) for i in newScript]
    newScript = [re.sub('#RAWPATH#', rawPath, i) for i in newScript]
    newScript = [re.sub('#DERPATH#', derPath, i) for i in newScript]
    newScript = [re.sub('#SUBID#', subId, i) for i in newScript]

    newScript = ''.join(newScript)
    
    try:
        p = subprocess.run('qsub', input=newScript, encoding='utf-8', shell=True, check=True, stdout=subprocess.PIPE)
        logging.info(p.stdout)
    except subprocess.CalledProcessError as err:
        logging.error('Error: ', err)

if __name__ == '__main__':
    proj = '/brain/babri_group/Desktop/LIUChen/SES'
    rawPath = opj(proj, 'SES_BIDS')
    derPath = opj(proj, 'derivatives')
    
    tmpRoot = 'log'
    queName = 'short'
    templateScriptPath = opj(proj, 'code', 'sf_preprocess_dwi_template.sh')
    jobNumMax = 500
    ppn = 8
    
    for i in glob(opj(rawPath, 'sub-*')):
        subId = os.path.split(i)[-1]
        jobName = f'lz_{subId.replace("sub-", "")}'
        
        logging.info(jobName)
        while func_jobNumber(server=queName) >= jobNumMax:
            time.sleep(5)

        tmpPath = opj(tmpRoot, jobName)
        if not os.path.exists(tmpPath):
            os.makedirs(tmpPath)

        if os.path.exists(opj(derPath, subId, 'jhu-icbm-tracts.nii.gz')):
            continue

        submit(templateScriptPath=templateScriptPath,
            jobName=jobName,
            ppn=ppn,
            queName=queName,
            tmpPath=tmpPath,
            proj=proj,
            rawPath=rawPath,
            derPath=derPath,
            subId=subId)
        time.sleep(2)