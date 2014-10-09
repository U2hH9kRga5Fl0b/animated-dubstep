function [times] = get_all_times(c, sol)

sol = cast(sol, 'int32');

satisfies_argument_types(c, sol);
times = zeros(size(sol));

for d=1:c.D
    % If driver d doesn't perform any actions.
    if sol(d,1) < 0
       continue
    end
    
    % Need to make a method called get time from action to action
    % This should go in the city...
    firstLoc = cast(c.actions(sol(d,1)).location, 'int32');
    times(d,1) = c.durations(c.start_location,firstLoc) ...
        + c.actions(1).wait_time;
    
    for i=2:c.n
        if sol(d,i) < 0
            break;
        end
        
        sol(d, i)
        
        l1 = cast(c.actions(sol(d, i-1)).location, 'int32');
        l2 = cast(c.actions(sol(d, i  )).location, 'int32');
        times(d,i) = c.durations(l1, l2) + c.actions(sol(d,i)).wait_time;
    end
end


end
