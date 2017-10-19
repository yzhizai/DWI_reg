function wVec = getWeight_for_single_voxel(S, F)
% This function is used to test the simulated signals.
% Input:
%   S - the diffusion attenuation signal
%   F - the DBF matrix
wVec = zeros(size(F, 2), size(S, 1));
for aa = 1:size(S, 1)
    wVec(:, aa) = lsqnonneg(F, reshape(S(aa, :), [], 1));
end
