Y = SH_mat_matrix_real;

phi = linspace(0, 2*pi, 100);
theta = linspace(0, pi, 100);

[phi_m, theta_m] = meshgrid(phi, theta);

AA = map({theta_m, phi_m}, Y, 'UniformOutput', false);

%%
clf
for aa = 1:16
rho = AA{aa};
r = rho.*sin(theta_m);
x = r.*cos(phi_m);  % spherical coordinate equations
y = r.*sin(phi_m);
z = rho.*cos(theta_m);

subplot(4, 4, aa)
surf(x,y,z)
light
lighting phong
axis tight equal off
view(0, 0)
camzoom(1.5)
end

