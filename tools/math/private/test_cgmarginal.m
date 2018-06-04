% Add parent folder to path
addpath(fileparts(pwd))

% selecting one axis
full(cgmarginal(3, 1))
full(cgmarginal(3, 2))
full(cgmarginal(3, 3))
% selecting two axes
full(cgmarginal(3, [1 3]))
full(cgmarginal(3, [3 2]))
% selecting three axes
full(cgmarginal(3, [3 1 2]))

% ans =
% 
%      1     0     0     0     0     0     0     0
%      0     1     0     0     0     0     0     0
% 
% 
% ans =
% 
%      1     0     0     0     0     0     0     0
%      0     0     1     0     0     0     0     0
% 
% 
% ans =
% 
%      1     0     0     0     0     0     0     0
%      0     0     0     0     1     0     0     0
% 
% 
% ans =
% 
%      1     0     0     0     0     0     0     0
%      0     1     0     0     0     0     0     0
%      0     0     0     0     1     0     0     0
%      0     0     0     0     0     1     0     0
% 
% 
% ans =
% 
%      1     0     0     0     0     0     0     0
%      0     0     0     0     1     0     0     0
%      0     0     1     0     0     0     0     0
%      0     0     0     0     0     0     1     0
% 
% 
% ans =
% 
%      1     0     0     0     0     0     0     0
%      0     0     0     0     1     0     0     0
%      0     1     0     0     0     0     0     0
%      0     0     0     0     0     1     0     0
%      0     0     1     0     0     0     0     0
%      0     0     0     0     0     0     1     0
%      0     0     0     1     0     0     0     0
%      0     0     0     0     0     0     0     1