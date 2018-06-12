% Given
nout = 4; % Number of outcomes
P_ABC = get_dist('EJM');

% cvx_begin
%     variable x(nout^6);% P_A1B1C1A2B2C2
%     subject to
%         % Marginal equivalence conditions
%         sum_marginal(nout, 6, [1 2 3]) * x == P_ABC;
%         sum_marginal(nout, 6, [4 3]) * x == sum_marginal(nout, 3, [1 3]) * P_ABC;
%         sum_marginal(nout, 6, [5 1]) * x == sum_marginal(nout, 3, [2 1]) * P_ABC;
%         sum_marginal(nout, 6, [6 2]) * x == sum_marginal(nout, 3, [3 2]) * P_ABC;
%         sum_marginal(nout, 6, [4]) * x == sum_marginal(nout, 3, [1]) * P_ABC;
%         sum_marginal(nout, 6, [5]) * x == sum_marginal(nout, 3, [2]) * P_ABC;
%         sum_marginal(nout, 6, [6]) * x == sum_marginal(nout, 3, [3]) * P_ABC;
%         % Independence condition
%         sum_marginal(nout, 6, [4 5 6]) * x == kron(kron(sum_marginal(nout, 3, [1]) * P_ABC, sum_marginal(nout, 3, [2]) * P_ABC),sum_marginal(nout, 3, [3]) * P_ABC); 
%         % Nonnegativity condition
%         x >= 0;
% cvx_end

%--------------LP standard form---------------
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


cvx_begin
    variables x(nout^6) t;
    dual variable y;
    maximize t;
    subject to 
        y: A * x == b;
        x >= t;
cvx_end

%-----------Analysis----------------

% rref(A)
% fprintf('Matrix A: m = %d, n = %d, rank = %d\n', size(A), rank(full(A)))
% fprintf('-b^T y = %f\n', -b.' * y)


% ------------Results---------------
% Status: Solved
% Optimal value (cvx_optval): +6.10298e-05
