function [verified_lower, verified_upper, stats] = vsdp_wrapper(A, b, c, K, solveropt, verbose, tolerance, use_xu)
% input: problem instance, solver+optimizer, options
% call mysdps, vsdpup, vsdplow
% measure time and iterations at each round
% add custom options (verbose, optimizer, tolerance, etc.)
% output: upper and lower bounds, time and iteration

%% Input args
if nargin < 6
    verbose = 0; % Default: silent
end

if nargin <7
    tolerance = []; % Default: disabled
end

if nargin <8
    use_xu = false; % Default: false
end

%% Solver and optimizer settings
moseks = {'mosek_INTPNT', 'mosek_INTPNT+BI',...
           'mosek_PRIMAL_SIMPLEX', 'mosek_DUAL_SIMPLEX'};
gurobis = {'gurobi_PRIMAL_SIMPLEX', 'gurobi_DUAL_SIMPLEX', 'gurobi_BARRIER'};
solvers = [moseks, gurobis, {'sdpt3', 'sedumi', 'linprog'}];

if ~any(strcmp(solveropt, solvers))
    error('SOLVEROPT value error');
end

% Handling path clash between Mosek and MATLAB linprog
if strcmp(solveropt, 'linprog')
    rmpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
elseif any(strcmp(solveropt, moseks))
    addpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
end

% Split and get solver name
tmp = split(solveropt, '_');
solver = tmp{1}; %mosek, gurobi, sdpt3, sedumi, linprog

% Optimizer settings
OPTIONS = get_optimizer_settings(solver, solveropt);

% for Linprog
OPTIONS.LINPROG_OPTIONS = optimset();

% for Mosek BI
OPTIONS.MOSEK_OPTIONS.MSK_IPAR_BI_MAX_ITERATIONS = 100000;

% Verbose
if verbose == 0
    OPTIONS.MOSEK_OPTIONS.MSK_IPAR_LOG = 0;
    OPTIONS.GUROBI_OPTIONS.OutputFlag = 0;
    OPTIONS.SEDUMI_OPTIONS.fid = 0;
    OPTIONS.SDPT3_OPTIONS.printlevel = 0;
    OPTIONS.LINPROG_OPTIONS = optimset(OPTIONS.LINPROG_OPTIONS,...
        'LargeScale','on', 'Display', 'off');
end

% Tolerance
if ~isempty(tolerance)
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_PFEAS = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_DFEAS = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_REL_GAP = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_INFEAS = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_MU_RED = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_PFEAS = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_DFEAS = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_INFEAS = tolerance;
    OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_REL_GAP = max( 1e-14, tolerance);
    
    OPTIONS.GUROBI_OPTIONS.BarConvTol = tolerance;
    OPTIONS.GUROBI_OPTIONS.FeasibilityTol = max(1e-9, tolerance);
    OPTIONS.GUROBI_OPTIONS.MarkowitzTol = max(1e-4, tolerance);
    OPTIONS.GUROBI_OPTIONS.OptimalityTol = max(1e-9, tolerance);
    
    OPTIONS.SEDUMI_OPTIONS.eps = tolerance;
    OPTIONS.SDPT3_OPTIONS.gaptol = tolerance; %1e-8;
    OPTIONS.LINPROG_OPTIONS = optimset(OPTIONS.LINPROG_OPTIONS,...
        'TolFun', max(1e-10, tolerance), 'TolCon', max(1e-9, tolerance));
end

%% Call VSDP
stats = struct();
vsdpinit(solver);

tic;
[objt,xt,yt,zt,info] = mysdps(A,b,c,K,[],[],[],OPTIONS);
stats.mysdps_time = toc;

if info ~= 0
    fprintf('#Non-optimal return code: %d#\n', info);
end

% Calculate verified bounds
if use_xu
    tic;
    [verified_lower,y,dl,info] = vsdplow(A,b,c,K,xt,yt,zt,ones(length(c),1),OPTIONS);
    stats.vsdplow_time = toc;
    stats.vsdplow_iter = info.mysdps_iter;
    % Placeholders
    stats.vsdpup_time = 0;
    stats.vsdpup_iter = 0;
    verified_upper = 0;
else
    tic;
    [verified_lower,y,dl,info] = vsdplow(A,b,c,K,xt,yt,zt,[],OPTIONS);
    stats.vsdplow_time = toc;
    stats.vsdplow_iter = info.mysdps_iter;
    % Placeholders
    stats.vsdpup_time = 0;
    stats.vsdpup_iter = 0;
    verified_upper = 0;
    %tic;
    %[verified_lower,y,dl,info] = vsdplow(A,b,c,K,xt,yt,zt,[],OPTIONS);
    %stats.vsdplow_time = toc;
    %stats.vsdplow_iter = info.mysdps_iter;
%     verified_lower = 0;
%     stats.vsdplow_time = 0;
%     stats.vsdplow_iter = 0;
% 
%     tic;
%     [verified_upper,x,lb,info] = vsdpup(A,b,c,K,xt,yt,zt,[],OPTIONS);
%     stats.vsdpup_time = toc;
%     stats.vsdpup_iter = info.mysdps_iter;
end

%% Clean-up
% Added Mosek back to MATLAB path
addpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
end

function OPTIONS = get_optimizer_settings(solver, solveropt)
OPTIONS = struct();
switch solver
    case 'mosek'
        switch solveropt
            case 'mosek_INTPNT'
                OPTIONS.MOSEK_OPTIONS.MSK_IPAR_OPTIMIZER = ...
                    'MSK_OPTIMIZER_INTPNT';
                OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 0;
            
            case 'mosek_INTPNT+BI'
                % default
                OPTIONS.MOSEK_OPTIONS.MSK_IPAR_OPTIMIZER = ...
                    'MSK_OPTIMIZER_INTPNT';
                OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 1;
           
            case 'mosek_PRIMAL_SIMPLEX'
                OPTIONS.MOSEK_OPTIONS.MSK_IPAR_OPTIMIZER = ...
                    'MSK_OPTIMIZER_PRIMAL_SIMPLEX';
            
            case 'mosek_DUAL_SIMPLEX'
                OPTIONS.MOSEK_OPTIONS.MSK_IPAR_OPTIMIZER = ...
                    'MSK_OPTIMIZER_DUAL_SIMPLEX';
        end
    case 'gurobi'
        switch solveropt
            case 'gurobi_PRIMAL_SIMPLEX'
                OPTIONS.GUROBI_OPTIONS.Method = 0;
                
            case 'gurobi_DUAL_SIMPLEX'
                OPTIONS.GUROBI_OPTIONS.Method = 1;
                
            case 'gurobi_BARRIER'
                OPTIONS.GUROBI_OPTIONS.Method = 2;
        end
end
end