nout = 4;
solver = 'Mosek_INTPNT';
slack = 3;

OPTIONS = struct();
%OPTIONS.MSK_IPAR_INTPNT_BASIS = 0;

% CVX FAILS:
%cvx_spiral(nout, get_dist('fail1'), solver, 'CG', slack);
%cvx_spiral(nout, get_dist('fail2'), solver, 'CG', slack);
%cvx_spiral(nout, get_dist('fail3'), solver, 'full', slack);
%cvx_spiral(nout, get_dist('500trials', [], 44), solver, 'CG', slack);
%cvx_spiral(nout, get_dist('500trials', [], 55), solver, 'CG', slack);%!!!
%cvx_spiral(nout, get_dist('500trials', [], 174), solver, 'CG', slack);%!!!
%cvx_spiral(nout, get_dist('500trials', [], 228), solver, 'cor', slack);

% VSDP ALSO FAILS:
OPTIONS.MOSEK_OPTIONS.MSK_IPAR_BI_MAX_ITERATIONS = 50000;
[objt,xt,yt,zt,info] = mysdps_spiral(nout, get_dist('fail1'), 'mosek', 'CG', slack, OPTIONS);

%OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 0;

%[objt1,xt1,yt1,zt1,info1] = mysdps_spiral(nout, get_dist('fail1'), 'mosek', 'CG', slack, OPTIONS);
% mysdps_spiral(nout, get_dist('fail3'), 'mosek', 'full', slack, OPTIONS);

% CVX FAILS BUT MOSEK DOESN'T:
%mysdps_spiral(nout, get_dist('fail2'), 'mosek', 'CG', slack, OPTIONS);


%%%%%%%%%%%%%MOSEK%%%%%%%%%%%%%%%%%
%sol = mosek_spiral(nout, get_dist('fail1'), 'full', slack)
