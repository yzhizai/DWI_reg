function wMat_resample_based_Def_demo
% For the reason of spm normalize write couldn't deal with the 4D image, so
% I write this function to compensate it.
filename = spm_select(1, 'nii');

diffeofile = spm_select(1, 'nii', 'choose the deformation field');

VF = spm_vol(filename);
[Y_reg, mat] = resample_based_deform(VF, diffeofile);

fname = inputdlg({'Output file name'}, 'Specified filename');
fname = fname{1};

ni = nifti;
ni.dat = file_array(fname, size(Y_reg), [spm_type('float32'), spm_platform('bigend')]);
ni.mat = mat;
ni.mat0 = mat;

create(ni);

for bb = 1:size(ni.dat, 4)
    ni.dat(:, :, :, bb) = Y_reg(:, :, :, bb);
end
