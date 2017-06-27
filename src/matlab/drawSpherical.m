Y = SH_mat_matrix_real;

phi = linspace(0, 2*pi, 100);
theta = linspace(0, pi, 100);

[phi_m, theta_m] = meshgrid(phi, theta);

AA = map({theta_m, phi_m}, Y, 'UniformOutput', false);

%% To draw the ODFs for the simulated data.
SHfile = spm_select(1, 'nii');
coefMat = spm_read_vols(spm_vol(SHfile));

clf
for bb = 1:16
    for cc = 1:16
        coef1 = reshape(coefMat(cc, bb, 1, :), [], 1);
        rho = zeros(size(phi_m));
        for aa = 1:numel(coef1)
            rho = rho + coef1(aa) * AA{aa};
        end
        r = rho.*sin(theta_m);
        x = r.*cos(phi_m);  % spherical coordinate equations
        y = r.*sin(phi_m);
        z = rho.*cos(theta_m);
        subplot(16, 16, (bb-1)*16 + cc)
        surf(x,y,z)
        axis tight equal off
        view([0, 0, 1])
    end
end

%% This is the test part.
% clf
% figure
% for bb = 6:7
%     for cc = 2
%         coef1 = reshape(coefMat(cc, bb, 1, :), [], 1);
%         rho = zeros(size(phi_m));
%         for aa = 1:numel(coef1)
%             rho = rho + coef1(aa) * AA{aa};
%         end
%         r = rho.*sin(theta_m);
%         x = r.*cos(phi_m);  % spherical coordinate equations
%         y = r.*sin(phi_m);
%         z = rho.*cos(theta_m);
%         surf(x,y,z)
%         axis tight equal
%         view([0, 0, 1])
%     end
% end

clear all;