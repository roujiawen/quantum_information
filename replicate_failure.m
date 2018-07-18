nout = 4;
solver = 'MSK_OPTIMIZER_INTPNT';
slack = 3;


cvx_spiral(4, get_dist('fail1'), solver, 'full', 3);
%cvx_spiral(4, get_dist('fail2'), solver, 'CG', 3);
%cvx_spiral(4, get_dist('fail3'), solver, 'full', 3);