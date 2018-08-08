function mat2csv(filepath)
% Assuming the variable name is 'data'
% Example:
% mat2csv('results/5-500trials_v2/rand_fea_500trials')
load(filepath, 'data');
if strcmp(extractAfter(filepath,length(filepath)-4), '.mat')
    filepath = extractBefore(filepath,length(filepath)-3);
end
cell2csv([filepath '.csv'], data);
end