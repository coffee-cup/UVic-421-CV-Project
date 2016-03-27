function [ objects, count ] = eliminate( global_objects, global_count )
%ELIMINATE Summary of this function goes here
%   Detailed explanation goes here
    
    objects = repmat(CreateCopepod('empty', [0 0]), 10000, 1);
    positions = zeros(10000, 3);
    count = 1;

    % How much the copepod needs to move to be considered a copepod
    MOVE_THRESH = 20;

    for i=1:global_count
        cur_copepod = global_objects(i);
        moved_amount = sum(cur_copepod.deltas);
        if moved_amount > MOVE_THRESH
           objects(count) = cur_copepod;
           count = count + 1;
        end
    end

end

