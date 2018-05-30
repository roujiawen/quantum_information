function M = pmarginal(A, order)
    % similar to permute_sum, except:
    % input can be flat or nonflat
    % output will be a flattened column vector
    % only for binary variables
    
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
    A = permute(A, [order rest]); % swap axes => shape:[7,2,5,3,11]
    m = 2^length(order);
    n = 2^length(rest);
    A = reshape(A, [m, n]); % new shape: [7*2*5, 3*11]
    M = A * ones(n, 1); % [7*2*5, 3*11] * [3*11, 1]
end