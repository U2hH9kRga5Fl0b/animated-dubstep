
% This function simulates a solution to a city.
% It returns whether the solution is feasible and all the objectives.

function [feasible, times, distances, num_serviced, fees] = simulate(c, sol)

satisfies_argument_types(c, sol)

sol = cast(sol, 'int32');

all_times = get_all_times(c, sol);


is_valid = true;
is_valid = is_valid && satisfies_operation_orders(c, sol);
is_valid = is_valid && satisfies_truck_begin_end(c, sol);
is_valid = is_valid && satisfies_time_windows(c, sol);
is_valid = is_valid && satisfies_sizes_follow(c, sol);
is_valid = is_valid && satifies_inventory_bounds(c, sol, all_times);
is_valid = is_valid && satisfies_no_overlap(c, sol);
is_valid = is_valid && satisfies_actions_constrains(c, sol);

distances = count_distances(c, sol);
fees = count_fees(c, sol);
times = count_times(c, sol, all_times);
num_serviced = count_num_requests(c, sol);


end

