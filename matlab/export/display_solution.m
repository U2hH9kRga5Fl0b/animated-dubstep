
% Now, to display the solution in a visualization overview

% This function plots a solution over a city.

% This looks like garbage :(

function display_solution(c, sol)

display_city(c);

colors = rand(c.number_of_drivers, 3);

for d=1:c.number_of_drivers
    prev = c.locs(c.start_location, :);
    for s=1:c.number_of_actions
        if sol(d,s) < 0
            break;
        end
        
        next = c.locs(c.actions(sol(d,s)).location, :);
        
        line(prev, next, 'Color', colors(d, :));
        prev = next;
    end
end


end