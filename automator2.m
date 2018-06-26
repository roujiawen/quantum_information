cur_solver = 'Mosek';
optimizers = {'MSK_OPTIMIZER_INTPNT', ...
    'MSK_OPTIMIZER_PRIMAL_SIMPLEX', ...
    'MSK_OPTIMIZER_DUAL_SIMPLEX'};
bases = {'full', 'CG', 'corr'};

headers = {'solver', 'basis', 'slack', 'cvx_cputime',...
    'cvx_status', 'primal opt', 'dual opt', 'gap',...
    'cvx_optbnd', 'cvx_slvitr', 'cvx_slvtol'};
data = headers;

for i = 1:length(optimizers)
    cvx_solver(cur_solver);
    cur_optimizer = optimizers{i};
    cvx_solver_settings('MSK_IPAR_OPTIMIZER',cur_optimizer);
    cur_solver_optimizer = strcat(cur_solver, extractAfter(cur_optimizer,13));
    for j = 1:length(bases)
        cur_basis = bases{j};
        for slack = 0:1
            if slack == 1
                slack_label = 'slack';
            else
                slack_label = 'noslack';
            end
            diary(sprintf('outs/%s_%s_%s.txt',...
                cur_solver_optimizer, cur_basis, slack_label))
            stats = spiral_out4(cur_basis,slack);
            diary off;
            datarow = [{cur_solver_optimizer},{cur_basis},{slack_label},stats];
            data = [data; datarow];
            cell2csv('stats_mosek.csv', data);
        end
    end
end
