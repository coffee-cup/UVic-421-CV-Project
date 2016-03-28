function [ tracked_objects, tracked_positions, tracked_count, unused_objects] = track( global_objects, global_positions, global_count, frame_objects, frame_positions, frame_count, I)
%TRACK Tracks one frame of objects to the previous frame
%   Matches up connected components from one frame to another
%   
%   global_objects:     copepod objects from the previous frames
%   global_positions:   positions and index of copepods from previous
%                       frames, (in format [row, col, index into objects
%                                           array])
%   global_count:       number of objects and positions from previous frame
%   frame_objects:      copepod objects from the current frame
%   frame_positions:    positions and index of copepods from current frame
%   frame_count:        number of objects and positions from current frame
%   
%   tracked_objects:    updated array of copepods that have been tracked
%                       from previous frame to current frame
%   tracked_positions:  positions of updated copepods
%   tracked_count:      number of objects tracked
%   unused_objects:     copepod objects that did not get tracked from the
%                       last frame to the current frame
    
    % Bounds to look for matching copepod
    % These bounds are based off of the ocean currents direction
    % Gives a more accurate tracking of copepods
    LEFT = 200;
    RIGHT = 5;
    TOP = 10;
    BOTTOM = TOP;
    
    tracked_objects = repmat(CreateCopepod('empty', [0 0]), frame_count, 1);
    tracked_positions = zeros(frame_count, 3);
    tracked_count = 1;
    
    % All of the copepods we have already tracked
    % 1 = not taken, 0 = taken
    taken_positions = ones(size(global_positions,1), 1);
    
    % Plot all global positions (last frames)
    %hold on;
    %plot(global_positions(:,2,:), global_positions(:,1,:), 'y.');
    
    % Loop through objects found in current frame and try to find
    % the best match to the last frame
    for i=1:frame_count-1
       cur_pos = frame_positions(i, :, :);
       frame_copepod = frame_objects(cur_pos(3));
       
       title(sprintf('Looking at copepod %d / %d', i, frame_count-1));
       
       % Plot the bounds to look in
       hold on;
       pat = patch([cur_pos(2)-LEFT cur_pos(2)-LEFT cur_pos(2)+RIGHT cur_pos(2)+RIGHT], [cur_pos(1)-TOP cur_pos(1)+BOTTOM cur_pos(1)+TOP cur_pos(1)-BOTTOM], 'r');
       set(pat,'FaceAlpha', 0.2);
       
       % Only compare to copepods in area around copepod we are looking at
       nearest_y = global_positions(:,1,:) > max(0,(cur_pos(1) - TOP)) & global_positions(:,1,:) < (cur_pos(1) + BOTTOM);
       nearest_x = global_positions(:,2,:) > max(0,(cur_pos(2) - LEFT)) & global_positions(:,2,:) < (cur_pos(2) + RIGHT);
       nearest = nearest_y & nearest_x & taken_positions;
       
      % Plot the current object we are looking at
      %hold on;
      %plot(cur_pos(2) ,cur_pos(1), 'g.');
       
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
           
           % Compute the euclidean distances between current object
           % position and all potential matches
           [shortest_distance, shortest_index] = min((potential_positions(:,1)-cur_pos(1)).^2 + (potential_positions(:,2)-cur_pos(2)).^2);
           shortest_distance = sqrt(shortest_distance);
           
           % The matched object is the closest
           matched_position = potential_matches(shortest_index,:,:);
           
           % Get the global copepod object that this copepod matches
           matched_copepod = global_objects(matched_position(3));
           
           % Update the copepod object with new data
           matched_copepod.label = tracked_count;
           matched_copepod.num_locations = matched_copepod.num_locations + 1;
           matched_copepod.locations(matched_copepod.num_locations,:) = [cur_pos(1) cur_pos(2)];
           matched_copepod.deltas(matched_copepod.num_locations-1) = shortest_distance;
           matched_copepod.latest_pos = cur_pos;
           
           % Store the copepod and position as being tracked
           tracked_objects(tracked_count) = matched_copepod;
           tracked_positions(tracked_count, :, :) = [cur_pos(1), cur_pos(2), tracked_count];
           
           % Mark this global copepod as being taken, so we cant match
           % mutliple objects to it
           taken_positions(nearest_indicies(shortest_index)) = 0;
           
           % Plot potential points
           %hold on;
           %plot(potential_positions(:,2), potential_positions(:,1), 'yo');
           
           % Plot matched point to current point
           %plot([cur_pos(2) matched_position(:,2,:)], [cur_pos(1) matched_position(:,1,:)], 'g');
           %plot(matched_position(:,2,:), matched_position(:,1,:), 'r.');
       end
      tracked_count = tracked_count + 1;
    end
    
    % Find all used objects from previous frame that were not tracked
    taken_positions = taken_positions(1:global_count-1);
    unused_objects = global_objects(find(taken_positions));

end

