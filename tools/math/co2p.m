function SN = co2p(ndim)
    % input is the dimension (number of variables)
    % variables are binary
    % output will be the change of basis matrix

    S_inv = [0.5 0.5; 0.5 -0.5]; % change of basis matrix
    SN = kpow(S_inv, ndim);
end