%--------------General form---------------
[A, b, G, h] = get_cut_constraints('W-type');

% cvx_begin
%     variable x(8);
%     subject to 
%         % Equality conditions
%         A * x == b;
%         % Inequality conditions
%         G * x <= h;
% cvx_end

%     1.0000
%     0.6667
%     0.6667
%     0.4444
%     0.6667
%     0.3333
%     0.3333
%     0.1111

linprog(zeros(8,1), G, h, A, b)

%--------------LP standard form---------------
% c = zeros(16,1);
% A = [G eye(8);
%       A zeros(12,8)];
% b = [zeros(8,1);
%       b];

% cvx_begin
%     variable x(16);
%     minimize(c.' * x);
%     subject to
%         % Equality conditions
%         A_ * x == b_;
%         % Nonnegative conditions
%         x >= 0;
% cvx_end

