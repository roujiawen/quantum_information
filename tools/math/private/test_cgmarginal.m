% Add parent folder to path
addpath(fileparts(pwd))

% create an input example
A = linspace(0,7, 8);
A = 2.^A;
A = reshape(A,2,2,2)
% A(:,:,1) =
% 
%      1     4
%      2     8
% 
% 
% A(:,:,2) =
% 
%     16    64
%     32   128


% test: selecting one variable
cgmarginal(A, [1])
cgmarginal(A, [2])
cgmarginal(A, [3])
% ans =
% 
%      1
%      2
% 
% 
% ans =
% 
%      1
%      4
% 
% 
% ans =
% 
%      1
%     16



% test: selecting two variables
cgmarginal(A, [1 3])
% ans =
% 
%      1
%      2
%     16
%     32

cgmarginal(A, [3 2])
% ans =
% 
%      1
%     16
%      4
%     64



% test: selecting three variables
cgmarginal(A, [3 1 2])
% ans =
% 
%      1
%     16
%      2
%     32
%      4
%     64
%      8
%    128