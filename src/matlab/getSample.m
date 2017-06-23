function S = getSample(varargin)
% GETSAMPLE - This function is used to generate simulated data

diff_ori = load(varargin{1});
func = varargin{2};
S = zeros(size(diff_ori, 1), 1);
for aa = 1:size(diff_ori, 1)
    k = diff_ori(aa, :);
    S(aa) = func(k);
end
