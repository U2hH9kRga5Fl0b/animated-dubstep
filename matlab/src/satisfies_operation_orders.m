
% This function returns true when all the orders of the operations are valid. 
% For example, if there is a 'P' after a 'P' at any point, this is invalid.


% c is the city
% sol is the solution

% author  <entire group>

function [is_valid] = satisfies_operation_orders(c, sol, v)

is_valid = true;

for d=1:c.number_of_drivers
	for i=1:size(sol, 2)-1
		% We have hit the end of this route.
		if sol(d,i+1) <= 0
			continue
		end
		
		% Get this operation
		first_operation = c.actions(sol(d,i  )).operation;
		% Get the next operation
		second_operation = c.actions(sol(d,i+1)).operation;

		% Check if this sequence is valid
		this_is_valid = operation_follows_operation(first_operation, second_operation);
		if not(this_is_valid)
			is_valid = false;
            if v
                % We could use the error function here...
                warning(['The operations did not follow each other.\n' ...
                    'for driver %d\nwhile going from stop %d to stop %d\n' ...
                    'first operation = %c, second operation = %c'], d, i, i+1, ...
                    cast(first_operation, 'char'), ...
                    cast(second_operation, 'char'));
            end
		end
	end
end




end
