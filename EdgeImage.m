function [ E ] = EdgeImage( I )
%EDGEIMAGE Creates edge image by applying dilate and erode

se = strel('square', 3);
I2 = imdilate(I, se);
I3 = imerode(I, se);

I4 = I2 - I3;

E = I4;

end

