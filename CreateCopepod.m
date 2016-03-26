function [ copepod ] = CreateCopepod( label,  init_position)
%CREATECOPEPOD Creates a single copepod object
%   label: unique identifier for copepod
%   init_position: coords of initial position new copepod was spotted at
%   copepod.locations: Mx2 array to hold history of pod locations
%   copepod.deltas: M-1x2 array to hold differences between pod locations
%   copepod.latest_pos: coords of last position copepod was at

    % use max num of locations (may need to change)
    MAX_LOCATIONS = 10000;

    copepod = struct('num_locations', 0, 'label', label, 'latest_pos', init_position, 'locations', zeros(MAX_LOCATIONS, 2), 'deltas', zeros(MAX_LOCATIONS, 2));
    copepod;
    copepod.locations(copepod.num_locations+1, :) = init_position;
    copepod.num_locations = 1;

end

