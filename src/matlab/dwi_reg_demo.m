function dwi_reg_demo

% Generate the affine matrix
Aff_init = rotationVectorToMatrix(pi/12*[0, 0, 1]);
Aff = eye(4);
Aff(1:3, 1:3) = Aff_init;

% Obtain the real diffusion gradient directions
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

wFile = spm_select(1, 'nii', 'choose the transformed weight image');

wV = spm_vol(wFile);
wMat = spm_read_vols(wV);

wMat_cell = mat2cell(wMat, ones(1, size(wMat, 1)), ones(1, size(wMat, 2)), ...
    ones(1, size(wMat, 3)), size(wMat, 4));
% F = getDBFmatrix(bmatrix, Aff);
F = getDBFmatrix(bmatrix);

S_reg_cell = cellfun(@(x) F*x(:), wMat_cell, 'UniformOutput', false);

S_reg_cell = cellfun(@(x) reshape(x, 1, 1, 1, []), S_reg_cell, 'UniformOutput', false);

S_reg = reshape(cat(1, S_reg_cell{:}), size(wMat, 1), size(wMat, 2), size(wMat, 3), []);

ni = nifti;
fname = inputdlg({'output filename'}, 'give output file name');
fname = fname{1};
ni.dat = file_array(fname, ...
    size(S_reg), [spm_type('float32'), spm_platform('bigend')]);

ni.mat = wV(1).mat;
ni.mat0 = wV(1).mat;

create(ni);

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = S_reg(:, :, :, aa);
end






