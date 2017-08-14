% List of open inputs
% Coregister: Estimate: Reference Image - cfg_files
% Coregister: Estimate: Source Image - cfg_files
dwiFiles = cellstr(spm_select(Inf, 'image', 'choose the dwi files'));
T1Files = cellstr(spm_select(Inf, 'image', 'choose the T1 files'));
% check whether the files matching
checkflag = 0;
for aa = 1:numel(dwiFiles)
    [pat1, ~, ~, ~] = spm_fileparts(dwiFiles{aa});
    [pat2, ~, ~, ~] = spm_fileparts(T1Files{aa});
    checkflag = checkflag + isequal(pat1, pat2);
end
if ~isequal(checkflag, numel(dwiFiles))
    error('The files are not matching');
end

nrun = numel(T1Files); % enter the number of runs here
jobfile = {'F:\Documents\GitHub\DWI_reg\src\matlab\new_norm_based_T1_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = dwiFiles(crun); % Coregister: Estimate: Reference Image - cfg_files
    inputs{2, crun} = T1Files(crun); % Coregister: Estimate: Source Image - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
