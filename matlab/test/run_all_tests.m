operations_dont_follow
ensure_city_is_valid
valid_nonempty_city
test_translate
test_empty_solution
test_over_capacity
test_generate_solution
%test_zero_landfills.incomplete
%test_time_windows.incomplete
%test_driver_overlap.incomplete

% ?
%test_start_end_are_same.incomplete


assert(simulate(c, -ones(c.number_of_drivers, 1)), 'Empty solution should be valid.');
assert(simulate(c, -ones(c.number_of_drivers, c.number_of_actions)), 'Empty solution should be valid.');
assert(simulate(c, -ones(c.number_of_drivers, c.number_of_actions * 5)), 'Empty solution should be valid.');
assert(simulate(c, -ones(c.number_of_drivers, c.number_of_actions * 100)), 'Empty solution should be valid.');
