% Given:
P_ABC = [0.5;0;0;0;0;0;0;0.5]; %(000, 100, 010, 110, 001, 101, 011, 111)
 
% P_ABC in CG coordinate:
G_ABC = p2cg(3)*P_ABC;

cvx_begin
    variables P_CG_inf(8) z(8) t;
    dual variables y1 y2 y3;
    maximize(t);
    subject to 
        % Equality conditions
        % G_A2C1 = G_AC
        y1: cgmarginal(3, [1 3]) * P_CG_inf == cgmarginal(3, [1 3]) * G_ABC;
        % G_B1C1 = G_BC
        y2: cgmarginal(3, [2 3]) * P_CG_inf == cgmarginal(3, [2 3]) * G_ABC;
        % G_A2B1 = G_A * G_B
        y3: cgmarginal(3, [1 2]) * P_CG_inf == kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC);
        % Nonnegative conditions
        cg2p(3) * P_CG_inf - t == z;
        z >= 0;
cvx_end


%-----------Analysis----------------
b = [cgmarginal(3, [1 3]) * G_ABC;
    cgmarginal(3, [2 3]) * G_ABC;
    kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC)];

b.' * [y1; y2; y3]


%-----------Results----------------
% Status: Solved
% Optimal value (cvx_optval): -0.125
%  
% 
% ans =
% 
%     0.1250
