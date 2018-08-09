
%-------------- toy problem ---------------------
% c     = [3 1 5 1]';
% a     = sparse([[3 1 2 0];[2 1 3 1];[0 2 0 3]]);
% blc   = [30 15  -inf]';
% buc   = [30 inf 25 ]';
% blx   = zeros(4,1);
% bux   = [inf 10 inf inf]';

%-------------- random problem ---------------------
% rng('default');
% rng(333);
% m = 20;
% n = 50;
% A = rand(m, n);
% b = rand(m, 1);
% c = rand(n, 1);
% K.l = n;
% A = A';

%-------------- cut inflation ---------------------
[A, b, G, h] = get_cut_constraints('anti-correlation', 'CG');
[m, n] = size(A);
K.l = n;
c = zeros(n,1);
A = A';


clear mosek_prob;
mosek_prob.c = full(c);
mosek_prob.a = sparse(A)';
mosek_prob.blc = full(b);
mosek_prob.buc = full(b);
mosek_prob.blx = zeros(length(c),1);
mosek_prob.bux = inf(length(c),1);
param = struct();
%param.MSK_IPAR_LOG = 0;
tolerance = 0;

param.MSK_DPAR_INTPNT_CO_TOL_PFEAS = tolerance;
param.MSK_DPAR_INTPNT_CO_TOL_DFEAS = tolerance;
param.MSK_DPAR_INTPNT_CO_TOL_REL_GAP = tolerance;
param.MSK_DPAR_INTPNT_CO_TOL_INFEAS = tolerance;
param.MSK_DPAR_INTPNT_CO_TOL_MU_RED = tolerance;
param.MSK_DPAR_INTPNT_TOL_PFEAS = tolerance;
param.MSK_DPAR_INTPNT_TOL_DFEAS = tolerance;
param.MSK_DPAR_INTPNT_TOL_INFEAS = tolerance;
%param.MSK_DPAR_INTPNT_TOL_REL_GAP = tolerance; %max( 1e-14, tolerance)

[r, res] = mosekopt('minimize', mosek_prob, param);
sol   = res.sol;
sol.itr.solsta

% Interior-point solution.

% sol.itr.xx'      % x solution.
% sol.itr.sux'     % Dual variables corresponding to buc.
% sol.itr.slx'     % Dual variables corresponding to blx.

% Basic solution.

%sol.bas.xx'      % x solution in basic solution.

%[x,tmp,flag,tmp,lambda] = linprog(full(c),[],[],A',full(b),zeros(length(c),1),inf(length(c),1));
    