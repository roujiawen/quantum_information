% Add parent folder to path
addpath(fileparts(pwd))

A = linspace(0, 7,8);
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


A = permute_sum(A, [3 2])
% A =
% 
%      3    12
%     48   192
