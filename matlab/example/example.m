c = generate(50,4,3, 3);
c.actions(1)
c.action(50)
sol = cast( max(1,c.n * rand(c.D, c.n)), 'uint32');
get_all_times(c, sol);
