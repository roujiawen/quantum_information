%% Params
verbose = 0;
use_interval = true;
solvers = {'mosek' 'mosek_INTPNT_ONLY' 'sedumi' 'sdpt3'};
basis = 'CG_red';
slack = 'slack(z=x+t-1)'; slackcode = 3;
%slack = 'slack(z=x-t)'; slackcode = 1;

nout = 5;
dist_A = low2high_dist('W-type', nout, use_interval, 0);%infea
dist_B = low2high_dist('uniform', nout, use_interval, 0);%fea

%dist_A = [];dist_B = [];

%start_point = 0.035;
%stop_point =  0.045;

%start_point = 0.05276;
%stop_point =  0.05277;

%start_point = 0.3333333;
%stop_point =  0.33333336;

start_point = 0.065;stop_point =  0.075;
%start_point = 0.0573;stop_point =  0.05732;%nout4
%start_point = 0.057352;stop_point =  0.057353;%nout3

steps = 10;

%% I/O
dt = datestr(datetime('now'), 'mmm-dd-yyyy_HH.MM');
results_path = sprintf('results/slack%d_%s_%s.mat', slackcode, basis, dt);

data = struct();
data.start_point = start_point; data.stop_point = stop_point;
data.steps = steps; data.nout = nout; data.basis = basis;
data.slack = slack;

%% Trials
for solver = solvers
    lbs =calc_lbound(nout, dist_A, dist_B, solver{1}, basis, slack, start_point, stop_point, steps, verbose, use_interval);
    if slackcode == 3
        data.([solver{1} '_lbs']) = lbs - 1;
    else
        data.([solver{1} '_lbs']) = lbs;
    end
end

save(results_path, 'data');


%% Call plotting function
lb_plot(results_path);
