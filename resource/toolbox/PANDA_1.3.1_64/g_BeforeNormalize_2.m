 
function g_BeforeNormalize_2( Raw_File, FA_4normalize_mask, JobName )
%
%__________________________________________________________________________
% SUMMARY OF G_BEFORENORMALIZE
% 
% Some pre-process before Normalize FA to template
%
% SYNTAX:
%
% 1) g_BeforeNormalize( Raw_File, FA_4normalize_mask )
% 2) g_BeforeNormalize( Raw_File, FA_4normalize_mask, JobName )
%__________________________________________________________________________
% INPUTS:
%
% Raw_File
%        (string) 
%        The full path of the MD/L1/L23m image to be handled.
%        For example: '/data/Handled_Data/001/001_MD.nii.gz'
%
% JOBNAME
%        (string) the name of the job which call the command this time.It
%        is determined in the function g_dti_pipeline.
%        If you use this function alone, this parameter is not needed.
%__________________________________________________________________________
% OUTPUTS:
%         
% See g_BeforeNormalize_..._FileOut.m file.
%__________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Gaolang Gong, Zaixu Cui, State Key Laboratory of Cognitive
% Neuroscience and Learning, Beijing Normal University, 2012.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code
% keywords: pre-processing, fslmaths

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
    
if strcmp(Raw_File(end-6:end), '.nii.gz')
    Raw_File_4normalize = [Raw_File(1:end-7) '_4normalize'];
elseif strcmp(Raw_File(end-3:end), '.nii');
    Raw_File_4normalize = [Raw_File(1:end-4) '_4normalize'];
else
    error('Raw image is not a NIFTI file');
end
% preprocessing FA
system(['fslval ' Raw_File ' dim1 > ' Raw_File_4normalize '_System.txt']);
dim1 = load([Raw_File_4normalize '_System.txt']);
system(['fslval ' Raw_File ' dim2 > ' Raw_File_4normalize '_System.txt']);
dim2 = load([Raw_File_4normalize '_System.txt']);
system(['fslval ' Raw_File ' dim3 > ' Raw_File_4normalize '_System.txt']);
dim3 = load([Raw_File_4normalize '_System.txt']);
delete([Raw_File_4normalize '_System.txt']);

cmd = ['fslmaths ' Raw_File ' -mul ' FA_4normalize_mask ' ' Raw_File_4normalize];
system(cmd);

if nargin == 2
    [a, ~, ~] = fileparts(Raw_File);
    [a, ~, ~] = fileparts(a);
    cmd = ['touch ' a filesep 'tmp' filesep 'OutputDone' filesep JobName '.done '];
    system(cmd);
end

