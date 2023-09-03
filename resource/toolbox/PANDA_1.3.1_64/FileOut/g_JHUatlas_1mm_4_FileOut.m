function [ FileOut ] = g_JHUatlas_1mm_4_FileOut( JobName,NiiOutputPath,NumberOfSubject_String,dtifit_Prefix )
%
% FileOut contain all the files' full path of the job JHUatlas_1mm_4 output 
% 3 files will be produced: _L23m_to_target_1mm.WMlabel, 
%                           _L23m_to_target_1mm.WMtract, .done 
% .done file is sign of the completion of the job
%
FileOut{1} = [NiiOutputPath NumberOfSubject_String filesep 'standard_space' filesep dtifit_Prefix '_L23m_4normalize_to_target_1mm.WMlabel' ] ;
FileOut{2} = [NiiOutputPath NumberOfSubject_String filesep 'standard_space' filesep dtifit_Prefix '_L23m_4normalize_to_target_1mm.WMtract' ] ;
FileOut{3} = [NiiOutputPath NumberOfSubject_String filesep 'tmp' filesep 'OutputDone' filesep JobName '.done' ] ;