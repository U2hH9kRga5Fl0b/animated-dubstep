% Y = # of yards, or staging areas to make
% R = # of requests
% L = # of landfills
% D = # of drivers or trucks
% display = true or false, show the city grid after making the city

function [c] = generate_city(R, L, Y, D)

n = R + 8 * Y + 4 * L;
m = R + Y + L;

%n = cast(n, 'uint32');
%m = cast(m, 'uint32');
%Y = cast(Y, 'uint32');
%L = cast(L, 'uint32');
%D = cast(D, 'uint32');

% This is the number of seconds in a 12 hour day;
%we may want to change this, but I'm just using it as a placeholder.
% This is necessary when setting morning or evening time windows below.
total_time = 43200;

%time_scale determines how to scale the Euclidean distance to measure the
%travel duration between two points.  At this moment, we've decided to use
%the scale of 1 to 5 just for test purposes  (These are measured in seconds - so for
%every one unit of distance, this is a travel time of 1 to 5 seconds).

%In the future, this may be a random number, however, depending on what we
%consider the unit of distance measurement (mile, foot, etc.)

time_scale=cast(4*rand() + 1, 'uint32');

dumpsters = [6, 9, 12, 16]; % 0 means no dumpster...
ndumpsters = length(dumpsters);

trucks = ['small', 'medium', 'large'];
ntrucks = length(trucks);

% Set the basic data from the parameter list
c = city;
c.m = m;
c.n = n;
c.R = R;
c.Y = Y;
c.D = D;
c.L = L;
c.max_time = total_time;

% Create the durations matrix, filled initially with zeroes
c.durations = cast(zeros(m,m), 'uint32');

c.locs = 50 * rand(m, 2);  % Generate random points for the city

%NOTE: rand generates points between 0 and 1, but we may want to scale
%this, depending on what we decide a unit of distance is.  For now, just
%for fun, I've scaled it to be between 0 and 50 (this just sounded good
%to me, but there's no real reason for it).

for i = 1:m
    for j = 1:m
        % Find the Euclidean distance between our random points
        dx = c.locs(i,1) - c.locs(j,1);
        dy = c.locs(i,2) - c.locs(j,2);
        
        % Calculate the times between each point
        c.durations(i,j) = time_scale * sqrt(dx * dx + dy * dy);
    end
end


% zero diagonal elements, as the duration from the stop to itself is 0 seconds
c.durations = c.durations + cast(rand(m,m), 'uint32');
c.durations = c.durations - diag(diag(c.durations));

% Make the distances related to the times...
c.distances = c.durations + cast(rand(m,m), 'uint32');
c.distances = c.distances - diag(diag(c.distances));

%Now that we have all of our locations, we have to determine what each kind
%of location is.  We assign the yards and the dumps, and assume everything
%else is a customer location.


%By this generator, the start location is always index 1, which is assigned
%as our first yard (below).
c.start_location = 1;

%We are just assigning it a number that corresponds to a particular
%coordinate within the locs matrix.

%Initialize the yards with an empty array
c.yards = staging_area.empty(Y, 0);

%Initialize the actions with an empty array
c.actions = action.empty(n, 0);
next_action_index   = cast(1, 'uint32');
next_location_index = cast(1, 'uint32');

%Fill the yard data
for i = 1:Y
    % Since we are generating random points anyway, the first Y
    % locations in locs are yards, and then the next D locations are dumps.
    cap = 10 + rand() * 10;
    c.yards(i).capacity = cap;
    c.yards(i).location = next_location_index;
    
    %Now, there are four kinds of dumpsters; therefore, we initialize
    % the yards to have a vector that stores how many of each size
    %they have (not going over capacity).
    
    %I picked the divisor 2 on the capacity randomly, just to try and have
    %a somewhat regular distribution of containers at each facility.
    c.yards(i).inventory = cast(cap * rand(ndumpsters,1) / ndumpsters, 'uint32');
    
    for j = 1:ndumpsters
        c.actions(next_action_index).operation   = 'S';
        c.actions(next_action_index).in_size     = dumpsters(j);
        c.actions(next_action_index).out_size    = 0;
        c.actions(next_action_index).start_time  = 0;
        c.actions(next_action_index).stop_time   = total_time;
        c.actions(next_action_index).wait_time   = 5;
        c.actions(next_action_index).location    = next_location_index;
        
        next_action_index = next_action_index + 1;
        
        c.actions(next_action_index).operation   = 'U';
        c.actions(next_action_index).in_size     = 0;
        c.actions(next_action_index).out_size    = dumpsters(j);
        c.actions(next_action_index).start_time  = 0;
        c.actions(next_action_index).stop_time   = total_time;
        c.actions(next_action_index).wait_time   = 5;
        c.actions(next_action_index).location    = next_location_index;
        
        next_action_index = next_action_index + 1;
    end
    
    next_location_index = next_location_index + 1;
end


c.landfills = landfill.empty(L, 0);
for i=1:L
    c.landfills(i).fee = 5 + rand();
    c.landfills(i).location = next_location_index;
    
    for j = 1:ndumpsters
        c.actions(next_action_index).operation   = 'E';
        c.actions(next_action_index).in_size     = dumpsters(j);
        c.actions(next_action_index).out_size    = dumpsters(j);
        c.actions(next_action_index).start_time  = 0;
        c.actions(next_action_index).stop_time   = total_time;
        c.actions(next_action_index).wait_time   = 10;
        c.actions(next_action_index).location    = next_location_index;
        
        next_action_index = next_action_index + 1;
    end
    
    next_location_index = next_location_index + 1;
end

for i=1:R
    %Now, we set the operations to be performed at each location.  These
    %are the letter codes:
    % D = Dropoff
    % P = Pickup
    % R = Replace (dropoff and pickup together)
    op = datasample('PDR', 1, 'Weights', [.4 .4 .2]);
    c.actions(next_action_index).operation   = op;
    switch(op)
        case 'P'
            c.actions(next_action_index).in_size     = 0;
            c.actions(next_action_index).out_size    = datasample(dumpsters, 1);
        case 'D'
            c.actions(next_action_index).in_size     = datasample(dumpsters, 1);
            c.actions(next_action_index).out_size    = 0;
        case 'R'
            c.actions(next_action_index).in_size     = datasample(dumpsters, 1);
            c.actions(next_action_index).out_size    = datasample(dumpsters, 1);
        otherwise
            display('ERROR - bad operation');
    end
    
    r = rand();
    if (r < .4)
        c.actions(next_action_index).start_time  = cast(0, 'uint32');
        c.actions(next_action_index).stop_time   = cast(total_time / 2, 'uint32');
    elseif ( r < .8)
        c.actions(next_action_index).start_time  = cast(total_time / 2, 'uint32');
        c.actions(next_action_index).stop_time   = cast(0, 'uint32');
    else
        window = 50;
        st_tm = cast(rand() * (total_time - window), 'uint32');
        c.actions(next_action_index).start_time  = st_tm;
        c.actions(next_action_index).stop_time   = cast(st_tm + window, 'uint32');
    end
    
    %I've scaled the wait times at each stop to be between 60 and 600
    %seconds (1 to 10 minutes).  This can be changed later, but I thought
    %it sounded realistic:
    c.actions(i).wait_time = cast(540*rand() + 60, 'uint32');
    c.actions(next_action_index).location    = next_location_index;
    
    %Now, finally, we add some constraints on what trucks can visit each
    %location.  In general, most locations can be visited by any truck;
    %however, if any of the dumpsters to be dropped off or picked up are
    %size 16, then this can only be visited by the largest truck ('large').
    %Also, randomly, there are other locations that can only be serviced by
    %the smallest truck, size 1.
    if ((op == 'P' || op == 'R') ...
        && c.actions(next_action_index).out_size == 16)
        c.actions(next_action_index).allowable_trucks = [zeros(ntrucks-1,1); 1];
    elseif (rand() < .5)
        c.actions(next_action_index).allowable_trucks = [1; zeros(ntrucks-1,1)];
    else
        c.actions(next_action_index).allowable_trucks = ones(ntrucks,1);
    end
    
    % move to the next action/location
    next_action_index   = next_action_index   + 1;
    next_location_index = next_location_index + 1;
end
