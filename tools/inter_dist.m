function dist = inter_dist(eta, dist_A, dist_B, use_interval)
% INTER_DIST Interpolate a mid point between two distributions, given
% parameter eta

if (nargin < 3) || isempty(dist_A) || isempty(dist_B)
    % infeasible
    dist_A = get_dist('complete correlation', use_interval);
    % feasible
    dist_B = get_dist('uniform', use_interval);
end

if nargin < 4
    use_interval = false;%default
end

if use_interval
    eta = intval(eta);
end

% Take the convex combination
dist = (1-eta) * dist_A + eta * dist_B;

end
