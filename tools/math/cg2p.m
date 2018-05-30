function P = cg2p(G)
    % input can be flat or nonflat
    % output will be a flattened column vector
    % only for binary variables
    G = G(:); % in case G is not flattened
    ndim = log2(length(G));
    if floor(ndim) ~= ndim
       error('Error. Length of G must be a power of 2.')
    end
    S_inv = [0 1; 1 -1]; % change of basis matrix
    P = kpow(S_inv, ndim) * G;
end