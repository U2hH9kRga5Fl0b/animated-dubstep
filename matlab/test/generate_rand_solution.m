
% This function generates a random solution for city c.
% The generated solution is most likely not valid...

% author  Trever

function [sol] = generate_rand_solution(c)


% Generate a random solution
sol = 1 + (c.n-1) * rand(c.D, c.n);

% We will add some negative ones at the end, which means the end doesn't have length n
% Generate the lengths to cut these routes off at
lens = 1 + cast((c.n-1) * rand(c.D, 1), 'int32');

for d=1:c.D
	sol(i, lens(i):c.n) = -1;
end

sol = cast(sol, 'int32');

end
