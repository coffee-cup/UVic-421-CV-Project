function [ CC_mask ] = segment( ima_in )
%PROCESS Segments pods using active contours
%   Detailed explanation goes here
    
    % Dilate and Erode to get border image
    ima_edge = EdgeImage(ima_in);

    % Apply simple threshold to remove small noise or random specs
    threshValue = graythresh(ima_edge);
    ima_thresh = ima_edge > (255 * threshValue);
     
    % Apply active contouring using built in Matlab function
    contours = activecontour(ima_edge, imdilate(ima_thresh, ones(5)));
    %seg = region_seg(ima_edge, imdilate(ima_thresh, ones(7)), 200);
    
    CC_mask = contours;

end

