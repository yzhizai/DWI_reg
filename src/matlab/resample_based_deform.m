function Y_reg = resample_based_deform(VF, Y_ori, Def)
% This file is used to resample the data from VF to VG.
% Input:
%   VF - just using the provide the VF(1).mat
%   Y_ori - the subj image matrix used to transform.
%   Def - the deformation matrix.

M     = inv(VF(1).mat);
if isempty(Y_ori)
    Y_ori = spm_read_vols(VF);
end


tmp          = zeros(size(Def),'single');
tmp(:,:,:,1) = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
tmp(:,:,:,2) = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
tmp(:,:,:,3) = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);

Y_reg = zeros(size(Def, 1), size(Def, 2), size(Def, 3), numel(VF));
for aa = 1:size(Y_ori, 4)
    c                  = spm_diffeo('bsplinc', single(Y_ori(:, :, :, aa)), [3 3 3 0 0 0]);         
    Y_reg(:, :, :, aa) = spm_diffeo('bsplins', c, tmp, [3 3 3 0 0 0]);
end
