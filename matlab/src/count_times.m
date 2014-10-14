
% This returns the time that it takes each driver to perform his route

% all_times is the time that each action is performed at (calculated by get_all_times)


%    author Matt

% All this function takes is all_times calculated by the get_all_times
% function, and it returns the last time each driver visits any stops.

function [end_times] = count_times(all_times)

end_times = max(max(all_times, [], 2), 0);

end
