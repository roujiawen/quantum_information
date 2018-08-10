function samples = gen_test_case(fea, n_sample)
%% PARAMS
verbose = 0;
use_interval = true;
l_out = 2;
h_out = 4;
nvar = 3;

%% INPUT ARGS
if nargin < 2
    n_sample = 1;
end

%%
% Get eta at 10^-3 around feasibility border
if fea%feasible
    eta = 1/3+1e-3;
else%infeasible
    eta = 1/3-1e-3;
end

% Get 2-outcome distribution
out2_dist = inter_dist(eta, [], [], use_interval);

%% Generating N random samples
samples = intval(zeros(h_out^nvar, n_sample));
for k = 1:n_sample
    certified = false;
    while ~certified%Keep generating new sample until certified
        % Blow-up to 4-outcome randomly
        out4_dist = low2high_dist(l_out, out2_dist, h_out, use_interval);
        % Call VSDP
        if verbose>0
            disp('Verifying with VSDP');
        end
        [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
            verify_spiral_fea(h_out, out4_dist, true);
        % Display output
        if verbose>0
            disp(info);
        end
        % Certified?
        if fea && strcmp(info, 'Certified Feasible')
            certified = true;
        elseif ~fea && strcmp(info, 'Certified Infeasible')
            certified = true;
        else %Otherwise not certified
            if verbose>0
                disp('Failed to certify generated test case');
            end
        end
    end
    [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
            verify_spiral_fea(h_out, mid(out4_dist), false);
    if fea
        if ~strcmp(info, 'Certified Feasible')
            error('BAD');
        end
    else
        if ~strcmp(info, 'Certified Infeasible')
            error('BAD');
        end
    end
    disp(k);
    samples(:, k) = out4_dist;
end
end