function SN = p2cg(ndim)
    % input is the dimension (number of variables)
    % variables are binary
    % output will be the change of basis matrix

    S = [1 1; 1 0]; % change of basis matrix for two vars
    SN = kpow(S, ndim);
end