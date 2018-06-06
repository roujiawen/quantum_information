% Given:
P_ABC = [0;1/3;1/3;0;1/3;0;0;0];%(000, 100, 010, 110, 001, 101, 011, 111)
%P_ABC = [0;1;1;1;1;1;1;0]/6;

% Convert to correlator coordinates
C_ABC = p2co(3)*P_ABC;

% cvx_begin
%     variable x(64);%C_A1B1C1A2B2C2
%     subject to
%         % Marginal equivalence conditions
%         comarginal(6, [1 2 3]) * x == C_ABC;
%         comarginal(6, [4 3]) * x == comarginal(3, [1 3]) * C_ABC;
%         comarginal(6, [5 1]) * x == comarginal(3, [2 1]) * C_ABC;
%         comarginal(6, [6 2]) * x == comarginal(3, [3 2]) * C_ABC;
%         comarginal(6, [4]) * x == comarginal(3, [1]) * C_ABC;
%         comarginal(6, [5]) * x == comarginal(3, [2]) * C_ABC;
%         comarginal(6, [6]) * x == comarginal(3, [3]) * C_ABC;
%         % Independence condition
%         comarginal(6, [4 5 6]) * x == kron(kron(comarginal(3, [1]) * C_ABC, comarginal(3, [2]) * C_ABC),comarginal(3, [3]) * C_ABC); 
%         % Nonnegativity condition
%         co2p(6) * x >= 0;
% cvx_end


%--------------General form---------------
A = [comarginal(6, [1 2 3]);
    comarginal(6, [4 3]);
    comarginal(6, [5 1]);
    comarginal(6, [6 2]);
    comarginal(6, [4]);
    comarginal(6, [5]);
    comarginal(6, [6]);
    comarginal(6, [4 5 6])];
b = [C_ABC;
    comarginal(3, [1 3]) * C_ABC;
    comarginal(3, [2 1]) * C_ABC;
    comarginal(3, [3 2]) * C_ABC;
    comarginal(3, [1]) * C_ABC;
    comarginal(3, [2]) * C_ABC;
    comarginal(3, [3]) * C_ABC;
    kron(kron(comarginal(3, [1]) * C_ABC, comarginal(3, [2]) * C_ABC),comarginal(3, [3]) * C_ABC)];
G = -co2p(6);
h = 0;

% cvx_begin
%     variable x(64);
%     subject to 
%         A * x == b;
%         G * x <= h;
% cvx_end

%--------------LP standard form---------------
A_ = [G eye(64);
      A zeros(34,64)];
b_ = [zeros(64,1);
      b];

cvx_begin
    variables x(64) s(64) t;
    dual variable y;
    minimize(-t);
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

