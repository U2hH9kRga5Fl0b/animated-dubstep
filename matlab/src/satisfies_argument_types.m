% This function returns false when c is not a city, or sol does not have the right dimensions.

% author Trever


function [feasible] = satisfies_argument_types(c, sol)

feasible = true;

if ~ isa(c, 'city')
    disp('The second argument must be a city!!');
    
    feasible = false;
    return
end

if ~ isequal(size(sol), [ c.number_of_drivers, c.number_of_actions])
    disp('Your solution is of the wrong dimension!!');
    
    feasible = false;
    return
end


if any(any(sol > c.number_of_actions)) || any(any(sol < -1)) 
    warning(...
        ['solutions matrix has entries that are not valid indices into the number of actions.' ...
        'The number of actions in the city is %d.\n' ...
        'The maximum entry of the city is %d.\n' ...
        'The minimum entry of the city is %d.\n' ...
        ], c.number_of_actions, max(max(sol)), min(min(sol)));
	feasible = false;
end


if any(any(sol == 0))
	warning('The solution matrix cannot contain zeros');
	feasible = false;
	
	% fixing...
	% sol(sol == 0) = -1;
end


end
