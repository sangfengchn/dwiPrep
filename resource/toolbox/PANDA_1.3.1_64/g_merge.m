
function g_merge( DataNii_folder,files_in,Prefix,MaskFile,JobName )
%
%__________________________________________________________________________
% SUMMARY OF G_MERGE
% 
% Concatenate images of different runs in gradient directions .
%
% SYNTAX:
%
% 1) g_merge( DataNii_folder,files_in,Prefix,MaskFile )
% 2) g_merge( DataNii_folder,files_in,Prefix,MaskFile,JobName )
%__________________________________________________________________________
% INPUTS:
%
% DATANII_FOLDER
%        (string) 
%        The full path of the NIfTI data
%        For example: '/data/Handled_Data/001/'
%
% FILES_IN
%        (string) 
%        The full path of a .mat file which store three variables
%        'VolumePerSequence' 
%        VolumePerSequence:
%                 (integer)
%                 the quantity of volume for one scan 
%
% PREFIX
%       (string)
%       The prefix of the file name.
%
% MASKFILE
%       (string) 
%       The full path of the brain mask.
%
% JOBNAME
%        (string) 
%        The name of the job which call the command this time.It is 
%        determined in the function g_dti_pipeline.
%        If you use this function alone, this parameter is not needed.
%__________________________________________________________________________
% OUTPUTS:
%         
% See g_merge_FileOut.m file
%__________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Gaolang Gong, Zaixu Cui, State Key Laboratory of Cognitive
% Neuroscience and Learning, Beijing Normal University, 2012.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code
% keywords: fslmerge

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

load(files_in);

for i = 1:VolumePerSequence 
    VolumeAverage{i} = [DataNii_folder filesep 'tmp' filesep Prefix '_DWI_' num2str(i - 1,'%04.0f') '_average.nii.gz'];
end

VolumeAvergeMerge = [DataNii_folder filesep 'native_space' filesep 'data.nii.gz'];
cmd = ['fslmaths ' VolumeAverage{1} ' -mul ' MaskFile ' ' VolumeAverage{1}];
system(cmd);
system(['cp ' VolumeAverage{1} ' ' VolumeAvergeMerge]);
for i = 2:VolumePerSequence 
    cmd = ['fslmaths ' VolumeAverage{i} ' -mul ' MaskFile ' ' VolumeAverage{i}];
    system(cmd);
    cmd = ['fslmerge -t ' VolumeAvergeMerge  ' ' VolumeAvergeMerge ' ' VolumeAverage{i}];
    system(cmd);
end

% Rename bvecs_average as bvecs
system(['cp ' DataNii_folder filesep 'tmp' filesep Prefix '_bvecs_average ' DataNii_folder filesep 'native_space' filesep 'bvecs']);
% Rename bvals_average as bvals
system(['cp ' DataNii_folder filesep 'tmp' filesep Prefix '_bvals_average ' DataNii_folder filesep 'native_space' filesep 'bvals']);

if nargin == 5
    cmd = ['touch ' DataNii_folder filesep 'tmp' filesep 'OutputDone' filesep JobName '.done '];
    system(cmd);
end
