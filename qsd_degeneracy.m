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

% parameters
n = 4;% number of indices/states
m = 2;% dimension of state space
p = [0.1 0.1 0.7 0.1]; % probabilities of Alice sending the i-th state

% density matrices
r1 = [1 0; 0 0];
r2 = [0 0; 0 1];
r3 = 1/2 * [1 1; 1 1];
r4 = 1/2 * [1 -1; -1 1];
rho = cat(3, r1, r2, r3, r4); % list of n density matrices of size (m,m)

% Run optimization
[E, opt] = qsd(n, m, p, rho);

for picked = 1:4
    for maxmin_i=1:2
        if maxmin_i == 1
            maxmin = "max"
        else
            maxmin = "min"
        end
        cvx_begin
            % variable is a list of n POVM elements
            variable E(m, m, n) hermitian semidefinite
            % placeholders for intermediate results
            expressions E_dot_rho(m, m, n) tr(n)
            E_dot_rho = dot2(E, rho, E_dot_rho)
            tr = trace2(E_dot_rho, tr)
            % objective
            if maxmin == "max"
                maximize(trace(E(:,:,picked)))
            else
                minimize(trace(E(:,:,picked)))
            end
            % constraints
                % sum(p_i * tr(E_i*rho_i)) == opt
                
                p * tr >= opt
                % completeness relation
                sum(E, 3) == eye(m)
                % each E_i is positive semidefinite
                for k = 1 : n
                    E(:,:,k) == hermitian_semidefinite(m)
                end
        cvx_end
        filename = sprintf('POVMs/%d_%s.txt', picked, maxmin);
        if (exist(filename, 'file'))
           delete(filename);
        end
        diary(filename);pprint_cmat(E,6);
        disp(tr);
        diary off;
    end
end
