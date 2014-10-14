% c is a city
% sol are the routes of the drivers

% Returns true when the size coming out of each each action matches the size coming in.

% Future work:
% This might be too strong.
% If the size coming in to a request is bigger than the one requested, maybe this is ok.

% author:    Tamlyn

function [is_valid] = satisfies_sizes_follow(c, sol)

is_valid = true;
for d=1:c.number_of_drivers
    for a=1:c.number_of_actions-1 
        % We have hit the end of this route.
        if sol(d,a+1) <= 0
                continue
        end
        
        % Size dumpster leaving this stop
        out = c.actions(sol(d,a)).out_size;
        % Size dumpster entering next stop
        in = c.actions(sol(d,a+1)).in_size;
        if  out ~= in
            is_valid = false;
            warning(['Dumpster size problem:\n'...
                '   Driver %d left stop %d with dumper size %d\n'...
                '   and stop %d calls for dumpster size %d.\n\n'],...
                d, a, out, a+1, in); 
        end
    end
end

end