% Matrices stay nonflat in the main body of code

% Given:
P_ABC = [0.5;0;0;0;0;0;0;0.5]; %(000, 100, 010, 110, 001, 101, 011, 111)
 
% P_ABC in CG coordinate:
G_ABC = p2cg(P_ABC);

zero_vector = zeros(8,1);

cvx_begin
    variable x(8); % x is G_A2B1C1
    maximize(zero_vector.' * x); 
    subject to 
        % Equality conditions
        % G_A2C1 = G_AC
        cgmarginal(x, [1 3]) == cgmarginal(G_ABC, [1 3]);
        % G_B1C1 = G_BC
        cgmarginal(x, [2 3]) == cgmarginal(G_ABC, [2 3]);
        % G_A2B1 = S * P_A * P_B
        cgmarginal(x, [1 2]) == p2cg((pmarginal(P_ABC, 1))*(pmarginal(P_ABC, 2)).');
        % Nonnegative conditions
        cg2p(x) >= 0;
cvx_end

% RESULTS
% Status: Infeasible
% Optimal value (cvx_optval): -Inf
