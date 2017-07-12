diffeoFile = spm_select(1, '^y_.*nii$', 'choose a deformation file');
[Def, mat] = get_def(diffeoFile);

J = spm_diffeo('def2jac', Def);

F_temp = reshape(J(8, 8 ,1, :), 3, []);

F = F_temp + eye(3);

F = pinv(F);
R = sqrtm(F*F')\F;  %FS method