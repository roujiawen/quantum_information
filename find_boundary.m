%% Params
verbose = 0;
use_interval = true;
solvers = {'mosek_INTPNT_ITR' 'mosek_INTPNT_ONLY'};
const_type = 'eq';
basis = 'corr';
%slack = 'slack(z=x+t-1)'; slackcode = 3;
%slack = 'slack(z=x-t)'; slackcode = 1;

nout = 2;

start_point = 0.5-1e-12;
stop_point =  0.5;

steps = 10;

%% I/O
dt = datestr(datetime('now'), 'mmm-dd-yyyy_HH.MM');
results_path = sprintf('results/find_boundary_%s.mat', dt);

data = struct();
data.start_point = start_point; data.stop_point = stop_point;
data.steps = steps; data.nout = nout; data.basis = basis;
data.const_type = const_type;


%% Trials
for solver_tmp = solvers
    presolver = solver_tmp{1};
    %% OPTIONS

        OPTIONS = struct();
        % VERBOSE
        if verbose == 0
            OPTIONS.MOSEK_OPTIONS.MSK_IPAR_LOG = 0;
            OPTIONS.SEDUMI_OPTIONS.fid = 0;
            OPTIONS.SDPT3_OPTIONS.printlevel = 0;
            OPTIONS.LINPROG_OPTIONS = optimset('LargeScale','on', 'Display', 'off');
        end
        % TOLERANCE
        tolerance = 0;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_PFEAS = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_DFEAS = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_REL_GAP = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_INFEAS = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_MU_RED = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_PFEAS = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_DFEAS = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_INFEAS = tolerance;
        OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_REL_GAP = max( 1e-14, tolerance);
        OPTIONS.SEDUMI_OPTIONS.eps = tolerance;
        %OPTIONS.SDPT3_OPTIONS.gaptol = 1e-8;%tolerance;
        if verbose == 0
            OPTIONS.LINPROG_OPTIONS = optimset(OPTIONS.LINPROG_OPTIONS,...
                'TolFun', max(1e-10, tolerance), 'TolCon', max(1e-9, tolerance));
        else
            OPTIONS.LINPROG_OPTIONS = optimset(...
                'TolFun', max(1e-10, tolerance), 'TolCon', max(1e-9, tolerance));
        end

        % INTPNT_ONLY
        if strcmp(presolver, 'mosek_INTPNT_ONLY')
            solver = 'mosek';
            OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 0;
        elseif strcmp(presolver, 'mosek_INTPNT_ITR')
            solver = 'mosek';
        elseif strcmp(presolver, 'mosek_INTPNT_BAS')
            OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 1;
            solver = 'mosek';
        else 
            solver = presolver;
        end
        
    % Handling name clash between Mosek and MATLAB linprog
    if strcmp(solver, 'linprog')
        rmpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
    elseif strcmp(solver, 'mosek')
        addpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
    end
    % Calculate interval and range
    interval = (stop_point-start_point)/steps;
    ubs = zeros(1, steps+1);
    lbs = zeros(1, steps+1);
    counter = 0;
    range_ = start_point:interval:stop_point;
    
    textprogressbar(sprintf('Calculating bounds with %s: ', presolver));
    for eta = range_
        textprogressbar((eta-start_point)/(stop_point-start_point)*100);
        
        % Get P_ABC and constraint formulation
        P_ABC = inter_dist(eta, [], [], use_interval);
        [A, b] = get_spiral_form(const_type, basis, P_ABC, use_interval);
        [m, n] = size(A);
        K = struct();
        K.l = n;%nonnegative cone
        c = zeros(n,1);
        
        % Call VSDP
        vsdpinit(solver, 0);

        [objt,xt,yt,zt,info] = mysdps(A,b,c,K,[],[],[],OPTIONS);
        if info ~= 0
            fprintf('#%d#\n', info);
        end

        % Calculate verified bounds
        %[fL,y,dl] = vsdplow(A,b,c,K,xt,yt,zt,[],OPTIONS);
        %[fU,x,lb] = vsdpup(A,b,c,K,xt,yt,zt,[],OPTIONS);
        infeas = vsdpinfeas(A,b,c,K,'p',xt,yt,zt,OPTIONS);

        % Store bounds
        counter = counter + 1;
        infeas_list(counter) = infeas;
    end
    textprogressbar('Done!');

    addpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
    data.([presolver '_lbs']) = infeas_list;
end

save(results_path, 'data');


%% Call plotting function
lb_plot(results_path);
