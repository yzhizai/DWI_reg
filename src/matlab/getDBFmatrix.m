function F = getDBFmatrix(oriReal)
% Input:
%   oriReal - the gradient directions of acquiring the dwi images, which size is 3*N

ori300 = load('Grad_dirs_300.txt');
ori300 = ori300';
bval = 2000;
oriBmatrix = bval_bvec_to_matrix([0, bval*ones(1, size(oriReal, 2))], oriReal);
lambda1 = 1.5*10^-3;
lambda2 = 3*10^-4;
F = zeros(size(oriBmatrix, 1), size(ori300, 2));

for aa = 1:size(ori300, 2)
    ori = ori300(:, aa);
    DT = (lambda1 - lambda2)*(ori*ori') + lambda2*eye(3);
    DT_vec = [DT(1, 1), DT(1, 2), DT(1, 3), DT(2, 2), DT(2, 3), DT(3, 3)];
    F(:, aa) = exp(oriBmatrix*DT_vec');
end
F = cat(2, ones(size(oriBmatrix, 1), 1)*exp(-bval*lambda1), F);