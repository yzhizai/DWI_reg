function [Y_reg, mat] = resample_based_deform(VF, diffeofile)
% This file is used to resample the data from VF to VG.
% Input:
%   VF 
%   diffeofile - the filename of diffeofile prefixed with "y_".
M = inv(VF(1).mat);
Y_ori = spm_read_vols(VF);

[Def,mat] = get_def(diffeofile);
tmp          = zeros(size(Def),'single');
tmp(:,:,:,1) = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
tmp(:,:,:,2) = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
tmp(:,:,:,3) = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);

Y_reg = zeros(size(Y_ori));
for aa = 1:size(Y_ori, 4)
    c = spm_diffeo('bsplinc', single(Y_ori(:, :, :, aa)), [3 3 3 0 0 0]);
    Y_reg(:, :, :, aa) = spm_diffeo('bsplins', c, tmp, [3 3 3 0 0 0]);
end
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