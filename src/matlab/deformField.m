function deformField(Aff, VG)

deformMat = zeros([VG.dim, 3]);

[XX, YY, ZZ] = meshgrid(1:VG.dim(1), 1:VG.dim(2), 1:VG.dim(3));

deformVec = Aff\VG.mat*[XX(:)'; YY(:)'; ZZ(:)'; ones(1, numel(XX(:)))];

for aa = 1:3
    deformMat(:, :, :, aa) = reshape(deformVec(aa, :), VG.dim);
end

ni = nifti;
ni.dat = file_array('y_deform.nii', ...
    size(deformMat), [spm_type('float32'), spm_plateform('bigend')]);

ni.mat = 
ni.mat0 = 
create(ni);

for bb = 1:3
    ni.dat(:, :, :, bb) = deformMat(:, :, :, bb);
end