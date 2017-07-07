function F = getDBFmatrix(oriBmatrix, Aff)
% Input: oriBmatrix = bval_bvec_to_matrix(bval*ones(1, size(oriReal, 2)), oriReal);
%   oriReal - the gradient directions of acquiring the dwi images, which
%   size is 3*N, including b0 direction. 

% Initialize parameters
lambda1 = 1.5*10^-3;
lambda2 = 3*10^-4;

ori300 = load('Grad_dirs_300.txt');
if size(ori300, 1) > size(ori300, 2)
    ori300 = ori300';
end

Aff = Aff(1:3, 1:3); % 4*4 to 3*3
if nargin > 1
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
    F(:, aa) = exp(oriBmatrix*DT_vec');
end
F = cat(2, ones(size(oriBmatrix, 1), 1)*exp(-bval*lambda1), F);