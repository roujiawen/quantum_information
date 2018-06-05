% Given
P_ABC = [0;1/3;1/3;0;1/3;0;0;0];%(000, 100, 010, 110, 001, 101, 011, 111)

% cvx_begin
%     variable x(64);%P_A1B1C1A2B2C2
%     subject to
%         % Marginal equivalence conditions
%         pmarginal(6, [1 2 3]) * x == P_ABC;
%         pmarginal(6, [4 3]) * x == pmarginal(3, [1 3]) * P_ABC;
%         pmarginal(6, [5 1]) * x == pmarginal(3, [2 1]) * P_ABC;
%         pmarginal(6, [6 2]) * x == pmarginal(3, [3 2]) * P_ABC;
%         pmarginal(6, [4]) * x == pmarginal(3, [1]) * P_ABC;
%         pmarginal(6, [5]) * x == pmarginal(3, [2]) * P_ABC;
%         pmarginal(6, [6]) * x == pmarginal(3, [3]) * P_ABC;
%         % Independence condition
%         pmarginal(6, [4 5 6]) * x == kron(kron(pmarginal(3, [1]) * P_ABC, pmarginal(3, [2]) * P_ABC),pmarginal(3, [3]) * P_ABC); 
%         % Nonnegativity condition
%         x >= 0;
% cvx_end

%--------------LP standard form---------------
A = [pmarginal(6, [1 2 3]);
    pmarginal(6, [4 3]);
    pmarginal(6, [5 1]);
    pmarginal(6, [6 2]);
    pmarginal(6, [4]);
    pmarginal(6, [5]);
    pmarginal(6, [6]);
    pmarginal(6, [4 5 6])];
b = [P_ABC;
    pmarginal(3, [1 3]) * P_ABC;
    pmarginal(3, [2 1]) * P_ABC;
    pmarginal(3, [3 2]) * P_ABC;
    pmarginal(3, [1]) * P_ABC;
    pmarginal(3, [2]) * P_ABC;
    pmarginal(3, [3]) * P_ABC;
    kron(kron(pmarginal(3, [1]) * P_ABC, pmarginal(3, [2]) * P_ABC),pmarginal(3, [3]) * P_ABC)];


cvx_begin
    variable x(64);
    subject to 
        A * x == b;
        x >= 0;
cvx_end


%-----------Analysis----------------

%rref(A)
fprintf('Matrix A: m = %d, n = %d, rank = %d\n', size(A), rank(full(A)))

% ------------Results---------------
% Status: Infeasible
% Optimal value (cvx_optval): +Inf
%  
% Matrix A: m = 34, n = 64, rank = 18

