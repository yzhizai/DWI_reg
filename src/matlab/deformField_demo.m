function deformField_demo

% choose an image in target space
filename      = spm_select(1, 'nii');
V             = spm_vol(filename);
% Aff_init      = rotationVectorToMatrix(pi/12*[0, 0, 1]);
% Aff           = eye(4);
% Aff(1:3, 1:3) = Aff_init;
Aff = eye(4, 4);
Aff(1, 2) = 0.5;
deformField(Aff, V(1));

