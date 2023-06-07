clc; clear;

proj = '.';
raw = fullfile(proj, 'rawdata');
SPMROOT = 'D://toolbox//spm12';
addpath(genpath(SPMROOT));

subs = dir(fullfile(raw, 'sub-*'));
for i = 1:numel(subs)
    subId = subs(i).name;
    if exist(fullfile(raw, subId, 'stats'))
        continue;
    end
    disp(subId);
    matlabbatch = preproc(raw, subId, SPMROOT);
    spm_jobman('run', matlabbatch);
    % break;
end

function matlabbatch = preproc(raw, subId, SPMROOT)
    json = jsondecode(fileread(fullfile(raw, subId, 'func', sprintf('%s_task-nback_bold.json', subId))));
    statPath = fullfile(raw, subId, 'stats');
    if ~exist(statPath)
        mkdir(statPath);
    end
    %-----------------------------------------------------------------------
    % Job saved on 07-Jun-2023 13:07:33 by cfg_util (rev $Rev: 6942 $)
    % spm SPM - SPM12 (7219)
    % cfg_basicio BasicIO - Unknown
    %-----------------------------------------------------------------------
    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'raw';
    % matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
    %                                                                      {'E:\S_task-TaskFMri\rawdata\sub-526ZHUJIUCAI\anat\sub-526ZHUJIUCAI_T1w.nii'}
    %                                                                      {'E:\S_task-TaskFMri\rawdata\sub-526ZHUJIUCAI\func\sub-526ZHUJIUCAI_task-nback_bold.nii'}
    %                                                                      }';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                         {fullfile(raw, subId, 'anat', sprintf('%s_T1w.nii', subId))}
                                                                         {fullfile(raw, subId, 'func', sprintf('%s_task-nback_bold.nii', subId))}
                                                                         }';
    matlabbatch{2}.spm.temporal.st.scans{1}(1) = cfg_dep('Named File Selector: raw(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
    matlabbatch{2}.spm.temporal.st.nslices = 33;
    matlabbatch{2}.spm.temporal.st.tr = 2;
    matlabbatch{2}.spm.temporal.st.ta = 1.93939393939394;
    % matlabbatch{2}.spm.temporal.st.so = [0 1.035 0.06 1.095 0.1225 1.155 0.1825 1.2175 0.2425 1.2775 0.305 1.3375 0.365 1.4 0.425 1.46 0.4875 1.52 0.5475 1.5825 0.6075 1.6425 0.67 1.7025 0.73 1.765 0.79 1.825 0.8525 1.885 0.9125 1.9475 0.9725];
    matlabbatch{2}.spm.temporal.st.so = json.SliceTiming';
    
    matlabbatch{2}.spm.temporal.st.refslice = 33;
    matlabbatch{2}.spm.temporal.st.prefix = 'a';
    matlabbatch{3}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{4}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Named File Selector: raw(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{4}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{4}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{4}.spm.spatial.coreg.estimate.other(2) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.vol(1) = cfg_dep('Named File Selector: raw(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(2) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    % matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.tpm = {'D:\toolbox\spm12\tpm\TPM.nii'};
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.tpm = {fullfile(SPMROOT, 'tpm', 'TPM.nii')};
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                                 78 76 85];
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
    matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Estimate & Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{6}.spm.spatial.smooth.dtype = 0;
    matlabbatch{6}.spm.spatial.smooth.im = 0;
    matlabbatch{6}.spm.spatial.smooth.prefix = 's';
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_file_split.name = 'preproc';
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_file_split.files(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_file_split.index = {
                                                                         1
                                                                         2
                                                                         }';
    % matlabbatch{8}.spm.stats.fmri_spec.dir = {'E:\S_task-TaskFMri\rawdata\sub-526ZHUJIUCAI\stat'};
    matlabbatch{8}.spm.stats.fmri_spec.dir = {statPath};
    matlabbatch{8}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{8}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{8}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{8}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{8}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('File Set Split: preproc (1)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('{}',{1}));
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(1).name = 'instruction';
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(1).onset = [0
                                                             50
                                                             100
                                                             150
                                                             200
                                                             250
                                                             300
                                                             350
                                                             400];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(1).duration = [10
                                                                10
                                                                10
                                                                10
                                                                10
                                                                10
                                                                10
                                                                10
                                                                10];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(2).name = '0back';
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(2).onset = [10
                                                             260
                                                             360];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(2).duration = [40
                                                                40
                                                                40];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(3).name = '1back';
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(3).onset = [60
                                                             160
                                                             410];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(3).duration = [40
                                                                40
                                                                40];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(4).name = '2back';
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(4).onset = [110
                                                             210
                                                             310];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(4).duration = [40
                                                                40
                                                                40];
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(4).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(5).name = 'end';
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(5).onset = 450;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(5).duration = 20;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess.cond(5).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{8}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    % matlabbatch{8}.spm.stats.fmri_spec.sess.multi_reg = {'E:\S_task-TaskFMri\rawdata\sub-526ZHUJIUCAI\func\rp_asub-526ZHUJIUCAI_task-nback_bold.txt'};
    matlabbatch{8}.spm.stats.fmri_spec.sess.multi_reg = {fullfile(raw, subId, 'func', sprintf('rp_a%s_task-nback_bold.txt', subId))};
    matlabbatch{8}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{8}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{8}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{8}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{8}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{8}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{8}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{8}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{9}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{9}.spm.stats.fmri_est.write_residuals = 1;
    matlabbatch{9}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{10}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{10}.spm.stats.con.consess{1}.tcon.name = '1back-0back';
    matlabbatch{10}.spm.stats.con.consess{1}.tcon.weights = [0 -1 1];
    matlabbatch{10}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{2}.tcon.name = '2back-1back';
    matlabbatch{10}.spm.stats.con.consess{2}.tcon.weights = [0 0 -1 1];
    matlabbatch{10}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{3}.tcon.name = '2back-0back';
    matlabbatch{10}.spm.stats.con.consess{3}.tcon.weights = [0 -1 0 1];
    matlabbatch{10}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.delete = 0;

end
