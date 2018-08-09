% Given:
P_ABC = get_dist('complete correlation'); %(000, 100, 010, 110, 001, 101, 011, 111)
 
% P_ABC in CG coordinate:
C_ABC = p2co(3)*P_ABC;

% Filter matrices
M_AC = comarginal(3, [1 3]);
M_BC = comarginal(3, [2 3]);
M_AB = comarginal(3, [1 2]);

% cvx_begin
%     variable x(8); % x is C_A2B1C1
%     subject to 
%         % Equality conditions
%         % C_A2C1 = C_AC
%         M_AC * x == M_AC * C_ABC;
%         % C_B1C1 = C_BC
%         M_BC * x == M_BC * C_ABC;
%         % C_A2B1 = C_A * C_B
%         M_AB * x == kron(comarginal(3, [1]) * C_ABC, comarginal(3, [2]) * C_ABC);
%         % Nonnegative conditions
%         co2p(3)*x >= 0;
% cvx_end


%--------------General form---------------

% Concatenate conditions
A = [M_AC;
     M_BC;
     M_AB];
b = [M_AC * C_ABC;
     M_BC * C_ABC;
     kron(comarginal(3, [1]) * C_ABC, comarginal(3, [2]) * C_ABC)];
G = -co2p(3);
h = 0;
 
% cvx_begin
%     variable x(8);
%     subject to 
%         % Equality conditions
%         A * x == b;
%         % Inequality conditions
%         G * x <= h;
% cvx_end


%--------------LP standard form---------------
A_ = [G eye(8);
      A zeros(12,8)];
b_ = [zeros(8,1);
      b];

cvx_begin
    variable x(16);
    subject to
        % Equality conditions
        A_ * x - b_ == 0;
        % Nonnegative conditions
        x >= 0;
cvx_end



% RESULTS
% Status: Infeasible
% Optimal value (cvx_optval): +Inf

%--------------Analysis---------------
fprintf('Rank of A = %d\n', rank(full(A)));

fprintf('Rank of A'' = %d\n', rank(full(A_)));


