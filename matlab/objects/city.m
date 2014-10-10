%     S = {0, 1, 2, 3, 4}                                                                           Set of dumpster sizes
%     T = {1, 2, 3}                                                                                 Set of possible Truck types
%     O = { 'D', 'P', 'E', 'S', 'U', 'R'}                                                           Set of operations

%     Variable name                                     Type                  Dimension                Description
classdef city
    properties
        number_of_actions                   %           int                   1 x 1                  # of actions, or stops
        number_of_locations                 %           int                   1 x 1                  # of unique locations
        number_of_drivers                   %           int                   1 x 1                  # number of trucks/Drivers
        number_of_staging_areas             %           int                   1 x 1                  # of Staging Areas (or Yards)
        number_of_requests                  %           int                   1 x 1                  # of customer requests
        number_of_landfills                 %           int                   1 x 1                  # of land fills

        actions                             %           action                n x 1                  The set of actions
        yards                               %           staging_area          Y x 1                  The set of staging areas
        landfills                           %           landfill              L x 1                  The set of landfills

        durations                           %           time                  m x m                  The time to get from location to location
        distances                           %           meters                m x m                  The distance between all locations
        
        locs                                %           double                m x 2                  The x-y pairs of the locations

        start_location                      %           index < m             1 x 1                  The location where each truck starts
        max_time                            %           int                   1 x 1                  Total number of seconds that the route can run
        
        
        % Convenience properties...
        location_to_landfill
        location_to_stagingarea
    end

    methods
        function [fill] = get_landfill_for_action(obj, idx)
            assert(idx >= 1 && idx <= obj.number_of_actions, ...
                'Bad index into actions: %d. \n(Valid indices are %d to %d)', ...
                idx, 1, obj.number_of_actions);
            idx = cast(idx, 'int32');
            assert(obj.actions(idx).operation == 'E', ...
                'Trying to get a landfill index of an operation that does not happen at a landfill.');
            landfill_index = obj.location_to_landfill(...
                obj.actions(idx).location);
            assert(landfill_index >= 1 && landfill_index <= obj.number_of_landfills, ...
                'The landfill for action %d is not set!', idx);
            fill = obj.landfills(landfill_index);
        end
        function [yard] = get_stagingarea_for_action(obj, idx)
            assert(idx >= 1 && idx <= obj.number_of_actions, ...
                'Bad index into actions: %d. \n(Valid indices are %d to %d)', ...
                idx, 1, obj.number_of_actions);
            idx = cast(idx, 'int32');
            op = obj.actions(idx).operation;
            assert(op == 'U' || op == 'S', ...
                'Trying to get a staging area index of an operation that does not happen at a stagingarea.');
            staging_area_index = obj.location_to_stagingarea(...
                obj.actions(idx).location);
            assert(staging_area_index >= 1 && staging_area_index <= obj.number_of_stagingareas, ...
                'The staging area for action %d is not set!', idx);
            yard = obj.stagingareas(staging_area_index);
        end
    end
end


