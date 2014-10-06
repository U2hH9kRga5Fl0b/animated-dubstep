function [feasible, times, distance, num_serviced, fees] = simulate(c, sol)

satisfies_argument_types(c, sol)

feasible = false; 
num_serviced = 0;
distance = 0;
fees = 0;
times = rand(c.D, 1); % lets make up some times, maybe they will believe us...


end

