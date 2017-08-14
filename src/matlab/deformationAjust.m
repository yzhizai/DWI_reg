% List of open inputs
% Deformations: Deformation Field - cfg_files
% Deformations: Save as - cfg_entry
% Deformations: Output directory - cfg_files
defFiles = cellstr(spm_select(Inf, '^y_.*.nii', 'choose the deformation files'));

nrun = numel(defFiles); % enter the number of runs here
jobfile = {'F:\Documents\GitHub\DWI_reg\src\matlab\deformationAjust_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(3, nrun);
for crun = 1:nrun
    inputs{1, crun} = defFiles(crun); % Deformations: Deformation Field - cfg_files
    [pat, tit, ext] = fileparts(defFiles{crun});
    inputs{2, crun} = tit; % Deformations: Save as - cfg_entry
    inputs{3, crun} = {pat}; % Deformations: Output directory - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
