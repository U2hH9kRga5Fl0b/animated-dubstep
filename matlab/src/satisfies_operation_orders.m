
% This function returns true when all the orders of the operations are valid. 
% For example, if there is a 'P' after a 'P' at any point, this is invalid.


% c is the city
% sol is the solution

% author  <entire group>

function [is_valid] = satisfies_operation_orders(c, sol)

is_valid = true;

for d=1:c.number_of_drivers
	for i=1:c.number_of_actions-1
		% We have hit the end of this route.
		if sol(d,i) <= 0
			continue
		end
		
		% Get this operation
		first_operation = c.actions(sol(d,i)).operation;
		% Get the next operation
		second_operation = c.actions(sol(d,i+1)).operation;

		% Check if this sequence is valid
		is_valid = operation_follows_operation(first_operation, second_operation);
		if is_valid == 0
			% We could use the error function here...
			disp('The operations did not follow eachother.');
			disp('For driver:');
			disp(d);
			disp('For stop:');
			disp(i);
			disp('to');
			disp(i+1);
			disp('first operation:');
			disp(cast(first_operation, 'char'));
			disp('second operation:');
			disp(cast(second_operation, 'char'));
			is_valid = false;
		end
	end
end




end
