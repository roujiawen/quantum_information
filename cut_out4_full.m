% Given:
nout = 4;
P_ABC = get_dist('EJM'); 

M_AC = sum_marginal(nout, 3, [1 3]);
M_BC = sum_marginal(nout, 3, [2 3]);
M_AB = sum_marginal(nout, 3, [1 2]);
    
M_A = sum_marginal(nout, 3, 1);
M_B = sum_marginal(nout, 3, 2);

% cvx_begin
%     variable x(nout^3);
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
    variable x(nout^3);
    subject to 
        A * x == b;
        x >= 0;
cvx_end

% ------------Results---------------
% Status: Solved
% Optimal value (cvx_optval): +0


%-----------Analysis----------------

%rref(A)
rank(full(A))



