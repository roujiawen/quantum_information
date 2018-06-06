% Test sum_marginal against pmarginal (only binary)

% Add parent folder to path
addpath(fileparts(pwd));


success = 1;
for i = 4:10
    for j = 1:2:i
        for k = 2:2:i
            for l = 1:i
                if l ~= j && l~=k
                if sum(sum((sum_marginal(2, i, [j k l]) ~= pmarginal(i, [j k l]))))>0
                    success = 0;
                end
                end
            end
        end
    end
end

if success
    fprintf('Passed the test!\n');
else
    fprintf('Failed the test!\n');
end

 