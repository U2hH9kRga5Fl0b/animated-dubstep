% This function returns true when all the truck type constraints are met.

% author: Trever


function [is_valid] = satisfies_truck_type_constraints(c, sol)

is_valid = true;

for d=1:c.number_of_drivers
    type = c.truck_types(d);
    for s=1:c.number_of_actions
        stop = sol(d,s);
        
        % Hit end of route...
        if stop < 0
            break;
        end
        
        allowed = c.actions(stop).allowable_truck_types;
        if ~ allowed(type)
            is_valid = false;
            warning(['Truck type constraint not met.\n' ...
                ' driver: %d, stop %d, type %d, action %d\n'], ...
                 d, s, type, stop);
        end
    end
end


end