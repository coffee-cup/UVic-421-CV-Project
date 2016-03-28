function [ objects, positions, count ] = label( CC_mask, I )
%LABEL Labels a frame of video from binary connected component mask from
%segmentation. Does not track
%   CC_mask:    connected component mask after segmentation
%   I:          original or pre-processed image with correct size

    % Label all connected components
    [labeledImage, numberOfBlobs] = bwlabel(CC_mask);

    [r, c] = size(I);
    
    % Create array of empty copepod objects as placeholders
    objects = repmat(CreateCopepod('empty', [0 0]), numberOfBlobs, 1);
    positions = zeros(numberOfBlobs, 3);
    
    % label with 4 connectivity
    m_label = bwlabel(CC_mask, 4);
    count = 1;

    % Loop through all found labels
    % Compute label area create new region/copepod depending on size
     for blob=1:numberOfBlobs
         thisBlob = ismember(labeledImage, blob);

         % Find row and col positions of pixels in this component
         [rows, cols, vals] = find(thisBlob);

         area = size(vals, 1);
         sum_r = 0;
         sum_c = 0;
         % Loop through points in labeled area to find its center
         for i=1:area
            sum_r = sum_r + rows(i);
            sum_c = sum_c + cols(i);
         end

         center = [round(sum_r / area) round(sum_c / area)];

         if area < 200
            % Detected a copepod
            copepod = CreateCopepod(vals(1), center);

            % Add detected copepod object to objects array at label index
            objects(count) = copepod;
            positions(count, :, :) = [center(1), center(2), count];
            %plot(center(2), center(1), 'go'); 
            count = count + 1;
         else
            % Not a copepod
         end
     end
end

