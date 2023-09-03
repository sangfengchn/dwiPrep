atlasPath = "resource/atlas/AAL_brain_2mm.nii.gz";
tmpPath = "derivatives/fmriprep/sub-10486/func/" + ...
    "sub-10486_task-rest_space-MNI152NLin6Asym_desc-denosied_bold.nii.gz";

atlasData = niftiread(atlasPath);
tmpData = niftiread(tmpPath);
tmpMeta = niftiinfo(tmpPath);
roiIndex = 15;
dims = size(tmpData);
tmpRoiSingle = zeros(dims(4), 1);
tmpCorrcoef = zeros(dims(1), dims(2), dims(3));

for i = 1:dims(4)
    tmpTimeData = tmpData(:, :, :, i);
    tmpRoiSingle(i) = mean(tmpTimeData(atlasData == roiIndex), ...
        'omitnan');
end

for i = 1:dims(1)
    for j = 1:dims(2)
        for k = 1:dims(3)
            tmp = corrcoef(tmpRoiSingle, tmpData(i, j, k, :));
            tmpCorrcoef(i, j, k) = tmp(1, 2);
        end
    end
end
niftiwrite(tmpCorrcoef, "demo.nii", tmpMeta);