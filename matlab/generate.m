% Y = # of yards, or staging areas to make
% D = # of drivers or trucks
% R = # of requests
% L = # of landfills
% display = true or false, show the city grid after making the city

function [c] = generate(R, L, Y, D, display)


%This function uses rand() throughout, so we need to generate a new random
%seed for every run through:

rng('shuffle')

n = R + 8 * Y + 4 * L;
m = R + Y + L;

n = cast(n, 'uint32');
m = cast(m, 'uint32');
Y = cast(Y, 'uint32');
D = cast(D, 'uint32');
total_time = 43200; % This is the number of seconds in a 12 hour day; we may want to change this, but I'm just using it as a placeholder.
                                    % This is necessary when setting
                                    % morning or evening time windows
                                    % below.

%time_scale determines how to scale the Euclidean distance to measure the
%travel duration between two points.  At this moment, we've decided to use
%the scale of 1 to 5 just for test purposes  (These are measured in seconds - so for
%every one unit of distance, this is a travel time of 1 to 5 seconds).

%In the future, this may be a random number, however, depending on what we
%consider the unit of distance measurement (mile, foot, etc.)

time_scale=cast(4*rand() + 1, 'uint32');

% Set the basic data from the parameter list
c = city;
c.m = m;
c.n = n;
c.Y = Y;
c.D = D;

% Create the durations matrix, filled initially with zeroes
c.durations = cast(zeros(m,m), 'uint32');

locs = 50 * rand(m, 2);  % Generate random points for the city

%By this generator, the start location is always index 1, which is assigned
%as our first yard (below).
c.start_location = [ locs(1, 1), locs(1, 2) ];

%NOTE: rand generates points between -1 and 1, but we may want to scale
%this, depending on what we decide a unit of distance is.  For now, just
%for fun, I've scaled it to be between -50 and 50 (this just sounded good
%to me, but there's no real reason for it).

for i = 1:m
    for j = 1:m
        % Find the Euclidean distance between our random points
        dx = locs(i,1) - locs(j,1);
        dy = locs(i,2) - locs(j,2);
        
        % Calculate the times between each point
        c.durations(i,j) = time_scale * sqrt(dx * dx + dy * dy);
    end
end

c.durations = c.durations + cast(rand(m,m), 'uint32'); 
                                                                                      
c.durations = c.durations - diag(diag(c.durations)); % zero diagonal elements, as the duration from the stop to itself is 0 seconds


%Now that we have all of our locations, we have to determine what each kind
%of location is.  We assign the yards and the dumps, and assume everything
%else is a customer location.

%We are just assigning it a number that corresponds to a particular
%coordinate within the locs matrix.

%Initialize the yards with an empty array
c.yards = staging_area.empty(Y, 0);

%Fill the yard data
for i = 1:Y
    % There might be a better way to do this, but for now I've just assumed
% (since we are generating random points anyway, that the first Y
% locations in locs are yards, and then the next D locations are dumps).
    c.yards(i).capacity = cast(10 + rand() * 10, 'uint32');
    c.yards(i).location = [locs(i, 1), locs(i, 2)];
    
    %Now, there are four kinds of dumpsters; therefore, we initialize
    % the yards to have a vector that stores how many of each size
    %they have (not going over capacity).
    
    %I picked the divisor 2 on the capacity randomly, just to try and have
    %a somewhat regular distribution of containers at each facility.
    c.yards(i).inventory = [cast((rand() * c.yards(i).capacity / 2), 'uint32'), cast((rand() * c.yards(i).capacity / 2), 'uint32'), cast((rand() * c.yards(i).capacity / 2), 'uint32'), cast((rand() * c.yards(i).capacity / 2), 'uint32')];
    
    %We might have gone over capacity.  Therefore, we check this and
    %subtract randomly if we are:
    
    while (c.yards(i).inventory(1) + c.yards(i).inventory(2) + c.yards(i).inventory(3) + c.yards(i).inventory(4) > c.yards(i).capacity)
            rand_num = cast(rand() * 4 + 1, 'uint32');
                if (rand_num > 4) rand_num = 4; end
                    if ( c.yards(i).inventory(rand_num) > 0) c.yards(i).inventory(rand_num) = c.yards(i).inventory(rand_num) - 1; end
    end
end



dump_locs = zeros(D, 2); %This stores all of our dump locations

for i=(1+Y):(D + Y)
    dump_locs(i - Y, 1) = locs(i, 1);
    dump_locs(i - Y, 2) = locs(i, 2);
end


%Initialize the actions with an empty array
c.actions = action.empty(n, 0);

%Initialize the allowable trucks with an empty array

c.allowable_trucks = ones(m, 3);

%Main loop to fill in all of the stop data with random information
for i = 1:n
    
    %I've scaled the wait times at each stop to be between 60 and 600
    %seconds (1 to 10 minutes).  This can be changed later, but I thought
    %it sounded realistic:
    c.actions(i).wait_time = cast(540*rand() + 60, 'uint32');
    
    %Now, we set the operations to be performed at each location.  These
    %are the letter codes:
    % D = Dropoff
    % P = Pickup
     % R = Replace (dropoff and pickup together)  -- I added this back in
    % separately, because it was the best way to code it that I could find
    
    %RULES: 
        
    %Add a random action to the stop we've found
    k = rand() * 3;
        if ( k < 1 ) % Create pickup
            c.actions(i).operation = 'P';
            %If this is a pickup, the in_size must always be zero (as the
            %truck going there must be empty)
            c.actions(i).in_size = 0;
            %Now, create a random size that we are picking up
            a = cast(rand() * 3 + 1,'uint32');
            c.actions(i).out_size = a;
        end
        if ( k < 2 && k > 1 ) %Create dropoff
            c.actions(i).operation = 'D';
            %If this is a dropoff, the out_size must always be zero (as the
            %truck will be leaving empty)
             c.actions(i).out_size = 0;
             %Create a random size that we are dropping off
            a = cast(rand() * 3 + 1,'uint32');
            c.actions(i).in_size = a;
        end
        if ( k > 2 ) %Create replace
            c.actions(i).operation = 'R';
            %Create random sizes for pickup and dropoff
            a = cast(rand() * 3 + 1,'uint32');
            c.actions(i).out_size = a;
            a = cast(rand() * 3 + 1,'uint32');
            c.actions(i).in_size = a;
        end
        
        
    % Now, we need to create a random starting and stopping time
    k = rand() * 3;
        if ( k < 1 ) % Create infinite time window
            c.actions(i).start_time = 0;
            c.actions(i).stop_time = Inf;
        end
        if ( k < 2 && k > 1 ) %Create evening time window
            c.actions(i).start_time = cast( total_time / 2, 'uint32' );
            c.actions(i).stop_time = Inf;
        end
        if ( k > 2 ) %Create morning time window
            c.actions(i).start_time = 0;
            c.actions(i).stop_time = cast( total_time / 2, 'uint32' );
        end
        
    % Generate a random location
    % As these are already randomly created, I just go down the list,
    % making sure not to pick a location we already chose for yards and
    % dumpsters.
    c.actions(i).location = [ locs( (Y + D) + i, 1 ), locs( (Y + D) + i, 2 ) ];
    
    %Now, finally, we add some constraints on what trucks can visit each
    %location.  In general, most locations can be visited by any truck;
    %however, if any of the dumpsters to be dropped off or picked up are
    %size 4, then this can only be visited by the largest truck (size 3).
    %Also, randomly, there are other locations that can only be serviced by
    %the smallest truck, size 1.
    k = rand() * 10; % We don't want many locations to be restricted to the smallest truck
        if ( k < 1 ) % Create restriction, allowing only the smallest truck to this location
            c.allowable_trucks(i, 2) = 0;
            c.allowable_trucks(i, 3) = 0;
        end
        if ( c.actions(i).out_size > 3 || c.actions(i).in_size > 3 ) %Only allow the largest trucks
            c.allowable_trucks(i, 1) = 0;
            c.allowable_trucks(i, 2) = 0;
            c.allowable_trucks(i, 3) = 1;
        end
    
end

%Now, to display the city in a visualization overview

if ( display == true )
    
    
    sizes = 3 * ones(m, 1);
    colors = ones(m, 1);
    
    for i=1:Y
        colors(i, 1) = 4;
    end
    for i=(1+Y):(D + Y)
        colors(i, 1) = 7;
    end
    %need starts, roads, wait times, sizes, number of trucks
    
    scatter(locs(1:m, 1), locs(1:m, 2), sizes, colors);
    
    for i = 1:n
        %List all of the customer requests
        text(c.actions(i).location(1, 1), c.actions(i).location(1, 2), strcat(' ', c.actions(i).operation));
        text(c.actions(i).location(1, 1), c.actions(i).location(1, 2), strcat(' (Stop #', int2str((Y + D) + i), ') '), 'HorizontalAlignment', 'right');
    end
    for i = 1:D
        %List the dumps
        text(dump_locs(i, 1), dump_locs(i, 2), 0, ' DUMP', 'VerticalAlignment', 'top', 'Color', 'red');
        text(dump_locs(i, 1), dump_locs(i, 2), 0, strcat(' (Stop #', int2str(Y + i), ') '), 'VerticalAlignment', 'bottom', 'Color', 'red');
    end
    for i = 1:Y
        %List the yards
        if ( i > 1) text(c.yards(i).location(1, 1), c.yards(i).location(1, 2), 0, strcat(' Stop #', int2str(i)), 'VerticalAlignment', 'bottom', 'Color', 'green'); end
        text(c.yards(i).location(1, 1), c.yards(i).location(1, 2), 0, 'YARD', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Color', 'green');
        text(c.yards(i).location(1, 1), c.yards(i).location(1, 2), 0, strcat('INV[', int2str(c.yards(i).inventory(1)), ', ', int2str(c.yards(i).inventory(2)), ', ', int2str(c.yards(i).inventory(3)), ', ', int2str(c.yards(i).inventory(4)), '] '), 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Color', 'green');
        text(c.yards(i).location(1, 1), c.yards(i).location(1, 2), 0, strcat(' CAP: ', int2str(c.yards(i).capacity)), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'Color', 'green');
    end
    %List the first yard
    text(c.yards(1).location(1, 1), c.yards(1).location(1, 2), 0, '(Start) #1', 'VerticalAlignment', 'bottom', 'Color', 'green');
    %Create the roads
    % NOTE: I've commented this out, because it clutters up the graph;
    % however, the logic works
    %for i = 1:(Y + D + n)
    %    for j = 1:(Y + D + n)
    %        line( [ locs(i, 1), locs(j, 1) ], [ locs(i, 2), locs(j, 2) ] );
    %    end
    %end
    
end


