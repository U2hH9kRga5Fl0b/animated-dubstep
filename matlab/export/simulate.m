
% This function simulates a solution to a city.
% It returns whether the solution is feasible and all the objectives.

function [feasible, times, distances, num_serviced, fees] = simulate(c, sol)

feasible = satisfies_argument_types(c, sol);

sol = cast(sol, 'int32');
all_times = get_all_times(c, sol);

feasible = feasible && satisfies_operation_orders(c, sol);
%feasible = feasible && satisfies_truck_begin_end(c, sol);
feasible = feasible && satisfies_time_windows(c, sol, all_times);
feasible = feasible && satisfies_sizes_follow(c, sol);
feasible = feasible && satisfies_inventory_bounds(c, sol, all_times);
feasible = feasible && satisfies_no_overlap(c, sol);
feasible = feasible && satisfies_truck_type_constraints(c, sol);
feasible = feasible && satisfies_starts_with_no_dumpster(c, sol);

distances = count_distances(c, sol);
fees = count_fees(c, sol);
times = count_times(all_times);
num_serviced = count_num_requests(c, sol);

end

