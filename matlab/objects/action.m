% An action is simply something that can be performed.  There are a few
% kinds of actions, designated by these letters:

    % D = Dropoff
    % P = Pickup
    % E = Empty (or take to dumpster)
    % S = Stage (take a container back to a staging area)
    % U = Unstage (remover a container from a staging area
    % R = Replace (dropoff and pickup together)  -- I added this back in
    % separately, because it was the best way to code it that I could find

%     Variable name                                     Type                  Dimension                Description
classdef action
    properties
        operation                             %           O                     1 x 1                  Operation to be performed at stop $i$ (note that these can be multiple actions)
        in_size                               %           S                     1 x 1                  The size of the dumpster at each stop.
        out_size                              %           S                     1 x 1                  (We can decide if we actually want this).
        start_time                            %           time                  1 x 1                  First time that this action could be performed
        stop_time                             %           time                  1 x 1                  Last time this action could be performed
        wait_time                             %           time                  1 x 1                  The wait time required to visit stop $i$
        location                              %           index < m             1 x 1                  The location where the stop happens at.
        
        allowable_truck_types                 %           [0,1]             |T|-1 x 1                  The truck types that allowed at this location.
    end

    methods
    end
end

