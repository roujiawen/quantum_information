solver = 'mosek';
basis = 'CG_red';
slack = 1;
% nout = 2; P_ABC = get_dist('W-type');
nout = 2; P_ABC = get_dist('complete correlation');
% nout = 2; P_ABC = get_dist('anti-correlation');
% nout = 4; P_ABC = get_dist('EJM');


% Constraints
[A_, b_, tmp, tmp] = get_spiral_constraints(nout, P_ABC, basis);
K = struct();
switch slack
    case 0
        %-------------no slack---------------
        A = A_;
        b = b_;
        [m, n] = size(A);
        K.l = n;
        c = zeros(n,1);
    case 1
        %-------------slack(x>=t)-------------------
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
    case 3
        %--------------slack(x=y-t+1)---------------
        A_sum = sum(A_, 2);
        A = [A_ -A_sum];
        b = b_ - A_sum;
        [m, n] = size(A);
        K.l = n;
        c = [zeros(n-1, 1);
            1];
end


% Call VSDP
vsdpinit('mosek');
OPTIONS.MOSEK_OPTIONS = struct();
OPTIONS.MOSEK_OPTIONS.MSK_IPAR_LOG = 0;
[objt,xt,yt,zt,info] = mysdps(A,b,c,K,[],[],[],OPTIONS);
if info ~= 0
    error('VSDP returns error/infeasible');
end

% Verified bounds
[fL,y,dl] = vsdplow(A,b,c,K,xt,yt,zt,[],OPTIONS);
[fU,x,lb] = vsdpup(A,b,c,K,xt,yt,zt,[],OPTIONS);
objt
fU
fL





