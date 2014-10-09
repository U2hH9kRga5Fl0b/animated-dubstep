% This function returns false when c is not a city, or sol does not have the right dimensions.

% author Trever


function [feasible] = satisfies_argument_types(c, sol)

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


if any(any(sol > c.n)) || any(any(sol < -1)) 
	disp('This matrix has entries that are not valid indices into the number of actions.');
	disp('The number of actions in the city:');
	disp(c.n);
	disp('The maximum entry in the solution:');
	disp(max(max(sol)));
	disp('The minimum entry in the solution:');
	disp(max(max(sol)));
	feasible = false;
end


if any(any(sol == 0))
	disp('The solution matrix cannot contain zeros');
	feasible = false;
	
	% fixing...
	% sol(sol == 0) = -1;
end


end