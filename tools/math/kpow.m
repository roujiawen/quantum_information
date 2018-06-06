function A = kpow(M, n)
    if ~is_pos_int(n)
       error('Error. N must be a positive integer.')
    end
    A = M;
    for i = 2:1:n
        A = kron(A, M);
    end
end