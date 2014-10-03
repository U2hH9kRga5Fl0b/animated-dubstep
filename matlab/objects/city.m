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
        R                                   %           int                   1 x 1                  # of customer requests
        L                                   %           int                   1 x 1                  # of land fills

        actions                             %           action                n x 1                  The set of actions
        yards                               %           staging_area          Y x 1                  The set of staging areas
        landfills                           %           landfills             L x 1                  The set of landfills

        durations                           %           time                  m x m                  The time to get from location to location
        distances                           %           meters                m x m                  The distance between all locations
        
        locs                                %           double                m x 2                  The x-y pairs of the locations

        start_location                      %           index < m             1 x 1                  The location where each truck starts
        total_time                          %           int                   1 x 1                  Total number of seconds that the route can run
    end

    methods
    end
end


