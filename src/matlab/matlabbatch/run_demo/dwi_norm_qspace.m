% List of open inputs
% DWIs registration: Diffusion Images: - cfg_files
% DWIs registration: Deformation Field: - cfg_files
% DWIs registration: bval: - cfg_files
% DWIs registration: bvec: - cfg_files
dwiFiles = cellstr(spm_select(Inf, 'nii', 'choose the dwi files'));
nrun = numel(dwiFiles); % enter the number of runs here
[pat, tit, ext] = fileparts(mfilename('fullpath'));
jobfile = {fullfile(pat, [tit, '_job.m'])};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(4, nrun);
for crun = 1:nrun
    inputs{1, crun} = dwiFiles(crun); % DWIs registration: Diffusion Images: - cfg_files
    filename = dwiFiles{crun};
    bvalName = strrep(filename, '.nii', '.bval');
    bvecName = strrep(filename, '.nii', '.bvec');
    [pat, tit, ext, ~] = spm_fileparts(filename);
    mainName = strsplit(tit, '_');
    defName = fullfile(pat, ['y_y_', mainName{1}, '_T1', ext]);
    inputs{2, crun} = {defName}; % DWIs registration: Deformation Field: - cfg_files
    inputs{3, crun} = {bvecName}; % DWIs registration: bvec: - cfg_files
    inputs{4, crun} = {bvalName}; % DWIs registration: bval: - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
