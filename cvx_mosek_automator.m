function data = cvx_mosek_automator(data, bases, filename, nout, P_ABC)
cur_solver = 'Mosek';
optimizers = {'MSK_OPTIMIZER_INTPNT', ...
    'MSK_OPTIMIZER_PRIMAL_SIMPLEX', ...
    'MSK_OPTIMIZER_DUAL_SIMPLEX'};

for i = 1:length(optimizers)
    cur_optimizer = optimizers{i};
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
            stats = cvx_spiral(nout, P_ABC, cur_solver, cur_basis,slack, cur_optimizer);
            diary off;
            datarow = [{cur_solver_optimizer},{cur_basis},{slack_label},stats];
            data = [data; datarow];
            cell2csv(filename, data);
        end
    end
end

end
