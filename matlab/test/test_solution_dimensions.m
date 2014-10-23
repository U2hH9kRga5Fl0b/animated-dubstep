
assert(simulate(c, -ones(c.number_of_drivers, 1)), 'Empty solution should be valid.');
assert(simulate(c, -ones(c.number_of_drivers, c.number_of_actions)), 'Empty solution should be valid.');
assert(simulate(c, -ones(c.number_of_drivers, c.number_of_actions * 5)), 'Empty solution should be valid.');
assert(simulate(c, -ones(c.number_of_drivers, c.number_of_actions * 100)), 'Empty solution should be valid.');
