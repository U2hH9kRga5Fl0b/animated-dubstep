
% Make a city
c = generate_city(10,2,2,2)




% Make a solution, although it probably isn't valid.
sol = generate_rand_solution(c)




% This is the number of actions
c.number_of_actions




% This is the number of drivers
c.number_of_drivers




% These are the actions
c.actions




% Look at the 5-th action
c.actions(5)




% What is the 5-th action's operation
c.actions(5).operation




% What is the third action performed by the second driver
c.actions(sol(2,3));




% Now c has 50 actions
c = generate(50,4,3, 3);




% What happens when we try to simulate a solution?
simulate(c, generate_rand_solution(c));

