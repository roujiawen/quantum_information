m = 2;
P_xy = [0.25 0.25 0.25 0.25]; %00 10 01 11
rho = 1/2 *...
    [0  0  0  0;
     0  1 -1  0;
     0 -1  1  0;
     0  0  0  0];

cvx_begin
    % variable is a list of n POVM elements
    variable B(m, m, 2, 2) hermitian semidefinite
    
    % objective: sum_xy (p_xy * tr(A x B * rho))
    AB =
    E_dot_rho = dot2(E, rho, E_dot_rho)
    tr = trace2(E_dot_rho, tr)
    maximize(p * tr)
    
    subject to
        % completeness relation
        sum(E, 3) == eye(m)
        % each E_i is positive semidefinite
        for k = 1 : n
            E(:,:,k) == hermitian_semidefinite(m)
        end
cvx_end

end