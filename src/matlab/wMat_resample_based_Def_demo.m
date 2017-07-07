function wMat_resample_based_Def_demo
% For the reason of spm normalize write couldn't deal with the 4D image, so
% I write this function to compensate it.
filename = spm_select(1, 'nii');

diffeofile = spm_select(1, 'nii', 'choose the deformation field');
[Def,mat] = get_def(diffeofile);
VF = spm_vol(filename);
Y = spm_read_vols(VF);
M = inv(VF(1).mat);

tmp          = zeros(size(Def),'single');
tmp(:,:,:,1) = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
tmp(:,:,:,2) = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
tmp(:,:,:,3) = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);

Y_reg = zeros(size(Y));
for aa = 1:size(Y, 4)
    Y_org = Y(:, :, :, aa);
    c = spm_diffeo('bsplinc', single(Y_org), [3 3 3 0 0 0]);
    Y_reg(:, :, :, aa) = spm_diffeo('bsplins', c, tmp, [3 3 3 0 0 0]);
end

fname = inputdlg({'Output file name'}, 'Specified filename');
fname = fname{1};

ni = nifti;
ni.dat = file_array(fname, size(Y_reg), [spm_type('float32'), spm_platform('bigend')]);
ni.mat = mat;
ni.mat0 = mat;

create(ni);

for bb = 1:size(ni.dat, 4)
    ni.dat(:, :, :, bb) = Y_reg(:, :, :, bb);
end
% VG.fname = fname;
% V = spm_create_vol(VG);
% spm_write_vol(V, Y_reg);


%==========================================================================
% function [Def,mat] = get_def(job)
%==========================================================================
function [Def,mat] = get_def(filename)
% Load a deformation field saved as an image
Nii = nifti(filename);
Def = single(Nii.dat(:,:,:,1,:));
d   = size(Def);
if d(4)~=1 || d(5)~=3, error('Deformation field is wrong!'); end
Def = reshape(Def,[d(1:3) d(5)]);
mat = Nii.mat;