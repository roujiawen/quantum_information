function [A, b, c, K] = get_slack_vsdp_form(A_, b_, slack)

const_type = 'eq';

K = struct();
switch slack
    case {0, 'noslack'}
        %-------------no slack---------------
        A = A_;
        b = b_;
        [m, n] = size(A);
        K.l = n;
        c = zeros(n,1);
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
end