% Given:
P_ABC = [0.5;0;0;0;0;0;0;0.5]; %(000, 100, 010, 110, 001, 101, 011, 111)

M_AC = pmarginal(3, [1 3]);
M_BC = pmarginal(3, [2 3]);
M_AB = pmarginal(3, [1 2]);
    
M_A = pmarginal(3, 1);
M_B = pmarginal(3, 2);

% cvx_begin
%     variable x(8);
%     subject to 
%         M_AC * x == M_AC * P_ABC;
%         M_BC * x == M_BC * P_ABC;
%         M_AB * x == kron(M_A * P_ABC, M_B * P_ABC);
%         x >= 0;
% cvx_end

%--------------LP standard form---------------
A = [M_AC;
     M_BC;
     M_AB];
 
b = [M_AC * P_ABC;
     M_BC * P_ABC;
     kron(M_A * P_ABC, M_B * P_ABC)];

cvx_begin
    variable x(8);
    subject to 
        A * x == b;
        x >= 0;
cvx_end

% ------------Results---------------
% Status: Infeasible
% Optimal value (cvx_optval): +Inf


%-----------Analysis----------------

%rref(A)
rank(full(A))%rank=7



