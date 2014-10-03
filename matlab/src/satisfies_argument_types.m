function [feasible] = get_all_times(c, sol)


if ~ isa(c, 'city')
    disp('The second argument must be a city!!');
    
    feasible = false;
    return
end

if ~ isequal(size(sol), [ c.D, c.n])
    disp('Your solution is of the wrong dimension!!');
    
    feasible = false;
    return
end

end