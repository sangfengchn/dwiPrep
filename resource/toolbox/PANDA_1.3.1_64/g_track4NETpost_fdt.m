function g_track4NETpost_fdt(Label_seed_fileCell,Label_fdt_fileCell,ProbabilisticNetworkPostJobNum,Prefix)
%
%__________________________________________________________________________
% SUMMARY OF G_TRACK4NETPOST_FDT
% 
% Construct network with the result of probabilistic fiber tracking results
%
% SYNTAX:
%
% 1) g_track4NETpost_fdt(Label_seed_fileCell,Label_fdt_fileCell,ProbabilisticNetworkPostJobNum,Prefix)
%__________________________________________________________________________
% INPUTS:
%
% LABEL_SEED_FILECELL
%        (cell of strings) 
%        Each cell is seed file in probabilistic tracking.
%
% LABEL_FDT_FILECELL
%        (cell of strings)
%        Each cell is fdt_paths.nii.gz in the probabilistic tracking 
%        results.
%
% PROBABILISTICNETWORKPOSTJOBNUM
%        (integer) 
%        The serial number of probabilistic post network job.
%
% PREFIX
%        (string)
%        The prefix for the filename of the resultant file.
%__________________________________________________________________________
% OUTPUTS:
%
% See g_track4NETpost_fdt_..._FileOut.m file         
%__________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Gaolang Gong, Suyu Zhong, Zaixu Cui, State Key Laboratory 
% of Cognitive Neuroscience and Learning, Beijing Normal University, 2012.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code
% keywords: probabilistic, network

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

if length(Label_seed_fileCell) ~= length(Label_fdt_fileCell)
    error('number of files are not matched'); 
end

[LabelIDFolder, ~, ~] = fileparts(Label_seed_fileCell{1}); 
[ProbabilisticFolder, ~, ~] = fileparts(LabelIDFolder);

SeedsQuantity = length(Label_seed_fileCell);
SeedsPerJob = fix(SeedsQuantity / 10);
Remainer = mod(SeedsQuantity, 10);
if Remainer
    if ProbabilisticNetworkPostJobNum <= Remainer
        SeedsPerJob = SeedsPerJob + 1;
        StartSeedNum = SeedsPerJob * (ProbabilisticNetworkPostJobNum - 1);
    else
        StartSeedNum = (SeedsPerJob + 1) * Remainer + SeedsPerJob * (ProbabilisticNetworkPostJobNum - Remainer - 1);
    end
else
    StartSeedNum = SeedsPerJob * (ProbabilisticNetworkPostJobNum - 1);
end

% StartSeedNum = SeedsPerJob * (ProbabilisticNetworkPostJobNum - 1);
% if ProbabilisticNetworkPostJobNum == 10
%     Remainer = mod(SeedsQuantity, 10);
%     SeedsPerJob = SeedsPerJob + Remainer;
% end
% 
% SliceQuantity = str2num(SliceQuantityString);
% SlicesPerJob = round(SliceQuantity / 10);
% Remainer = mod(SliceQuantity, 10);
% if BedpostXJobNum <= Remainer
%     SlicesPerJob = SlicesPerJob + 1;
%     StartSliceNum = SlicesPerJob * (BedpostXJobNum - 1);
% else
%     StartSliceNum = (SlicesPerJob + 1) * Remainer + SlicesPerJob * (BedpostXJobNum - Remainer);
% end

seed_Voxel_matrix = zeros(length(Label_seed_fileCell), length(Label_seed_fileCell));
target_Voxel_matrix = zeros(length(Label_seed_fileCell), length(Label_seed_fileCell));
target_meanFDT_matrix = zeros(length(Label_seed_fileCell), length(Label_seed_fileCell));
disp(Remainer);
disp(StartSeedNum);
if StartSeedNum <= SeedsQuantity
    for i = 1:SeedsPerJob 
        SeedCurrentNum = StartSeedNum + i;
        disp(SeedCurrentNum);
        Label_seed_fileName = Label_seed_fileCell{SeedCurrentNum};
        disp(Label_seed_fileName);
        disp(cat(2, 'reading label of ',Label_seed_fileName));
        system(['fslstats ' Label_seed_fileName ' -V > ' ProbabilisticFolder filesep 'ProbabilisticPost_' ...
            num2str(ProbabilisticNetworkPostJobNum) '_System.txt']);
        tmp_prob = load([ProbabilisticFolder filesep 'ProbabilisticPost_' num2str(ProbabilisticNetworkPostJobNum) '_System.txt']); 
        seed_Voxel_matrix(SeedCurrentNum,:) = tmp_prob(1);
        fdt_fileName = Label_fdt_fileCell{SeedCurrentNum};
        disp(fdt_fileName);
        for j = 1:length(Label_seed_fileCell)
            if j ~= SeedCurrentNum
                Label_target_fileName = Label_seed_fileCell{j};
                system(['fslstats ' fdt_fileName ' -k ' Label_target_fileName ' -M -V > ' ProbabilisticFolder filesep ...
                    'ProbabilisticPost_' num2str(ProbabilisticNetworkPostJobNum) '_System.txt']);
%                 [~, Flag] = str2num(results);
%                 if ~Flag 
% %                 if strcmp(results(1:5), 'ERROR') 
%                     target_meanFDT_matrix(SeedCurrentNum, j)=0;
%                     target_Voxel_matrix(SeedCurrentNum, j)=0; 
%                 else
                tmp_prob = load([ProbabilisticFolder filesep 'ProbabilisticPost_' num2str(ProbabilisticNetworkPostJobNum) '_System.txt']);
                target_meanFDT_matrix(SeedCurrentNum, j) = tmp_prob(1);
                target_Voxel_matrix(SeedCurrentNum, j) = tmp_prob(2);
%                 end
            end
        end
    end
    delete([ProbabilisticFolder filesep '_ProbabilisticPost_' num2str(ProbabilisticNetworkPostJobNum) '_System.txt']);
%     seedVoxel = seed_Voxel_matrix;
%     targetVoxel = target_Voxel_matrix;
%     FDT2target = target_Voxel_matrix .* target_meanFDT_matrix;
%     ProbabilisticMatrix = FDT2target./seed_Voxel_matrix./10000;
    if ~exist([ProbabilisticFolder filesep 'tmp'], 'dir')
        mkdir([ProbabilisticFolder filesep 'tmp']);
    end
    ProbabilisticMatrixPath = [ProbabilisticFolder filesep 'tmp' filesep Prefix '_ProbabilisticMatrix_' num2str(ProbabilisticNetworkPostJobNum, '%2d') '.mat'];
%     save( ProbabilisticMatrixPath, 'ProbabilisticMatrix' ); 
    save( ProbabilisticMatrixPath, 'seed_Voxel_matrix', 'target_Voxel_matrix', 'target_meanFDT_matrix' ); 
end
