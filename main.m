close all; % closes all figures

video = 'good_video.mp4';
% image = 'test_105.png';
video = VideoReader(video);

cur_frame = 1;
% Loops through image frames
while hasFrame(video)
   str = sprintf('Original Image | time: %f | frame: %d', video.CurrentTime, cur_frame);
   frame = readFrame(video);
   
   disp(sprintf('\nRead Frame %d', cur_frame));
   
   % frame = imread(image);
   figure;
   imshow(frame);
   title(str);
  
   disp('Preprocessing...');
   ima_pre = preprocess(frame);
   
   figure;
   imshow(ima_pre);
   title('Image After Pre-Processing');
   
   disp('Segmenting...');
   ima_seg = segment(ima_pre);
   
   figure;
   imshow(ima_seg);
   title('Image After Segmentation');
   
   disp('Labeling...');
   [frame_objects, frame_positions, frame_count] = label(ima_seg, ima_pre);
   title(sprintf('Labeled copepods for Frame %d', cur_frame));
    
   disp('Tracking...');
   % First frame, set global data as frame data
   if cur_frame == 1
        global_objects = frame_objects;
        global_positions = frame_positions;
        global_count = frame_count;
   else
        [global_objects, global_positions, global_count, unused_objects_frame] = track(global_objects, global_positions, global_count, frame_objects, frame_positions, frame_count, ima_seg);
        if exist('unused_objects')
            unused_objects = cat(1, unused_objects, unused_objects_frame);
        else
            unused_objects = unused_objects_frame;
        end
   end
   
   if cur_frame == 4
       break;
   end
   cur_frame = cur_frame + 1;
end

disp('Eliminating...');
% Eliminate all un-moved copepod objects
[final_objects, final_count] = eliminate(cat(1, global_objects, unused_objects), global_count+size(unused_objects, 1));

disp('Showing Movement...');
show_movement(ima_seg, final_objects, final_count);