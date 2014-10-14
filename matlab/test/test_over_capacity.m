c = get_default_test_city();
c.yards(1).capacity = 0;
sol = [ 3 2 1 -1  ; -1 -1 -1 -1];
feasible = simulate(c, sol);
assert(~feasible, 'This is not a feasible solution. It does not meet the capacity constraints.');
