function M = pmarginal(ndim, axes)
% pmarginal Filter-sum matrix that takes the marginal of a 
% joint probability vector (for binary variables) along
% given axes. e.g. P_BA = M * P_ABC
%
% Inputs:
% ndim  The dimension of the original probability vector 
%       e.g. ndim(P_ABC) = 3
% axes  A row vector specifying the axes to marginalize
%       over. The order does matter.
%
% Outputs:
% M     A sparse matrix which is the filter, of size 
%       (length(filtered_vector), length(original_vector))
%
% Example:
% >> pmarginal(3, [3 2])
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
    
    if floor(ndim) ~= ndim
       error('Error. Dimension must be an integer.')
    end
    if any(floor(axes) ~= axes) || any(axes > ndim)
       error('Error. AXES contains an invalid permutation index.')
    end
    
    % Create index array A= [1, 2, 3, ..., 2^N]
    ini_len = 2^ndim;
    A = 1:ini_len;
    
    % Reshape A into either a N-D matrix or a column vector
    if ndim>1
        A = reshape(A, ones(1, ndim)*2); 
    else
        A = A(:);
    end
    
    % Permute and reshape into 2D matrix with shape (m,n)
    rest = setdiff(1:ndim, axes);
    A = permute(A, [axes rest]); 
    m = 2^length(axes);
    n = 2^length(rest);
    A = reshape(A, [m, n]);
    
    % Create filter matrix with shape (fin_len/m, ini_len)
    M=sparse(repmat(1:m,1,n), A, ones(m,n), m, ini_len);
    
end