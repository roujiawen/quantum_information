slack = 0;
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

%--------------CVX without slack---------------
if slack == false
    cvx_begin
        variable x(nout^6);
        dual variable y;
        subject to 
            y: A * x == b;
            x >= 0;
    cvx_end
else
    %--------------CVX with slack---------------
    cvx_begin
        variables x(nout^6) t;
        dual variable y;
        maximize t;
        subject to 
            y: A * x == b;
            x >= t;
    cvx_end
end