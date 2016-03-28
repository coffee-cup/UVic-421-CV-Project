function [ objects, count ] = eliminate( global_objects, global_count )
%ELIMINATE Eliminate copepods that do not move
%   Copepods whose positions do not change by a specific threshold
%   are eliminated and not counted
    
    objects = repmat(CreateCopepod('empty', [0 0]), 10000, 1);
    count = 1;

    % How much the copepod needs to move to be considered a copepod
    % Choosen by experimentation
    MOVE_THRESH = 20;

    % Loop through all counted objects and check if they have moved
    for i=1:global_count
        cur_copepod = global_objects(i);
        moved_amount = sum(cur_copepod.deltas);
        if moved_amount > MOVE_THRESH
           objects(count) = cur_copepod;
           count = count + 1;
        end
    end

end

