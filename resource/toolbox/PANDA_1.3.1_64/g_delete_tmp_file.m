function g_delete_tmp_file( Nii_Output_Folder_Path,Delete_Flag,QuantityOfSequence,Prefix,JobName )
%
%__________________________________________________________________________
% SUMMARY OF G_DELETE_TMP_FILE
% 
% Delete the temporary file during the excution of the program.
%
% SYNTAX:
%
% 1) g_delete_tmp_file( Nii_Output_Folder_Path, Delete_Flag, QuantityOfSequence, Prefix )
% 2) g_delete_tmp_file( Nii_Output_Folder_Path, Delete_Flag, QuantityOfSequence, Prefix, JobName )
%__________________________________________________________________________
% INPUTS:
%
% Nii_Output_Path
%        (string) 
%        The full path of the folder which we need to put the NIfTI data of
%        the subject in 
%        For example: '/data/Handled_Data/001/'
%
% DELETE_FLAG
%        (integer, 0 or 1)
%        1 : delete the data converted from the DICOM
%        0 : keep the data converted from the DICOM
%
% QUANTITYOFSEQUENCE
%        (integer)
%        The quantity of scans.
%
% PREFIX
%        (string)
%        The prefix of files to be deleted.
%
% JOBNAME
%        (string) 
%        The name of the job which call the command this time.It is 
%        determined in the function g_dti_pipeline.
%        If you use this function alone, this parameter is not needed.
%__________________________________________________________________________
% OUTPUTS:
%        
%__________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Zaixu Cui, Gaolang Gong, State Key Laboratory of Cognitive
% Neuroscience and Learning, Beijing Normal University, 2012.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code

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

disp(Delete_Flag);
if Delete_Flag == 1
    system(['rm ' Nii_Output_Folder_Path filesep 'tmp' filesep '*']);
else
    for i = 1:QuantityOfSequence
        system(['mv ' Nii_Output_Folder_Path filesep 'tmp' filesep Prefix '_DWI_' num2str(i,'%02.0f') '.nii.gz ' Nii_Output_Folder_Path filesep]);
        system(['mv ' Nii_Output_Folder_Path filesep 'tmp' filesep Prefix '_bvals_' num2str(i,'%02.0f') ' ' Nii_Output_Folder_Path filesep]);
        system(['mv ' Nii_Output_Folder_Path filesep 'tmp' filesep Prefix '_bvecs_' num2str(i,'%02.0f') ' ' Nii_Output_Folder_Path filesep]);
    end
    system(['rm ' Nii_Output_Folder_Path filesep 'tmp' filesep '*']);
    for i = 1:QuantityOfSequence
        system(['mv ' Nii_Output_Folder_Path filesep Prefix '_DWI_' num2str(i,'%02.0f') '.nii.gz ' Nii_Output_Folder_Path filesep 'tmp' filesep]);
        system(['mv ' Nii_Output_Folder_Path filesep Prefix '_bvals_' num2str(i,'%02.0f') ' ' Nii_Output_Folder_Path filesep 'tmp' filesep]);
        system(['mv ' Nii_Output_Folder_Path filesep Prefix '_bvecs_' num2str(i,'%02.0f') ' ' Nii_Output_Folder_Path filesep 'tmp' filesep]);
    end
end
    
if nargin == 5
    cmd = ['touch ' Nii_Output_Folder_Path filesep 'tmp' filesep 'OutputDone' filesep JobName '.done '];
    system(cmd);
end

