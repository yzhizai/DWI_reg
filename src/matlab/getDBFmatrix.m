function F = getDBFmatrix(oriBmatrix, n_b0, Aff)
% Usage: F = GETDBFMATTRIX(oriBmatrix, n_b0[, Aff])
% Input: 
%   oriBmatrix = bval_bvec_to_matrix(bval, bvec);
%     oriReal - the gradient directions of acquiring the dwi images, which
%     size is 3*N, including b0 direction. 
%   n_b0 - the number of b0 volume
%   Aff - the affine matrix, 4*4
% Output: 
%  F - the DBF matrix without the rows corresponding to b0 volume.  

% Initialize parameters
uniformOrientationFilePath = 'F:\Documents\GitHub\DWI_reg\src\matlab\Grad_dirs_300.txt';

lambda1 = 1.5*10^-3;
lambda2 = 3*10^-4;

ori300 = load(uniformOrientationFilePath);
if size(ori300, 1) > size(ori300, 2)
    ori300 = ori300';
end

ori300 = ori300([2, 1, 3], :);

oriBmatrix(1:n_b0, :) = [];

if nargin > 2
    Aff = Aff(1:3, 1:3); % 4*4 to 3*3
    ori300 = Aff*ori300;
    for bb = 1:size(ori300, 2)
        ori300(:, bb) = ori300(:, bb)/norm(ori300(:, bb));
    end
end
% Get bval from B-matrix.
bval = round(sum(oriBmatrix(3, [1, 4, 6])));

F = zeros(size(oriBmatrix, 1), size(ori300, 2));

for aa = 1:size(ori300, 2)
    ori = ori300(:, aa);
    DT = (lambda1 - lambda2)*(ori*ori') + lambda2*eye(3);
    DT_vec = [DT(1, 1), DT(1, 2), DT(1, 3), DT(2, 2), DT(2, 3), DT(3, 3)];
    F(:, aa) = exp(-1*oriBmatrix*DT_vec');
end
F = cat(2, ones(size(oriBmatrix, 1), 1)*exp(-1*bval*lambda1), F);