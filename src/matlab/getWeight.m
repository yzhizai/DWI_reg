function wMat = getWeight(S, F)
% Input:
%   S - the datamatrix without b0
%   F - the DBF matrix
[dim1, dim2, dim3, dim4] = size(S);
% Obtain the weight matrix
wCell = cellfun(@(x) lsqnonneg(F, reshape(x, [], 1)), ...
    mat2cell(S, ones(1, dim1), ones(1, dim2), ones(1, dim3), dim4), ...
    'UniformOutput', false);
wMat = cellfun(@(x) reshape(x, 1, 1, 1, []), wCell, 'UniformOutput', false);
wMat = reshape(cat(1, wMat{:}), dim1, dim2, dim3, []);