function [Def,mat] = get_def(filename)
% Load a deformation field saved as an image
Nii = nifti(filename);
Def = single(Nii.dat(:,:,:,1,:));
d   = size(Def);
if d(4)~=1 || d(5)~=3, error('Deformation field is wrong!'); end
Def = reshape(Def,[d(1:3) d(5)]);
mat = Nii.mat;