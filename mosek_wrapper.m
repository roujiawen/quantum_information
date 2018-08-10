function mosek_wrapper(A, b, const_type)

if nargin < 3
    const_type = 'eq';
end
clear mosek_prob;
clear K;
switch const_type
    case 'eq'
        % A * x = b
        % x > 0
        [m, n] = size(A);
        K.l = n;
        c = zeros(n,1);
        
        mosek_prob.c = full(c);
        mosek_prob.a = sparse(A);
        mosek_prob.blc = full(b);
        mosek_prob.buc = full(b);
        mosek_prob.blx = zeros(n,1);
        mosek_prob.bux = inf(n,1);
    case 'ineq'
        % A * x > b
        [m, n] = size(A);
        K.f = n;
        c = zeros(n,1);
        
        mosek_prob.c = full(c);
        mosek_prob.a = sparse(A);
        mosek_prob.blc = full(b);
        mosek_prob.buc = inf(m, 1);
        mosek_prob.blx = -inf(n,1);
        mosek_prob.bux = inf(n,1);
end





param = struct();

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

[r, res] = mosekopt('minimize', mosek_prob, param);
sol   = res.sol;
disp([sol.itr.solsta '   ' sol.itr.prosta]);

% Interior-point solution.

% sol.itr.xx'      % x solution.
% sol.itr.sux'     % Dual variables corresponding to buc.
% sol.itr.slx'     % Dual variables corresponding to blx.

% Basic solution.

%sol.bas.xx'      % x solution in basic solution.

%[x,tmp,flag,tmp,lambda] = linprog(full(c),[],[],A',full(b),zeros(length(c),1),inf(length(c),1));
end