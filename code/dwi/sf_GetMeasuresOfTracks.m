% 提取穿过某一个roi的纤维束的指标
restoredefaultpath;
proj = '/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration_multiple_network';
der = fullfile(proj, 'derivatives', 'preprocess_dwi');
res = fullfile(proj, 'resource', 'toolbox');
% proj = '.';
% der = '.';
% res = '.';

meaName = 'dtifit_FA.nii.gz';
trkName = 'tracks_filtered_roi-15.trk';
resName = 'TracksMeasure_mea-FA_roi-15.csv';

addpath('/opt/software/fsl/etc/matlab');
setenv('FSLDIR', '/opt/software/fsl');
addpath(fullfile(res, 'along-tract-stats-master'));

subs = dir(fullfile(der, 'sub-*'));
for i = 1:numel(subs)
    subId = subs(i).name;
    disp(subId);

    subVol = read_avw(fullfile(subs(i).folder, subs(i).name, meaName));
    [subHeader, subTracks] = trk_read(fullfile(subs(i).folder, subs(i).name, trkName));
    
    subVol = flip(subVol, 2);
    [meanInt, stdInt, nVox] = trk_stats_quick(subHeader, subTracks, subVol, 'cubic');
    subTab = table(meanInt, stdInt, nVox, 'VariableNames', {'MeanIntensity', 'StdIntensity', 'NumVoxel'});
    writetable(subTab, fullfile(subs(i).folder, subs(i).name, resName));
    break
end
disp('Done.');
