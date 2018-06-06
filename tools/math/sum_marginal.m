function M = sum_marginal(nout, nvar, axes)
%SUM_MARGINAL Filter matrix that takes the marginal of a 
% probability distribution in the `summing` manner (for full
% joint probability vectors). e.g. P_BA = M * P_ABC
%
% Inputs:
% nout   An integer, the number of outcomes for each random variable.
%        (e.g. nout for binary variables is 2)
% nvar  An integer specifying the number of variables in the joint
%        probability distribution. (e.g. nvar for P_ABC is 3)
% axes  A row vector specifying the axes to marginalize
%       over. The order matters.
%
% Outputs:
% M     A sparse matrix which is the filter, of size 
%       (length(filtered_vector), length(original_vector))
%
% Example:
% >> sum_marginal(2, 3, [3 2])
%
% ans =
% 
%    (1,1)        1
%    (1,2)        1
%    (3,3)        1
%    (3,4)        1
%    (2,5)        1
%    (2,6)        1
%    (4,7)        1
%    (4,8)        1
%
% -----------------------------------------------------
    

    if ~is_pos_int([nout, nvar, axes])
       error('Error. INPUT must be positive integers.')
    end
    if any(axes > nvar)
       error('Error. AXES contains an invalid permutation index.')
    end
    
    % Create index array A= [1, 2, 3, ..., nout^nvar]
    ini_len = nout^nvar;
    A = 1:ini_len;
    
    % Reshape A into either a nvar-dimensional matrix or a column vector
    if nvar>1
        A = reshape(A, ones(1, nvar)*nout); 
    else
        A = A(:);
    end
    
    % Permute and reshape into 2D matrix with shape (m,n)
    rest = setdiff(1:nvar, axes);
    A = permute(A, [axes rest]); 
    m = nout^length(axes);
    n = nout^length(rest);
    A = reshape(A, [m, n]);
    
    % Create filter matrix with shape (fin_len/m, ini_len)
    M=sparse(repmat(1:m,1,n), A, ones(m,n), m, ini_len);
    

end