% Closes all figures
close all; 

% Get video filename string
video = 'good_video.mp4';

% NR
image = 'test_105.png';

% Read video filename into itself
video = VideoReader(video);

% Set current frame to 1
cur_frame = 1;

% For each frame in the video, perform the following operations: 
while hasFrame(video)
   
   % NR
   str = sprintf('Original Image | time: %f | frame: %d', video.CurrentTime, cur_frame);
   
   % Read the next frame of the video
   frame = readFrame(video);
   
   % NR
   figure;
   imshow(frame);
   title(str);
   
   % Pre-process the image
   ima_pre = preprocess(frame);
   
   % NR
   figure;
   imshow(ima_pre);
   title('Image After Pre-Processing');
   
   % Segment the Pre-processed image using active contouring
   ima_seg = segment(ima_pre);
   
   % NR
   figure;
   imshow(ima_seg);
   title('Image After Segmentation');
   
   % Label the 
   [frame_objects, frame_positions, frame_count] = label(ima_seg, ima_pre);
   title(sprintf('Labeled copepods for Frame %d', cur_frame));
    
   % For the inital frame, initialize global_object data as frame data
   if cur_frame == 1
        global_objects = frame_objects;
        global_positions = frame_positions;
        global_count = frame_count;
   % If not the first frame of video, track the copepods of this frame
   else
        [global_objects, global_positions, global_count] = track(global_objects, global_positions, global_count, frame_objects, frame_positions, frame_count, ima_seg);
   end
   
   %NR
   if cur_frame == 2
       break;
   end 
   
   %Increment current frame
   cur_frame = cur_frame + 1;
   
end