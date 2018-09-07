%% Test grid
const_type = 'eq';
basis = 'full';
solvers = {'mosek_INTPNT', 'mosek_INTPNT+BI',...
           'mosek_PRIMAL_SIMPLEX', 'mosek_DUAL_SIMPLEX',...
           'sdpt3', 'sedumi', 'linprog',...
           'gurobi_PRIMAL_SIMPLEX', 'gurobi_DUAL_SIMPLEX', 'gurobi_BARRIER'};
slacks = {'slack(z=x-t)', 'slack(z=x+t-1)'};
use_xu = true;
%% I/O
test_data_path = 'logs/mid_ver_infea_test_cases_v1.mat';
load(test_data_path);
ntrials = size(test_cases, 2);
results_data_path = 'results/test3_infea_full_xu_low_test';

% Output data file
headers = {'trial', 'slack', 'solver',...
    'verified_lower', 'verified_upper', 'mysdps_time', ...
    'vsdplow_time', 'vsdplow_iter', ...
	'vsdpup_time', 'vsdpup_iter'};
data = headers;

%% Trials
for k = 1:ntrials
    P_ABC = test_cases(:,k);% No intervals
    for slack_tmp = slacks
        for solver_tmp = solvers
            slack = slack_tmp{1};
            solver = solver_tmp{1};
% Print progress
fprintf('%d %s %s\n', k, slack, solver);
% Get basis formulation and slack formulation
[constraint_A, constraint_b] = get_spiral_form(const_type, basis, P_ABC);
[A, b, c, K] = get_slack_vsdp_form(constraint_A, constraint_b, slack);
% Run VSDP wrapper
[verified_lower, verified_upper, stats] = vsdp_wrapper(A, b, c, K, solver, 0, [], use_xu);
% Add data row to master table
datarow = {k, slack, solver, ...
    verified_lower, verified_upper,stats.mysdps_time, ...
    stats.vsdplow_time, stats.vsdplow_iter, ...
	stats.vsdpup_time, stats.vsdpup_iter};
data = [data; datarow];
% Update master table to .csv file and .mat file
cell2csv(strcat(results_data_path, '.csv'), data);
save(results_data_path, 'data');          
            
        end
    end
end

