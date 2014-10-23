
% This function returns an array containing all the valid actions that can
% be performed by driver d at stop s, assuming that all other actions in
% sol are to be performed on city c


function [ possibles ] = get_list_of_valid_actions(c, sol, d, s)

%if simulate(c, sol)
%    error('The city has to start out feasible in order to see if any others are feasible!');
%end

possibles = zeros(c.number_of_actions, 1);

for i=1:c.number_of_actions
    sol(d,s) = i;
    feasible=simulate(c, sol, false, false);
    if feasible
        possibles(i) = i;
    end
end

possibles=possibles(possibles>0);

end



