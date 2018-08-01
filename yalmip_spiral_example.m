solver = 'mosek';
basis = 'full';
slack = 1;
% Given
nout = 2; % Number of outcomes
P_ABC = get_dist('complete correlation');

%--------------Constraint matrices---------------
[A, b, G, h] = get_spiral_constraints(nout, P_ABC, basis);

% Set YALMIP solver options
options = sdpsettings('solver',solver,'verbose',1,'debug',1,'savesolveroutput', 1);%, 'mosek.MSK_IPAR_OPTIMIZER', 'MSK_OPTIMIZER_FREE_SIMPLEX');
    
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