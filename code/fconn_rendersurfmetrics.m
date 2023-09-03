%% setup major directories
clear; clc
tmpinfo = what('./');
tmppath = tmpinfo.path;
proj_dir = tmppath(1:(numel(tmppath)-13));
hcp_dir = [proj_dir '/data'];
surf_dir = [proj_dir '/matlab/surfmodels'];
ConteAtlas_dir = [surf_dir '/32k_ConteAtlas_v2'];

%% setup major toolboxes
fs_home = [proj_dir '/matlab/freesurfer'];
%connectome computation system
ccs_matlab = [proj_dir '/matlab/core'];
ccs_vistool = [proj_dir '/matlab/vistlbx'];
%cifti toolbox
cifti_matlab = [proj_dir '/matlab/cifti-matlab-master'];
gifti_matlab = [proj_dir '/matlab/gifti-master'];

%% add the paths to matlab
addpath(genpath(ccs_matlab)) %ccs matlab scripts
addpath(genpath(ccs_vistool)) %ccs matlab scripts
addpath(genpath(cifti_matlab)) %cifti paths
addpath(genpath(gifti_matlab)); %gifti paths
addpath(genpath(fs_home)) %freesurfer matlab scripts

%% load the geometry of the 32k_ConteAtlas
Conte32k_lh = gifti([ConteAtlas_dir ...
    '/Conte69.L.very_inflated.32k_fs_LR.surf.gii']);
nVertices_lh = size(Conte32k_lh.vertices,1);
surfConte69_lh.tri = Conte32k_lh.faces;
surfConte69_lh.coord = Conte32k_lh.vertices'; 
% right hemisphere
Conte32k_rh = gifti([ConteAtlas_dir ...
    '/Conte69.R.very_inflated.32k_fs_LR.surf.gii']);
nVertices_rh = size(Conte32k_rh.vertices,1);
surfConte69_rh.tri = Conte32k_rh.faces;
surfConte69_rh.coord = Conte32k_rh.vertices';

%% Load Colormaps
cmap_sdmean = jet(256); cmap_sdmean(1,:) = 0.5;
cmap_tdmean = jet(256); cmap_tdmean(127:129,:) = 0.5;
%caret single direction
fcolor = [ccs_vistool '/fimages/caret_sdirection.tif'];
cmap_caret1 = ccs_mkcolormap(fcolor);
cmap_caret1(1,:) = 0.5;
%caret double direction
fcolor = [ccs_vistool '/fimages/caret_bdirection.tif'];
cmap_caret2 = ccs_mkcolormap(fcolor);
cmap_caret2(127:129,:) = 0.5;

%% loop subjects from HCP1200 release
data_dir = [hcp_dir '/1200'];
rest_labels = {...
    'rfMRI_REST1_LR', ...
    'rfMRI_REST1_RL', ...
    'rfMRI_REST2_LR', ...
    'rfMRI_REST2_RL'};
seeds_label = {'IPS','FEF','MT+','MPF','PCC','LP'};
seeds_coord = [-25 -57 46; 25 -13 50; -45 -69 -2; ...
    -1 47 -4; -5 -49 40; -45 -67 36];
num_seeds = numel(seeds_label);
bands_label = {'slow6','slow5','slow4','slow3','slow2','slow1'};
num_bands = numel(bands_label);
subject = '100610';
fig_dir = [proj_dir '/figures/' subject];
if ~exist(fig_dir,'dir')
    mkdir(fig_dir)
end
%cifti toolbox
surfstat_matlab = [proj_dir '/matlab/surfstat'];
addpath(genpath(surfstat_matlab))
sub_dir = [data_dir '/' subject '/MNINonLinear/Results'];
for idx_rest=1%:4
    disp(['subject ' subject ': ' rest_labels{idx_rest}])
    func_dir = [sub_dir '/' rest_labels{idx_rest}];
    if ~exist([fig_dir '/' rest_labels{idx_rest}],'dir')
        mkdir(fig_dir, rest_labels{idx_rest});
    end
    %loop bands
    for idx_bd=3 %num_bands
        %seed-based FC
        for idx_seed=1:num_seeds
            disp(['seed-based FC estimation: ' seeds_label{idx_seed} ...
                ' in ' bands_label{idx_bd} ' ...'])
            fmetric = [func_dir '/boldsfc_' seeds_label{idx_seed} ...
                '_cort.' bands_label{idx_bd} '.mat'];
            load(fmetric); tmpstats = [seedfc_cc_lh; seedfc_cc_rh];
            cmax = max(tmpstats); cmin = min(tmpstats);
            if cmin<0 
                cmap_range = [-cmax cmax]*0.68;
                cmap_tmp = cmap_caret2;
            else 
                cmap_range = [0 cmax]*0.68;
                cmap_tmp = cmap_caret1;
            end
            figure('Units', 'pixel', 'Position', [100 100 800 800]); 
            axis off
            SurfStatView(seedfc_cc_lh, surfConte69_lh, ' ', 'white', 'true'); 
            colormap(cmap_tmp); SurfStatColLim(cmap_range);
            set(gcf, 'PaperPositionMode', 'auto');            
            figout = [rest_labels{idx_rest} '_sfc_' ...
                seeds_label{idx_seed} '_cc.' bands_label{idx_bd} '.lh.png'];
            print('-dpng', '-r300', figout); close
            
            figure('Units', 'pixel', 'Position', [100 100 800 800]); 
            axis off
            SurfStatView(seedfc_cc_rh, surfConte69_rh, ' ', 'white', 'true'); 
            colormap(cmap_tmp); SurfStatColLim(cmap_range);
            set(gcf, 'PaperPositionMode', 'auto');
            figout = [rest_labels{idx_rest} '_sfc_' ...
                seeds_label{idx_seed} '_cc.' bands_label{idx_bd} '.rh.png'];
            print('-dpng', '-r300', figout); close
        end
    end
end
