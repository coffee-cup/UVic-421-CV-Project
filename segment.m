function [ ima_out ] = segment( ima_in )
%PROCESS Segments pods using active contours
%   Detailed explanation goes here
    
    E = EdgeImage(ima_in);
    
    NUM_SNAKES = 1;
    NUM_POINTS_IN_SNAKE = 5;
    
    imshow(E);
    
    snakes = zeros(NUM_POINTS_IN_SNAKE, 2, NUM_SNAKES);
    % Get points for each snake 
    for i=1:NUM_SNAKES
        title(sprintf('Enter %d points for snake %d', NUM_POINTS_IN_SNAKE, i));
        [x y] = getpts;
        snakes(:,:,i) = [x y];
    end
    
    % Plot points on image
    title('snakes');
    for i=1:NUM_SNAKES
        % Loop through points in snake
        hold on;
        snake = snakes(:,:,i);
        x = snake(:,1);
        y = snake(:,2);
        scatter(x, y);
        line(x, y);
        %for j=1:NUM_POINTS_IN_SNAKE
        %   plot(snake(j,1), snake(j,2), '-x');
        %end
    end
    
    %MoveSnakes(ima_in, snakes);
    
    % Make box
    m = zeros(size(E,1),size(E,2));
    m(min(y):max(y), min(x):max(x)) = 1;
    m(min(y)+100:max(y)+100, min(x)+100:max(x)+100) = 1;
    
    % Show box
    figure; imshow(m);
    
    %-- Run segmentation
    seg = region_seg(E, m, 300, 0.001);

    figure; imshow(seg); title('Global Region-Based Segmentation');
    
    ima_out = E;

end

