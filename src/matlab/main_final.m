function main_final(dwiFile, diffeoFile, bvecFile, bvalFile, paraFile)

%% Choose the dwi image and diffeofield file
% dwiFile        = spm_select(1, 'nii', 'choose the diffusion MRI data');
[pat, tit, ext, ~] = spm_fileparts(dwiFile);
% diffeoFile     = spm_select(1, '^y_.*nii$', 'choose the deformation file', {}, pat);
% bvecFile = spm_select(1, 'bvec', 'bvec', {}, pat);
% bvalFile = spm_select(1, 'bval', 'bval', {}, pat);

[Def, mat]     = get_def(diffeoFile);
Def_y = zeros(size(Def));
[xx, yy, zz] = ndgrid(1:size(Def, 1), 1:size(Def,2), 1:size(Def, 3));

Def_y(:, :, :, 1) = mat(1, 1)*xx + mat(1, 2)*yy + mat(1, 3)*zz + mat(1, 4);
Def_y(:, :, :, 2) = mat(2, 1)*xx + mat(2, 2)*yy + mat(2, 3)*zz + mat(2, 4);
Def_y(:, :, :, 3) = mat(3, 1)*xx + mat(3, 2)*yy + mat(3, 3)*zz + mat(3, 4);

Def_sub = Def - Def_y;


%% Affine matrix
% Aff = rotationVectorToMatrix(pi/12*[0, 0, 1]);
J = spm_diffeo('def2jac', Def_sub);
J = reshape(J, size(J, 1), size(J, 2), size(J, 3), []); 
J(isnan(J)) = 0;
% JCell = mat2cell(J, ones(1, size(J, 1)), ones(1, size(J, 2)), ones(1, size(J, 3)), ...
%     size(J, 4));
% RCell = cellfun(@jac2R, JCell, 'UniformOutput', false); % each element is a 3*3 matrix.

% Use Jacobian matrix to get the rotation with FS method.
R = zeros(size(J));
for aa = 1:size(J, 1)
    for bb = 1:size(J, 2)
        for cc = 1:size(J, 3)
            R(aa, bb, cc, :) = reshape(jac2R(J(aa, bb, cc, :)), [], 1);
        end
    end
end

% RCell = cellfun(@(x) reshape(x, 1, 1, 1, []), RCell, 'UniformOutput', false);
% RMat = reshape(cat(1, RCell{:}), size(J, 1), size(J, 2), size(J, 3), []);
clearvars J

%% Fit DBFs and get n_b0

bvec     = load(bvecFile);
bval     = load(bvalFile);
if size(bvec, 1) > size(bvec, 2)
    bvec = bvec';
end
if size(bval, 1) > size(bval, 2)
    bval = bval';
end
bmatrix = bval_bvec_to_matrix(bval, bvec, [2, 1, 3], [1, 1, 1]);
n_b0 = 0;
for bb = 1:size(bmatrix, 1)
    if round(sum(bmatrix(bb, [1, 4, 6]))) < 10
        n_b0  = n_b0 + 1;
    end
end
F0 = getDBFmatrix(bmatrix, n_b0);

VF_dwi = spm_vol(dwiFile);
S      = spm_read_vols(VF_dwi);
S      = S(:, :, :, (n_b0 + 1):end);

wMat   = getWeight(S, F0);
clearvars F0 S
% Save the weight matrix into a 4D file.
fname  = fullfile(pat, 'wMat.nii'); 
ni     = nifti;
ni.dat = file_array(fname, size(wMat), ...
    [spm_type('float32'), spm_platform('bigend')]);

ni.mat  = VF_dwi(1).mat;
ni.mat0 = VF_dwi(1).mat;
create(ni)

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = wMat(:, :, :, aa);
end
%% Transform b0 volumes
b0_trans   = resample_based_deform(VF_dwi(1:n_b0), [], Def);
% transform wMat 
wMat_trans = resample_based_deform(VF_dwi(1), wMat, Def);
[sizeX, sizeY, sizeZ, sizeS] = size(wMat_trans);
wMat_trans_cell  = mat2cell(wMat_trans, ones(1, sizeX), ones(1, sizeY), ...
    ones(1, sizeZ), sizeS);
RCell = mat2cell(R, ones(1, sizeX), ones(1, sizeY), ones(1, sizeZ), size(R, 4));
%% For each voxel, affine matrix is unique, which is obtained from jacobian 
% clear workspace
clearvars wMat R wMat_trans


% reconstruct the data into standard space.
%% 
% In order to make every individual dataset to the same space not only the
% same anatomical space but also the q-space. Each image should be provided
% the same diffusion gradients to reconstruct.
if ~isempty(paraFile)
    para = load(paraFile);
    bmatrix = para.bmatrix;
end
%%
S_reg_cell = cellfun(@(x, y)compose_signal(bmatrix, n_b0, x, y),RCell, wMat_trans_cell, 'UniformOutput', false);
% S_reg = zeros(sizeX, sizeY, sizeZ, numel(VF_dwi) - n_b0);
% for aa = 1:sizeX
%     for bb = 1:sizeY
%         for cc = 1:sizeZ
%             F = getDBFmatrix(bmatrix, n_b0, reshape(R(aa, bb, cc, :), 3, 3));
%             S_reg(aa, bb, cc, :) = F*reshape(wMat_trans(aa, bb, cc, :), [], 1);
%         end
%     end
% end
clearvars RCell wMat_trans_cell
S_reg_cell = cellfun(@(x) reshape(x, 1, 1, 1, []), S_reg_cell, 'UniformOutput', false);
S_reg      = reshape(cat(1, S_reg_cell{:}), sizeX, sizeY, sizeZ, []);
S_reg      = cat(4, b0_trans, S_reg);
S_reg(isnan(S_reg)) = 0;

ni     = nifti;
fname  = fullfile(pat, ['w', tit, ext]);
ni.dat = file_array(fname, ...
    size(S_reg), [spm_type('float32'), spm_platform('bigend')]);

ni.mat  = mat;
ni.mat0 = mat;

create(ni);

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = S_reg(:, :, :, aa);
end
function S =  compose_signal(bmatrix, n_b0, Aff, w)
Aff        = reshape(Aff, 3, 3);
Aff = inv(Aff);
F          = getDBFmatrix(bmatrix, n_b0, Aff);
S          = F*w(:);
