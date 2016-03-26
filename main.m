close all; % closes all figures

video = 'good_video.mp4';
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
   
   [frame_objects, frame_positions, frame_count] = label(ima_seg, ima_pre);
    
   % First frame, set global data as frame data
   if cur_frame == 1
       global_objects = frame_objects;
       global_positions = frame_positions;
       global_count = frame_count;
   else
       
   end
   
   break;
   cur_frame = cur_frame + 1;
end