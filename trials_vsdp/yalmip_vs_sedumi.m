rng('default');
rng(333);
m = 6;
n = 5;
A = sparse(rand(m, n));
b = rand(m, 1);
c = rand(n, 1);

%----------Yalmip-------------------
% % Set YALMIP solver options
% options = sdpsettings('solver','sedumi','verbose',1,'debug',1,'savesolveroutput', 1);%, 'mosek.MSK_IPAR_OPTIMIZER', 'MSK_OPTIMIZER_FREE_SIMPLEX');
% 
% % Problem
% x = sdpvar(n, 1);
% Objective = dot(c, x);
% Constraints = [A * x == b, x >= 0];
% % Run optimizer
% sol = optimize(Constraints,Objective,options);%minimize
% % Save solver output
% solveroutput = sol.solveroutput;
% save('test.mat', 'solveroutput');
% 
% primal_opt = value(Objective);
% y = dual(Constraints(1));
% dual_opt = -dot(y, b);
% gap = primal_opt - dual_opt;
% 
% % Collect statistics
% stats = {sol.yalmiptime, sol.solvertime, yalmiperror(sol.problem),...
%     sol.info, primal_opt, dual_opt, gap};
% 
% stats


%----------sedumi------------------------
K.l = n;
[x, y, info] = sedumi(A,b,c, K);
%fprintf('\nPrimal obj: %f Dual obj: %f\n', full(dot(c,x)), full(dot(b,y)));


%----------test function pretransfo in sedumi----------

%pars.fid = 1;
%[A,b,c,K,prep,origcoeff] = pretransfo(A,b,c,K,pars);
