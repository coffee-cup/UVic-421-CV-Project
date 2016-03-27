function [ tracked_objects, tracked_positions, tracked_count ] = track( global_objects, global_positions, global_count, frame_objects, frame_positions, frame_count, I)
%TRACK Summary of this function goes here
%   Detailed explanation goes here

    % Radius to look at when comparing copepod locations
    RADIUS = 20;
    
    disp(sprintf('There are %d global copepods and %d frame copepods', global_count, frame_count));
    
    %tracked_objects = global_objects;
    %tracked_positions = global_positions;
    %tracked_count = global_count;
    
    tracked_objects = repmat(CreateCopepod('empty', [0 0]), 10000, 1);
    tracked_positions = zeros(10000, 3);
    tracked_count = 1;
    
    taken_positions = zeros(size(global_positions));
    
    for i=1:frame_count
       cur_pos = frame_positions(i, :, :);
       frame_copepod = frame_objects(cur_pos(3));
       
       figure;
       imshow(I);
       title(sprintf('Looking at copepod %d', i));
       
       hold on;
       plot(cur_pos(2)-RADIUS, cur_pos(1)-RADIUS, 'g*');
       plot(cur_pos(2)-RADIUS, cur_pos(1)+RADIUS, 'g*');
       plot(cur_pos(2)+RADIUS, cur_pos(1)+RADIUS, 'g*');
       plot(cur_pos(2)+RADIUS, cur_pos(1)-RADIUS, 'g*');
       % Only compare to copepods in area around copepod we are looking at
       nearest_y = global_positions(:,1,:) > (cur_pos(1) - RADIUS) & global_positions(:,1,:) < (cur_pos(1) + RADIUS);
       nearest_x = global_positions(:,2,:) > (cur_pos(2) - RADIUS) & global_positions(:,2,:) < (cur_pos(2) + RADIUS);
       nearest = nearest_y & nearest_x;
       
       % No copepod match was found
       % Add new copepod to global
       if sum(nearest) == 0
           disp('New copepod was detected');
           tracked_objects(tracked_count) = frame_copepod;
           %tracked_positions(tracked_count, :, :) = 
       end
       
       tracked_count = tracked_count + 1;
       
       break;
    end

end

