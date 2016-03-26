close all; % closes all figures

video = 'small_2.avi';
image = 'test_105.png';
video = VideoReader(video);

cur_frame = 1;
% Loops through image frames
while hasFrame(video)
   str = sprintf('Original Image | time: %f | frame: %d', video.CurrentTime, cur_frame);
   frame = readFrame(video);
   
   % frame = imread(image);
   figure;
   imshow(frame);
   title(str);
  
   ima_pre = preprocess(frame);
   
   figure;
   imshow(ima_pre);
   title('Image After Pre-Processing');
   
   ima_seg = segment(ima_pre);
   
   figure;
   imshow(ima_seg);
   title('Image After Segmentation');
   
   frame_objects = label(ima_seg, ima_pre);
   
   frame_objects;
    
   break;
   cur_frame = cur_frame + 1;
end