function [is_valid] = operation_follows_operation(first_operation, second_operation)


switch first_operation
	case 'S'
		is_valid = or(...
			second_operation == 'U' , ...
			second_operation == 'P' ...
		);
	case 'U'
		is_valid = or( ...
			second_operation == 'S' , ...
			second_operation == 'D' , ...
			second_operation == 'R' ...
			);
	case 'P'
		is_valid = second_operation == 'E';
	case 'D'
		is_valid = or( ...
			second_operation == 'S' , ...
			second_operation == 'U' , ...
			second_operation == 'P' , ...
			second_operation == 'D' , ...
			second_operation == 'E' , ...
			second_operation == 'R' ...
			);
	case 'E'
		is_valid = or( ...
			second_operation == 'S' , ...
			second_operation == 'U' , ...
			second_operation == 'P' , ...
			second_operation == 'D' , ...
			second_operation == 'E' , ...
			second_operation == 'R' ...
			);
	case 'R'
		is_valid = or( ...
			second_operation == 'S' , ...
			second_operation == 'U' , ...
			second_operation == 'P' , ...
			second_operation == 'D' , ...
			second_operation == 'E' , ...
			second_operation == 'R' ...
			);
	otherwise
		disp('Bad operation. We found:');
		disp(cast(first_operation, 'char'));
		disp('It should be one of these');
		disp('SUPERD');
end





end
