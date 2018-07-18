test_name = 'rand_infea_100trials';
solvers = {'MSK_OPTIMIZER_INTPNT',...
    'MSK_OPTIMIZER_PRIMAL_SIMPLEX', ... 
    'MSK_OPTIMIZER_DUAL_SIMPLEX'};%SDPT3 SeDuMi Gurobi
bases = {'full', 'CG', 'corr'};
slack_states = {'noslack', 'slack_v1(x>=t)', 'slack_v2(|t|<=1)', 'slack_v3(x=y-t+1)'};
ntrials = 100;

% Output data file
headers = {'num_outcomes', 'solver', 'basis', 'slack', 'trial',...
    'cvx_cputime', 'cvx_status', 'primal opt', 'dual opt', 'gap',...
    'cvx_optbnd', 'cvx_slvitr', 'cvx_slvtol'};
data = headers;

for h_out = 4:4
    % Create test data
    test_data = zeros(h_out^3, ntrials);
    for trial = 1:ntrials
        h_dist = low2high_dist('W-type', h_out);
        test_data(:,trial) = h_dist;
    end
    % Save test data
    save(sprintf('logs/test_data_%s', test_name), 'test_data');
    % Load test data
%     load(sprintf('logs/test_data_%s.mat', test_name), 'test_data')
    for trial = 1:ntrials
        for k1 = 1:length(solvers)
            solver = solvers{k1};
            for k2 = 1:length(bases)
                basis = bases{k2};
                for k3 = 0:3
                    slack = slack_states{k3+1};
                
                    % trials
                    h_dist = test_data(:,trial);
                    [stats, solution] = cvx_spiral(h_out, h_dist, solver, basis, k3);
                    % Add data row to master table
                    datarow = [{h_out},{solver},{basis},{slack},{trial},stats];
                    data = [data; datarow];
                    % Update master table to .csv file and .mat file
                    cell2csv(sprintf('results/%s.csv', test_name), data);
                    save(sprintf('results/%s', test_name), 'data');
                end
            end
        end
    end
end
                
                


