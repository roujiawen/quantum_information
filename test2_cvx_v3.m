% Compare noslack vs. slack
const_type = 'eq';
cvx_solver_settings('-clearall');
cvx_solver('Mosek');
cvx_solver_settings('MSK_IPAR_OPTIMIZER', 'MSK_OPTIMIZER_INTPNT');
cvx_solver_settings('MSK_IPAR_INTPNT_BASIS', 0);

%% I/O
test_data_path = 'logs/mid_ver_fea_test_cases_v1.mat';
load(test_data_path);
ntrials = size(test_cases, 2);
results_data_path = 'results/test2_cvx_fea_no_bi_v3';

% Output data file
headers = {'trial', 'basis', 'slack',...
    'cvx_cputime', 'cvx_status', 'primal opt', 'dual opt', 'gap',...
    'cvx_optbnd', 'cvx_slvitr', 'cvx_slvtol'};
data = headers;

%% Trials
for k = 1:ntrials
    P_ABC = test_cases(:,k);% No intervals
    for basis_tmp = {'full', 'CG'}
        for slack_tmp = {'noslack', 'slack(x>=t)', 'slack(z=x-t)'}
            slack = slack_tmp{1};
            basis = basis_tmp{1};
% Print progress
fprintf('%d %s %s\n', k, basis, slack);
% Get basis formulation and slack formulation
[A, b] = get_spiral_form(const_type, basis, P_ABC);
% Run CVX

n = size(A, 2);
switch slack
    case {0, 'noslack'}
        cvx_begin quiet
            variable x(n);
            dual variable y;
            y: A * x == b;
            x >= 0;
        cvx_end
        primalopt = cvx_optval;
        dualopt = -dot(b,y);
    case {'slack(x>=t)'}
        cvx_begin quiet
            variables x(n) t;
            dual variable y;
            maximize t;
            y: A * x == b;
            x >= t;
        cvx_end
        primalopt = cvx_optval;
        dualopt = -dot(b,y);
    case {'slack(z=x-t)'}
        A_sum = sum(A, 2);
        cvx_begin quiet
            variables x(n+1) ;
            dual variable y;
            maximize x(1);
            subject to
                y: [A_sum A] * x == b;
                x(2:n+1) >= 0;
        cvx_end
        primalopt = cvx_optval;
        dualopt = -dot(b,y);
end
gap = primalopt-dualopt;
stats = {cvx_cputime, cvx_status,...
         primalopt, dualopt, gap,...
         cvx_optbnd, cvx_slvitr, cvx_slvtol};
% Add data row to master table
datarow = [{k}, {basis}, {slack}, stats];
data = [data; datarow];
% Update master table to .csv file and .mat file
%cell2csv(strcat(results_data_path, '.csv'), data);
save(results_data_path, 'data');
        end
    end
end
