function SN = p2co(ndim)
    % input is the dimension (number of variables)
    % variables are binary
    % output will be the change of basis matrix

    if floor(ndim) ~= ndim
       error('Error. Dimension must be an integer.')
    end
    S = [1 1; 1 -1]; % change of basis matrix for two vars
    SN = kpow(S, ndim);
end