
function g_applywarp( raw_file, warp_file, resolution, JobName, target_fileName, prefix, ResultantFolder )
%
%__________________________________________________________________________
% SUMMARY OF G_APPLYWARP
% 
% Apply the warps estimated by fnirt to some images.
%
% SYNTAX:
%
% 1) g_applywarp( raw_file,warp_file )
% 2) g_applywarp( raw_file,warp_file,resolution )
% 3) g_applywarp( raw_file,warp_file,resolution,JobName )
% 4) g_applywarp( raw_file,warp_file,resolution,JobName,target_fileName )
%__________________________________________________________________________
% INPUTS:
%
% RAW_FILE
%        (string) 
%        The full path of the NIfTI data to be written to standard space.
%        For example: '/data/Handled_Data/001/001_FA.nii.gz'
%
% WARP_FILE
%        (string) 
%        The full path of warps estimated by fnirt
%        For example:
%        '/data/Handled_Data/001/001_FA_4normalize_to_target_warp.nii.gz'
%
% resolution
%        (integer: 1 or 2)
%        The final resolution of the normalized data.
%        1: 'FMRIB58_FA_1mm.nii.gz' as reference
%            i.e. resampling the data at 1x1x1mm resolution in MNI space
%        2: 'MNI152_T1_2mm.nii.gz' as reference
%            i.e. resampling the data at 2x2x2mm resolution in MNI space
%
% JOBNAME
%        (string) 
%        The name of the job which call the command this time.It is 
%        determined in the function g_dti_pipeline.
%        If you use this function alone, this parameter is not needed.
%
% TARGET_FILENAME
%        (string)
%        For quanlity control of registering.
%
% PREFIX
%        (string) 
%        The prefix of the name for the slice image. 
%__________________________________________________________________________
% OUTPUTS:
%
% See g_applywarp_..._FileOut.m file        
%__________________________________________________________________________
% COMMENTS:
%
% My work is based on the psom refered to http://code.google.com/p/psom/.
% It has an attractive feature: if the job breaks and you restart, it will
% excute the job from the break point rather than from the start.
% The output files jobs will produce are specifiled in the file named 
% [JOBNAME '_FileOut.m']
%
% Copyright (c) Gaolang Gong, Zaixu Cui, State Key Laboratory of Cognitive
% Neuroscience and Learning, Beijing Normal University, 2012.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code
% keywords: applywarp

% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documation files, to deal in the
% Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

global PANDAPath;
[PANDAPath, y, z] = fileparts(which('PANDA.m'));

if nargin < 3
    resolution = 1;
end 

if resolution == 1
    ref_fileName = [PANDAPath filesep 'data' filesep 'Templates' filesep 'FMRIB58_FA_1mm.nii.gz'];
    Suffix = '1mm';
elseif resolution == 2
    ref_fileName = [PANDAPath filesep 'data' filesep 'Templates' filesep 'MNI152_T1_2mm.nii.gz'];
    Suffix = '2mm';
end

[a,b,~] = fileparts(raw_file);
if nargin < 7 
    [SubjectFolder,~,~] = fileparts(a);
    if strcmp(raw_file(end-2:end), '.gz') % .nii.gz
        outputfile = [SubjectFolder filesep 'standard_space' filesep b(1:end - 4) '_to_target_' Suffix];
    elseif strcmp(raw_file(end-3:end), '.nii');
        outputfile = [SubjectFolder filesep 'standard_space' filesep b '_to_target_' Suffix];
    else
        error('not a NIFTI file');
    end
    disp(SubjectFolder);
    disp(outputfile);
else
    if strcmp(raw_file(end-2:end), '.gz') % .nii.gz
        outputfile = [ResultantFolder filesep b(1:end - 4) '_to_target_' Suffix];
    elseif strcmp(raw_file(end-3:end), '.nii');
        outputfile = [ResultantFolder filesep b '_to_target_' Suffix];
    else
        error('not a NIFTI file');
    end
    disp(outputfile);
end

cmd = cat(2, 'applywarp -i ', raw_file, ' -o ', outputfile, ' -r ', ref_fileName, ' -w ', warp_file, ' --rel');
disp(cmd);
system(cmd);

if nargin >= 5 & ~isempty(target_fileName)
    FANormalized1mmSlicedir = [SubjectFolder filesep 'quality_control' filesep 'FA_Normalized_1mm'];
    if ~exist(FANormalized1mmSlicedir, 'dir')
        mkdir(FANormalized1mmSlicedir);
    end
    cmd = ['cd ' FANormalized1mmSlicedir ' && slicesdir -o ' outputfile ' ' target_fileName];
    system(cmd);
    % Shorten the file name of the combined image
    CombinedImage = g_ls([FANormalized1mmSlicedir filesep 'slicesdir' filesep '*__*']);
    if ~isempty(CombinedImage)
        [ParentFolder, ~, Suffix] = fileparts(CombinedImage{1});
        cmd = ['mv ' CombinedImage{1} ' ' ParentFolder filesep prefix '_FAnormalize_grot_all' Suffix];
        system(cmd);
    end
end

if nargin >= 4 & nargin < 7   
    cmd = ['touch ' SubjectFolder filesep 'tmp' filesep 'OutputDone' filesep JobName '.done '];
    system(cmd);
end

