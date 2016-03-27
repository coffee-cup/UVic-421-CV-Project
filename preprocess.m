function [ ima_out ] = preprocess( ima_in )
%PREPROCESS Performs prepocessing on input image


    [r, c, s] = size(ima_in);
    
    % Crop image to remove black borders and timestamp
    ima_crop = imcrop(ima_in, [10 10 c-20 r-20]);
    
    % Convert to 8 bit gray scale
    ima_gray = rgb2gray(ima_crop);
    
    % Sharpen with unsharp mask
    ima_sharpen = imsharpen(ima_gray, 'Radius', 10, 'Amount', 3,'Threshold',0.1);
    
    ima_out = ima_sharpen;
    
end

