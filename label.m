function [ objects, positions, count ] = label( CC_mask, I )
%LABEL Labels a frame of video from binary connected component mask from
%segmentation. Does not track
%   CC_mask: connected component mask after segmentation

[r, c] = size(I);
objects = repmat(CreateCopepod('empty', [0 0]), 10000, 1);
positions = zeros(10000, 3);
m_label = bwlabel(CC_mask, 4); % label with 4 connectivity
count = 1;

[labeledImage, numberOfBlobs] = bwlabel(CC_mask);
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
     
     %figure; imshow(thisBlob);title(sprintf('Blob: %d / %d', blob, numberOfBlobs));
     %disp(sprintf('Label %d / %d, Area: %d', blob, numberOfBlobs, area));
     
     %hold on;
     if area > 144
         % To big to be a copepod
         %plot(center(2), center(1), 'b*');
     else
        % Detected a copepod
        copepod = CreateCopepod(vals(1), center);
        
        % Add detected copepod object to objects array at label index
        objects(count) = copepod;
        positions(count, :, :) = [center(1), center(2), count];
        %plot(center(2), center(1), 'ro'); 
        count = count + 1;
     end
 end

end

