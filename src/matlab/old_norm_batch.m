% List of open inputs
% Old Normalise: Estimate & Write: Source Image - cfg_files
% Old Normalise: Estimate & Write: Images to Write - cfg_files
filenames = cellstr(spm_select(Inf, 'nii'));
nrun = numel(filenames); % enter the number of runs here
jobfile = {'F:\Documents\GitHub\DWI_reg\src\matlab\old_norm_batch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = filenames(crun); % Old Normalise: Estimate & Write: Source Image - cfg_files
    inputs{2, crun} = filenames(crun); % Old Normalise: Estimate & Write: Images to Write - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
