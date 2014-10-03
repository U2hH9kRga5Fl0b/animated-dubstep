function [feasible, times, num_serviced] = simulate(solution, c)

if ~ isa(c, 'city')
    disp('The second argument must be a city!!');
    
    feasible = false;
    times = [];
    num_serviced = 0;
    return
end

if ~ isequal(size(solution), [ c.D, c.n])
    disp('Your solution is of the wrong dimension!!');
    
    feasible = false;
    times = [];
    num_serviced = 0;
    return
end

feasible = false; % you still fail though, mwah ha ha ha
num_serviced = 0; % ... hard
times = rand(c.D, 1); % lets make up some times, maybe they will believe us...


