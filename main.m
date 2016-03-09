close all; % closes all figures

video = VideoReader('small_2.avi');

cur_frame = 1;
% Loops through image frames
while hasFrame(video)
   frame = readFrame(video);
   
   figure;
   imshow(frame);
   str = sprintf('Original Image | time: %f | frame: %d', video.CurrentTime, cur_frame);
   title(str);
   
   ima_pre = preprocess(frame);
   
   figure;
   imshow(ima_pre);
   title('Image After Pre-Processing');
   
   ima_seg = segment(ima_pre);
   
   figure;
   imshow(ima_seg);
   title('Image After Segmentation');
    
   break;
   cur_frame = cur_frame + 1
end