% List of open inputs
% DWIs registration: Diffusion Images: - cfg_files
% DWIs registration: Deformation Field: - cfg_files
% DWIs registration: bval: - cfg_files
% DWIs registration: bvec: - cfg_files
dwiFiles = cellstr(spm_select(Inf, 'nii', 'choose the dwi files'));
nrun = numel(dwiFiles); % enter the number of runs here
jobfile = {'G:\Duansf\Github\DWI_reg\src\matlab\matlabbatch\run_demo\dwi_norm_qspace_this_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(4, nrun);
for crun = 1:nrun
    inputs{1, crun} = dwiFiles(crun); % DWIs registration: Diffusion Images: - cfg_files
    filenamej = dwiFiles{crun};
    
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % DWIs registration: Deformation Field: - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % DWIs registration: bval: - cfg_files
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % DWIs registration: bvec: - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
