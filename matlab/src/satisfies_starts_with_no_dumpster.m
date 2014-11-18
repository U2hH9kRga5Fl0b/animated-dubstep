% This function makes sure that the first operation that a truck performs has no dumpster.
% This is because we assume that each truck starts out with no dumpster.
% The set of first possible operations is: {'U',  'P' }


% author: Tamlyn

function [is_valid] = satisfies_starts_with_no_dumpster(c, sol, v)

is_valid = true;

for d = 1:c.number_of_drivers
    if size(sol, 2) < 1 || sol(d,1) < 0
        continue;
    end
    % First operation for each driver
    s = c.actions(sol(d,1)).operation;
    % 'U' and 'P' only possible first operations
    if s ~= 'U' && s ~= 'P'
        is_valid = false;
        if v
            warning(['Driver %d''s first operation is %s.\n'...
                '   The first operation cannot have a dumpster, so it can only be a P or U.\n\n'], d, s); 
        end
    end
    s = c.actions(sol(d,sum(sol(d,:)>0))).operation;
    if s ~= 'S' && s ~= 'D'
        is_valid = false;
        if v
            warning(['Driver %d''s last operation is %s.\n'...
                '   The last operation cannot have a dumpster, so it can only be a S or D.\n\n'], d, s); 
        end
    end
end

end
