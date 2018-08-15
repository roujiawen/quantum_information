function prob = get_slack_mosek_form(A, b, slack)

const_type = 'eq';

prob = struct();
switch slack
    case {0, 'noslack'}
        %-------------no slack---------------
        [m, n] = size(A);
        
        prob.c = zeros(n, 1);
        prob.a = sparse(A);
        prob.blc = b;
        prob.buc = b;
        prob.blx = zeros(n, 1);
        
    case {1, 'slack(z=x-t)'}
        %-------------slack(x>=t/z=x-t)-------------------
        [m, n] = size(A);
        A_sum = sum(A, 2);
        
        prob.c = [zeros(n, 1); -1];%maximize t
        prob.a = sparse([A A_sum]);
        prob.blc = b;
        prob.buc = b;
        prob.blx = [zeros(n, 1); -inf];
        
    case {3, 'slack(z=x+t-1)'}
        %--------------slack(z=x+t-1)---------------
        [m, n] = size(A);
        A_sum = sum(A, 2);
        
        prob.c = [zeros(n, 1); 1];%minimize t
        prob.a = sparse([A -A_sum]);
        tmp = b - A_sum;
        prob.blc = tmp;
        prob.buc = tmp;
        prob.blx = zeros(n+1, 1);
end
end