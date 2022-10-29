#!/bin/csh -f


# MODIFY FOLLOWING DIRECTORIES 
# FSL_PATH IS THE MAIN FSL PATH AND SHOULD CONTAIN BIN/, CONFIG/, LIB/... SUBDIRECTORIES)
# PYTHON_EXEC IS THE PATH FOR THE PYTHON EXECUTABLE

# set for MRN Arvind
set FWMRN_PATH = /brain/babri_group/Desktop/LIZilin/HTN_duration/derivatives/freewater/scripts_FW_CONSORTIUM
set SIMGPY = /brain/babri_group/Desktop/LIZilin/HTN_duration/derivatives/freewater/envpy39.simg
set SIMGFSL = /brain/babri_group/Desktop/LIZilin/HTN_duration/derivatives/freewater/fmriprep-20.1.3.simg

# Example: set for UCD - Pauline
#set FWMRN_PATH = /data/home/maillard/scripts_FW_CONSORTIUM
#set FSL_PATH = /data/condorWorkspace/fsl-6.0.1/fsl/
#set BINFSL = ${FSL_PATH}/bin
#set PYTHON_EXEC = /usr/bin/python


###############################################################################
#DO NOT MODIFY
#set SUBJ_PATH = `ls -d $1`

set DATAFW_PATH = $5

echo ${DATAFW_PATH}

set MASKWM_PATH = ${FWMRN_PATH}/FMRIB58_FA_1mm_thr  
set DATAFSL_PATH = ${FWMRN_PATH}/FMRIB58_FA_1mm
set DATA_FILE = ${DATAFW_PATH}/data.nii.gz
set BRAINMASK_FILE = ${DATAFW_PATH}/brain_mask.nii.gz
set BVAL_FILE = ${DATAFW_PATH}/file.bval
set BVEC_FILE = ${DATAFW_PATH}/file.bvec

if(! -d ${DATAFW_PATH}) then
	mkdir ${DATAFW_PATH}
endif

cd ${DATAFW_PATH}

cp $1 ${DATA_FILE}
cp $2 ${BRAINMASK_FILE}
cp $3 ${BVAL_FILE}
cp $4 ${BVEC_FILE}


# GENERATE THE FW MAP
singularity exec $SIMGPY python ${FWMRN_PATH}/fw_mrn.py ${DATAFW_PATH} 


# COMPUTE TRANSFORMATION PARAMETERS DTI -> FSL FA TEMPLATE
singularity exec $SIMGFSL fsl_reg wls_dti_FA ${DATAFSL_PATH} nat2std -e -FA

# TRANSFORM FW, FA AND MD MAPS INTO FSL SPACE
singularity exec $SIMGFSL applywarp -i wls_dti_FW -o wls_dti_FW_warp -r ${DATAFSL_PATH} -w nat2std_warp
singularity exec $SIMGFSL applywarp -i fwc_wls_dti_FA -o  fwc_wls_dti_FA_warp -r ${DATAFSL_PATH} -w nat2std_warp

#${BINFSL_PATH}/applywarp -i fwc_wls_dti_MD -o fwc_dti_wls_MD_warp -r ${DATAFSL_PATH} -w nat2std_warp
#COMPUTE AND STORE IN summary.txt FILE MEAN FW and FA  WITHIN WM VOXELS
#echo "`${BINFSL}/fslstats wls_dti_FW_warp -k ${MASKWM_PATH} -M` `${BINFSL_PATH}fslstats fwc_wls_dti_FA_warp -k ${MASKWM_PATH} -M` `${BINFSL_PATH}fslstats fwc_dti_wls_MD_warp -k ${MASKWM_PATH} -M`" > summary.txt

echo "`singularity exec ${SIMGFSL} fslstats wls_dti_FW_warp -k ${MASKWM_PATH} -M` `singularity exec ${SIMGFSL} fslstats fwc_wls_dti_FA_warp -k ${MASKWM_PATH} -M`" > summary.txt

# clean up
rm  ${DATA_FILE}
rm  ${BRAINMASK_FILE}
rm  ${BVAL_FILE}
rm  ${BVEC_FILE}

rm ${DATAFW_PATH}/*log
rm ${DATAFW_PATH}/*MD*

