solver = 'mosek';
basis = 'full';
slack = 1;
% Given
nout = 4; % Number of outcomes
P_ABC = get_dist('EJM');

%--------------Constraints---------------
% Marginal equivalence & independence conditions
A = [sum_marginal(nout, 6, [1 2 3]);
    sum_marginal(nout, 6, [4 3]);
    sum_marginal(nout, 6, [5 1]);
    sum_marginal(nout, 6, [6 2]);
    sum_marginal(nout, 6, [4]);
    sum_marginal(nout, 6, [5]);
    sum_marginal(nout, 6, [6]);
    sum_marginal(nout, 6, [4 5 6])];
b = [P_ABC;
    sum_marginal(nout, 3, [1 3]) * P_ABC;
    sum_marginal(nout, 3, [2 1]) * P_ABC;
    sum_marginal(nout, 3, [3 2]) * P_ABC;
    sum_marginal(nout, 3, [1]) * P_ABC;
    sum_marginal(nout, 3, [2]) * P_ABC;
    sum_marginal(nout, 3, [3]) * P_ABC;
    kron(kron(sum_marginal(nout, 3, [1]) * P_ABC, sum_marginal(nout, 3, [2]) * P_ABC),sum_marginal(nout, 3, [3]) * P_ABC)];

% Set YALMIP solver options
options = sdpsettings('solver','mosek','verbose',1,'debug',1,'savesolveroutput', 1, 'mosek.MSK_IPAR_OPTIMIZER', 'MSK_OPTIMIZER_FREE_SIMPLEX');
    
%--------------YALMIP without slack---------------
if slack == false
    x = sdpvar(nout^6, 1);%column vector
    Constraints = [A * x == b, x >= 0];
    Objective = [];%feasibility
    % Run optimizer
    sol = optimize(Constraints,Objective,options);
    % Save solver output
    solveroutput = sol.solveroutput;
    save('test.mat', 'solveroutput');

else
    %--------------YALMIP with slack---------------
    x = sdpvar(nout^6, 1);
    t = sdpvar(1);%scalar
    Objective = t;
    Constraints = [A * x == b, x >= t];
    % Run optimizer
    sol = optimize(Constraints,-Objective,options);%maximize
    % Save solver output
    solveroutput = sol.solveroutput;
    save('test.mat', 'solveroutput');
end

primal_opt = value(Objective);
y = dual(Constraints(1));
dual_opt = dot(y, b);
gap = primal_opt - dual_opt;

% Collect statistics
stats = {sol.yalmiptime, sol.solvertime, yalmiperror(sol.problem),...
    sol.info, primal_opt, dual_opt, gap};

stats