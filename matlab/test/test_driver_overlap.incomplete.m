

c=generate_city(50, 2, 2, 2);
sol=generate_rand_solution(c); % Create a random solution
%Make sure that one of the entires overlaps
a = 0;
for i = 1:c.number_of_actions
    if c.actions(i).operation == 'P' || c.actions(i).operation == 'D' || c.actions(i).operation == 'R'
        a = i;
        break;
    end
end
sol(1,1) = a;
sol(1,2) = a;
[feasible, times, distances, num_serviced, fees] = simulate(c, sol, false);

% Verify some of the obvious facts about the empty solution...
assert(feasible, 'The driver visited a stop more than once!');