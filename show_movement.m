function [ output_args ] = show_movement( I, objects, count )
%SHOW_MOVEMENT Summary of this function goes here
%   Detailed explanation goes here

    black = zeros(size(I));
    figure; title('Final copepods');
    imshow(black);
    hold on;
    for i=1:count
        cur_copepod = objects(i);
        moved_locations = cur_copepod.locations(1:cur_copepod.num_locations,:);
        plot(moved_locations(:,2), moved_locations(:,1));
        plot(moved_locations(:,2), moved_locations(:,1), 'b.');
        pause(0.001);
    end
end

