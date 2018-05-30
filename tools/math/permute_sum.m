function M = permute_sum(A, order)
    % variables can be arbitrary d-ary
    % input and output are both nonflattened matrices
    in_shape = size(A); % shape of input (e.g.[2,3,5,7,11])
    ndim = length(in_shape); % number of dimensions of input (e.g. 5)
    
    if any(floor(order) ~= order) || any(order > ndim)
       error('Error. ORDER contains an invalid permutation index.')
    end
    
    rest = setdiff(1:ndim, order); % e.g. order = [4 1 3]; rest = [2 5]
    A = permute(A, [order rest]); % swap axes => shape:[7,2,5,3,11]
    out_shape = in_shape(order); % [7,2,5]
    rest_prod = prod(in_shape(rest)); % prod([3,11])
    A = reshape(A, [prod(out_shape), rest_prod]);% new shape: [7*2*5, 3*11]
    A = A * ones(rest_prod, 1); % [7*2*5, 3*11] * [3*11, 1]
    switch length(out_shape)
        case 1
            M = A;
        case 0
            M = [];
        otherwise
            M = reshape(A, out_shape);
    end
end