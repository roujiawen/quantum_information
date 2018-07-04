function [E, cvx_optval] = qsd(n, m, p, rho)
% Solve a quantum state discrimination problem using cvx.
%
% Inputs
%     n   : int, the number of indices/states
%     m   : int, the dimension of state space
%     p   : row vector of length n, probabilities of Alice 
%           sending the i-th state
%     rho : matrix of size (m, m, n), pool of n density matrices
%           of size (m,m), which are the states that Alice could send
% Outputs
%     E   : the POVM that maximizes Bob's probability of correct guess
% ------------------------------------------------------


cvx_begin
    % variable is a list of n POVM elements
    variable E(m, m, n) hermitian semidefinite
    % placeholders for intermediate results 
    expressions E_dot_rho(m, m, n) tr(n)
    
    % objective: sum(p_i * tr(E_i*rho_i))
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