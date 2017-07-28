function tidy_dir(dirName)
oldPath = pwd;
cd(dirName);
[~, tit, ~] = fileparts(dirName);
fList = dir('*1000*');
delete(fList(:).name);

movefile([tit, '_grad_2500'], 'ori.bvec');
movefile([tit, '_bval_2500'], 'ori.bval');
gunzip('*.nii.gz');
delete('*.nii.gz');

fileName = dir('*nii');
fname = fileName(1).name;
V = spm_vol(fname);
Y = spm_read_vols(V);

[pat, tit, ext, ~] = spm_fileparts(V(1).fname);
fname = fullfile(pat, [tit, '_b0', ext]);
Vw = V(1);
Vw.fname = fname;
Vw = spm_create_vol(Vw);

spm_write_vol(Vw, Y(:, :, :, 1));
cd(oldPath);