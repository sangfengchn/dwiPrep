#! /bin/bash
set -exu
# set -u

PROJ=/brain/zhanjunzhang/Desktop/LIZIlin/HTN_duration_multiple_network
RAWPATH=$PROJ/rawdata
DERPATH=$PROJ/derivatives/preprocess_dwi
RESOURCE=$PROJ/resource
SIMGPYTHON=$RESOURCE/toolbox/envpy39.simg
SIMGMATLAB=$RESOURCE/toolbox/matlab-r2020a.simg
chmod +x $PROJ/code/utils/ecclog2mat.sh
chmod +x $PROJ/code/utils/rotbvecs
chmod +x $RESOURCE/toolbox/dtk/dti_recon
chmod +x $RESOURCE/toolbox/dtk/dti_tracker
chmod +x $RESOURCE/toolbox/dtk/spline_filter

# for each subject
for subPath in `echo $RAWPATH/sub-*`
do
    subId=$(basename $subPath)
    subId=${subId/'sub-'/''}
    echo $subId
    
    # check where there is dwi folder
    [ ! -d $subPath/dwi ] && echo "No dwi: sub-${subId}" && continue
    [ ! -f $subPath/anat/*_T1w.nii.gz ] && echo "No T1w: $subId" && continue

    # mkdir derivatives folder
    subDerPath=$DERPATH/sub-$subId
    [ -d $subDerPath ] && continue
    # [ -f $subDerPath/tracks_filtered.trk ] && continue
    [ ! -d $subDerPath ] && mkdir -p $subDerPath

    # >>>>>>>>>>>>>>>> preprocessing <<<<<<<<<<<<<<<<<<<<
    # merge run sequentially
    fslmerge -t $subDerPath/dwi.nii.gz $subPath/dwi/*.nii.gz
    singularity exec $SIMGPYTHON python $PROJ/code/utils/sf_CombineGradient.py $subPath $subDerPath

    # eddy_correct & head motion correction
    eddy_correct $subDerPath/dwi.nii.gz $subDerPath/dwi.nii.gz 0
    $PROJ/code/utils/ecclog2mat.sh $subDerPath/dwi.ecclog
    $PROJ/code/utils/rotbvecs $subDerPath/dwi.bvec $subDerPath/dwi.bvecrot $subDerPath/eddymat.list

    # split b0
    fslroi $subDerPath/dwi.nii.gz $subDerPath/b0.nii.gz 0 1
    #去除b0图像的非脑组织
    bet $subDerPath/b0.nii.gz $subDerPath/b0_brain -m -f 0.2

    # fit tensor
    #张量计算
    dtifit \
        -k $subDerPath/dwi.nii.gz \
        -m $subDerPath/b0_brain_mask.nii.gz \
        -r $subDerPath/dwi.bvecrot \
        -b $subDerPath/dwi.bval \
        -o $subDerPath/dtifit \
        --sse \
        --save_tensor
    fslmaths $subDerPath/dtifit_L2.nii.gz -add $subDerPath/dtifit_L3.nii.gz -div 2 $subDerPath/dtifit_RD.nii.gz 

    ## >>>>>>>>>>>>>>>>> VBM & ROI <<<<<<<<<<<<<<<<<<<<<<<<<
    # t1w-version: t1w needed in this step
    # preprocess t1w
    [ -f $subPath/anat/sub-${subId}_T1w.nii.gz ] && cp $subPath/anat/sub-${subId}_T1w.nii.gz $subDerPath/t1w.nii.gz
    robustfov -v -i $subDerPath/t1w.nii.gz -r $subDerPath/t1w.nii.gz
    #去噪
    fast -v -o $subDerPath/t1w -B $subDerPath/t1w.nii.gz
    #去完噪的图像重新覆盖掉原本的t1图像
    mv $subDerPath/t1w_restore.nii.gz $subDerPath/t1w.nii.gz
    #删除去噪中间文件
    rm $subDerPath/t1w_*
    #去除t1图像的颅骨
    bet $subDerPath/t1w.nii.gz $subDerPath/t1w_brain -m -R -f 0.4

    # registration
    # b0 to t1w, b02t1
    epi_reg --epi=${subDerPath}/b0_brain.nii.gz --t1=${subDerPath}/t1w.nii.gz --t1brain=${subDerPath}/t1w_brain.nii.gz --out=${subDerPath}/b0_brain_dwi2t1w -v
    rm ${subDerPath}/b0_brain_dwi2t1w_fast*
    # b0_brain_dwi2t1w.mat is transform b0 from b0 space to t1w space. t1到b0的转换参数
    mv ${subDerPath}/b0_brain_dwi2t1w.mat ${subDerPath}/dwi2t1w.mat
    #t1到b0的转换参数
    convert_xfm -omat ${subDerPath}/t1w2dwi.mat -inverse ${subDerPath}/dwi2t1w.mat

    # t1w to mni
    #t1到mni的线性参数
    flirt -in ${subDerPath}/t1w_brain.nii.gz -ref $RESOURCE/template/MNI152_T1_1mm_brain.nii.gz -omat ${subDerPath}/t1w2mni.mat
    #mni到t1的线性参数
    convert_xfm -omat ${subDerPath}/mni2t1w.mat -inverse ${subDerPath}/t1w2mni.mat
    #t1到mni的非线性参数
    fnirt --in=${subDerPath}/t1w_brain.nii.gz --aff=${subDerPath}/t1w2mni.mat --cout=${subDerPath}/t1w2mniWarp --ref=${RESOURCE}/template/MNI152_T1_1mm_brain.nii.gz -v
    #应用非线形的转换参数，得到mni空间上的t1
    applywarp --ref=${RESOURCE}/template/MNI152_T1_1mm_brain.nii.gz --in=${subDerPath}/t1w_brain.nii.gz --warp=${subDerPath}/t1w2mniWarp.nii.gz --out=${subDerPath}/t1w_brain_mni.nii.gz
    #mni到t1的非线性参数
    invwarp -w ${subDerPath}/t1w2mniWarp.nii.gz -o ${subDerPath}/mni2t1wWarp.nii.gz -r ${subDerPath}/t1w_brain.nii.gz -v

    # dti measures to mni for vbm
    #应用上面线形及非线形的转换参数，将dti measures转换到标准空间（vbm）
    # fa线形转换到t1
    # flirt -in $subDerPath/dtifit_FA.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/dtifit_FA_mni.nii.gz
    #fa通过t1非线形转换到mni
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/dtifit_FA_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/dtifit_FA_mni.nii.gz
    # MD
    # flirt -in $subDerPath/dtifit_MD.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/dtifit_MD_mni.nii.gz
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/dtifit_MD_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/dtifit_MD_mni.nii.gz

    # flirt -in $subDerPath/dtifit_L1.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/dtifit_L1_mni.nii.gz
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/dtifit_L1_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/dtifit_L1_mni.nii.gz

    # flirt -in $subDerPath/dtifit_RD.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/dtifit_RD_mni.nii.gz
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/dtifit_RD_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/dtifit_RD_mni.nii.gz

    # transform atlas into dwi space for roi-based analysis
    #将atlas非线形转换到t1
    # applywarp --ref=$subDerPath/t1w_brain.nii.gz --in=$RESOURCE/atlas/JHU-ICBM-labels-1mm.nii.gz --warp=$subDerPath/mni2t1wWarp.nii.gz --out=$subDerPath/jhu-icbm-labels.nii.gz --interp=nn
    #将t1空间的atlas转换到dwi空间
    # flirt -in $subDerPath/jhu-icbm-labels.nii.gz -ref $subDerPath/b0_brain.nii.gz -applyxfm -init $subDerPath/t1w2dwi.mat -out $subDerPath/jhu-icbm-labels.nii.gz -interp nearestneighbour
    #应用另一个atlas
    # applywarp --ref=$subDerPath/t1w_brain.nii.gz --in=$RESOURCE/atlas/JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz --warp=$subDerPath/mni2t1wWarp.nii.gz --out=$subDerPath/jhu-icbm-tracts.nii.gz --interp=nn
    # flirt -in $subDerPath/jhu-icbm-tracts.nii.gz -ref $subDerPath/b0_brain.nii.gz -applyxfm -init $subDerPath/t1w2dwi.mat -out $subDerPath/jhu-icbm-tracts.nii.gz -interp nearestneighbour


    # # # >>>>>>>>>>>>>>>>>>> free water <<<<<<<<<<<<<<<<<
    # singularity exec $SIMGPYTHON python $RESOURCE/toolbox/scripts_FW_CONSORTIUM/fw_mrn.py $subDerPath/dwi.nii.gz $subDerPath/b0_brain_mask.nii.gz $subDerPath/dwi.bval $subDerPath/dwi.bvec $subDerPath
    
    # flirt -in $subDerPath/fwc_wls_dti_FA.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/fwc_wls_dti_FA_mni.nii.gz
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/fwc_wls_dti_FA_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/fwc_wls_dti_FA_mni.nii.gz

    # flirt -in $subDerPath/fwc_wls_dti_MD.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/fwc_wls_dti_MD_mni.nii.gz
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/fwc_wls_dti_MD_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/fwc_wls_dti_MD_mni.nii.gz

    # flirt -in $subDerPath/wls_dti_FW.nii.gz -ref $subDerPath/t1w_brain.nii.gz -applyxfm -init $subDerPath/dwi2t1w.mat -out $subDerPath/wls_dti_FW_mni.nii.gz
    # applywarp --ref=$RESOURCE/template/MNI152_T1_1mm_brain.nii.gz --in=$subDerPath/wls_dti_FW_mni.nii.gz --warp=$subDerPath/t1w2mniWarp.nii.gz --out=$subDerPath/wls_dti_FW_mni.nii.gz


    # >>>>>>>>>>>>>>>>>> Tractogram <<<<<<<<<<<<<<<<<
    #解算张量用于纤维追踪
    $RESOURCE/toolbox/dtk/dti_recon $subDerPath/dwi.nii.gz $subDerPath/dtk_ -gm $subDerPath/dwi.GradientMatrix -b $subDerPath/dwi.bval -ot nii.gz
    #全脑纤维追踪
    $RESOURCE/toolbox/dtk/dti_tracker $subDerPath/dtk_ $subDerPath/tracks.trk -iz -m $subDerPath/dtk_fa.nii.gz 0.2 -m2 $subDerPath/b0_brain_mask.nii.gz 0.5 -it nii.gz -fact -at 45
    #平滑纤维束
    $RESOURCE/toolbox/dtk/spline_filter $subDerPath/tracks.trk 0.5 $subDerPath/tracks_filtered.trk
    rm -rf $subDerPath/dtk_*
    
    #把灰质的模版配准到dwi图像
    #灰质atlas非线性到t1
    applywarp --ref=$subDerPath/t1w_brain.nii.gz --in=$RESOURCE/atlas/AAL_brain.nii.gz --warp=$subDerPath/mni2t1wWarp.nii.gz --out=$subDerPath/AAL_brain.nii.gz --interp=nn
    #t1空间的atlas线性转换到dwi空间
    flirt -in $subDerPath/AAL_brain.nii.gz -ref $subDerPath/b0_brain.nii.gz -applyxfm -init $subDerPath/t1w2dwi.mat -out $subDerPath/AAL_brain.nii.gz -interp nearestneighbour
    applywarp --ref=$subDerPath/t1w_brain.nii.gz --in=$RESOURCE/atlas/BN_Atlas_246_1mm.nii --warp=$subDerPath/mni2t1wWarp.nii.gz --out=$subDerPath/BN_Atlas_246_1mm.nii.gz --interp=nn
    flirt -in $subDerPath/BN_Atlas_246_1mm.nii.gz -ref $subDerPath/b0_brain.nii.gz -applyxfm -init $subDerPath/t1w2dwi.mat -out $subDerPath/BN_Atlas_246_1mm.nii.gz -interp nearestneighbour

    #生成结构网络矩阵
    mkdir -p $subDerPath/tmp
    cp $subDerPath/AAL_brain.nii.gz $subDerPath/tmp/AAL_brain.nii.gz
    cp $subDerPath/tracks_filtered.trk $subDerPath/tmp/tracks_filtered.trk
    cp $subDerPath/dtifit_FA.nii.gz $subDerPath/tmp/dtifit_FA.nii.gz
    matlab -r "restoredefaultpath; addpath(genpath('$RESOURCE/toolbox/PANDA_1.3.1_64')); g_DeterministicNetwork('$subDerPath/tmp/tracks_filtered.trk', '$subDerPath/tmp/AAL_brain.nii.gz', '$subDerPath/tmp/dtifit_FA.nii.gz'); exit;"
    rm -rf $subDerPath/tmp
    
    mkdir -p $subDerPath/tmp
    cp $subDerPath/BN_Atlas_246_1mm.nii.gz $subDerPath/tmp/BN_Atlas_246_1mm.nii.gz
    cp $subDerPath/tracks_filtered.trk $subDerPath/tmp/tracks_filtered.trk
    cp $subDerPath/dtifit_FA.nii.gz $subDerPath/tmp/dtifit_FA.nii.gz
    matlab -r "restoredefaultpath; addpath(genpath('$RESOURCE/toolbox/PANDA_1.3.1_64')); g_DeterministicNetwork('$subDerPath/tmp/tracks_filtered.trk', '$subDerPath/tmp/BN_Atlas_246_1mm.nii.gz', '$subDerPath/tmp/dtifit_FA.nii.gz'); exit;"
    rm -rf $subDerPath/tmp
done