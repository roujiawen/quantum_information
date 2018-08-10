function [constraint_A, constraint_b] = get_spiral_form(ctype, basis, P_ABC)
% GET_SPIRAL_FORM returns formulation for the spiral inflation, given
% the constraint type {'eq', 'ineq'} and basis {'full', 'CG', 'corr'}

% For easy debugging
if nargin == 0
    ctype = 'eq'; basis = 'CG'; P_ABC = ones(8,1)/8;
end

% Constants
nvar = 3;
nout = round(length(P_ABC)^(1/nvar));
P_ABC = P_ABC(:);
if strcmp(basis, 'CG')
    G_ABC = switch_basis_mat('full', 'CG', nout, nvar) * P_ABC;
elseif strcmp(basis, 'corr')
    C_ABC = switch_basis_mat('full', 'corr', nout, nvar) * P_ABC;
end

% Aliases for readibility
A1=1; B1=2; C1=3; A2=4; B2=5; C2=6;
A=1; B=2; C=3;

%% -----------------EQUALITY CONSTRAINTS--------------------
    function [constraint_A, constraint_b] = eq_full
        % M_inf * x = P_ABC  =>  A * x = b
        % where x = P(A1,B1,C1,A2,B2,C2)
        % M_inf : matrix that sums over the marginal of inflation
        constraint_A = ...
            [M_inf(A1,B1,C1);
            M_inf(A1,B2,C2);
            M_inf(B1,C2,A2);
            M_inf(C1,A2,B2);
            M_inf(A2,B2,C2)];
        constraint_b = ...
            [P_ori(A,B,C);
            kron(P_ori(C), P_ori(A,B));
            kron(P_ori(A), P_ori(B,C));
            kron(P_ori(B), P_ori(C,A));
            kron(P_ori(C), kron(P_ori(B), P_ori(A)))];
    end

    function [constraint_A, constraint_b] = eq_CG
        % K_inf * S_CG * x = G_ABC  =>  A * x = b
        % where x = P(A1,B1,C1,A2,B2,C2)
        % K_inf : matrix that picks the marginal of inflation
        S_CG = switch_basis_mat('full', 'CG', nout, 6);
        
        constraint_A = ...
            [K_inf(A1,B1,C1);
            K_inf(A1,B2,C2);
            K_inf(B1,C2,A2);
            K_inf(C1,A2,B2);
            K_inf(A2,B2,C2)] * S_CG;
        constraint_b = ...
            [G_ori(A,B,C);
            kron(G_ori(C), G_ori(A,B));
            kron(G_ori(A), G_ori(B,C));
            kron(G_ori(B), G_ori(C,A));
            kron(G_ori(C), kron(G_ori(B), G_ori(A)))];
        constraint_A = constraint_A(red_rows_filter, :);
        constraint_b = constraint_b(red_rows_filter, :);
    end

    function [constraint_A, constraint_b] = eq_corr
        % K_inf * S_corr * x = C_ABC  =>  A * x = b
        % where x = P(A1,B1,C1,A2,B2,C2)
        % K_inf : matrix that picks the marginal of inflation
        S_corr = switch_basis_mat('full', 'corr', nout, 6);
        
        constraint_A = ...
            [K_inf(A1,B1,C1);
            K_inf(A1,B2,C2);
            K_inf(B1,C2,A2);
            K_inf(C1,A2,B2);
            K_inf(A2,B2,C2)] * S_corr;
        constraint_b = ...
            [C_ori(A,B,C);
            kron(C_ori(C), C_ori(A,B));
            kron(C_ori(A), C_ori(B,C));
            kron(C_ori(B), C_ori(C,A));
            kron(C_ori(C), kron(C_ori(B), C_ori(A)))];
        
        constraint_A = constraint_A(red_rows_filter, :);
        constraint_b = constraint_b(red_rows_filter, :);
    end

%% -----------------INEQUALITY CONSTRAINTS--------------------
    function [constraint_A, constraint_b] = ineq_CG
        % K_inf * x = G_ABC   &   S_CG_inv * x >=0
        %       => A * x >= b
        % where x = G(A1,B1,C1,A2,B2,C2)
        % K_inf : matrix that picks the marginal of inflation
        
        A_eq = ...
            [K_inf(A1,B1,C1);
            K_inf(A1,B2,C2);
            K_inf(B1,C2,A2);
            K_inf(C1,A2,B2);
            K_inf(A2,B2,C2)];
        b_eq = ...
            [G_ori(A,B,C);
            kron(G_ori(C), G_ori(A,B));
            kron(G_ori(A), G_ori(B,C));
            kron(G_ori(B), G_ori(C,A));
            kron(G_ori(C), kron(G_ori(B), G_ori(A)))];
        
        A_eq = A_eq(red_rows_filter, :);
        b_eq = b_eq(red_rows_filter, :);
        
        % Substitute fixed x elements
        [fixed_indices, tmp] = find(A_eq'==1);%column-major
        S_CG_inv = switch_basis_mat('CG', 'full', nout, 6);
        fixed_coefs = S_CG_inv(:, fixed_indices);
        
        constraint_A = S_CG_inv(:, ...
                setdiff(1:size(S_CG_inv, 2), fixed_indices));
        constraint_b = - fixed_coefs * b_eq;

    end

    function [constraint_A, constraint_b] = ineq_corr
        % K_inf * x = C_ABC   &   S_corr_inv * x >=0
        %       => A * x >= b
        % where x = C(A1,B1,C1,A2,B2,C2)
        % K_inf : matrix that picks the marginal of inflation
        
        A_eq = ...
            [K_inf(A1,B1,C1);
            K_inf(A1,B2,C2);
            K_inf(B1,C2,A2);
            K_inf(C1,A2,B2);
            K_inf(A2,B2,C2)];
        b_eq = ...
            [C_ori(A,B,C);
            kron(C_ori(C), C_ori(A,B));
            kron(C_ori(A), C_ori(B,C));
            kron(C_ori(B), C_ori(C,A));
            kron(C_ori(C), kron(C_ori(B), C_ori(A)))];
        
        A_eq = A_eq(red_rows_filter, :);
        b_eq = b_eq(red_rows_filter, :);
        
        % Substitute fixed x elements
        [fixed_indices, tmp] = find(A_eq'==1);%column-major
        S_corr_inv = switch_basis_mat('corr', 'full', nout, 6);
        fixed_coefs = S_corr_inv(:, fixed_indices);
        
        constraint_A = S_corr_inv(:, ...
                setdiff(1:size(S_corr_inv, 2), fixed_indices));
        constraint_b = - fixed_coefs * b_eq;
    end

%% -----------------HELPER FUNCTIONS--------------------
    function mar_matrix = M_inf(varargin)
        %A1=1, B1=2, C1=3, A2=4, B2=5, C2=6
        indices = cell2mat(varargin);
        mar_matrix = sum_marginal(nout, 6, indices);
    end

    function mar_P = P_ori(varargin)
        %A=1, B=2, C=3
        indices = cell2mat(varargin);
        mar_P = sum_marginal(nout, nvar, indices) * P_ABC;
    end

    function mar_matrix = K_inf(varargin)
        %A1=1, B1=2, C1=3, A2=4, B2=5, C2=6
        indices = cell2mat(varargin);
        mar_matrix = slice_marginal(nout, 6, indices);
    end

    function mar_P = G_ori(varargin)
        %A=1, B=2, C=3
        indices = cell2mat(varargin);
        mar_P = slice_marginal(nout, nvar, indices) * G_ABC;
    end

    function mar_P = C_ori(varargin)
        %A=1, B=2, C=3
        indices = cell2mat(varargin);
        mar_P = slice_marginal(nout, nvar, indices) * C_ABC;
    end

    function fil = red_rows_filter
        % Filtering redundant rows in CG and correlator bases
        cube = ones(nout, nout, nout); % cube of size nout^3
        cube(1,:,:) = 0;
        cube(:,1,1) = 0;
        sub1 = ones(nout^3,1);
        sub2 = cube(:);
        sub3 = sub1; sub3(1) = 0;
        fil = logical([sub1; sub2; sub2; sub2; sub3]);
    end

%% -----------------MAIN--------------------
if exist([ctype '_' basis])~=2
    error('Not implemented');
end
[constraint_A, constraint_b] = eval([ctype '_' basis]);

end

