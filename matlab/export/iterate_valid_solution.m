function [ best ] = iterate_valid_solution( c, n )
%Written initially by Matthew Stanley

%This function assigns drivers customer requests, and pretty much
%constructs a random solution matrix from scratch.  The parameter c is the
%city in which the solution is created, and n is the number of times to
%run.  This function iteratively compares the solutions it creates, and
%picks the best one (this is why n is in there... the more times it runs,
%the better).
%
% The one major thing that this function does NOT check is if inventories
% fall into the negatives.  That is instead handled by the feasible flag;
% if feasible is ever returned negative, then the solution is discarded and
% the function looks for another one.



%------  NOTE
% This function currently FREEZES if there is a non-morning time window to
% service.  I am trying to fix this... however, if there are no specific
% time constraints, it works as intended.
%------------------------------------------



%This is a basic error that I encountered, that I needed to check for up
%here... if there is no driver in the city that can service a particular
%request because of the truck types, we just terminate


for k = 1:c.number_of_requests
    found_impossible_request = true;
    if ( c.actions( 8 * c.number_of_staging_areas + 4 * c.number_of_landfills + k ).allowable_truck_types(1) == 1 )
        for j = 1:c.number_of_drivers
            if ( c.truck_types(j) == 1 )
                found_impossible_request = false;
                break;
            end
        end
    end
    if ( c.actions( 8 * c.number_of_staging_areas + 4 * c.number_of_landfills + k ).allowable_truck_types(2) == 1 && found_impossible_request == true )
        for j = 1:c.number_of_drivers
            if ( c.truck_types(j) == 2 )
                found_impossible_request = false;
                break;
            end
        end
    end
    if ( c.actions( 8 * c.number_of_staging_areas + 4 * c.number_of_landfills + k ).allowable_truck_types(3) == 1 && found_impossible_request == true )
        for j = 1:c.number_of_drivers
            if ( c.truck_types(j) == 1 )
                found_impossible_request = false;
                break;
            end
        end
    end
    
    %ESCAPE IF THERE IS AN IMPOSSIBLE REQUEST
    if ( found_impossible_request == true )
        warning( strcat('THERE IS NO TRUCK TYPE TO SERVICE REQUEST #', int2str(k), ' IN THIS CITY.  ABORTING.'));
        return;
    end
end

best = -ones(c.number_of_drivers, 1);
requests = zeros(c.number_of_requests, 1); % stores the customer requests
rng('shuffle');

found_one = false;  %Stores whether or not we've found a valid solution or not

number_found = 0; %This is how many solutions are actually found; false ones do not count

%Main loop to continue generating solutions
while ( number_found <= n )
    sol = -ones(c.number_of_drivers, 1);
    %We split up all of the customer requests into a vector so they are
    %in random order and none of them are repeated
    for k = 1:c.number_of_requests
        requests(k) = randi([1, c.number_of_actions]);
        %Make sure this is a customer request
        while (c.actions(requests(k)).operation ~= 'P' && c.actions(requests(k)).operation ~= 'R' && c.actions(requests(k)).operation ~= 'D')
            requests(k) = randi([1, c.number_of_actions]);
            %Check to see if we've assigned this one already; if so,
            %make the while loop continue
            for j = 1:k-1
                if ( requests(k) == requests(j) )
                    requests(k) = 1;
                    break;
                end
            end
        end
    end
    
    %assign everything
    for a = 1:c.number_of_requests
        %Find a random driver, and make sure he can service the request
        driver = randi([1, c.number_of_drivers]);
        while ( c.actions(requests(a)).allowable_truck_types(c.truck_types(driver)) ~= 1 )
            driver = randi([1, c.number_of_drivers]);
        end
        
        %Find a new customer request to assign the driver
        
        %First, we need to find the next empty slot for the driver in his
        %actions; if there is no new slot, we need to resize sol
        pos = 1; % This is the position to assign the driver an action
        while ( sol(driver, pos) ~= -1 )
            %We've reached the end of the matrix
            if ( size(sol, 2) == pos )
                for p = 1:c.number_of_drivers
                    sol(p, pos + 1) = -1;
                end
            end
            pos = pos + 1;
        end
        
        %First, we deal with pickups
        if ( c.actions(requests(a)).operation == 'P' )
            
            %The simplest case is when the driver is empty; then he can
            %just go to the pickup, and then to a dump; this can occur
            %if it is his first action, or if his previous out_size was
            %0
            if ( sol(driver, 1) == -1 || c.actions(sol(driver, pos - 1)).out_size == 0 )
                sol(driver, pos) = requests(a);
                
            else if ( pos > 1 && c.actions(sol(driver, pos - 1)).out_size ~= 0 )
                    
                    %If his previous out size wasn't 0, send him back to a
                    %random staging area to drop off his dumpster, then out to
                    %the customer request
                    %Pick a random yard
                    sol(driver, pos) = randi([1, c.number_of_actions]);
                    while ( c.actions(sol(driver, pos)).operation ~= 'S' || c.actions(sol(driver, pos)).in_size ~= c.actions(sol(driver, pos - 1)).out_size )
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                    end
                    %We've reached the end of the matrix
                    if ( size(sol, 2) == pos )
                        for p = 1:c.number_of_drivers
                            sol(p, pos + 1) = -1;
                        end
                    end
                    pos = pos + 1;
                    sol(driver, pos) = requests(a);
                end
            end
            
            %Now, regardless of how he picked something up, he must
            %now empty it at a dumpster - so we choose one randomly
            %We've reached the end of the matrix
            
            if ( size(sol, 2) == pos )
                for p = 1:c.number_of_drivers
                    sol(p, pos + 1) = -1;
                end
            end
            pos = pos + 1;
            sol(driver, pos) = randi([1, c.number_of_actions]);
            while ( c.actions(sol(driver, pos)).operation ~= 'E' || c.actions(sol(driver, pos)).in_size ~= c.actions(sol(driver, pos - 1)).out_size )
                sol(driver, pos) = randi([1, c.number_of_actions]);
            end
            
        end % End of pickup type
        
        
        
        
        
        
        %Next, we deal with dropoffs
        if ( c.actions(requests(a)).operation == 'D' )
            
            if ( pos == 1 ) %The driver is just starting out, get him to pick up a container
                %Unstage a new dumpster
                sol(driver, pos) = randi([1, c.number_of_actions]);
                while ( c.actions(sol(driver, pos)).operation ~= 'U' || c.actions(requests(a)).in_size ~= c.actions(sol(driver, pos)).out_size )
                    sol(driver, pos) = randi([1, c.number_of_actions]);
                end
                %We've reached the end of the matrix
                if ( size(sol, 2) == pos )
                    for p = 1:c.number_of_drivers
                        sol(p, pos + 1) = -1;
                    end
                end
                pos = pos + 1;
                sol(driver, pos) = requests(a);
                %The simplest case, of course, is when a driver has the
                %right size container on his truck, and we just send him to
                %the dropoff (it is assumed that he has already emptied his
                %load with a pickup)
            else if ( pos > 1 && c.actions(sol(driver, pos - 1)).out_size == c.actions(requests(a)).in_size )
                    sol(driver, pos) = requests(a);
                    
                    
                    %We need him to go to a random yard, and pick up the right
                    %size container (providing the inventory is there)
                    %Pick a random yard, if he has something on his truck
                    %already
                else if ( pos > 1 && c.actions(sol(driver, pos - 1) ).out_size ~= 0 )
                        
                        %Stage what he has
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                        while ( c.actions(sol(driver, pos)).operation ~= 'S' || c.actions(sol(driver, pos)).in_size ~= c.actions(sol(driver, pos - 1)).out_size )
                            sol(driver, pos) = randi([1, c.number_of_actions]);
                        end
                        %We've reached the end of the matrix
                        if ( size(sol, 2) == pos )
                            for p = 1:c.number_of_drivers
                                sol(p, pos + 1) = -1;
                            end
                        end
                        pos = pos + 1;
                        
                        %Unstage a new dumpster
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                        while ( c.actions(sol(driver, pos)).operation ~= 'U' || c.actions(requests(a)).in_size ~= c.actions(sol(driver, pos)).out_size )
                            sol(driver, pos) = randi([1, c.number_of_actions]);
                        end
                        %We've reached the end of the matrix
                        if ( size(sol, 2) == pos )
                            for p = 1:c.number_of_drivers
                                sol(p, pos + 1) = -1;
                            end
                        end
                        pos = pos + 1;
                    else %The driver is empty
                        %Unstage a new dumpster
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                        while ( c.actions(sol(driver, pos)).operation ~= 'U' || c.actions(requests(a)).in_size ~= c.actions(sol(driver, pos)).out_size )
                            sol(driver, pos) = randi([1, c.number_of_actions]);
                        end
                        %We've reached the end of the matrix
                        if ( size(sol, 2) == pos )
                            for p = 1:c.number_of_drivers
                                sol(p, pos + 1) = -1;
                            end
                        end
                        pos = pos + 1;
                    end
                end
                sol(driver, pos) = requests(a);
                
            end % End of dropoff type
        end
        %Finally, we deal with replaces; this is pretty much similar to
        %a dropoff followed by a pickup, in terms of the code
        if ( c.actions(requests(a)).operation == 'R' )
            
            %THE DROPOFF PART
            
            if ( pos == 1 ) %The driver is just starting out, get him to pick up a container
                %Unstage a new dumpster
                sol(driver, pos) = randi([1, c.number_of_actions]);
                while ( c.actions(sol(driver, pos)).operation ~= 'U' || c.actions(requests(a)).in_size ~= c.actions(sol(driver, pos)).out_size )
                    sol(driver, pos) = randi([1, c.number_of_actions]);
                end
                %We've reached the end of the matrix
                if ( size(sol, 2) == pos )
                    for p = 1:c.number_of_drivers
                        sol(p, pos + 1) = -1;
                    end
                end
                pos = pos + 1;
                sol(driver, pos) = requests(a);
                %The simplest case, of course, is when a driver has the
                %right size container on his truck, and we just send him to
                %the dropoff (it is assumed that he has already emptied his
                %load with a pickup)
            else if ( pos > 1 && c.actions(sol(driver, pos - 1)).out_size == c.actions(requests(a)).in_size )
                    sol(driver, pos) = requests(a);
                    
                    
                    %We need him to go to a random yard, and pick up the right
                    %size container (providing the inventory is there)
                    %Pick a random yard, if he has something on his truck
                    %already
                else if ( pos > 1 && c.actions(sol(driver, pos - 1) ).out_size ~= 0 )
                        
                        %Stage what he has
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                        while ( c.actions(sol(driver, pos)).operation ~= 'S' || c.actions(sol(driver, pos)).in_size ~= c.actions(sol(driver, pos - 1)).out_size )
                            sol(driver, pos) = randi([1, c.number_of_actions]);
                        end
                        %We've reached the end of the matrix
                        if ( size(sol, 2) == pos )
                            for p = 1:c.number_of_drivers
                                sol(p, pos + 1) = -1;
                            end
                        end
                        pos = pos + 1;
                        
                        %Unstage a new dumpster
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                        while ( c.actions(sol(driver, pos)).operation ~= 'U' || c.actions(requests(a)).in_size ~= c.actions(sol(driver, pos)).out_size )
                            sol(driver, pos) = randi([1, c.number_of_actions]);
                        end
                        %We've reached the end of the matrix
                        if ( size(sol, 2) == pos )
                            for p = 1:c.number_of_drivers
                                sol(p, pos + 1) = -1;
                            end
                        end
                        pos = pos + 1;
                    else %The driver is empty
                        %Unstage a new dumpster
                        sol(driver, pos) = randi([1, c.number_of_actions]);
                        while ( c.actions(sol(driver, pos)).operation ~= 'U' || c.actions(requests(a)).in_size ~= c.actions(sol(driver, pos)).out_size )
                            sol(driver, pos) = randi([1, c.number_of_actions]);
                        end
                        %We've reached the end of the matrix
                        if ( size(sol, 2) == pos )
                            for p = 1:c.number_of_drivers
                                sol(p, pos + 1) = -1;
                            end
                        end
                        pos = pos + 1;
                    end
                end
                sol(driver, pos) = requests(a);
            end
            %END OF THE DROPOFF PART
            
            
            %THE PICKUP PART
            %We know for a fact the driver is now empty, so we just
            %have him pickup and go to a dump
            
            %Go to a dump
            if ( size(sol, 2) == pos )
                for p = 1:c.number_of_drivers
                    sol(p, pos + 1) = -1;
                end
            end
            pos = pos + 1;
            sol(driver, pos) = randi([1, c.number_of_actions]);
            while ( c.actions(sol(driver, pos)).operation ~= 'E' || c.actions(sol(driver, pos)).in_size ~= c.actions(sol(driver, pos - 1)).out_size )
                sol(driver, pos) = randi([1, c.number_of_actions]);
            end
            
            %END OF THE PICKUP PART OF REPLACE
            
            
        end % End of replace type
    
        %Now, if this is the driver's last action, we must make sure that they
        %drop off this dumpster to a staging area
    
        if ( a == c.number_of_requests )
            for m = 1:c.number_of_drivers
                %find the last action for each driver
                temp = 1;
                while ( sol(m, temp) ~= -1 && temp ~= size(sol, 2)) 
                    temp = temp + 1;
                end
                
                if ( sol(m, temp) ~= -1 && c.actions(sol(m, temp)).operation == 'E' )
                    %Send the driver to unstage
                       if ( size(sol, 2) == temp )
                            for p = 1:c.number_of_drivers
                                sol(p, temp + 1) = -1;
                            end
                            temp = temp + 1;
                       end
                     %Stage the dumpster
                     sol(m, temp) = randi([1, c.number_of_actions]);
                     while ( c.actions(sol(m, temp)).operation ~= 'S' || c.actions(sol(m, temp)).in_size ~= c.actions(sol(m, temp - 1)).out_size )
                            sol(m, temp) = randi([1, c.number_of_actions]);
                     end
                end
            end
        end
        
        
        
        
        
    end
    
    
    
    
    
    
    
    %COMPARISON STAGE
    
    %This is the part where we determine if we have found a better solution
    %than before or not.
    
    %This step just stores the first matrix as the best one, as it is all
    %we have generated:
    [feasible, times, distances, num_serviced, fees, invs] = simulate(c, sol, false);
    if ( feasible == true && found_one == false )
        best = sol;
        found_one = true;
    end
    
    %Now, we start swapping out better and better ones for what we found
    %initially.  NOTE:  There are likely better ways to compare "better"
    %solutions, but I wrote this just for the time being.
    if ( feasible == true && found_one == true )
        
        [feasible_b, times_b, distances_b, num_serviced_b, fees_b, invs_b] = simulate(c, best, false);
        
        %COMPARE THE SOLUTIONS
        if ( sum(times) <= sum(times_b) )
            if ( sol ~= -ones(size(sol,1),size(sol,2)) )
                    best = sol;   %These HAVE to be compared nested like this, or else MATLAB doesn't like it because they are all different dimensions
            end
        end
    end
    
    number_found = number_found + 1;
    
    %END OF THE COMPARISON STAGE
end
end

