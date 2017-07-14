function R = jac2R(Jx)

Jmat = reshape(Jx, 3, 3);
F = Jmat + eye(3);

R = sqrtm(F*F')\F;