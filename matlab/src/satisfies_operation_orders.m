function [is_valid] = satisfies_operation_orders(c, sol)


is_valid = true;

for d=1:c.D
	for i=1:c.n-1
		first_operation = c.actions(sol(d,i)).operation;
		second_operation = c.actions(sol(d,i+1)).operation;

		is_valid = operation_follows_operation(first_operation, second_operation);
		if is_valid == 0
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
