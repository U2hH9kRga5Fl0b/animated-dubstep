% c is a city
% sol are the routes of the drivers

% This function counts the number of costumer requests (not landfills or staging areas) that have been visited.

%   author Trever


function [number_of_requests_serviced] = count_num_requests(c, sol)

number_of_requests_serviced = 0;


for d=1:c.number_of_drivers
    for s=1:c.number_of_actions
        stop = sol(d,s);
        
        if stop < 0
            break;
        end
        
        a = c.actions(stop);
        if a.operation == 'P' ...
                || a.operation == 'D' ...
                || a.operation == 'R'
            number_of_requests_serviced = number_of_requests_serviced + 1;
        end
    end
end


end