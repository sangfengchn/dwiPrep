import nibabel as nib

path = './derivatives/tbss_fa/data/stats/lz_FW_tstat3.nii.gz'
img = nib.load(path)
data = img.get_fdata()

dataNeg = data.copy()
dataNeg[dataNeg > 0] = 0
nib.save(nib.Nifti1Image(dataNeg, img.affine), path.replace('.nii.gz', '_neg.nii.gz'))

dataPos = data.copy()
dataPos[dataPos < 0] = 0
nib.save(nib.Nifti1Image(dataPos, img.affine), path.replace('.nii.gz', '_pos.nii.gz'))
