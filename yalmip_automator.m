% Number of outcomes and distribution
nout = 4;
P_ABC = get_dist('EJM');

% Iteration range
solvers = {'Mosek' 'SDPT3' 'SeDuMi', 'Gurobi', 'linprog'};
bases = {'full', 'CG', 'corr'};

% Output data file
headers = {'solver', 'basis', 'slack', 'yalmiptime', 'solvertime',...
    'error', 'info', 'primal_opt', 'dual_opt', 'gap'};
data = headers;

for i = 1:length(solvers)
    solver = solvers{i};
    for j = 1:length(bases)
        basis = bases{j};
        for slack = 0:1
            if slack == 1
                slack_label = 'slack';
            else
                slack_label = 'noslack';
            end
            % Save command window output to .txt file
            diary(sprintf('outs/Yalmip_%s_%s_%s.txt',...
                solver, basis, slack_label))
            % Call optimization function
            [stats, solveroutput] = yalmip_spiral(nout, P_ABC,...
                                  solver, basis, slack);
            diary off;
            % Save solverouput to .mat file
            save(sprintf('outs/YmpSlvOut_%s_%s_%s.mat',...
                solver, basis, slack_label), 'solveroutput');
            % Add data row to master table
            datarow = [{solver},{basis},{slack_label}, stats];
            data = [data; datarow];
            % Update master table to .csv file
            cell2csv('stats_yalmip_spiral_out4.csv', data);
        end
    end
end
