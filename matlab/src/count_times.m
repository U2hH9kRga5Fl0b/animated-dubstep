% This returns the time that it takes each driver to perform his route

% c is the city
% sol is the solution
% all_times is the time that each action is performed at (calculated by get_all_times)


%    author Matt


function [end_times] = count_times(c, sol, all_times)

end_times = zeros(1, c.number_of_drivers);

% This is the last non-negative entry of each row of all_times

end