function test_cases = gen_test_case(fea, n_sample, filepath)
%% PARAMS
verbose = 1;
use_interval = true;
l_out = 2;
h_out = 4;
nvar = 3;

%% INPUT ARGS
if nargin < 2
    n_sample = 1;
end

if nargin < 3
    filepath = [];
end
%%
% Get eta at 10^-3 around feasibility border
if fea%feasible
    eta = 1/2+1e-3;
else%infeasible
    eta = 1/2-1e-3;
end

% Get 2-outcome distribution
out2_dist = inter_dist(eta, [], [], use_interval);

%% Generating N random test_cases
test_cases = intval(zeros(h_out^nvar, n_sample));
for k = 1:n_sample
    disp(k);
    certified = false;
    while ~certified%Keep generating new sample until certified
        % Blow-up to 4-outcome randomly
        out4_dist = low2high_dist(l_out, out2_dist, h_out, use_interval);
        % Call VSDP
        if verbose>0
            disp('Verifying with VSDP');
        end
        [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
            verify_spiral_fea(h_out, out4_dist, use_interval);
        % Display output
        if verbose>0
            disp(info);
            %disp(['  #' best_ub_info]);
            %disp(['  #' best_lb_info]);
        end
        % Certified?
        if fea && strcmp(info, 'Certified Feasible')
            % Try again with mid values
            if verbose>0
                disp('Try again with mid()');
            end
            [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
                verify_spiral_fea(h_out, mid(out4_dist), false);
            if strcmp(info, 'Certified Feasible')
                if verbose>0
                    disp('Certified Feasible with mid()');
                    %disp(['  #' best_ub_info]);
                    %disp(['  #' best_lb_info]);
                end
                certified = true;
            else
                disp('VSDP catastrophy');
                dt = datestr(datetime('now'), 'mmm-dd-yyyy_HH.MM');
                cata_path = sprintf('logs/cata_%s.mat', dt);
                save(cata_path, 'out4_dist');
            end
        elseif ~fea && strcmp(info, 'Certified Infeasible')
            % Try again with mid values
            if verbose>0
                disp('Try again with mid()');
            end
            [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
                verify_spiral_fea(h_out, mid(out4_dist), false);
            if strcmp(info, 'Certified Infeasible')
                if verbose>0
                    disp('Certified Infeasible with mid()');
                    %disp(['  #' best_ub_info]);
                    %disp(['  #' best_lb_info]);
                end
                certified = true;
            else
                disp('VSDP catastrophy');
                dt = datestr(datetime('now'), 'mmm-dd-yyyy_HH.MM');
                cata_path = sprintf('logs/cata_%s.mat', dt);
                save(cata_path, 'out4_dist');
            end
        else %Otherwise not certified
            if verbose>0
                disp('Failed to certify generated test case');
            end
        end
    end
    test_cases(:, k) = out4_dist;
    if ~isempty(filepath)
        save(filepath, 'test_cases');
    end
end
end