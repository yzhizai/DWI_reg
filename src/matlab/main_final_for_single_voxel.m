function S_recon = main_final_for_single_voxel(S, bvecFile, bvalFile)
% This function is used to test the simulated signals
%% Fit DBFs and get n_b0
bvec     = load(bvecFile);
bval     = load(bvalFile);
if size(bvec, 1) > size(bvec, 2)
    bvec = bvec';
end
if size(bval, 1) > size(bval, 2)
    bval = bval';
end

new_order = get_new_order(bvec);

bmatrix = bval_bvec_to_matrix(bval, bvec, [2, 1, 3], [1, 1, 1]);
n_b0 = 0;
for bb = 1:size(bmatrix, 1)
    if round(sum(bmatrix(bb, [1, 4, 6]))) < 10
        n_b0  = n_b0 + 1;
    end
end
F0 = getDBFmatrix(bmatrix, n_b0);

S_fit = S(:, 2:end);
wVec   = getWeight_for_single_voxel(S_fit, F0);

bvec_dwi = bvec(:, 2:end);
bvec_dwi = bvec_dwi(:, new_order);
bvec(:, 2:end) = bvec_dwi;  %rearrange the order of the diffusion gradients.

bmatrix1 = bval_bvec_to_matrix(bval, bvec, [2, 1, 3], [1, 1, 1]);
F1 = getDBFmatrix(bmatrix1, n_b0);

S_recon = F1*wVec;
S_recon = S_recon';
S_recon = cat(2, S(:, 1), S_recon);

function new_order = get_new_order(bvec)
neg_indx = bvec < 0;
neg_indx_z = repmat(neg_indx(3, :), 3, 1);
neg_indx_z = neg_indx_z*(-2) + 1;
bvec = bvec.*neg_indx_z;

[azim, elev, ~] = cart2sph(bvec(1, 2:end), bvec(2, 2:end), bvec(3, 2:end));
sph_array = [azim', (pi/2 - elev)'];
[~, new_order] = sortrows(sph_array, [2, 1]);