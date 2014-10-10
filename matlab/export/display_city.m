% Now, to display the city in a visualization overview

% This function plots a city.

function display_city(c)
% TODO: this function shouldn't depend on the order the city was made!!!

sizes = 3 * ones(c.number_of_locations, 1);
colors = ones(c.number_of_locations, 1);

for i=1:c.number_of_staging_areas
    colors(i, 1) = 4;
end
for i=(1+c.number_of_staging_areas):(c.number_of_drivers + c.number_of_staging_areas)
    colors(i, 1) = 7;
end

%need starts, roads, wait times, sizes, number of trucks
scatter(c.locs(:, 1), c.locs(:, 2), sizes, colors);

for i = 1:c.number_of_staging_areas
    %List the yards
    loc = c.locs(c.yards(i).location, :);
    if (i > 1)
        text(loc(1, 1), loc(1, 2), ...
            0, strcat(' Yard #', int2str(i)),...
            'VerticalAlignment', 'bottom', 'Color', 'green');
    end
    text(loc(1, 1), loc(1, 2), 0, 'YARD', ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'bottom', 'Color', 'green');
    text(loc(1, 1), loc(1, 2), 0, ...
        strcat('INV[', ... 
        int2str(c.yards(i).inventory(1)), ', ', ...
        int2str(c.yards(i).inventory(2)), ', ', ...
        int2str(c.yards(i).inventory(3)), ', ', ...
        int2str(c.yards(i).inventory(4)), '] '), ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', ...
        'Color', 'green');
    text(loc(1, 1), loc(1, 2), 0, ...
        strcat(' CAP: ', int2str(c.yards(i).capacity)), ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top',...
        'Color', 'green');
end
for i = 1:c.number_of_landfills
    %List the dumps
%   If we wanted to print the loction it would be:
%    l = c.landfills(i).location;
    loc = c.locs(c.landfills(i).location, :);
    text(loc(1, 1), loc(1, 2), 0, ' DUMP', ...
        'VerticalAlignment', 'top', 'Color', 'red');
    text(loc(1, 1), loc(1, 2), 0, strcat(' (Dump #', ...
        int2str(i), ') '), 'VerticalAlignment', 'bottom', ...
        'Color', 'red');
end




for i = (c.number_of_staging_areas + c.number_of_landfills + 1):c.number_of_locations
    %List all of the customer requests
    loc = c.locs(i, :);
%    text(loc(1,1), loc(1,2), strcat(' ', c.actions(i).operation));
    text(loc(1, 1), loc(1, 2), ...
        strcat(' (Stop #', int2str(i - (c.number_of_staging_areas + c.number_of_landfills)), ') '), ...
        'HorizontalAlignment', 'right');
end

%List the first yard
loc = c.locs(c.yards(c.start_location).location, :);
text(loc(1, 1), loc(1, 2), 0,...
    '(Start) #1', 'VerticalAlignment', 'bottom', 'Color', 'green');

end
