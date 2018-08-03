function dist = inter_dist(eta, use_interval)
% INTER_DIST Interpolate a mid point between two distributions, given
% parameter eta

if nargin < 2
    use_interval = false;%default
end

% infeasible
dist_A = get_dist('complete correlation', use_interval);
% feasible
dist_B = get_dist('uniform', use_interval);
% Take the convex combination
dist = (1-eta) * dist_A + eta * dist_B;

end
