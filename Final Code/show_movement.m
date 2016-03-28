function [ output_args ] = show_movement( I, objects, count )
%SHOW_MOVEMENT Draws the movement of copepod objects overlayed on image I

    % Uncomment to draw copepods on black image
    %black = zeros(size(I));
    
    figure; title('Final Copepod Movement');
    imshow(I);
    hold on;
    for i=1:count
        cur_copepod = objects(i);
        moved_locations = cur_copepod.locations(1:cur_copepod.num_locations,:);
        plot(moved_locations(:,2), moved_locations(:,1));
        plot(moved_locations(:,2), moved_locations(:,1), 'b.');
    end
end

