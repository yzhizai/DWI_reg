function main

%% Choose the dwi image and diffeofield file
dwiFile = spm_select(1, 'nii', 'choose the diffusion MRI data');
diffeoFile = spm_select(1, '^y_./nii&', 'choose the deformation file');
[Def, mat] = get_def(diffeoFile);
[pat, ~, ~, ~] = spm_fileparts(dwiFile);

%% Fit DBFs and get n_b0
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
n_b0 = 0;
for bb = 1:size(bmatrix, 1)
    if round(sum(bmatrix(bb, [1, 4, 6]))) < 10
        n_b0  = n_b0 + 1;
    end
end
F0 = getDBFmatrix(bmatrix, n_b0);

VF_dwi = spm_vol(dwiFile);
S = spm_read_vols(VF_dwi);
S = S(:, :, :, (n_b0 + 1):end);

wMat = getWeight(S, F0);

% Save the weight matrix into a 4D file.
fname = fullfile(pat, 'wMat.nii'); 
ni = nifti;
ni.dat = file_array(fname, size(wMat), ...
    [spm_type('float32'), spm_platform('bigend')]);

ni.mat = V(1).mat;
ni.mat0 = V(1).mat;
create(ni)

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = wMat(:, :, :, aa);
end
%% Transform b0 volumes
b0_trans = resample_based_deform(VF_dwi(1:n_b0), Def);
% transform wMat 
VF_wmat = spm_vol(fname);

wMat_trans = resample_based_deform(VF_wmat, Def);
wMat_cell = mat2cell(wMat_trans, ones(1, size(wMat_trans, 1)), ones(1, size(wMat_trans, 2)), ...
    ones(1, size(wMat_trans, 3)), size(wMat_trans, 4));

%% For each voxel, affine matrix is unique, which is obtained from jacobian 
% detminant of deformation field.
J  = spm_deformations('def2jac', Def);


F = getDBFmatrix(bmatrix);

% reconstruct the data into standard space.
S_reg_cell = cellfun(@(x) F*x(:), wMat_cell, 'UniformOutput', false);

S_reg_cell = cellfun(@(x) reshape(x, 1, 1, 1, []), S_reg_cell, 'UniformOutput', false);

S_reg = reshape(cat(1, S_reg_cell{:}), size(wMat, 1), size(wMat, 2), size(wMat, 3), []);

S_reg = cat(4, b0_trans, S_reg);


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
