% This returns the time that each action is performed at.

% It has the same dimension as sol, and get_times(i,j) is the time that action number sol(i,j) is performed.

%    author Trever

function [times] = get_all_times(c, sol, waits)

sol = cast(sol, 'int32');

satisfies_argument_types(c, sol);
times = -ones(size(sol));

for d=1:c.number_of_drivers
    % If driver d doesn't perform any actions.
    if size(sol, 2) < 1 || sol(d,1) < 0
       continue
    end
    
    % Need to make a method called get time from action to action
    % This should go in the city...
    firstLoc = cast(c.actions(sol(d,1)).location, 'int32');
    times(d,1) = c.durations(c.start_location, firstLoc) ...
        + c.actions(sol(d,1)).wait_time;
    
    if waits(d,1) > 0
       times(d,1) = max(times(d,1), c.actions(sol(d,1)).start_time); 
    end
    
    for i=2:size(sol, 2)
        if sol(d,i) < 0
            break;
        end
        
        l1 = cast(c.actions(sol(d, i-1)).location, 'int32');
        l2 = cast(c.actions(sol(d, i  )).location, 'int32');
        
        times(d,i) = times(d,i-1) + c.durations(l1, l2) + c.actions(sol(d,i)).wait_time;
        
        if waits(d,i) > 0
            times(d,i) = max(times(d,i), c.actions(sol(d,i)).start_time); 
        end
    end
end


end
