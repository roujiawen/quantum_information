function [ memory_in_use ] = mem_to_MB(mem_elements)
%ref: https://in.mathworks.com/matlabcentral/answers/uploaded_files/1861/monitor_memory_whos.m

if size(mem_elements,1) > 0

    for i = 1:size(mem_elements,1)
        memory_array(i) = mem_elements(i).bytes;
    end

    memory_in_use = sum(memory_array);
    memory_in_use = memory_in_use/1048576;
else
    memory_in_use = 0;
end