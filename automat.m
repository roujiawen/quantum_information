solvers = {'Mosek' 'SDPT3' 'SeDuMi'};
bases = {'full', 'CG', 'corr'};
for i = 1:length(solvers)
    cur_solver = solvers{i};
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
            spiral_out4(cur_basis,slack);
            diary off
        end
    end
end
