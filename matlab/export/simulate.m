
% This function simulates a solution to a city.
% It returns whether the solution is feasible and all the objectives.

function [feasible, times, distances, num_serviced, fees] = simulate(c, sol, v, checkall)

if nargin < 4
	checkall = true;
end
if nargin < 3
    v = true;
else 
end

times = [];
distances = [];
num_serviced = [];
fees = [];

feasible = satisfies_argument_types(c, sol, v);
if ~feasible && ~checkall
    return;
end

sol = cast(sol, 'int32');
all_times = get_all_times(c, sol);

feasible = satisfies_operation_orders(c, sol, v) && feasible;
if ~feasible && ~checkall
    return
end
feasible = satisfies_time_windows(c, sol, all_times, v) && feasible;
if ~feasible && ~checkall
    return
end
feasible = satisfies_sizes_follow(c, sol, v) && feasible;
if ~feasible && ~checkall
    return
end
feasible = satisfies_inventory_bounds(c, sol, all_times, v) && feasible;
if ~feasible && ~checkall
    return
end
feasible = satisfies_no_overlap(c, sol, v) && feasible;
if ~feasible && ~checkall
    return
end
feasible = satisfies_truck_type_constraints(c, sol, v) && feasible;
if ~feasible && ~checkall
    return
end
feasible = satisfies_starts_with_no_dumpster(c, sol, v) && feasible;
if ~feasible && ~checkall
    return
end

distances = count_distances(c, sol);
fees = count_fees(c, sol);
times = count_times(all_times);
num_serviced = count_num_requests(c, sol);

end

