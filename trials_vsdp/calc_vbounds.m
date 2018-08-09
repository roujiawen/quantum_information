function [ubs, lbs] = calc_vbounds(nout, dist_A, dist_B, solver, basis, slack, start_point, stop_point, steps, verbose, use_interval)
% CALC_VBOUNDS

%% INTVAL
if nargin < 11
    use_interval = false;%default
end

%% OPTIONS

if nargin < 10
    verbose = 0;%default
end

OPTIONS = struct();
% INTPNT_ONLY
if strcmp(solver, 'mosek_INTPNT_ONLY')
    solver = 'mosek';
    OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 0;
end

if strcmp(solver, 'mosek_INTPNT_ITR')
    solver = 'mosek';
end

if strcmp(solver, 'mosek_INTPNT_BAS')
    OPTIONS.MOSEK_OPTIONS.MSK_IPAR_INTPNT_BASIS = 1;
    solver = 'mosek';
end
% VERBOSE
if verbose == 0
    OPTIONS.MOSEK_OPTIONS.MSK_IPAR_LOG = 0;
    OPTIONS.SEDUMI_OPTIONS.fid = 0;
    OPTIONS.SDPT3_OPTIONS.printlevel = 0;
    OPTIONS.LINPROG_OPTIONS = optimset('LargeScale','on', 'Display', 'off');
end
% TOLERANCE
tolerance = 0;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_PFEAS = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_DFEAS = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_REL_GAP = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_INFEAS = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_CO_TOL_MU_RED = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_PFEAS = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_DFEAS = tolerance;
% OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL _INFEAS = tolerance;
%OPTIONS.MOSEK_OPTIONS.MSK_DPAR_INTPNT_TOL_REL_GAP = max( 1e-14, tolerance);
OPTIONS.SEDUMI_OPTIONS.eps = tolerance;
%OPTIONS.SDPT3_OPTIONS.gaptol = 1e-8;%tolerance;
if verbose == 0
    OPTIONS.LINPROG_OPTIONS = optimset(OPTIONS.LINPROG_OPTIONS,...
        'TolFun', max(1e-10, tolerance), 'TolCon', max(1e-9, tolerance));
else
    OPTIONS.LINPROG_OPTIONS = optimset(...
        'TolFun', max(1e-10, tolerance), 'TolCon', max(1e-9, tolerance));
end

%% Handling name clash between Mosek and MATLAB linprog
if strcmp(solver, 'linprog')
    rmpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
elseif strcmp(solver, 'mosek')
    addpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
end

interval = (stop_point-start_point)/steps;
ubs = zeros(1, steps+1);
lbs = zeros(1, steps+1);
counter = 0;
range_ = start_point:interval:stop_point;
textprogressbar(sprintf('Calculating bounds with %s: ', solver));

for eta = range_
    textprogressbar((eta-start_point)/(stop_point-start_point)*100);
    
    % Distribution and constraints
    [fU, fL] = vbounds_spiral(nout, eta, dist_A, dist_B,...
        solver, basis, slack, OPTIONS, use_interval);
    
    % Store bounds
    counter = counter + 1;
    ubs(counter) = fU;
    lbs(counter) = fL;
end
textprogressbar('Done!');

addpath('/Users/work/Documents/MATLAB/mosek/8/toolbox/r2014a');
end