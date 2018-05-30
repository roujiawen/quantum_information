function M = cgmarginal(A, order)
% cgmarginal Marginal of a probability distribution (for 
% binary variables) in Collins-Gisin notation.
%
% Inputs:
% A     Probability vector in Collins-Gisin notation. It can
%       either be a column vector of size (2^N, 1) or a N-D
%       matrix with size (2, 2, ..., 2).
% order a row vector specifying the axes to marginalize
%       over. The order matters.
%
% Outputs:
% A column vector, the marginal probability distribution.
%
% Example:
% >> cgmarginal([0.5 0; 0.2 0.3], [1])
%
% ans =
% 
%     0.5000
%     0.2000
    
    ndim = log2(length(A(:))); % number of dimensions of input
    
    if floor(ndim) ~= ndim
       error('Error. Length of A must be a power of 2.')
    end
    
    if ndim>1
        A = reshape(A, ones(1, ndim)*2);
    else
        A = A(:); % column vector
    end
    
    if any(floor(order) ~= order) || any(order > ndim)
       error('Error. ORDER contains an invalid permutation index.')
    end
    
    rest = setdiff(1:ndim, order); % e.g. order = [4 1 3]; rest = [2 5]
    A = permute(A, [rest order]); % swap axes => [2 5 4 1 3]
    for i = rest
        A = A(1, :);
        ndim = ndim - 1;
        if ndim>1
            A = reshape(A, ones(1, ndim)*2);
        end
    end % [4 1 3]
    M = A(:);
end