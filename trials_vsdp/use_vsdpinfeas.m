%--------------General form---------------
% [A, b, G, h] = get_cut_constraints('complete correlation');
% n = size(A,2);
% c = zeros(n,1);
% K.l = n;

rng('default');
rng(333);
m = 5;
n = 5;
A = sparse(rand(m, n));
b = rand(m, 1);
c = rand(n, 1);
K.l = n;

vsdpinit('mosek');
OPTIONS.MOSEK_OPTIONS = struct();
[objt xt yt zt info] = mysdps(A,b,c,K,[], [], [], OPTIONS);

objt
info