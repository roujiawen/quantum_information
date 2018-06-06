function bool = is_pos_int(inputs)
%IS_POS_INT Returns `true` if input contains only positive integers.
    if any(floor(inputs) ~= inputs) || any(inputs <= 0)
        bool = false;
    else
        bool = true;
    end
end

