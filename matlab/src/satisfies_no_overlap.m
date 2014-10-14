% This function makes sure that no customer request is visited twice.


%author Matt

function [is_valid] = satisfies_no_overlap(c, sol)

is_valid = true;
error_flag = ' ';

% A dump or yard can be visited twice, but customer requests cannot.



% We can probably get around depending on the actions being in a certain order if we just skip the actions we don't care about.

% for n = (4 * c.number_of_landfills + 8 * c.number_of_staging_areas + 1):c.number_of_actions
for n = 1:c.number_of_actions

    op = c.actions(n).operation;
    if op == 'U' || op == 'S' || op == 'E'
	continue;
    end
    
    count = 0; %The number of times we see a particular action n in the matrix
    
    for i = 1:c.number_of_drivers
        for j = 1:length(sol(1, :))  % This could just be size(sol, 2)  (or even just c.num_of_actions)
            if sol(i, j) < 0
                continue;
            end
            
            if ( n == sol(i, j) ) 
                count = count + 1;
            end
            
            if ( count == 2 )
                error_flag = strcat('Stop ', int2str(n), ' is visited more than once; this is a customer request ', ...
				'The second time is by driver ', int2str(i), ' at stop ', int2str(j));
                warning(error_flag);
                is_valid = false;
                count = count + 1;
            end
        end
    end
end

% This could probably be done in quadratic time if we kept a running sum of the number of times each location was visited.
%
% I haven't run this, but could be future debugging work.
%
%times_visited = zeros(1, c.number_of_locations);
%for d = 1:c.number_of_drivers
%	for s=1:c.number_of_actions
%		if sol(d,s) < 0
%			continue;
%		end
%		
%		a = c.actions(sol(d,s));
%		if a.operation == 'U' || a.operation == 'S' || a.operation == 'E'
%			continue;
%		end
%		
%		times_visited(a.location) = times_visited(a.location) + 1;
%		if times_visited(a.location) > 1)
%			warning('Action %d now performed %d times (driver %d, stop %d)', sol(d,s), times_visited(a.location), d, s);
%			is_valid = false;
%		end
%	end
%end

%if any(times_visited > 1)
%	warning(' ... ')
%end

end