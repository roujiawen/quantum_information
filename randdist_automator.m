% changable
pattern = [1 1;
     2 2;
     1 1]; % used for choosing from dis
solver = 'mosek';
optimizer = 'MSK_OPTIMIZER_FREE';
basis = 'full';
slack = 1;

% fixed parameters
nvar = 3;
l_out = 2;
h_out = 4;
infea = false;

dis = horzcat([1; 0; 0; 0],...
            [1/2; 1/2; 0; 0],...
            [1/2; 1/4; 1/4; 0],...
            [0.1; 0.3; 0.6; 0],...
            [0.2; 0.2; 0.3; 0.3],...
            [0.1; 0.2; 0.3; 0.4]);
            
conv_mat = zeros(h_out, l_out, nvar);
 
 for i3 = 1:3%nvar
     for i2 = 1:2%l_out
         chosen_dis = dis(:,pattern(i3, i2));
         conv_mat(:,i2,i3) = chosen_dis;%(randperm(4));
     end
 end
 
 
 
%  conv_mat(:,:,1) =
% 
%          0    0.5000
%          0    0.5000
%     1.0000         0
%          0         0
% 
% 
% conv_mat(:,:,2) =
% 
%          0    0.5000
%          0         0
%          0         0
%     1.0000    0.5000
% 
% 
% conv_mat(:,:,3) =
% 
%          0    0.5000
%          0    0.5000
%     1.0000         0
%          0         0

% conv_mat(:,:,1) =
% 
%      0     0
%      1     0
%      0     0
%      0     1
% 
% 
% conv_mat(:,:,2) =
% 
%      0     0
%      1     0
%      0     1
%      0     0
% 
% 
% conv_mat(:,:,3) =
% 
%      0     0
%      1     0
%      0     0
%      0     1

% conv_mat(:,:,1) =
% 
%      0     0
%      0     1
%      1     0
%      0     0
% 
% 
% conv_mat(:,:,2) =
% 
%      0     1
%      1     0
%      0     0
%      0     0
% 
% 
% conv_mat(:,:,3) =
% 
%      0     0
%      0     1
%      1     0
%      0     0

 h_dist = low2high_dist(get_dist("uniform"), l_out, h_out, infea, conv_mat);
 cvx_solver_settings('MSK_IPAR_OPTIMIZER',optimizer);
 cvx_solver(solver);
 cvx_spiral(h_out, h_dist, basis, slack);
 %conv_mat
 
 