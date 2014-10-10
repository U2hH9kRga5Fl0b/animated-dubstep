

c=generate_city(50, 2, 2, 2);
sol=-ones(c.number_of_drivers, c.number_of_actions);
[feasible, times, distances, num_serviced, fees] = simulate(c, sol);

assert(feasible, 'The empty solution is always valid!');