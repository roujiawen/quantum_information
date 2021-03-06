function SN = cg2p(ndim)
    % input is the dimension (number of variables)
    % variables are binary
    % output will be the change of basis matrix

    S_inv = [0 1; 1 -1]; % change of basis matrix
    SN = kpow(S_inv, ndim);
end