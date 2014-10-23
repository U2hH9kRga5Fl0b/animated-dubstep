c = get_default_test_city();
sol = [ 3 2 1 -1  ; -1 -1 -1 -1];
[feasible, times, distances, num_serviced, fees] = simulate(c, sol);
assert(feasible, 'This is a feasible solution');

% 1->3 + 3->2 + 2->1 + wait(3) + wait(2) + wait(1)
%   4  +   5  +   3  +   3     +    2    +   1
assert(times(1) == 18, 'This took the wrong amount of time for the first driver.');
assert(times(2) == 0,  'This took the wrong amount of time for the second driver.');

% 1->3 + 3->2 + 2->1 
%   8  +  10  +  6   
assert(distances(1) == 24, 'This was the wrong amount of distance for the first driver.');
assert(distances(2) ==  0, 'This was the wrong amount of distance for the second driver.');

assert(num_serviced == 1, 'There was only one request that was serviced.');
assert(fees == 100, 'There is only one fee of 100');
