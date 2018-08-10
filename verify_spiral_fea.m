function [info, best_ub, best_ub_info, best_lb, best_lb_info] =...
    verify_spiral_fea(nout, P_ABC, use_interval)
solvers = {'mosek' 'sedumi'};
basis = 'CG_red';
slacks = {'slack(z=x+t-1)' 'slack(z=x-t)'};
total_run = length(solvers) * length(slacks);
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
for solver_tmp = solvers
    for slack_tmp = slacks
        solver = solver_tmp{1};
        slack = slack_tmp{1};
        run_count = run_count + 1;
        if verbose > 0
            fprintf('(%d/%d)Running %s %s\n', run_count, total_run, solver, slack);
        end
        [A_, b_, tmp, tmp] = get_spiral_constraints(nout, P_ABC, basis, use_interval);
        K = struct();
        switch slack
            case {0, 'noslack'}
                %-------------no slack---------------
                A = A_;
                b = b_;
                [m, n] = size(A);
                K.l = n;
                c = zeros(n,1);
            case {11, 'slack(x>=t)_old'}
                %-------------slack(x>=t) old redundant-------------------
                [m_, n_] = size(A_);
                A = [A_ zeros(m_, n_+1);
                     eye(n_) -ones(n_, 1) -eye(n_)];
                b = [b_;
                    zeros(n_, 1)];
                K.f = n_+1;
                K.l = n_;
                c = [zeros(n_,1);
                     -1;
                     zeros(n_,1)];
            case {1, 'slack(z=x-t)'}
                %-------------slack(x>=t/z=x-t)-------------------
                A_sum = sum(A_, 2);
                A = [A_sum A_];
                b = b_;
                [m, n] = size(A);
                K.f = 1;
                K.l = n-1;
                c = [-1; %maximize t
                    zeros(n-1,1);];
            case {3, 'slack(z=x+t-1)'}
                %--------------slack(z=x+t-1)---------------
                A_sum = sum(A_, 2);
                A = [A_ -A_sum];
                b = b_ - A_sum;
                [m, n] = size(A);
                K.l = n;
                c = [zeros(n-1, 1);
                    1];%minimize t
        end

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
            best_lb_info = [solver ' ' slack];
        end
        if fU < best_ub
            best_ub = fU;
            best_ub_info = [solver ' ' slack];
        end
        
        [if_stop, info] = check_stop(best_lb, best_ub);
        if if_stop
            return;
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