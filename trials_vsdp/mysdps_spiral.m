function [objt,xt,yt,zt,info] = mysdps_spiral(nout, P_ABC, solver, basis, slack, OPTIONS)
use_interval = false;

if nargin < 6
    OPTIONS = [];
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
%if info ~= 0
%    error('VSDP returns error/infeasible');

end
