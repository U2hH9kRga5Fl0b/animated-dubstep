
% This function generates a random solution for city c.
% The generated solution is most likely not valid...

% author  Trever

function [sol] = generate_rand_solution(c)


% Generate a random solution
sol = 1 + (c.number_of_actions-1) * rand(c.number_of_drivers, c.n);

% We will add some negative ones at the end, which means the end doesn't have length n
% Generate the lengths to cut these routes off at
lens = 1 + cast((c.number_of_actions-1) * rand(c.number_of_drivers, 1), 'int32');

for d=1:c.number_of_drivers
	sol(i, lens(i):c.number_of_actions) = -1;
end

sol = cast(sol, 'int32');

end
