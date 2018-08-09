verbose = 1;
use_interval = false;
start_point = 0; stop_point = 1; steps = 0;


solvers = {'mosek'};
basis = 'full';
slack = 'slack(z=x+t-1)'; slackcode = 3;
%slack = 'slack(z=x-t)'; slackcode = 1;
nout = 2;

for solver = solvers
    [ubs, lbs] = calc_vbounds(solver{1}, basis, slack, nout, start_point, stop_point, steps, verbose, use_interval);
end
 tmp = ubs - lbs;
 num_inf = sum(isinf(tmp))
 tmp = tmp(isfinite(tmp));
 average_gap = mean(tmp)