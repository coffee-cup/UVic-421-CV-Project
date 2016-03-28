function [ tracked_objects, tracked_positions, tracked_count, unused_objects] = track( global_objects, global_positions, global_count, frame_objects, frame_positions, frame_count, I)
%TRACK Summary of this function goes here
%   Detailed explanation goes here

    % Radius to look at when comparing copepod locations
    RADIUS = 40;
    
    % Bounds to look for matching copepod
    LEFT = 100;
    RIGHT = 5;
    TOP = 10;
    BOTTOM = TOP;
    
    disp(sprintf('There are %d global copepods and %d frame copepods', global_count, frame_count));
    
    %tracked_objects = global_objects;
    %tracked_positions = global_positions;
    %tracked_count = global_count;
    
    tracked_objects = repmat(CreateCopepod('empty', [0 0]), frame_count, 1);
    tracked_positions = zeros(frame_count, 3);
    tracked_count = 1;
    
    % All of the copepods we have already tracked
    % 1 = not taken, 0 = taken
    taken_positions = ones(size(global_positions,1), 1);
    
    figure(1);
    imshow(I);
    
    pause(5);
    % Plot all global positions (last frames)
    hold on;
    plot(global_positions(:,2,:), global_positions(:,1,:), 'y.');
    pause(5);
    for i=1:frame_count-1
       cur_pos = frame_positions(i, :, :);
       frame_copepod = frame_objects(cur_pos(3));
       
       %figure;
       %imshow(I);
       title(sprintf('Looking at copepod %d / %d', i, frame_count-1));
       
       hold on;
       %plot(cur_pos(2)-LEFT, cur_pos(1)-TOP, 'g.');
       %plot(cur_pos(2)-LEFT, cur_pos(1)+BOTTOM, 'g.');
       %plot(cur_pos(2)+RIGHT, cur_pos(1)+TOP, 'g.');
       %plot(cur_pos(2)+RIGHT, cur_pos(1)-BOTTOM, 'g.');
       pat = patch([cur_pos(2)-LEFT cur_pos(2)-LEFT cur_pos(2)+RIGHT cur_pos(2)+RIGHT], [cur_pos(1)-TOP cur_pos(1)+BOTTOM cur_pos(1)+TOP cur_pos(1)-BOTTOM], 'r');
       set(pat,'FaceAlpha', 0.2);
       % Only compare to copepods in area around copepod we are looking at
       nearest_y = global_positions(:,1,:) > max(0,(cur_pos(1) - TOP)) & global_positions(:,1,:) < (cur_pos(1) + BOTTOM);
       nearest_x = global_positions(:,2,:) > max(0,(cur_pos(2) - LEFT)) & global_positions(:,2,:) < (cur_pos(2) + RIGHT);
       nearest = nearest_y & nearest_x & taken_positions;
       
      hold on;
      plot(cur_pos(2) ,cur_pos(1), 'g.');
       
       % No copepod match was found
       % Add new copepod to global
       if sum(nearest) == 0
           %disp(sprintf('%d/%d: New copepod was detected', i, frame_count-1));
           tracked_objects(tracked_count) = frame_copepod;
           tracked_positions(tracked_count, :, :) = [cur_pos(1), cur_pos(2), tracked_count];
       else
           % We have found potential matches for this copepod
           %disp(sprintf('%d/%d: Found %d potential matches', i, frame_count-1, sum(nearest)));
           nearest_indicies = find(nearest);
           potential_matches = global_positions(nearest_indicies, :, :);
           potential_positions = [potential_matches(:,1,:) potential_matches(:,2,:)];
%            potential_positions = [global_positions(find(nearest), 1, :) global_positions(find(nearest), 2, :)];
           [shortest_distance, shortest_index] = min((potential_positions(:,1)-cur_pos(1)).^2 + (potential_positions(:,2)-cur_pos(2)).^2);
           shortest_distance = sqrt(shortest_distance);
           matched_position = potential_matches(shortest_index,:,:);
           
           % Get the global copepod object that this copepod matches
           matched_copepod = global_objects(matched_position(3));
           
           % Update the copepod object with new data
           matched_copepod.label = tracked_count;
           matched_copepod.num_locations = matched_copepod.num_locations + 1;
           matched_copepod.locations(matched_copepod.num_locations,:) = [cur_pos(1) cur_pos(2)];
           matched_copepod.deltas(matched_copepod.num_locations-1) = shortest_distance;
           matched_copepod.latest_pos = cur_pos;
           matched_copepod;
           
           tracked_objects(tracked_count) = matched_copepod;
           tracked_positions(tracked_count, :, :) = [cur_pos(1), cur_pos(2), tracked_count];
           
           % Mark this global copepod as being taken, so we cant match
           % mutliple objects to it
           taken_positions(nearest_indicies(shortest_index)) = 0;
           
           hold on;
           % Plot potential points
           %plot(potential_positions(:,2), potential_positions(:,1), 'yo');
           
           % Plot matched point to current point
            plot([cur_pos(2) matched_position(:,2,:)], [cur_pos(1) matched_position(:,1,:)], 'g');
           plot(matched_position(:,2,:), matched_position(:,1,:), 'r.');
       end
      tracked_count = tracked_count + 1;
    end
    
    taken_positions = taken_positions(1:global_count-1);
    unused_objects = global_objects(find(taken_positions));

end

