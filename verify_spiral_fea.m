function [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
    verify_spiral_fea(nout, P_ABC, use_interval)
solvers = {'mosek' 'sdpt3' 'sedumi'};
bases = {'full' 'CG' 'corr'};
solvers = solvers(randperm(numel(solvers)));
bases = bases(randperm(numel(bases)));

const_type = 'eq';
slacks = {'slack(z=x+t-1)' 'slack(z=x-t)'};
total_run = length(solvers) * length(slacks) * length(bases);
run_count = 0;
verbose = 0;

%% Solver options
OPTIONS = struct();
OPTIONS.MOSEK_OPTIONS.MSK_IPAR_BI_MAX_ITERATIONS = 100000;

% VERBOSE
if verbose < 2
    OPTIONS.MOSEK_OPTIONS.MSK_IPAR_LOG = 0;
    OPTIONS.SEDUMI_OPTIONS.fid = 0;
    OPTIONS.SDPT3_OPTIONS.printlevel = 0;
    OPTIONS.LINPROG_OPTIONS = optimset('LargeScale','on', 'Display', 'off');
end
% TOLERANCE
OPTIONS.SEDUMI_OPTIONS.eps = 0;

%%
best_ub = inf;
best_lb = -inf;
best_ub_info = '';
best_lb_info = '';

%% Formulation
for basis_tmp = bases
    for slack_tmp = slacks
        for solver_tmp = solvers
            solver = solver_tmp{1};
            basis = basis_tmp{1};
            slack = slack_tmp{1};
            run_count = run_count + 1;
            if verbose > 0
                fprintf('(%d/%d)Running %s %s\n', run_count, total_run, solver, slack);
            end
            
            [A_, b_] = get_spiral_form(const_type, basis, P_ABC, use_interval);
            [A, b, c, K] = get_slack_vsdp_form(A_, b_, slack);
            
            % Call VSDP
            vsdpinit(solver, 0);
            
            [objt,xt,yt,zt,info] = mysdps(A,b,c,K,[],[],[],OPTIONS);
            if info ~= 0
                fprintf('#%d#\n', info);
            end
            
            % Calculate verified bounds
            [fL,y,dl] = vsdplow(A,b,c,K,xt,yt,zt,[],OPTIONS);
            [fU,x,lb] = vsdpup(A,b,c,K,xt,yt,zt,[],OPTIONS);
            
            % Standardize
            if strcmp(slack, 'slack(z=x+t-1)')
                fL = fL - 1;
                fU = fU - 1;
            end
            
            if fL > best_lb
                best_lb = fL;
                best_lb_info = [solver ' ' basis ' ' slack];
            end
            if fU < best_ub
                best_ub = fU;
                best_ub_info = [solver ' ' basis ' ' slack];
            end
            
            [if_stop, info] = check_stop(best_lb, best_ub);
            if if_stop
                return;
            end
        end
    end
end

end

function [if_stop, info] = check_stop(best_lb, best_ub)
%% Output message
if_stop = true;
if best_lb > best_ub
    info = 'ERROR: Lower bound exceeds upper bound';
    return;
end

if best_lb > 0
    info = 'Certified Infeasible';
    return;
end

if best_ub < 0
    info = 'Certified Feasible';
    return;
end

if_stop = false;
info = 'Inconclusive';
end