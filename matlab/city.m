%     S = {0, 1, 2, 3, 4}                                                                           Set of dumpster sizes
%     T = {1, 2, 3}                                                                                 Set of possible Truck types
%     O = { 'D', 'P', 'E', 'S', 'U', 'R'}                                                           Set of operations

%     Variable name                                     Type                  Dimension                Description
classdef city
    properties
        n                                   %           int                   1 x 1                  # of actions, or stops
        m                                   %           int                   1 x 1                  # of unique locations
        D                                   %           int                   1 x 1                  # number of trucks/Drivers
        Y                                   %           int                   1 x 1                  # of Staging Areas (or Yards)
        
        total_time                          %           int                   1 x 1                  Total number of seconds that the route can run

        actions                             %           action                n x 1                  The set of actions
        yards                               %           staging_area          Y x 1                  The set of staging areas

        allowable_trucks                    %           [0, 1]                m x |T|=3              Constraint on what truck can visit each location (this could be of size n by |T| too)

        durations                           %           time                  m x m                  The time to get from location to location

        start_location                      %           index < m             1 x 1                  The location where each truck starts
    end

    methods
    end
end

