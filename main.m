% Closes all figures
close all; 

% Get video filename string
video = 'good_video.mp4';
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
   
   disp(sprintf('\nRead Frame %d', cur_frame));

   % NR
   %figure;
   %imshow(frame);
   %title(str);
  
   disp('Preprocessing...');
   
   % Pre-process the image
   ima_pre = preprocess(frame);
   
   % NR
   %figure;
   %imshow(ima_pre);
   %title('Image After Pre-Processing');
   
   disp('Segmenting...');
   % Segment the Pre-processed image using active contouring
   ima_seg = segment(ima_pre);
   
   % NR
   %figure;
   %imshow(ima_seg);
   %title('Image After Segmentation');
   
   disp('Labeling...');
   [frame_objects, frame_positions, frame_count] = label(ima_seg, ima_pre);
   title(sprintf('Labeled copepods for Frame %d', cur_frame));
    
   disp('Tracking...');
   % For the inital frame, initialize global data as frame data
   if cur_frame == 1
        global_objects = frame_objects;
        global_positions = frame_positions;
        global_count = frame_count;
   % If not the first frame of video, track the copepods of this frame
   else
        [global_objects, global_positions, global_count, unused_objects_frame] = track(global_objects, global_positions, global_count, frame_objects, frame_positions, frame_count, ima_seg);
        if exist('unused_objects')
            unused_objects = cat(1, unused_objects, unused_objects_frame);
        else
            unused_objects = unused_objects_frame;
        end
   end
   
   % How many frames to process
   if cur_frame == 5
       break;
   end 
   
   %Increment current frame
   cur_frame = cur_frame + 1;
end

disp('Eliminating...');
% Eliminate all un-moved copepod objects
[final_objects, final_count] = eliminate(cat(1, global_objects, unused_objects), global_count+size(unused_objects, 1));

disp('Showing Movement...');
% Plot the movement of copepods over the frames
show_movement(ima_seg, final_objects, final_count);
