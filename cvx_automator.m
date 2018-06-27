filename = 'cvx_stats_new_constraints.csv';
% Number of outcomes and distribution
nout = 4;
P_ABC = get_dist('EJM');

% Iteration range
solvers = {'Mosek' 'SDPT3' 'SeDuMi', 'Gurobi'};
bases = {'full', 'CG', 'corr'};

% Output data file
headers = {'solver', 'basis', 'slack', 'cvx_cputime',...
    'cvx_status', 'primal opt', 'dual opt', 'gap',...
    'cvx_optbnd', 'cvx_slvitr', 'cvx_slvtol'};
data = headers;

for i = 1:length(solvers)
    cur_solver = solvers{i};
    if cur_solver == "Mosek"
        data = cvx_mosek_automator(data, bases, filename, nout, P_ABC);
    else
        cvx_solver(cur_solver);
        for j = 1:length(bases)
            cur_basis = bases{j};
            for slack = 0:1
                if slack == 1
                    slack_label = 'slack';
                else
                    slack_label = 'noslack';
                end
                diary(sprintf('outs/%s_%s_%s.txt',...
                    cur_solver, cur_basis, slack_label))
                stats = cvx_spiral(nout, P_ABC, cur_basis,slack);
                diary off;
                datarow = [{cur_solver},{cur_basis},{slack_label},stats];
                data = [data; datarow];
                cell2csv(filename, data);
            end
        end
    end
end
