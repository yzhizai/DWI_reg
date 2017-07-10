% Test the function validation.
filename1 = spm_select(1, 'mat');
D1 = (1.5 - 0.3)*10^-3*([1, 0, 0]'*[1, 0, 0]) + 0.3*10^-3*eye(3);
D2 = (1.5 - 0.3)*10^-3*([0, 1, 0]'*[0, 1, 0]) + 0.3*10^-3*eye(3);

func1 = @(k) 0.5*(exp(-2000*k*D1*k') + exp(-2000*k*D2*k')); % crossed fibers
S0 = 150;
S1 = [S0; S0*getSample(filename1, func1)];

bvecFile = spm_select(1, 'bvec', 'bvec');
bvalFile = spm_select(1, 'bval', 'bval');
bvec = load(bvecFile);
bval = load(bvalFile);
if size(bvec, 1) > size(bvec, 2)
    bvec = bvec';
end
if size(bval, 1) > size(bval, 2)
    bval = bval';
end

bmatrix = bval_bvec_to_matrix(bval, bvec);
F = getDBFmatrix(bmatrix);

S = S1(2:end, :);

w = lsqnonneg(F, S);

S_recon = F*w;


