function dist = inter_dist(eta)
% INTER_DIST Interpolate a mid point between two distributions, given
% parameter eta

% infeasible
dist_A = get_dist('complete correlation');
% feasible
dist_B = get_dist('uniform');
% Take the convex combination
dist = (1-eta) * dist_A + eta * dist_B;

end
