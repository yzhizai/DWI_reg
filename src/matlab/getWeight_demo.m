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

% Obtain the weight matrix
wCell = cellfun(@(x) lsqnonneg(F, reshape(x, [], 1)), ...
    mat2cell(S, ones(1, V(1).dim(1)), ones(1, V(1).dim(2)), ones(1, V(1).dim(3)), size(S, 4)), ...
    'UniformOutput', false);
wMat = cellfun(@(x) reshape(x, 1, 1, 1, []), wCell, 'UniformOutput', false);
wMat = reshape(cat(1, wMat{:}), V(1).dim(1), V(1).dim(2), V(1).dim(3), []);

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