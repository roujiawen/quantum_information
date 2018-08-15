function [res, time] = mosek_wrapper(A, b, const_type)

if nargin < 3
    const_type = 'eq';
end
clear mosek_prob;
switch const_type
    case 'eq'
        % A * x = b
        % x > 0
        [m, n] = size(A);
        mosek_prob.c = zeros(n,1);
        mosek_prob.a = sparse(A);
        mosek_prob.blc = full(b);
        mosek_prob.buc = full(b);
        mosek_prob.blx = zeros(n,1);
        mosek_prob.bux = inf(n,1);
    case 'ineq'
        % A * x > b
        [m, n] = size(A);
        mosek_prob.c = zeros(n,1);
        mosek_prob.a = sparse(A);
        mosek_prob.blc = full(b);
        mosek_prob.buc = inf(m, 1);
        mosek_prob.blx = -inf(n,1);
        mosek_prob.bux = inf(n,1);
end

param = struct();
%-----------SOLVER-------------
%param.MSK_IPAR_INTPNT_BASIS = 0;
%param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_PRIMAL_SIMPLEX';

%-----------VERBOSE------------
param.MSK_IPAR_LOG = 0;

%-----------TOLERANCE------------
% tolerance = 0;
% param.MSK_DPAR_INTPNT_CO_TOL_PFEAS = tolerance;
% param.MSK_DPAR_INTPNT_CO_TOL_DFEAS = tolerance;
% param.MSK_DPAR_INTPNT_CO_TOL_REL_GAP = tolerance;
% param.MSK_DPAR_INTPNT_CO_TOL_INFEAS = tolerance;
% param.MSK_DPAR_INTPNT_CO_TOL_MU_RED = tolerance;
% param.MSK_DPAR_INTPNT_TOL_PFEAS = tolerance;
% param.MSK_DPAR_INTPNT_TOL_DFEAS = tolerance;
% param.MSK_DPAR_INTPNT_TOL_INFEAS = tolerance;
% param.MSK_DPAR_INTPNT_TOL_REL_GAP = tolerance; %max( 1e-14, tolerance)
tic;
[rcode, res] = mosekopt('minimize info', mosek_prob, param);
time = toc;

% x = res.sol.itr.xx;
% if ~isempty(x)
%     y = res.sol.itr.y;
%     z = c - A*y;
%     obj(1) = c'*x;
%     obj(2) = b'*y;
% end
% if (res.sol.itr.solsta == 1) && (res.sol.itr.prosta == 1)
%     info = 0;
% else
%     info = -1;
% end

% Interior-point solution.

% sol.itr.xx'      % x solution.
% sol.itr.sux'     % Dual variables corresponding to buc.
% sol.itr.slx'     % Dual variables corresponding to blx.

% Basic solution.

%sol.bas.xx'      % x solution in basic solution.

%[x,tmp,flag,tmp,lambda] = linprog(full(c),[],[],A',full(b),zeros(length(c),1),inf(length(c),1));
end