method = 'MSK_OPTIMIZER_PRIMAL_SIMPLEX';
% Set YALMIP solver options
options = sdpsettings('solver','mosek','verbose',1,'debug',1,'savesolveroutput', 1, 'mosek.MSK_IPAR_OPTIMIZER', method);
% Variable
x = sdpvar(2, 1);
% Objective
Objective = [];
% Constraints
A = [25 3; 0 10];
b = [3; 10];
Constraints = [A * x == b];
% Run optimizer
sol = optimize(Constraints,Objective,options);

yalmiperror(sol.problem)
sol.info
