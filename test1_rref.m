% Compare five formulations
% Using default Mosek solver
% No slack
test_data_path = 'logs/mid_ver_fea_test_cases_v1.mat';
load(test_data_path);
ntrials = size(test_cases, 2);

%% I/O
results_data_path = 'results/test1_fea_sparse';

% Output data file
headers = {'const_type', 'basis', 'trial',...
    'time', 'itr.prosta', 'itr.solsta', 'itr.pobjval', 'itr.dobjval',...
    'bas.prosta', 'bas.solsta', 'bas.pobjval', 'bas.dobjval',...
    'MSK_DINF_BI_CLEAN_DUAL_TIME', 'MSK_DINF_BI_CLEAN_PRIMAL_TIME',...
    'MSK_DINF_BI_CLEAN_TIME', 'MSK_DINF_BI_DUAL_TIME',...
    'MSK_DINF_BI_PRIMAL_TIME', 'MSK_DINF_BI_TIME',...
    'MSK_DINF_INTPNT_TIME', 'MSK_DINF_OPTIMIZER_TIME',...
    'MSK_DINF_PRESOLVE_ELI_TIME', 'MSK_DINF_PRESOLVE_LINDEP_TIME',...
    'MSK_DINF_PRESOLVE_TIME'};
data = headers;

for k = 1:ntrials
    P_ABC = test_cases(:,k);% No intervals
    for const_type_tmp = {'eq'}
        for basis_tmp = {'full', 'rref_full', 'CG'}
            const_type = const_type_tmp{1};
            basis = basis_tmp{1};
if ~(strcmp(const_type, 'ineq') && (strcmp(basis, 'full')))
    fprintf('%d %s %s\n', k, const_type, basis);
    [constraint_A, constraint_b] = get_spiral_form(const_type, basis, P_ABC);
    [res, time] = mosek_wrapper(constraint_A, constraint_b, const_type);
    sol = res.sol;
    info = res.info;
    % Add data row to master table
    datarow = {const_type, basis, k, time, ...
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
end


%%
% Compare five formulations
% Using default Mosek solver
% No slack
test_data_path = 'logs/mid_ver_infea_test_cases_v1.mat';
load(test_data_path);
ntrials = size(test_cases, 2);

%% I/O
results_data_path = 'results/test1_infea';

% Output data file
headers = {'const_type', 'basis', 'trial',...
    'time', 'itr.prosta', 'itr.solsta', 'itr.pobjval', 'itr.dobjval',...
    'bas.prosta', 'bas.solsta', 'bas.pobjval', 'bas.dobjval',...
    'MSK_DINF_BI_CLEAN_DUAL_TIME', 'MSK_DINF_BI_CLEAN_PRIMAL_TIME',...
    'MSK_DINF_BI_CLEAN_TIME', 'MSK_DINF_BI_DUAL_TIME',...
    'MSK_DINF_BI_PRIMAL_TIME', 'MSK_DINF_BI_TIME',...
    'MSK_DINF_INTPNT_TIME', 'MSK_DINF_OPTIMIZER_TIME',...
    'MSK_DINF_PRESOLVE_ELI_TIME', 'MSK_DINF_PRESOLVE_LINDEP_TIME',...
    'MSK_DINF_PRESOLVE_TIME'};
data = headers;

for k = 1:ntrials
    P_ABC = test_cases(:,k);% No intervals
    for const_type_tmp = {'eq', 'ineq'}
        for basis_tmp = {'full', 'CG', 'corr'}
            const_type = const_type_tmp{1};
            basis = basis_tmp{1};
if ~(strcmp(const_type, 'ineq') && (strcmp(basis, 'full')))
    fprintf('%d %s %s\n', k, const_type, basis);
    [constraint_A, constraint_b] = get_spiral_form(const_type, basis, P_ABC);
    [res, time] = mosek_wrapper(constraint_A, constraint_b, const_type);
    sol = res.sol;
    info = res.info;
    % Add data row to master table
    datarow = {const_type, basis, k, time, ...
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
end

