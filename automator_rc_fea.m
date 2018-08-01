%% I/O
test_name = 'rand_fea_500trials';
init_dist = 'anti-correlation';

test_data_path = sprintf('logs/test_data_%s', test_name);
results_data_path = sprintf('results/%s', test_name);

% Output data file
headers = {'num_outcomes', 'solver', 'basis', 'slack', 'trial',...
    'cvx_cputime', 'cvx_status', 'primal opt', 'dual opt', 'gap',...
    'cvx_optbnd', 'cvx_slvitr', 'cvx_slvtol'};
data = headers;

%% Test grid
solvers = {'Mosek_INTPNT', 'Mosek_INTPNT_ONLY', ...
    'Mosek_PRIMAL_SIMPLEX', 'Mosek_DUAL_SIMPLEX', ...
    'Gurobi'};%SDPT3 SeDuMi
bases = {'full', 'CG', 'CG_red', 'corr', 'corr_red'};
slack_types = {'noslack', 'slack(x>=t)', 'slack(x=y-t+1)'};
ntrials = 500;

%% Continue on disrupted results
if exist(strcat(results_data_path, '.mat'), 'file')
    disp('Found existing test results; continuing the test');
    load(results_data_path, 'data');
    start_from = size(data, 1)-1;
else
    disp('No existing test results found; starting from the beginning');
    start_from = 0;
end
pause(1);
counter = 0;

%%
for nout = 4:4
    if exist(strcat(test_data_path,'.mat'), 'file')
        % Load test data
        disp('Found existing test data; loading data');
        load(test_data_path, 'test_data')
    else
        % Create test data
        disp('No existing test data found; creating new data');
        test_data = zeros(nout^3, ntrials);
        for trial = 1:ntrials
            test_dist = low2high_dist(init_dist, nout);
            test_data(:,trial) = test_dist;
        end
        % Save test data
        save(test_data_path, 'test_data');
    end
    pause(1);
    
    for trial = 1:ntrials
        for k1 = 1:length(solvers)
            solver = solvers{k1};
            for k2 = 1:length(bases)
                basis = bases{k2};
                fprintf('outcome=%d   trial=%d   solver=%s   basis=%s\n', nout, trial, solver, basis);
                for k3 = 1:length(slack_types)
                    counter = counter+1;
                    if counter > start_from
                        slack = slack_types{k3};
                        % trials
                        test_dist = test_data(:,trial);
                        [stats, solution] = cvx_spiral_quiet(nout, test_dist, solver, basis, slack);
                        % Add data row to master table
                        datarow = [{nout},{solver},{basis},{slack},{trial},stats];
                        data = [data; datarow];
                        % Update master table to .csv file and .mat file
                        %cell2csv(strcat(results_data_path, '.csv'), data);
                        save(results_data_path, 'data');
                    end
                end
            end
        end
    end
end

