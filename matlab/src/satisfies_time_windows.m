% Returns true when all the times that each action is performed at fall within their time windows.



% author     Trever


% c is the city
% sol is the solution
% all_times is the time that each action represented by sol is performed (taken from get_all_times.m)

function [is_valid] = satisfies_time_windows(c, sol, all_times)

is_valid = true;

for d=1:c.number_of_drivers
    for s=1:c.number_of_actions
        if sol(d,s) < 0
            break;
        end
        
        a = c.actions(sol(d,s));
        time_serviced = all_times(d, s);
         
        if time_serviced < a.start_time
            is_valid = false;
            warning(['Stop made before start of time window.' ...
                'driver: %d, index %d, time=%d\n' ...
                'time window = (%d, %d)'],...
                 d, s, time_serviced, a.start_time, a.stop_time);
        end
       
        if time_serviced > a.stop_time
            is_valid = false;
            warning(['Stop made after end of time window.' ...
                'driver: %d, index %d, time=%d\n' ...
                'time window = (%d, %d)'],...
                d, s, time_serviced, a.stop_time, a.stop_time);
        end
    end
end

end