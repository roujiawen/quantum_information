function ans = kpow(M, n)
    if n < 1 || floor(n) ~= n
       error('Error. Input must be a positive integer.')
    end
    ans = M;
    for i = 2:1:n
        ans = kron(ans, M);
    end
end