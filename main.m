%close all; % closes all figures

video = 'small_2.avi';
image = 'DRAGONFISHSUBC13112_20140920T100103.000Z_27.png';
video = VideoReader(video);

cur_frame = 1;
% Loops through image frames
while hasFrame(video)
   str = sprintf('Original Image | time: %f | frame: %d', video.CurrentTime, cur_frame);
   frame = readFrame(video);
   
%    frame = imread(image);
   %figure;
   %imshow(frame);
   %title(str);
  
   
   %figure;
   %imshow(ima_pre);
   %title('Image After Pre-Processing');
   
   ima_seg = segment(ima_pre);
   
   %figure;
   %imshow(ima_seg);
   %title('Image After Segmentation');
    
   break;
   cur_frame = cur_frame + 1
end