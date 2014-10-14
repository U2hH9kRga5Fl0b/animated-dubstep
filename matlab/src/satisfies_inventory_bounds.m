
% This function returns true when all inventory and capacity constraints are met.

% Trever

function [is_valid] = satisfies_inventory_bounds(c,sol, all_times)

is_valid = true;

% The number of dumpster sizes...
num_sizes = 4;
function [index] = size_to_index(size)
	switch size
		case 6
			index = 1;
		case 9
			index = 2;
		case 12
			index = 3;
		case 16
			index = 4;
        otherwise
			index = -1;
	end
end

inventories = zeros(c.number_of_staging_areas, num_sizes);
for i=1:c.number_of_staging_areas
	inventories(i,:) = c.yards(i).inventory;
end


ts = sort(unique(reshape(all_times, 1, numel(all_times))));
ts = ts(ts>0);

for t=ts
	[d, s] = find(all_times == t);
	for i=1:length(d)
		idx = sol(d(i), s(i));
		a = c.actions(idx);
		
		delta = zeros(1, num_sizes);
		dsize = 0;
		
		if a.operation == 'S'
			dsize = a.in_size;
			idx = size_to_index(dsize);
			if idx < 0
				warning('Invalid in_size: %d for driver %d at stop %d.\n', a.in_size, d(i), s(i));
				is_valid = false;
				continue
			end
			delta(idx) = 1;
		elseif a.operation == 'U'
			dsize = a.out_size;
			idx = size_to_index(dsize);
			if idx < 0
				warning('Invalid in_size: %d for driver %d at stop %d.\n', a.in_size, d(i), s(i));
				is_valid = false;
				continue
			end
			delta(idx) = -1;
		else
			continue;
		end
		
		yard_idx = c.location_to_stagingarea(a.location);
		inventories(yard_idx, :) = inventories(yard_idx, :) + delta;
		
		if any(inventories(yard_idx, :) < 0)
			warning('Negative inventory for size %d driver %d stop %d.\n', dsize, d(i), s(i));
			is_valid = false;
		end
		
		num_dumpsters = sum(inventories(yard_idx, :));
		cap = c.yards(yard_idx).capacity;
		if num_dumpsters > cap
			warning('Staging area over its capacity of %d for driver %d at stop %d.\n', cap, d(i), s(i));
			is_valid = false;
		end
	end
end


end