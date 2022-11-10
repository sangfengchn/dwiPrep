function g_ProbabilisticNetworkMergeResults(ProbabilisticMatrixCell, Prefix, ProbabilisticTrackingType, LabelIdVector)
%
%__________________________________________________________________________
% SUMMARY OF G_PROBABILISTICNETWORKMERGERESULTS
%
% Merge all the network sub-jobs' results.
%
% SYNTAX:
%
% 1) g_ProbabilisticNetworkMergeResults(ProbabilisticMatrixCell, Prefix, ProbabilisticTrackingType, LabelIdVector)
%__________________________________________________________________________
% INPUTS:
%
% PROBABILISTICMATRIXCELL
%        (cell of strings) 
%        Each cell is the full path of result file of each sub-job.
%
% PREFIX
%        (string) 
%        The prefix for the name of resultant .mat file.
%
% PROBABILISTICTRACKINGTYPE
%        (string, 'OPD' or 'PD', default 'OPD')
%        'OPD' : Output path distribution.
%        'PD' : Correct path distribution for the length of the pathways and
%        output path distribution.
%
% LABELIDVECTOR
%        (string) 
%        A txt file which contain all the target file path.
%__________________________________________________________________________
% OUTPUTS:
%
% A matrix containing the connection probability of each two brain regions.         
%__________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Suyu Zhong, Gaolang Gong, Zaixu Cui, State Key Laboratory 
% of Cognitive Neuroscience and Learning, Beijing Normal University, 2012.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code
% keywords: pre-processing, probabilistic fiber tracking

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

tmp_prob = load(ProbabilisticMatrixCell{1});
seed_Voxel_matrix = tmp_prob.seed_Voxel_matrix;
target_Voxel_matrix = tmp_prob.target_Voxel_matrix;
target_meanFDT_matrix = tmp_prob.target_meanFDT_matrix;

for i = 2:length(ProbabilisticMatrixCell)

    tmp_prob = load(ProbabilisticMatrixCell{i});
    seed_Voxel_matrix = seed_Voxel_matrix + tmp_prob.seed_Voxel_matrix;
    target_Voxel_matrix = target_Voxel_matrix + tmp_prob.target_Voxel_matrix;
    target_meanFDT_matrix = target_meanFDT_matrix + tmp_prob.target_meanFDT_matrix;

end

FDT2target = target_Voxel_matrix .* target_meanFDT_matrix;
ProbabilisticMatrix = FDT2target./seed_Voxel_matrix./10000;
ProbabilisticMatrix(find(isnan(ProbabilisticMatrix)))=0;%Revised by Suyu Zhong; 2013_11_21
[TmpFolderPath, Name, z] = fileparts(ProbabilisticMatrixCell{1});
[ProbabilisticFolderPath, y, z] = fileparts(TmpFolderPath);
ProbabilisticMatrixPath = [ProbabilisticFolderPath filesep Prefix '_ProbabilisticMatrix_' ProbabilisticTrackingType '_' num2str(length(LabelIdVector)) '.txt'];
save(ProbabilisticMatrixPath, 'ProbabilisticMatrix', '-ascii');
