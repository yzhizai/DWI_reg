function wMat = getWeight(S, F)
% Input:
%   S - the datamatrix without b0
%   F - the DBF matrix
[dim1, dim2, dim3, ~] = size(S);
% % Obtain the weight matrix
% wCell = cellfun(@(x) lsqnonneg(F, reshape(x, [], 1)), ...
%     mat2cell(S, ones(1, dim1), ones(1, dim2), ones(1, dim3), dim4), ...
%     'UniformOutput', false);
% % Beta = 0.0001;
% % wCell = cellfun(@(x) l1ls_featuresign(reshape(x, [], 1), F, Beta), ...
% %     mat2cell(S, ones(1, dim1), ones(1, dim2), ones(1, dim3), dim4), ...
% %     'UniformOutput', false);
% wMat = cellfun(@(x) reshape(x, 1, 1, 1, []), wCell, 'UniformOutput', false);
% wMat = reshape(cat(1, wMat{:}), dim1, dim2, dim3, []);
wMat = zeros(dim1, dim2, dim3, size(F, 2));
for aa = 1:dim1
    for bb = 1:dim2
        for cc = 1:dim3
           wMat(aa, bb, cc, :) = lsqnonneg(F, reshape(S(aa, bb, cc, :), [], 1)); 
        end
    end
end
