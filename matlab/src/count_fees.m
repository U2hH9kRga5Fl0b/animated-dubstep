% This function counds the total number of fees that were accrued by solution sol to city c

%   author Trever

function [total_fees] = count_fees(c, sol)

total_fees = 0;

for d=1:c.number_of_drivers
    for s=1:size(sol, 2)
        stop = sol(d,s);
        
        if stop < 0
            break;
        end
        
        if not(c.actions(stop).operation == 'E')
            continue;
        end
        
        fee = c.get_landfill_for_action(stop).fee;
        total_fees = total_fees + fee;
    end
end

end