%% simulated data
filename1 = spm_select(1, 'mat'); % choose the pure direction file, such as Grad_dirs_60.txt
D1 = (1.5 - 0.3)*10^-3*([1, 0, 0]'*[1, 0, 0]) + 0.3*10^-3*eye(3);
D2 = (1.5 - 0.3)*10^-3*([0, 1, 0]'*[0, 1, 0]) + 0.3*10^-3*eye(3);
D3 = 1.5*10^-3*eye(3);

func1 = @(k) 0.5*(exp(-2000*k*D1*k') + exp(-2000*k*D2*k')); % crossed fibers
func2 = @(k) exp(-2000*k*D1*k');  % single fiber along x-axis
func3 = @(k) exp(-2000*k*D2*k'); % signle fiber along y-axis
func4 = @(k) exp(-2000*k*D3*k'); % isotropic diffusion

S0 = 150;
S1 = [S0; S0*getSample(filename1, func1)];
S2 = [S0; S0*getSample(filename1, func2)];
S3 = [S0; S0*getSample(filename1, func3)];
S4 = [S0; S0*getSample(filename1, func4)];


sample3D_1 = repmat(reshape(S4, 1, 1, []), 16, 16);
sample3D_2 = repmat(reshape(S3, 1, 1, []), 4, 14);
sample3D_3 = repmat(reshape(S2, 1, 1, []), 14, 4);
sample3D_4 = repmat(reshape(S1, 1, 1, []), 4, 4);

sample3D = sample3D_1;
sample3D(7:10, 2:end - 1, :) = sample3D_2;
sample3D(2:end - 1, 7:10, :) = sample3D_3;
sample3D(7:10, 7:10, :) =  sample3D_4;

sample4D = reshape(sample3D, 16, 16, 1, []);

ni = nifti;
ni.dat = file_array('sampleData.nii', ...
    size(sample4D), ...
    [spm_type('float32'), spm_platform('bigend')]);
ni.mat = diag([2, 2, 2, 1]);
ni.mat0 = diag([2, 2, 2, 1]);
create(ni);

for aa = 1:size(ni.dat, 4)
    ni.dat(:, :, :, aa) = sample4D(:, :, :, aa);
end

%% mask.nii
ni = nifti;
ni.dat = file_array('mask.nii', ...
    [16, 16, 1], ...
    [spm_type('float32'), spm_platform('bigend')]);
ni.mat = diag([2, 2, 2, 1]);
ni.mat0 = diag([2, 2, 2, 1]);
create(ni);

ni.dat(:, :, :) = ones(16, 16, 1);

%% Generate bval and bvec file
bvec = load(filename1);
bvec = cat(1, [0, 0, 0], bvec);
fid1 = fopen('ori.bvec', 'w+');
fprintf(fid1, '%f\t', bvec(:, 1));
fprintf(fid1, '\n');
fprintf(fid1, '%f\t', bvec(:, 2));
fprintf(fid1, '\n');
fprintf(fid1, '%f\t', bvec(:, 3));
fclose(fid1);

fid2 = fopen('ori.bval', 'w+');
fprintf(fid2, '%d\t', [0, ones(1, size(bvec, 1) - 1)*2000]);
fclose(fid2);

clear all;



