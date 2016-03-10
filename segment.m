function [ ima_out ] = segment( ima_in )
%PROCESS Segments pods using active contours
%   Detailed explanation goes here
    
    se = strel('square', 3);
    I2 = imdilate(ima_in, se);
    I3 = imerode(ima_in, se);
    
    I4 = I2 - I3;
    
    I5 = 255 - I4;
    
    ima_out = I5;

end

