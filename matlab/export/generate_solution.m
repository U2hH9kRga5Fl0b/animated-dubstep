% This function generates a random solution that is valid.
% The solution is likely not efficient.

function [sol] = generate_solution(c)

sollen = c.number_of_actions;

% This is the easiest valid solution to code...
% (It is just a place holder, eventually this routine should generate one of all possible solutions...)
sol = cast(-ones(c.number_of_drivers, sollen), 'int32');


for s=1:sollen
    one_driver_can_do_something = false;
    for d=1:c.number_of_drivers
        if s > 1 && sol(d,s-1) < 0
            continue % driver already can't do anything...
        end
        
        possibles = get_list_of_valid_actions(c, sol, d, s);
        if isempty(possibles)
            continue;
        end
    
        one_driver_can_do_something = true;
        sol(d, s) = datasample(possibles, 1);
    end
    
    if ~one_driver_can_do_something
        break;
    end
end




end
