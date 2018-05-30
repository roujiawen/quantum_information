P_ABC = [0.5;0;0;0;0;0;0;0.5]; %(000, 100, 010, 110, 001, 101, 011, 111)

% Used for taking marginals of P_ABC
M_AC = [1 0 1 0 0 0 0 0;
        0 1 0 1 0 0 0 0;
        0 0 0 0 1 0 1 0;
        0 0 0 0 0 1 0 1]; %(00, 10, 01, 11)
    
M_BC = [1 1 0 0 0 0 0 0;
        0 0 1 1 0 0 0 0;
        0 0 0 0 1 1 0 0;
        0 0 0 0 0 0 1 1]; %(00, 10, 01, 11)
    
M_A = [1 0 1 0 1 0 1 0;
       0 1 0 1 0 1 0 1]; %(0, 1)
   
M_B = [1 1 0 0 1 1 0 0;
       0 0 1 1 0 0 1 1]; %(0, 1)

% Change of basis matrix
S = [1 1;
     1 0]
% Inverse change of basis matrix
S_inv = inv(S);

% Filtering for P_CG
F_AC = [1 0 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0;
        0 0 0 0 1 0 0 0;
        0 0 0 0 0 1 0 0]
F_BC = [1 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0;
        0 0 0 0 1 0 0 0;
        0 0 0 0 0 0 1 0]
F_AB = [1 0 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0;
        0 0 0 1 0 0 0 0]
    
zero_vector = zeros(8,1);

cvx_begin
    variable x(8);
    maximize(zero_vector.' * x); % x is G_ABC
    subject to 
        % Equality conditions
        kpow(S_inv, 2) * (F_AC * x) == M_AC * P_ABC; % (00, 10, 01, 11)
        kpow(S_inv, 2) * (F_BC * x) == M_BC * P_ABC; % (00, 10, 01, 11)
        kpow(S_inv, 2) * (F_AB * x) == reshape((M_A * P_ABC)*(M_B * P_ABC).', [4,1]);
                                                    %(00, 10, 01, 11)
        % Nonnegative conditions
        kpow(S_inv, 3) * x >= 0;
cvx_end

% RESULTS
% Status: Infeasible
% Optimal value (cvx_optval): -Inf
