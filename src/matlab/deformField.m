function deformField(Aff, VG)
% Note that, the deformationfield in spm is a 5D matrix with dim4 is 1.
deformMat = zeros([VG.dim, 3]);

% ndgrid rather than meshgrid.
[XX, YY, ZZ] = ndgrid(1:VG.dim(1), 1:VG.dim(2), 1:VG.dim(3));

deformVec = Aff\VG.mat*[XX(:)'; YY(:)'; ZZ(:)'; ones(1, numel(XX(:)))];

for aa = 1:3
    deformMat(:, :, :, aa) = reshape(deformVec(aa, :), VG.dim);
end


dirName = spm_select(1, 'dir', 'choose a directory to store the image'); 
fname = inputdlg({'filename'}, 'Name a file');
fname = fullfile(dirName, fname{1});
ni = nifti;
ni.dat = file_array(fname, ...
    [VG.dim, 1, 3], 'FLOAT32-LE');

ni.mat = diag([2, 2, 2, 1]);
ni.mat0 = diag([2, 2, 2, 1]);
ni.mat_intent = 'Aligned';
ni.mat0_intent = 'Aligned';
ni.intent.code = 'VECTOR';
ni.intent.name = 'Mapping';
ni.descrip = 'Deformation field';
create(ni);

for bb = 1:3
    ni.dat(:, :, :, 1, bb) = deformMat(:, :, :, bb); % 5D matrix.
end

