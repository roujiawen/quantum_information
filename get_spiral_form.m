function get_spiral_form(ctype, basis, P_ABC)
% GET_SPIRAL_FORM returns formulation for the spiral inflation, given
% the constraint type {'eq', 'ineq'} and basis {'full', 'CG', 'corr'}
nvar = 3;
nout = length(P_ABC)^(1/nvar);

function mar_matrix = M_inf(varargin)
    keys =   {'A1','B1','C1','A2','B2','C2'};
    dict = containers.Map(keys, 1:6);
    indices = zeros(1, nargin);
    for k = 1:nargin
        indices(k) = dict(varargin{k});
    end
    mar_matrix = sum_marginal(nout, 6, indices);
end

function mar_P = P_ori(varargin)
    keys =   {'A', 'B', 'C'};
    dict = containers.Map(keys, 1:3);
    indices = zeros(1, nargin);
    for k = 1:nargin
        indices(k) = dict(varargin{k});
    end
    mar_P = sum_marginal(nout, 3, indices) * P_ABC;
end

switch ctype
    case 'eq'
        switch basis
            case 'full'
                % x = P(A1,B1,C1,A2,B2,C2)
                A = [M_inf('A1','B1','C1');
                     M_inf('A1','B2','C2');
                     M_inf('B1','C2','A2');
                     M_inf('C1','A2','B2');
                     M_inf('A2','B2','C2')];
                b = [P_ABC;
                     kron(P_ori('C'), P_ori('A','B'));
                     kron(P_ori('A'), P_ori('B','C'));
                     kron(P_ori('B'), P_ori('C','A'));
                     kron(P_ori('C'), kron(P_ori('B'), P_ori('A')))
                    ];
            case 'CG'
                constraint_A = ...
                    [
            case 'corr'
            otherwise
                error('Not implemented');
        end
    case 'ineq'
        switch basis
            case 'full'
                error('Not implemented');
            case 'CG'
            case 'corr'
            otherwise
                error('Not implemented');
        end
    otherwise
        error('Not implemented');
end
end

