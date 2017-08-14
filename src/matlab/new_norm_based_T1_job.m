%-----------------------------------------------------------------------
% Job saved on 13-Aug-2017 14:28:45 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.coreg.estimate.ref = '<UNDEFINED>';
matlabbatch{1}.spm.spatial.coreg.estimate.source = '<UNDEFINED>';
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.normalise.est.subj.vol(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{2}.spm.spatial.normalise.est.eoptions.biasreg = 0.0001;
matlabbatch{2}.spm.spatial.normalise.est.eoptions.biasfwhm = 60;
matlabbatch{2}.spm.spatial.normalise.est.eoptions.tpm = {'E:\DTI_app\spm12\tpm\TPM.nii'};
matlabbatch{2}.spm.spatial.normalise.est.eoptions.affreg = 'mni';
matlabbatch{2}.spm.spatial.normalise.est.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{2}.spm.spatial.normalise.est.eoptions.fwhm = 0;
matlabbatch{2}.spm.spatial.normalise.est.eoptions.samp = 3;
