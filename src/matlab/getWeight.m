function wMat = getWeight(S, F)
% Input:
%   S - the datamatrix without b0
%   F - the DBF matrix

% Obtain the weight matrix
wCell = cellfun(@(x) lsqnonneg(F, reshape(x, [], 1)), ...
    mat2cell(S, ones(1, V(1).dim(1)), ones(1, V(1).dim(2)), ones(1, V(1).dim(3)), size(S, 4)), ...
    'UniformOutput', false);
wMat = cellfun(@(x) reshape(x, 1, 1, 1, []), wCell, 'UniformOutput', false);
wMat = reshape(cat(1, wMat{:}), V(1).dim(1), V(1).dim(2), V(1).dim(3), []);