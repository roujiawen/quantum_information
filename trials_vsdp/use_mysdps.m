%--------random problem------------
% rng('default');
% rng(333);
% m = 20;
% n = 50;
% A = rand(m, n);
% b = rand(m, 1);
% c = rand(n, 1);
% K.l = n;

%---------cut inflation------------
[A, b, G, h] = get_cut_constraints('complete correlation', 'CG');

%---------spiral inflation------------
% nout = 2; % Number of outcomes
% P_ABC = get_dist('W-type');
% [A, b, G, h] = get_spiral_constraints(nout, P_ABC, 'CG_v2');

K = struct();
[m, n] = size(A);
K.l = n;
c = zeros(n,1);

vsdpinit('mosek');
%OPTIONS.MOSEK_OPTIONS = struct();
[objt xt yt zt info] = mysdps(A,b,c,K);
info

%[fL y dl] = vsdplow(A,b,c,K,xt,yt,zt);
%[fU x lb] = vsdpup(A,b,c,K,xt,yt,zt);
fprintf('\nPrimal obj: %f Dual obj: %f\n', full(dot(c,xt)), full(dot(b,yt)));


