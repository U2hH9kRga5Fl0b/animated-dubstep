% This function returns a city that is not empty, and is the same city
% every time.

function [c] = get_default_test_city()

% Some test data
R = 2;
Y = 1;
L = 1;
n = 4;
m = 4;


% Set the basic data from the parameter list
c = city;
c.number_of_locations = m;
c.number_of_actions = n;
c.number_of_requests = R;
c.number_of_staging_areas = Y;
c.number_of_drivers = 2;
c.number_of_landfills = L;
%c.max_time = total_time;
c.start_location = 1;
c.truck_types = [1 1];

% Create the durations matrix, filled initially with zeroes
c.durations = (1:4)' * ones(1,4)  + ones(1,4)' * (1:4);
c.distances = 2 * c.durations;
c.durations = c.durations - diag(diag(c.durations));
c.distances = c.distances - diag(diag(c.distances));

%c.locs = 50 * rand(m, 2);  % Generate random points for the city

c.location_to_landfill = [0 1 0 0 0];
c.location_to_stagingarea = [1 0 0 0 0];

% Build staging area
c.yards = staging_area.empty(1, 0);
c.yards(1).capacity = 5;
c.yards(1).location = 1;
c.yards(1).inventory = [0 0 0 0];

% Build Landfill
c.landfills = landfill.empty(L, 0);
c.landfills(1).fee = 100;
c.landfills(1).location = 2;

% Build actions
c.actions = action.empty(n, 0);

% Action 1
c.actions(1).operation = 'S';
c.actions(1).in_size = 6;
c.actions(1).out_size = 0;
c.actions(1).start_time = 0;
c.actions(1).stop_time = 50;
c.actions(1).wait_time = 1;
c.actions(1).location = 1;
c.actions(1).allowable_truck_types = [ 1 1 1];

% Action 2
c.actions(2).operation = 'E';
c.actions(2).in_size = 6;
c.actions(2).out_size = 6;
c.actions(2).start_time = 0;
c.actions(2).stop_time = 50;
c.actions(2).wait_time = 2;
c.actions(2).location = 2;
c.actions(2).allowable_truck_types = [ 1 1 1];

% Action 3
c.actions(3).operation = 'P';
c.actions(3).in_size = 0;
c.actions(3).out_size = 6;
c.actions(3).start_time = 0;
c.actions(3).stop_time = 50;
c.actions(3).wait_time = 3;
c.actions(3).location = 3;
c.actions(3).allowable_truck_types = [ 1 1 1];

% Action 4
c.actions(4).operation = 'D';
c.actions(4).in_size = 12;
c.actions(4).out_size = 0;
c.actions(4).start_time = 0;
c.actions(4).stop_time = 50;
c.actions(4).wait_time = 4;
c.actions(4).location = 4;
c.actions(4).allowable_truck_types = [ 1 1 1];


end