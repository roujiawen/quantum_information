% Given:
P_ABC = [0;1/3;1/3;0;1/3;0;0;0];%(000, 100, 010, 110, 001, 101, 011, 111)

% Convert to CG coordinates
G_ABC = p2cg(3)*P_ABC;

% cvx_begin
%     variable x(64);%G_A1B1C1A2B2C2
%     subject to
%         % Marginal equivalence conditions
%         cgmarginal(6, [1 2 3]) * x == G_ABC;
%         cgmarginal(6, [4 3]) * x == cgmarginal(3, [1 3]) * G_ABC;
%         cgmarginal(6, [5 1]) * x == cgmarginal(3, [2 1]) * G_ABC;
%         cgmarginal(6, [6 2]) * x == cgmarginal(3, [3 2]) * G_ABC;
%         cgmarginal(6, [4]) * x == cgmarginal(3, [1]) * G_ABC;
%         cgmarginal(6, [5]) * x == cgmarginal(3, [2]) * G_ABC;
%         cgmarginal(6, [6]) * x == cgmarginal(3, [3]) * G_ABC;
%         % Independence condition
%         cgmarginal(6, [4 5 6]) * x == kron(kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC),cgmarginal(3, [3]) * G_ABC); 
%         % Nonnegativity condition
%         cg2p(6) * x >= 0;
% cvx_end


%--------------General form---------------
A = [cgmarginal(6, [1 2 3]);
    cgmarginal(6, [4 3]);
    cgmarginal(6, [5 1]);
    cgmarginal(6, [6 2]);
    cgmarginal(6, [4]);
    cgmarginal(6, [5]);
    cgmarginal(6, [6]);
    cgmarginal(6, [4 5 6])];
b = [G_ABC;
    cgmarginal(3, [1 3]) * G_ABC;
    cgmarginal(3, [2 1]) * G_ABC;
    cgmarginal(3, [3 2]) * G_ABC;
    cgmarginal(3, [1]) * G_ABC;
    cgmarginal(3, [2]) * G_ABC;
    cgmarginal(3, [3]) * G_ABC;
    kron(kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC),cgmarginal(3, [3]) * G_ABC)];
G = -cg2p(6);
h = 0;

% cvx_begin
%     variable x(64);
%     subject to 
%         A * x == b;
%         G * x <= h;
% cvx_end

%--------------LP standard form---------------
% A_ = [G eye(64);
%       A zeros(34,64)];
% b_ = [zeros(64,1);
%       b];

cvx_begin
    variables x(64) s(64) t;
    dual variable y;
    maximize(t);
    subject to
        % Equality conditions
        y: A * x == b;
        G * x + eye(64) * s + t == 0;
        % Nonnegative conditions
        %x >= 0;
        s >= 0;
cvx_end

%-----------Analysis----------------
fprintf('Matrix A: m = %d, n = %d, rank = %d\n', size(A), rank(full(A)))
%fprintf('Matrix A'': m = %d, n = %d, rank = %d\n', size(A_), rank(full(A_)))
fprintf('-b^T y = %f\n', -b.' * y)


% ------------Results---------------
% Status: Infeasible
% Optimal value (cvx_optval): +Inf
%  
% Matrix A: m = 34, n = 64, rank = 18
% Matrix A': m = 98, n = 128, rank = 82