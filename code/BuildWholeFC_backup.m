%% setup major directory
clc; clear;

proj_dir = '.';
hcp_dir = [proj_dir '/hcprestdata'];
surf_dir = [proj_dir '/matlab/surfmodels'];

%% setup toolboxes
cifti_matlab = [proj_dir '/matlab/cifti-matlab-master'];
gifti_matlab = [proj_dir '/matlab/gifti-master'];
addpath(genpath(cifti_matlab));
addpath(gifti_matlab);

%% load the geometry of the 32k_ConteAtlas
ConteAtlas_dir = [proj_dir '/matlab/surfmodels/32k_ConteAtlas_v2'];
fSurfGraph = [proj_dir '/matlab/surfmodels/matlab/Conte69_32k_surfgraph.mat'];

%% load the label file (400 parcels)
SchaeferAtlas_path = [proj_dir ...
    '/Schaefer2018_400Parcels_7Networks_order.dlabel.nii'];
SchaeferAtlas_data = ft_read_cifti(SchaeferAtlas_path);

%% setup seed
seed_coord = [-48 -56 36];

%% load the index of seed point
[idx_surfroi, coord_seed] = ccs_core_seedsurfroi( ...
    seed_coord(1, :), ...
    ConteAtlas_dir, ...
    fSurfGraph);

%% Load the time series
data_dir = hcp_dir;
rest_labels = {...
    'rfMRI_REST1_LR', ...
    'rfMRI_REST1_7T_PA'};
subjects = dir(hcp_dir);

AllMFCs = zeros(numel(subjects) - 2, max(SchaeferAtlas_data.parcels));
AllMFCsSubject = string(zeros(numel(subjects) - 2, 1));

AllMFCs7T = zeros(numel(subjects) - 2, max(SchaeferAtlas_data.parcels));
AllMFCsSubject7T = string(zeros(numel(subjects) - 2, 1));

for sub_i = 3:numel(subjects)
    subject = subjects(sub_i).name;
    sub_dir = [data_dir '/' subject];
    num_rest_labels = size(rest_labels);
    num_rest_labels = num_rest_labels(2);

    disp(['Subject ' subject]);
    ffc = [sub_dir '/' rest_labels{1} ...
            '_Atlas_MSMAll_hp2000_clean.fc.mat'];
    load(ffc);
    AllMFCs(sub_i - 2, :) = mfcs;
    AllMFCsSubject(sub_i - 2, 1) = subjects(sub_i).name;

    ffc = [sub_dir '/' rest_labels{2} ...
            '_Atlas_MSMAll_hp2000_clean.fc.mat'];
    load(ffc);
    AllMFCs7T(sub_i - 2, :) = mfcs;
    AllMFCsSubject7T(sub_i - 2, 1) = subjects(sub_i).name;


%     for idx_rest = 1:num_rest_labels
%         disp(['subject ' subject ': ' rest_labels{idx_rest}]);
%         
%         frest = [sub_dir '/' rest_labels{idx_rest} ...
%             '_Atlas_MSMAll_hp2000_clean.dtseries.nii'];
%         ffc = [sub_dir '/' rest_labels{idx_rest} ...
%             '_Atlas_MSMAll_hp2000_clean.fc.mat'];
% 
%         if ~exist(frest, 'file')
%             disp(['There is no ' rest_labels{idx_rest} ...
%                 'for subject ' subject])
%         else
%             boldts = ft_read_cifti(frest);
%         
%             boldts_seed = boldts.dtseries(idx_surfroi, :);
%             boldts_seed = mean(boldts_seed, 1);
%             % the cerebral bold signal
%             boldts_cere = boldts.dtseries( ...
%                 (boldts.brainstructure == 1) | ...
%                 (boldts.brainstructure == 2), :);
%             fcs = sangf_fc(boldts_seed, boldts_cere);
%             % get the mean fc in each parcel
%             mfcs = sangf_mfc(fcs', SchaeferAtlas_data);
%             save(ffc, 'fcs', 'mfcs');
%             
%         end
%     end
end

save('AllMFC.mat', 'AllMFCs', 'AllMFCsSubject', 'AllMFCs7T', 'AllMFCsSubject7T');

%% function
function fcs = sangf_fc(seedts, wholets)
% the memory is small, split the matrix to reduce the need of memory.
num_vers = size(wholets);
num_vers = num_vers(1);
step = 5000;
num_loop = idivide(num_vers, int32(step), 'ceil');

% the whole functional connectivity
fcs = zeros(1, num_vers);
for i = 1:num_loop
    tmpidx_low = (i - 1) * step + 1;
    tmpidx_up = min(i * step, num_vers);
    tmpds = wholets(tmpidx_low:tmpidx_up, :);
    tmp_r = corrcoef([seedts' tmpds']);
    fcs(1, tmpidx_low:tmpidx_up) = tmp_r(2:end, 1);
end
end

function mfcs = sangf_mfc(fcs, lab)
num_rois = max(lab.parcels);
mfcs = zeros(1, num_rois);
for i = 1:num_rois
    mfcs(1, i) = mean(fcs(lab.parcels == i), 'omitnan');
end
end