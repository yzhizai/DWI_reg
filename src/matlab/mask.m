ni = nifti;
ni.dat = file_array('mask.nii', ...
    [16, 16, 1], ...
    [spm_type('float32'), spm_platform('bigend')]);
ni.mat = diag([2, 2, 2, 1]);
ni.mat0 = diag([2, 2, 2, 1]);
create(ni);

ni.dat(:, :, :) = ones(16, 16, 1);