function G = p2cg(P)
    % input can be flat or nonflat
    % output will be a flattened column vector
    % only for binary variables
    P = P(:); % in case P is not flattened
    ndim = log2(length(P));
    if floor(ndim) ~= ndim
       error('Error. Length of P must be a power of 2.')
    end
    S = [1 1; 1 0]; % change of basis matrix
    G = kpow(S, ndim) * P;
end