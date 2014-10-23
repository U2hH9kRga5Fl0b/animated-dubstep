

c = translate(['.' filesep 'test' filesep 'example_ui_data' ]);


assert(c.number_of_landfills == 4, 'Wrong number of landfills');
assert(c.number_of_staging_areas == 4, 'Wrong number of landfills');


%Storage,location,Capacity,6,9,12,16
%5,40,5,9,6,3,1
%6,50,7,7,12,5,1
%7,50,6,10,1,2,1
%8,70,10,3,5,0,1

assert(c.yards(2).capacity == 7, 'This made the wrong capacity for staging area 2');
assert(c.yards(2).location == 50, 'This made the wrong location for staging area 2');
assert(c.yards(2).inventory(2) == 12, 'This made the wrong location for staging area 2');



%Landfill,Wait time,Fee
%1,10 min,10
%2,30 min,20
%3,15 min,10
%4,15 min,15

assert(c.landfills(2).fee == 20, 'This made the wrong fee for landfill 2');
% The wait times are still not right...







%Index,address,In,Out,Small,Not Small,Time Window
%9,7899 Wadsworth Blvd Arvada CO 80003,0,16,0,1,OPEN
%10,1400 S Havana St Aurora CO 80012,12,0,0,0,am
%11,14200 E Ellsworth Ave Aurora CO 80012,12,9,0,0,am
%12,2800 Pearl St Boulder CO 80301,9,0,0,0,pm
%13,2171 Prairie Center Pkwy Brighton CO 80601,6,0,0,0,am
%14,5010 Founders Pkwy Castle Rock CO 80108,0,9,1,0,OPEN
%15,1630 E Cheyenne Mountain Blvd Colorado,0,12,0,0,OPEN
%16,7930 Northfield Blvd Denver CO 80238,6,0,0,0,OPEN
%17,7777 E Hampden Ave Denver CO 80231,6,9,1,0,OPEN
%18,6767 S Clinton St Englewood CO 80112,12,16,0,1,am
%19,1265 Sgt Jon Stiles Dr Highlands Ranch CO,9,0,0,0,pm
%20,14500 W Colfax Ave Unit B1 Lakewood CO,12,0,0,0,am
%21,460 S Vance St Lakewood CO 80226,0,16,0,1,OPEN
%22,11150 S Twenty Mile Rd Parker CO 80134,0,16,0,1,OPEN
%23,400 Marshall Rd Superior CO 80027,0,12,0,0,OPEN
%24,1001 E 120th Ave Thornton CO 80233,9,0,0,0,am
%25,10445 Reed St Westminster CO 80021,0,9,1,0,OPEN
%26,14451 Orchard Pkwy Westminster CO 80023,6,6,0,0,pm


a = c.actions(c.number_of_actions - c.number_of_locations + 13);
%13,2171 Prairie Center Pkwy Brighton CO 80601,6,0,0,0,am
assert(a.operation == 'D', 'Wrong operation for action at location 13');
assert(a.in_size == 6, 'Wrong in size for action at location 13');
assert(a.out_size == 0, 'Wrong out size for action at location 13');
assert(a.start_time == 0, 'Wrong start time for action at location 13');
assert(a.stop_time == c.max_time / 2, 'Wrong stop time for action at location 13');
assert(isequal(a.allowable_truck_types, [1 1 1]), 'Wrong constraints for action at location 13');
assert(all([ c.addresses{13} ] == '2171 Prairie Center Pkwy Brighton CO 80601'), 'Wrong address for action 13');


%Need to test several more actions!!!!



%Origin,Destination,Distance,Time
%1,1,0,0
%1,2,28902,981
%3,12,39326,1764
assert(c.distances(1,1) == 0, 'Wrong distance between 1 and 1');
assert(c.durations(1,1) == 0, 'Wrong time between 1 and 1');

assert(c.distances(1,2) == 28902, 'Wrong distance between 1 and 2');
assert(c.durations(1,2) == 981, 'Wrong time between 1 and 2');

assert(c.distances(3,12) == 39326, 'Wrong distance between 3 and 12');
assert(c.durations(3,12) == 1764, 'Wrong time between 3 and 12');


