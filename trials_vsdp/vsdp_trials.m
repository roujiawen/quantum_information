%% Params
verbose = 0;
use_interval = true;
solvers = {'mosek' 'sedumi' 'sdpt3'};
basis = 'CG_red';
slack = 'slack(z=x+t-1)'; slackcode = 3;
%slack = 'slack(z=x-t)'; slackcode = 1;

nout = 4;
dist_A = low2high_dist('W-type', 4, use_interval, 0);%infea
dist_B = get_dist('EJM', use_interval);%fea

start_point = 0.035;
stop_point =  0.045;

% start_point = 0.005;
% stop_point =  0.006;

% start_point = 0.3333333;
% stop_point =  0.3333336;

steps = 5;

%% I/O
dt = datestr(datetime('now'), 'mmm-dd-yyyy_HH.MM');
results_path = sprintf('results/slack%d_%s_%s.mat', slackcode, basis, dt);

data = struct();
data.start_point = start_point; data.stop_point = stop_point;
data.steps = steps; data.nout = nout; data.basis = basis;
data.slack = slack;

%% Trials
for solver = solvers
    [ubs, lbs] =calc_vbounds(nout, dist_A, dist_B, solver{1}, basis, slack, start_point, stop_point, steps, verbose, use_interval);
    if slackcode == 3
        data.([solver{1} '_ubs']) = ubs - 1;
        data.([solver{1} '_lbs']) = lbs - 1;
    else
        data.([solver{1} '_ubs']) = ubs;
        data.([solver{1} '_lbs']) = lbs;
    end
end

save(results_path, 'data');


%% Call plotting function
vsdp_plot(results_path);
