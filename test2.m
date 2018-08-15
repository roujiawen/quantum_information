% Compare noslack vs. slack
const_type = 'eq';

%% Mosek OPTIONS
param = struct();
param.MSK_IPAR_BI_MAX_ITERATIONS = 100000;
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
% param.MSK_DPAR_INTPNT_TOL_REL_GAP = max( 1e-14, tolerance);


%% I/O
test_data_path = 'logs/mid_ver_infea_test_cases_v1.mat';
load(test_data_path);
ntrials = size(test_cases, 2);
results_data_path = 'results/test2_infea';

% Output data file
headers = {'basis', 'slack', 'trial',...
    'time', 'itr.prosta', 'itr.solsta', 'itr.pobjval', 'itr.dobjval',...
    'bas.prosta', 'bas.solsta', 'bas.pobjval', 'bas.dobjval',...
    'MSK_DINF_BI_CLEAN_DUAL_TIME', 'MSK_DINF_BI_CLEAN_PRIMAL_TIME',...
    'MSK_DINF_BI_CLEAN_TIME', 'MSK_DINF_BI_DUAL_TIME',...
    'MSK_DINF_BI_PRIMAL_TIME', 'MSK_DINF_BI_TIME',...
    'MSK_DINF_INTPNT_TIME', 'MSK_DINF_OPTIMIZER_TIME',...
    'MSK_DINF_PRESOLVE_ELI_TIME', 'MSK_DINF_PRESOLVE_LINDEP_TIME',...
    'MSK_DINF_PRESOLVE_TIME'};
data = headers;

%% Trials
for k = 1:ntrials
    P_ABC = test_cases(:,k);% No intervals
    for basis_tmp = {'full', 'CG'}
        for slack_tmp = {'noslack', 'slack(z=x-t)', 'slack(z=x+t-1)'}
            slack = slack_tmp{1};
            basis = basis_tmp{1};
% Print progress
fprintf('%d %s %s\n', k, basis, slack);
% Get basis formulation and slack formulation
[constraint_A, constraint_b] = get_spiral_form(const_type, basis, P_ABC);
mosek_prob = get_slack_mosek_form(constraint_A, constraint_b, slack);
% Run Mosek with timer
tic;
[rcode, res] = mosekopt('minimize info', mosek_prob, param);
time = toc;
sol = res.sol;
info = res.info;
% Add data row to master table
datarow = {basis, slack, k, time, ...
    sol.itr.prosta,sol.itr.solsta,sol.itr.pobjval, sol.itr.dobjval,...
    sol.bas.prosta, sol.bas.solsta, sol.bas.pobjval, sol.bas.dobjval,...
    info.MSK_DINF_BI_CLEAN_DUAL_TIME, info.MSK_DINF_BI_CLEAN_PRIMAL_TIME,...
    info.MSK_DINF_BI_CLEAN_TIME, info.MSK_DINF_BI_DUAL_TIME,...
    info.MSK_DINF_BI_PRIMAL_TIME, info.MSK_DINF_BI_TIME,...
    info.MSK_DINF_INTPNT_TIME, info.MSK_DINF_OPTIMIZER_TIME,...
    info.MSK_DINF_PRESOLVE_ELI_TIME, info.MSK_DINF_PRESOLVE_LINDEP_TIME,...
    info.MSK_DINF_PRESOLVE_TIME};
data = [data; datarow];
% Update master table to .csv file and .mat file
%cell2csv(strcat(results_data_path, '.csv'), data);
save(results_data_path, 'data');
        end
    end
end

%%
% Compare noslack vs. slack
const_type = 'eq';

%% Mosek OPTIONS
param = struct();
param.MSK_IPAR_BI_MAX_ITERATIONS = 100000;
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
% param.MSK_DPAR_INTPNT_TOL_REL_GAP = max( 1e-14, tolerance);


%% I/O
test_data_path = 'logs/mid_ver_fea_test_cases_v1.mat';
load(test_data_path);
ntrials = size(test_cases, 2);
results_data_path = 'results/test2_fea';

% Output data file
headers = {'basis', 'slack', 'trial',...
    'time', 'itr.prosta', 'itr.solsta', 'itr.pobjval', 'itr.dobjval',...
    'bas.prosta', 'bas.solsta', 'bas.pobjval', 'bas.dobjval',...
    'MSK_DINF_BI_CLEAN_DUAL_TIME', 'MSK_DINF_BI_CLEAN_PRIMAL_TIME',...
    'MSK_DINF_BI_CLEAN_TIME', 'MSK_DINF_BI_DUAL_TIME',...
    'MSK_DINF_BI_PRIMAL_TIME', 'MSK_DINF_BI_TIME',...
    'MSK_DINF_INTPNT_TIME', 'MSK_DINF_OPTIMIZER_TIME',...
    'MSK_DINF_PRESOLVE_ELI_TIME', 'MSK_DINF_PRESOLVE_LINDEP_TIME',...
    'MSK_DINF_PRESOLVE_TIME'};
data = headers;

%% Trials
for k = 1:ntrials
    P_ABC = test_cases(:,k);% No intervals
    for basis_tmp = {'full', 'CG'}
        for slack_tmp = {'noslack', 'slack(z=x-t)', 'slack(z=x+t-1)'}
            slack = slack_tmp{1};
            basis = basis_tmp{1};
% Print progress
fprintf('%d %s %s\n', k, basis, slack);
% Get basis formulation and slack formulation
[constraint_A, constraint_b] = get_spiral_form(const_type, basis, P_ABC);
mosek_prob = get_slack_mosek_form(constraint_A, constraint_b, slack);
% Run Mosek with timer
tic;
[rcode, res] = mosekopt('minimize info', mosek_prob, param);
time = toc;
sol = res.sol;
info = res.info;
% Add data row to master table
datarow = {basis, slack, k, time, ...
    sol.itr.prosta,sol.itr.solsta,sol.itr.pobjval, sol.itr.dobjval,...
    sol.bas.prosta, sol.bas.solsta, sol.bas.pobjval, sol.bas.dobjval,...
    info.MSK_DINF_BI_CLEAN_DUAL_TIME, info.MSK_DINF_BI_CLEAN_PRIMAL_TIME,...
    info.MSK_DINF_BI_CLEAN_TIME, info.MSK_DINF_BI_DUAL_TIME,...
    info.MSK_DINF_BI_PRIMAL_TIME, info.MSK_DINF_BI_TIME,...
    info.MSK_DINF_INTPNT_TIME, info.MSK_DINF_OPTIMIZER_TIME,...
    info.MSK_DINF_PRESOLVE_ELI_TIME, info.MSK_DINF_PRESOLVE_LINDEP_TIME,...
    info.MSK_DINF_PRESOLVE_TIME};
data = [data; datarow];
% Update master table to .csv file and .mat file
%cell2csv(strcat(results_data_path, '.csv'), data);
save(results_data_path, 'data');
        end
    end
end

