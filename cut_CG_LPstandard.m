% Wrong conditions (still in P coordinate)
% Also no need to split into X+ and X- since X>=0 already

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
     1 0];
% Inverse change of basis matrix
S_inv = inv(S);

% Filtering for P_CG
F_AC = [1 0 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0;
        0 0 0 0 1 0 0 0;
        0 0 0 0 0 1 0 0];
F_BC = [1 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0;
        0 0 0 0 1 0 0 0;
        0 0 0 0 0 0 1 0];
F_AB = [1 0 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0;
        0 0 0 1 0 0 0 0];

%--------------General form---------------

% Concatenate conditions
A = [kpow(S_inv, 2) * F_AC;
     kpow(S_inv, 2) * F_BC;
     kpow(S_inv, 2) * F_AB];
b = [M_AC * P_ABC;
     M_BC * P_ABC;
     reshape((M_A * P_ABC)*(M_B * P_ABC).', [4,1])];
G = -kpow(S_inv, 3);
h = 0;

% cvx_begin
%     variable x(8);
%     subject to 
%         % Equality conditions
%         A * x == b;
%         % Nonnegative conditions
%         G * x <= h;
% cvx_end


%--------------LP standard form---------------
A_ = [G -G eye(8);
      A -A zeros(12,8)]
b_ = [zeros(8,1);
      b]

% cvx_begin
%     variable x(24);
%     subject to
%         % Equality conditions
%         A_ * x - b_ == 0;
%         % Nonnegative conditions
%         x >= 0;
% cvx_end


% RESULTS
% Status: Infeasible
% Optimal value (cvx_optval): +Inf

%--------------Analysis---------------
rank(A)
rank(A_)
