% Add parent folder to path
addpath(fileparts(pwd));


% Test slice_marginal against cgmarginal (only binary)
success = 1;
for i = 4:10
    for j = 1:2:i
        for k = 2:2:i
            for l = 1:i
                if l ~= j && l~=k
                if sum(sum((slice_marginal(2, i, [j k l]) ~= cgmarginal(i, [j k l]))))>0
                    success = 0;
                end
                end
            end
        end
    end
end



% 3*3*3 cube scenario
if ~all(all(slice_marginal(3, 3, [1 2]) == [eye(9) zeros(9, 18)]))
    success = 0;
end

temp = sparse(1:9,[1 10 19 4 13 22 7 16 25],ones(1,9),9,27);
if ~all(all(slice_marginal(3, 3, [3 2]) == temp))
    success = 0;
end

temp = sparse(1:27, ...
    [1 4 7 10 13 16 19 22 25 ...
     2 5 8 11 14 17 20 23 26 ...
     3 6 9 12 15 18 21 24 27], ...
    ones(1,27),27,27);
if ~all(all(slice_marginal(3, 3, [2 3 1]) == temp))
    success = 0;
end



% Print results
if success
    fprintf('Passed the test!\n');
else
    fprintf('Failed the test!\n');
end



 