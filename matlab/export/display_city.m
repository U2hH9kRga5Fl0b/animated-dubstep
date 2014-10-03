%Now, to display the city in a visualization overview
function display_city(c)
% TODO: this function shouldn't depend on the order the city was made!!!

sizes = 3 * ones(m, 1);
colors = ones(m, 1);

for i=1:Y
    colors(i, 1) = 4;
end
for i=(1+Y):(D + Y)
    colors(i, 1) = 7;
end

%need starts, roads, wait times, sizes, number of trucks
scatter(c.locs(:, 1), c.locs(:, 2), sizes, colors);

for i = 1:Y
    %List the yards
    loc = c.locs(c.yards(i).location);
    if (i > 1)
        text(loc(1, 1), loc(1, 2), ...
            0, strcat(' Stop #', int2str(i)),...
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
for i = (Y+1):(Y+D)
    %List the dumps
    loc = c.locs(i);
    text(loc(1, 1), loc(1, 2), 0, ' DUMP', ...
        'VerticalAlignment', 'top', 'Color', 'red');
    text(loc(1, 1), loc(1, 2), 0, strcat(' (Stop #', ...
        int2str(i - Y), ') '), 'VerticalAlignment', 'bottom', ...
        'Color', 'red');
end
for i = (Y+D+1):(Y+D+R)
    %List all of the customer requests
    loc = c.locs(i);
    text(loc(1,1), loc(1,2), strcat(' ', c.actions(i).operation));
    text(loc(1, 1), loc(1, 2), ...
        strcat(' (Stop #', int2str(i - (Y + D)), ') '), ...
        'HorizontalAlignment', 'right');
end

%List the first yard
text(c.yards(1).location(1, 1), c.yards(1).location(1, 2), 0,...
    '(Start) #1', 'VerticalAlignment', 'bottom', 'Color', 'green');

%Create the roads
% NOTE: I've commented this out, because it clutters up the graph;
% however, the logic works
%for i = 1:(Y + D + n)
%    for j = 1:(Y + D + n)
%        line( [ locs(i, 1), locs(j, 1) ], [ locs(i, 2), locs(j, 2) ] );
%    end
%end
end
