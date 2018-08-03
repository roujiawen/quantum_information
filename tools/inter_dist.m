function dist = inter_dist(eta, interval)
% INTER_DIST Interpolate a mid point between two distributions, given
% parameter eta

if nargin < 2
    interval = false;%default
end

% infeasible
dist_A = get_dist('complete correlation', interval);
% feasible
dist_B = get_dist('uniform', interval);
% Take the convex combination
dist = (1-eta) * dist_A + eta * dist_B;

end
