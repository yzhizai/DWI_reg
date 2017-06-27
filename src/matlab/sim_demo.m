function sim_demo
% Load data
filename = spm_select(1, 'nii');
V = spm_vol(filename);
S = spm_read_vols(V);
% Fit DBFs
bvecFile = spm_select(1, 'bvec');
bvec = load(bvecFile);
if size(bvec, 1) > size(bvec, 2)
    bvec = bvec';
end
F = getDBFmatrix(bvec);

% Obtain the weight matrix
wCell = cellfun(@(x) lsqnonneg(F, reshape(x, [], 1)), mat2cell(S, ones(1, V(1).dim(1)), ones(1, V(1).dim(2)), ones(1, V(1).dim(3)), numel(V)), ...
    'UniformOutput', false);
wMat = cellfun(@(x) reshape(x, 1, 1, 1, []), wCell, 'UniformOutput', false);
wMat = reshape(cat(1, wMat{:}), V(1).dim(1), V(1).dim(2), V(1).dim(3), []);

ni = nifti;
ni.dat = file_array('wMat.nii', size(wMat), ...
    [spm_type('float32'), spm_platform('bigend')]);

ni.mat = V(1).mat;
ni.mat0 = V(1).mat;
create(ni)

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = wMat(:, :, :, aa);
end