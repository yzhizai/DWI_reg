function deformField(Aff, VG)
% Note that, the deformationfield in spm is a 5D matrix with dim4 is 1.
deformMat = zeros([VG.dim, 3]);

[XX, YY, ZZ] = meshgrid(1:VG.dim(1), 1:VG.dim(2), 1:VG.dim(3));

deformVec = Aff\VG.mat*[XX(:)'; YY(:)'; ZZ(:)'; ones(1, numel(XX(:)))];

for aa = 1:3
    deformMat(:, :, :, aa) = reshape(deformVec(aa, :), VG.dim);
end

ni = nifti;
ni.dat = file_array('y_deform.nii', ...
    [VG.dim, 1, 3], [spm_type('float32'), spm_platform('bigend')]);

ni.mat = diag([2, 2, 2, 1]);
ni.mat0 = diag([2, 2, 2, 1]);
create(ni);

for bb = 1:3
    ni.dat(:, :, :, 1, bb) = deformMat(:, :, :, bb); % 5D matrix.
end