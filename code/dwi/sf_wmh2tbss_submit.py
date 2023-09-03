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

def submit(templateScriptPath, jobName, ppn, queName, tmpPath, derWmhPath, derDtiPath, subId, resource):
    with open(templateScriptPath, 'r', encoding='utf-8') as f:
        newScript = f.readlines()
    newScript = [re.sub('#JOBNAME#', jobName, i) for i in newScript]
    newScript = [re.sub('#PPN#', str(ppn), i) for i in newScript]
    newScript = [re.sub('#QUENAME#', queName, i) for i in newScript]
    newScript = [re.sub('#TMPPATH#', tmpPath, i) for i in newScript]
    newScript = [re.sub('#WMHDER#', derWmhPath, i) for i in newScript]
    newScript = [re.sub('#DTIDER#', derDtiPath, i) for i in newScript]
    newScript = [re.sub('#SUBID#', subId, i) for i in newScript]
    newScript = [re.sub('#RESOURCE#', resource, i) for i in newScript]

    newScript = ''.join(newScript)
    logging.info(newScript)
    
    # try:
    #     p = subprocess.run('qsub', input=newScript, encoding='utf-8', shell=True, check=True, stdout=subprocess.PIPE)
    #     logging.info(p.stdout)
    # except subprocess.CalledProcessError as err:
    #     logging.error('Error: ', err)

if __name__ == '__main__':
    proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration'
    derWmhPath = opj(proj, 'derivatives', 'wmh2tbss_bnunew')
    derDtiPath = opj(proj, 'derivatives', 'preprocess_dwi_bnunew')
    RESOURCE = opj(proj, 'resource')
    
    queName = 'new'
    templateScriptPath = opj(proj, 'code', 'sf_wmh2tbss_template.sh')
    jobNumMax = 300
    ppn = 8
    
    for i in glob(opj(derWmhPath, 'sub-*')):
        subId = os.path.split(i)[-1]
        jobName = f'lz_{subId.replace("sub-", "")}'        
        
        logging.info(jobName)
            
        if not os.path.exists(opj(derDtiPath, subId)): continue
        if os.path.exists(opj(derWmhPath, subId, 'ples_lpa_mrflair_mni_mask.nii.gz')): continue
        if (os.path.exists(opj(derWmhPath, subId, 'submited')) or
            os.path.exists(opj(derWmhPath, subId, 'running')) or
            os.path.exists(opj(derWmhPath, subId, 'finished'))):
            continue
        
        # with open(opj(derWmhPath, subId, 'submited'), 'w') as f: f.write("")
        submit(templateScriptPath=templateScriptPath,
            jobName=jobName,
            ppn=ppn,
            queName=queName,
            tmpPath=i,
            derWmhPath=derWmhPath,
            derDtiPath=derDtiPath,
            subId=subId,
            resource=RESOURCE)
        time.sleep(2)
        break