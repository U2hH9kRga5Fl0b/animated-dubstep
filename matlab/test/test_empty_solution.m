

c=generate_city(50, 2, 2, 2);
sol=-ones(c.number_of_drivers, c.number_of_actions); % don't visit any requests
[feasible, times, distances, num_serviced, fees] = simulate(c, sol);

% Verify some of the obvious facts about the empty solution...
assert(feasible, 'The empty solution is always valid!');
assert(num_serviced == 0, 'No requests were serviced!');
assert(fees == 0, 'No fees, because there were no landfills visited.');
assert(isequal(times, zeros(c.number_of_drivers, 1)), 'No time was spent.');
assert(isequal(times, zeros(c.number_of_drivers, 1)), 'No distance was covered.');