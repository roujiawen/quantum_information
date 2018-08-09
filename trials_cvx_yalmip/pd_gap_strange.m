% NEGATIVE
%-2.220446049250313e-16
cvx_spiral(2, get_dist('W-type'), 'mosek', 'corr_red', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_PRIMAL_SIMPLEX', 'CG_red', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_DUAL_SIMPLEX', 'corr_red', 3);
cvx_spiral(2, get_dist('complete correlation'), 'mosek', 'CG', 3);
cvx_spiral(2, get_dist('W-type'), 'sedumi', 'corr', 3);
%-4.044031776118118e-11
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_PRIMAL_SIMPLEX', 'corr', 3);
%-4.440892098500626e-16
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_PRIMAL_SIMPLEX', 'corr_red', 3);
%-1.554312234475219e-15
cvx_spiral(2, get_dist('complete correlation'), 'mosek', 'CG_red', 3);


% ZERO
cvx_spiral(2, get_dist('W-type'), 'mosek', 'corr', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_DUAL_SIMPLEX', 'full', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_DUAL_SIMPLEX', 'corr', 3);
cvx_spiral(2, get_dist('complete correlation'), 'mosek', 'corr', 3);


% POSITIVE
%2.220446049250313e-16
cvx_spiral(2, get_dist('W-type'), 'mosek', 'full', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_PRIMAL_SIMPLEX', 'full', 3);
cvx_spiral(2, get_dist('complete correlation'), 'mosek', 'corr_red', 3);
cvx_spiral(2, get_dist('complete correlation'), 'mosek', 'full', 3);
%1.110223024625157e-15
cvx_spiral(2, get_dist('W-type'), 'mosek', 'CG', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_DUAL_SIMPLEX', 'CG', 3);
%4.440892098500626e-16
cvx_spiral(2, get_dist('W-type'), 'mosek', 'CG_red', 3);
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_DUAL_SIMPLEX', 'CG_red', 3);
%6.661338147750939e-16
cvx_spiral(2, get_dist('W-type'), 'MSK_OPTIMIZER_PRIMAL_SIMPLEX', 'CG', 3);

'SDPT3'

% SeDuMi
cvx_spiral(2, get_dist('complete correlation'), 'sedumi', 'CG_red', 3);
cvx_spiral(2, get_dist('W-type'), 'sedumi', 'full', 3);
cvx_spiral(2, get_dist('W-type'), 'sedumi', 'CG', 3);
cvx_spiral(2, get_dist('W-type'), 'sedumi', 'CG_red', 3);