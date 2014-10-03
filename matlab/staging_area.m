%     Variable name                                     Type                  Dimension                Description

classdef staging_area
    properties
        capacity                            %           int                                          The capacity of the staging area
        inventory                           %           int             (|S|-1) x 1                  The number of dumpster of each size (except the 'No Dumpster')
        location                            %           index < m             1 x 1                  Location of the staging area
    end

    methods
    end
end

