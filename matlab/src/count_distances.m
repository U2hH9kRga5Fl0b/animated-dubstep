% c is a city
% sol are the routes of the drivers

% This function adds up all the distances traveled for each driver

%   author Cody

function [distances] = count_distances(c, sol)

distances = zeros(1, c.number_of_drivers);


for x=1:c.number_of_drivers
    if size(sol, 2) < 1 || sol(x,1) < 0
        continue
    end
    
    distances(1,x) = c.distances(c.start_location, ...
        c.actions(sol(x,1)).location);
    
    for s=2:size(sol, 2)
        if sol(x,s) < 0
            continue;
        end
        
        l1 = c.actions(sol(x,s-1)).location;
        l2 = c.actions(sol(x,s  )).location;
        
        distances(1,x) = distances(1,x) + c.distances(l1,l2);
        
    end

end

end
