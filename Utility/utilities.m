angle_diff = @(a,b) mod((a-b) + 180, 360)-180;
mld = @(A,B) ([A ones(size(A,1),1)])\B;
mld_noIC = @(A,B) (A)\B;

%ang below shoud be in angle, not radius (pi)
cirM1 = @(ang) mean(exp(1i*(ang/180*pi)));
cirMean = @(ang) angle(cirM1(ang))/pi*180;
cirStd = @(ang) sqrt(-2*log(abs(cirM1(ang))))/pi*180;

r_to_z = @(r) .5*(log(1+r)-log(1-r));
z_to_r = @(z) (exp(2*z)-1) ./ (exp(2*z)+1);


