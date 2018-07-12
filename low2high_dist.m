function h_dist = low2high_dist(l_dist, l_out, h_out, infea, conv_mat)
% LOW2HIGH_DIST generate random distribution with higher number of 
% outcomes which has the same feasibility with a corresponding 
% distribution with lower number of outcomes.
% Assumes 3 observed variables (triangle scenario)
nvar = 3;

% default input: infea = false
if nargin < 4
    infea = false;
end

% If conversion matrices (e.g. P(a'|a)) not given, generate randomly
if nargin < 5
    if infea == false
        % For feasible distribution, generate random matrix
        conv_mat = rand(h_out, l_out, nvar);

        % Normalize probabilities
        col_sums = sum(conv_mat, 1);
        divisor = repmat(col_sums, h_out, 1, 1);
        conv_mat = conv_mat ./ divisor;

    else
        % For infeasible distribution, generate random invertible matrix
        % Normalize probabilities
        error("Not implemented");
    end
end

%conv_mat
% Take kronecker product e.g. C x B x A
kron_prod = 1;
for k = 1:nvar
    kron_prod = kron(kron_prod, conv_mat(:,:,k));
end

% Multiply by original distribution
h_dist = kron_prod * l_dist;

%---------Code for verbose printouts---------
% rank(kron_prod)
% spy(kron_prod);
% find(h_dist)
% sum(sort(65 - find(h_dist)) ~= find(h_dist)) == 0
% h_dist(find(h_dist))

end
% call h_out = 4; h_dist = low2high_dist(get_dist("uniform"), 2, h_out);cvx_spiral(h_out, h_dist, 'full', 1)