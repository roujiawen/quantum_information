function mat2csv(filepath)
% Assuming the variable name is 'data'

load(filepath, 'data');
cell2csv([filepath '.csv'], data);
end