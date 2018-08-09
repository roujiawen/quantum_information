function [A, b, G, h] = get_cut_constraints(dist_name, basis)
%GET_CUT_CONSTRAINTS given the name of the distribution 
%and a basis name ('full', 'CG', 'corr'), outputs the set of constraints 
%(A, b, G, h) under the cut inflation.

if nargin < 1
    dist_name = 'complete correlation';
end

if nargin < 2
    basis = 'full';
end

[P_ABC, nout, feasibility] = get_dist(dist_name);

switch basis
    case 'CG'
        % Rewrote using slice_marginal and elie's suggestion
        % Convert to CG coordinates
        % Redundant constraints
        delete_rows = [1 3 9 10 11];
        preserve_rows = setdiff(1:12, delete_rows);
        G_ABC = switch_basis_mat('full', 'CG', nout, 3)*P_ABC;
        A = [slice_marginal(nout, 3, [1 3]);
            slice_marginal(nout, 3, [2 3]);
            slice_marginal(nout, 3, [1 2])]...
            * switch_basis_mat('full', 'CG', nout, 3);
        b = [slice_marginal(nout, 3, [1 3]) * G_ABC;
            slice_marginal(nout, 3, [2 3]) * G_ABC;
            kron(slice_marginal(nout, 3, [2]) * G_ABC, slice_marginal(nout, 3, [1]) * G_ABC)];
        % placeholders
        A = A(preserve_rows, :);
        b = b(preserve_rows, :);
        G = 0;
        h = 0;
    case 'full'
        M_AC = pmarginal(3, [1 3]);
        M_BC = pmarginal(3, [2 3]);
        M_AB = pmarginal(3, [1 2]);

        M_A = pmarginal(3, 1);
        M_B = pmarginal(3, 2);
        
        A = [M_AC;
             M_BC;
             M_AB];
        b = [M_AC * P_ABC;
             M_BC * P_ABC;
             kron(M_A * P_ABC, M_B * P_ABC)];
        G = 0;
        h = 0;
    otherwise
        error('not implemented');
end
end