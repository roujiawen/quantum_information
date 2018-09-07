% Compare noslack vs. slack
const_type = 'eq';
cvx_solver_settings('-clearall');
cvx_solver('sedumi');
%cvx_solver_settings('dumpfile','cvx_sedumi.mat');

test_data_path = 'logs/mid_ver_infea_test_cases_v1.mat';
load(test_data_path);

basis = 'full';
P_ABC = get_dist('W-type');%test_cases(:,1);

% Get basis formulation and slack formulation
[A, b] = get_spiral_form(const_type, basis, P_ABC);

% Run CVX
n = size(A, 2);

A_sum = sum(A, 2);
cvx_begin
    variables x(n+1) ;
    dual variable y;
    maximize x(1);
    subject to
        y: [A_sum A] * x == b;
        x(2:n+1) >= 0;
cvx_end

primalopt = cvx_optval;
dualopt = -dot(b,y);

primalopt = cvx_optval;
dualopt = -dot(b,y);


