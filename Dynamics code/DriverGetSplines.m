function [spl, spl_d, spl_dd] = DriverGetSplines(driver_info)

t = driver_info(:,1);
dof = driver_info(:,2);

spl = spline(t,dof);

NPieces = spl.pieces;
coefs_d  = zeros(NPieces,3);
coefs_dd = zeros(NPieces,2);

for k = 1:NPieces
    coefs_d(k,:) = polyder(spl.coefs(k,:));
end
spl_d = mkpp(t,coefs_d);

for k = 1:NPieces
    coefs_dd(k,:) = polyder(spl_d.coefs(k,:));
end
spl_dd = mkpp(t,coefs_dd);

end