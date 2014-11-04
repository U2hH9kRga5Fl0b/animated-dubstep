

c=generate_city(50, 2, 2, 2);
sol=generate_rand_solution(c); % Create a random solution
%Make sure that one time window cannot be met

c.actions(1).start_time = 0;
c.actions(1).stop_time = 0;

[feasible, times, distances, num_serviced, fees] = simulate(c, sol, false);

% Verify some of the obvious facts about the empty solution...
assert(feasible, 'The time window on stop 1 was not met.');