function [ region ] = CreateRegion( label, count )
%CREATEREGION Create a region for area with more than one copepod
%   label: unique identifier of region
%   count: number of copepods in region based on area

    % Define maximum number of copepods in a region
    MAX_COUNT = 100;

    region = struct;
    region.label = label;
    region.count = count;
    region.pods = zeros(MAX_COUNT);

end

