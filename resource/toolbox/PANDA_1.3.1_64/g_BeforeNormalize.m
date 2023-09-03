 
function g_BeforeNormalize( FA_File, JobName )
%
%__________________________________________________________________________
% SUMMARY OF G_BEFORENORMALIZE
% 
% Some pre-process before Normalize FA to template
%
% SYNTAX:
%
% 1) g_BeforeNormalize( FA_File )
% 2) g_BeforeNormalize( FA_File, JobName )
%__________________________________________________________________________
% INPUTS:
%
% FA_File
%        (string) 
%        The full path of the FA image to be handled.
%        For example: '/data/Handled_Data/001/001_FA.nii.gz'
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
    
if strcmp(FA_File(end-6:end), '.nii.gz')
    FA_File_4normalize = [FA_File(1:end-7) '_4normalize'];
    FA_File_4normalize_mask = [FA_File(1:end-7) '_4normalize_mask'];
elseif strcmp(FA_File(end-3:end), '.nii');
    FA_File_4normalize = [FA_File(1:end-4) '_4normalize'];
    FA_File_4normalize_mask = [FA_File(1:end-4) '_4normalize_mask'];
else
    error('FA is not a NIFTI file');
end
% preprocessing FA
system(['fslval ' FA_File ' dim1 > ' FA_File_4normalize '_System.txt']);
dim1 = load([FA_File_4normalize '_System.txt']);
system(['fslval ' FA_File ' dim2 > ' FA_File_4normalize '_System.txt']);
dim2 = load([FA_File_4normalize '_System.txt']);
system(['fslval ' FA_File ' dim3 > ' FA_File_4normalize '_System.txt']);
dim3 = load([FA_File_4normalize '_System.txt']);
delete([FA_File_4normalize '_System.txt']);

cmd=['fslmaths ' FA_File ' -min 1 -ero -roi 1 ' num2str(dim1-2) ' 1 ' num2str(dim2-2) ...
                    ' 1 ' num2str(dim3-2) ' 0 1 ' FA_File_4normalize];
system(cmd);        
% creat mask for fnirt
cmd = ['fslmaths ' FA_File_4normalize ' -bin ' FA_File_4normalize_mask];
system(cmd);

if nargin == 2
    [a, ~, ~] = fileparts(FA_File);
    [a, ~, ~] = fileparts(a);
    cmd = ['touch ' a filesep 'tmp' filesep 'OutputDone' filesep JobName '.done '];
    system(cmd);
end

