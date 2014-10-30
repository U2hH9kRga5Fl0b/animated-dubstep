
%Create a city with no landfills
c=generate_city(50, 0, 2, 2);
sol=generate_rand_solution(c); % Create a random solution
[feasible, times, distances, num_serviced, fees] = simulate(c, sol, false);

% Verify some of the obvious facts about the empty solution...
assert(feasible, 'This city has no landfills, and one is required');