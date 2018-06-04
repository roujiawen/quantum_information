% Everything is row-major (00, 01, 10, 11)
P_ABC = [0.5;0;0;0;0;0;0;0.5];

M_AC = [1 0 1 0 0 0 0 0;
        0 1 0 1 0 0 0 0;
        0 0 0 0 1 0 1 0;
        0 0 0 0 0 1 0 1];
    
M_BC = [1 0 0 0 1 0 0 0;
        0 1 0 0 0 1 0 0;
        0 0 1 0 0 0 1 0;
        0 0 0 1 0 0 0 1];

M_AB = [1 1 0 0 0 0 0 0;
        0 0 1 1 0 0 0 0;
        0 0 0 0 1 1 0 0;
        0 0 0 0 0 0 1 1];
    
M_A = [1 1 1 1 0 0 0 0;
       0 0 0 0 1 1 1 1];
   
M_B = [1 1 0 0 1 1 0 0;
       0 0 1 1 0 0 1 1];
    
zero_vector = zeros(8,1);


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
rank(A)%rank=7



