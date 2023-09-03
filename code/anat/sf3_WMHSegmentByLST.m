clc; clear all;

data = 'bids_tt/derivatives/wmh';
SPMROOT = '/brain/babri_group/Tools/spm12';
addpath(SPMROOT);

subs = dir(data);
subs = subs(3:end);

for i = 1:numel(subs)
    disp(sprintf('Segmenting %s...', subs(i).name));
    t1 = fullfile(data, subs(i).name, 't1w.nii');
    flair = fullfile(data, subs(i).name, 'flair.nii');
    
    spm_jobman('initcfg');
    %-----------------------------------------------------------------------
    % Job saved on 20-Sep-2022 14:14:36 by cfg_util (rev $Rev: 7345 $)
    % spm SPM - SPM12 (7771)
    % cfg_basicio BasicIO - Unknown
    %-----------------------------------------------------------------------
    matlabbatch{1}.spm.tools.LST.lpa.data_F2 = {strcat(flair, ',1')};
    matlabbatch{1}.spm.tools.LST.lpa.data_coreg = {strcat(t1, ',1')};
    matlabbatch{1}.spm.tools.LST.lpa.html_report = 1;

    spm('defaults', 'pet');
    spm_jobman('run', matlabbatch);
end