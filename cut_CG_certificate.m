% Given:
P_ABC = get_dist('complete correlation'); %(000, 100, 010, 110, 001, 101, 011, 111)
 
% P_ABC in CG coordinate:
G_ABC = p2cg(3)*P_ABC;

cvx_begin
    variable x(16); % x is concat(P_CG_inf, z)
    dual variables y1 y2 y3 y4 y5;
    expressions P_CG_inf(8) z(8);
    P_CG_inf = x(1:8);
    z = x(9:16);
    subject to 
        % Equality conditions
        % G_A2C1 = G_AC
        y1: cgmarginal(3, [1 3]) * P_CG_inf == cgmarginal(3, [1 3]) * G_ABC;
        % G_B1C1 = G_BC
        y2: cgmarginal(3, [2 3]) * P_CG_inf == cgmarginal(3, [2 3]) * G_ABC;
        % G_A2B1 = G_A * G_B
        y3: cgmarginal(3, [1 2]) * P_CG_inf == kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC);
        % Nonnegative conditions
        y4: cg2p(3) * P_CG_inf - z == 0;
        y5: z >= 0;
cvx_end

%-----------Analysis----------------
b = [cgmarginal(3, [1 3]) * G_ABC;
    cgmarginal(3, [2 3]) * G_ABC;
    kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC)];

b.' * [y1; y2; y3]

%-----------Results----------------
% Status: Infeasible
% Optimal value (cvx_optval): +Inf
%  
% 
% ans =
% 
%      1
