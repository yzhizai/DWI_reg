function getWeight_demo
% Load data
filename = spm_select(1, 'nii');
V = spm_vol(filename);
S = spm_read_vols(V);

% User given value
n_b0 = 1;

% Fit DBFs
bvecFile = spm_select(1, 'bvec', 'bvec');
bvalFile = spm_select(1, 'bval', 'bval');
bvec = load(bvecFile);
bval = load(bvalFile);
if size(bvec, 1) > size(bvec, 2)
    bvec = bvec';
end
if size(bval, 1) > size(bval, 2)
    bval = bval';
end

bmatrix = bval_bvec_to_matrix(bval, bvec);
F = getDBFmatrix(bmatrix);
% eliminate the row corresponding to b0 volume
S = S(:, :, :, (n_b0 + 1):end);

wMat = getWeight(S, F);

fname = inputdlg({'weight file name'}, 'output file name');
fname = fname{1};

ni = nifti;
ni.dat = file_array(fname, size(wMat), ...
    [spm_type('float32'), spm_platform('bigend')]);

ni.mat = V(1).mat;
ni.mat0 = V(1).mat;
create(ni)

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = wMat(:, :, :, aa);
end