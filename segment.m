function [ CC_mask ] = segment( ima_in )
%PROCESS Segments pods using active contours
%   Detailed explanation goes here
    
    NUM_SNAKES = 1;
    NUM_POINTS_IN_SNAKE = 5;
    
    %figure; imshow(ima_in);
    
    snakes = zeros(NUM_POINTS_IN_SNAKE, 2, NUM_SNAKES);
    % Get points for each snake 
%     for i=1:NUM_SNAKES
%         title(sprintf('Enter %d points for snake %d', NUM_POINTS_IN_SNAKE, i));
%         [x y] = getpts;
%         snakes(:,:,i) = [x y];
%     end
    
    % Plot points on image
%     title('snakes');
%     for i=1:NUM_SNAKES
%         % Loop through points in snake
%         hold on;
%         snake = snakes(:,:,i);
%         x = snake(:,1);
%         y = snake(:,2);
%         scatter(x, y);
%         line(x, y);
%     end
    
    %MoveSnakes(ima_in, snakes);
    
    % Make box
    %m = zeros(size(ima_in,1),size(ima_in,2));
    %m(min(y):max(y), min(x):max(x)) = 1;
    
    % Show box
%     figure; imshow(m);
    
    %-- Run segmentation
%     seg = region_seg(ima_in, m, 200, 0.001);

%     figure; imshow(seg); title('Global Region-Based Segmentation');
    
    % Apply simple threshold to remove small noise or random specs
    threshValue = graythresh(ima_in);
    I = ima_in < (255 * threshValue);
    figure; imshow(I); title(sprintf('Image thresholded at %d', threshValue*255))
    
    %CC = bwconncomp(I, 4);
    %[labeledImage, numberOfBlobs] = bwlabel(I);
    %measurments = regionprops(labeledImage);
    %contours = zeros(size(ima_in, 1), size(ima_in, 2));
%     figure;

    % Apply active contouring using built in Matlab function
    contours = activecontour(ima_in, imdilate(I, ones(3)));
    
%     for blob=1:numberOfBlobs
%         thisBlob = ismember(labeledImage, blob);
% %         figure; imshow(thisBlob);
%         disp(sprintf('Contour %d / %d', blob, numberOfBlobs));
%         contours = contours + activecontour(ima_in, imdilate(thisBlob, ones(3)), 200, 'Chan-Vese', 'SMOOTHFACTOR', 0.5);
%         figure(4); imshow(contours);
%     end
    
    %figure; imshow(contours); title('CONTOURS!!!!!!!!!!!');
    
    %Identify Number of Copepods found
    %temp = bwconncomp(contours,4);
    %copepods = temp.NumObjects;
    %copepods
    
    
%     [labeledImage, numberOfBlobs] = bwlabel(temp)
    
    %figure; imshow(ima_in .* uint8(contours)); title('Mask Over Image');
    CC_mask = contours;
%     ima_out = seg;

end

