function [A, b, G, h] = get_spiral_constraints(nout, P_ABC, basis)
%SPIRAL_CONSTRAINTS given the number of outcomes, a distribution vector 
%and a basis name ('full', 'CG', 'corr'), outputs the set of constraints 
%(A, b, G, h) under the spiral inflation.

switch basis
    case 'full'
        A = [sum_marginal(nout, 6, [1 2 3]);
            sum_marginal(nout, 6, [4 3]);
            sum_marginal(nout, 6, [5 1]);
            sum_marginal(nout, 6, [6 2]);
            sum_marginal(nout, 6, [4]);
            sum_marginal(nout, 6, [5]);
            sum_marginal(nout, 6, [6]);
            sum_marginal(nout, 6, [4 5 6])];
        b = [P_ABC;
            sum_marginal(nout, 3, [1 3]) * P_ABC;
            sum_marginal(nout, 3, [2 1]) * P_ABC;
            sum_marginal(nout, 3, [3 2]) * P_ABC;
            sum_marginal(nout, 3, [1]) * P_ABC;
            sum_marginal(nout, 3, [2]) * P_ABC;
            sum_marginal(nout, 3, [3]) * P_ABC;
            kron(kron(sum_marginal(nout, 3, [3]) * P_ABC, sum_marginal(nout, 3, [2]) * P_ABC),sum_marginal(nout, 3, [1]) * P_ABC)];
        % placeholders
        G = 0;
        h = 0;
    case 'CG_old'
        % Convert to CG coordinates
        G_ABC = switch_basis_mat('full', 'CG', nout, 3)*P_ABC;
        A = [slice_marginal(nout, 6, [1 2 3]);
            slice_marginal(nout, 6, [4 3]);
            slice_marginal(nout, 6, [5 1]);
            slice_marginal(nout, 6, [6 2]);
            slice_marginal(nout, 6, [4]);
            slice_marginal(nout, 6, [5]);
            slice_marginal(nout, 6, [6]);
            slice_marginal(nout, 6, [4 5 6])];
        b = [G_ABC;
            slice_marginal(nout, 3, [1 3]) * G_ABC;
            slice_marginal(nout, 3, [2 1]) * G_ABC;
            slice_marginal(nout, 3, [3 2]) * G_ABC;
            slice_marginal(nout, 3, [1]) * G_ABC;
            slice_marginal(nout, 3, [2]) * G_ABC;
            slice_marginal(nout, 3, [3]) * G_ABC;
            kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC)];
        G = -switch_basis_mat('CG', 'full', nout, 6);
        h = 0;
    case 'corr_old'
        % Convert to correlator coordinates
        G_ABC = switch_basis_mat('full', 'corr', nout, 3)*P_ABC;
        A = [slice_marginal(nout, 6, [1 2 3]);
            slice_marginal(nout, 6, [4 3]);
            slice_marginal(nout, 6, [5 1]);
            slice_marginal(nout, 6, [6 2]);
            slice_marginal(nout, 6, [4]);
            slice_marginal(nout, 6, [5]);
            slice_marginal(nout, 6, [6]);
            slice_marginal(nout, 6, [4 5 6])];
        b = [G_ABC;
            slice_marginal(nout, 3, [1 3]) * G_ABC;
            slice_marginal(nout, 3, [2 1]) * G_ABC;
            slice_marginal(nout, 3, [3 2]) * G_ABC;
            slice_marginal(nout, 3, [1]) * G_ABC;
            slice_marginal(nout, 3, [2]) * G_ABC;
            slice_marginal(nout, 3, [3]) * G_ABC;
            kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC)];
        G = -switch_basis_mat('corr', 'full', nout, 6);
        h = 0;
    case 'CG'
        % Convert to CG coordinates
        G_ABC = switch_basis_mat('full', 'CG', nout, 3)*P_ABC;
        A = [slice_marginal(nout, 6, [1 2 3]);
            slice_marginal(nout, 6, [4 3]);
            slice_marginal(nout, 6, [5 1]);
            slice_marginal(nout, 6, [6 2]);
            slice_marginal(nout, 6, [4]);
            slice_marginal(nout, 6, [5]);
            slice_marginal(nout, 6, [6]);
            slice_marginal(nout, 6, [4 5 6])]...
            * switch_basis_mat('full', 'CG', nout, 6);
        b = [G_ABC;
            slice_marginal(nout, 3, [1 3]) * G_ABC;
            slice_marginal(nout, 3, [2 1]) * G_ABC;
            slice_marginal(nout, 3, [3 2]) * G_ABC;
            slice_marginal(nout, 3, [1]) * G_ABC;
            slice_marginal(nout, 3, [2]) * G_ABC;
            slice_marginal(nout, 3, [3]) * G_ABC;
            kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC)];
        % placeholders
        G = 0;
        h = 0;
    case 'CG_red'
        % Convert to CG coordinates
        G_ABC = switch_basis_mat('full', 'CG', nout, 3)*P_ABC;
        temp = reshape(1:nout^2, [1 1]*nout);
        temp = temp(2:nout,2:nout);
        preserve_rows = temp(:);
        
        %--------------A---------------
        temp1 = slice_marginal(nout, 6, [1 2 3]);
        temp2 = slice_marginal(nout, 6, [4 3]);
        temp3 = slice_marginal(nout, 6, [5 1]);
        temp4 = slice_marginal(nout, 6, [6 2]);
        temp5 = slice_marginal(nout, 6, [4 5 6]);
        A = [temp1;
            temp2(preserve_rows,:);
            temp3(preserve_rows,:);
            temp4(preserve_rows,:);
            temp5(2:size(temp5,1),:)]...
            * switch_basis_mat('full', 'CG', nout, 6);
        %--------------b---------------
        temp1 = G_ABC;
        temp2 = slice_marginal(nout, 3, [1 3]) * G_ABC;
        temp3 = slice_marginal(nout, 3, [2 1]) * G_ABC;
        temp4 = slice_marginal(nout, 3, [3 2]) * G_ABC;
        temp5 = kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC);
        b = [temp1;
            temp2(preserve_rows,:);
            temp3(preserve_rows,:);
            temp4(preserve_rows,:);
            temp5(2:size(temp5,1),:)];
        % placeholders
        G = 0;
        h = 0;
    case 'corr'
        % Convert to correlator coordinates
        G_ABC = switch_basis_mat('full', 'corr', nout, 3)*P_ABC;
        A = [slice_marginal(nout, 6, [1 2 3]);
            slice_marginal(nout, 6, [4 3]);
            slice_marginal(nout, 6, [5 1]);
            slice_marginal(nout, 6, [6 2]);
            slice_marginal(nout, 6, [4]);
            slice_marginal(nout, 6, [5]);
            slice_marginal(nout, 6, [6]);
            slice_marginal(nout, 6, [4 5 6])]...
            * switch_basis_mat('full', 'corr', nout, 6);
        b = [G_ABC;
            slice_marginal(nout, 3, [1 3]) * G_ABC;
            slice_marginal(nout, 3, [2 1]) * G_ABC;
            slice_marginal(nout, 3, [3 2]) * G_ABC;
            slice_marginal(nout, 3, [1]) * G_ABC;
            slice_marginal(nout, 3, [2]) * G_ABC;
            slice_marginal(nout, 3, [3]) * G_ABC;
            kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC)];
        % placeholders
        G = 0;
        h = 0;
    case 'corr_red'
        % Convert to correlator coordinates
        G_ABC = switch_basis_mat('full', 'corr', nout, 3)*P_ABC;
        A = [slice_marginal(nout, 6, [1 2 3]);
            slice_marginal(nout, 6, [4 3]);
            slice_marginal(nout, 6, [5 1]);
            slice_marginal(nout, 6, [6 2]);
            slice_marginal(nout, 6, [4]);
            slice_marginal(nout, 6, [5]);
            slice_marginal(nout, 6, [6]);
            slice_marginal(nout, 6, [4 5 6])]...
            * switch_basis_mat('full', 'corr', nout, 6);
        b = [G_ABC;
            slice_marginal(nout, 3, [1 3]) * G_ABC;
            slice_marginal(nout, 3, [2 1]) * G_ABC;
            slice_marginal(nout, 3, [3 2]) * G_ABC;
            slice_marginal(nout, 3, [1]) * G_ABC;
            slice_marginal(nout, 3, [2]) * G_ABC;
            slice_marginal(nout, 3, [3]) * G_ABC;
            kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC)];
        
        
        
        G_ABC = switch_basis_mat('full', 'corr', nout, 3)*P_ABC;
        temp = reshape(1:nout^2, [1 1]*nout);
        temp = temp(2:nout,2:nout);
        preserve_rows = temp(:);
        
        %--------------A---------------
        temp1 = slice_marginal(nout, 6, [1 2 3]);
        temp2 = slice_marginal(nout, 6, [4 3]);
        temp3 = slice_marginal(nout, 6, [5 1]);
        temp4 = slice_marginal(nout, 6, [6 2]);
        temp5 = slice_marginal(nout, 6, [4 5 6]);
        A = [temp1;
            temp2(preserve_rows,:);
            temp3(preserve_rows,:);
            temp4(preserve_rows,:);
            temp5(2:size(temp5,1),:)]...
            * switch_basis_mat('full', 'corr', nout, 6);
        %--------------b---------------
        temp1 = G_ABC;
        temp2 = slice_marginal(nout, 3, [1 3]) * G_ABC;
        temp3 = slice_marginal(nout, 3, [2 1]) * G_ABC;
        temp4 = slice_marginal(nout, 3, [3 2]) * G_ABC;
        temp5 = kron(kron(slice_marginal(nout, 3, [3]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [1]) * G_ABC);
        b = [temp1;
            temp2(preserve_rows,:);
            temp3(preserve_rows,:);
            temp4(preserve_rows,:);
            temp5(2:size(temp5,1),:)];
        % placeholders
        G = 0;
        h = 0;
end
end