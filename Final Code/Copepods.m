function [ copepod_count ] = Copepods( videofile, number_of_frames )
%COPEPODS Runs copepod counting algorithm on video file for a number of
%frames
%   videofile:          filename of the copepod video
%   number_of_frames:   The number of frames to process
%
%   copepod_count:      The final count of copepods that moved through the
%   frames
% 
%   Step images are only shown for the first frame

    % Read video filename into itself
    video = VideoReader(videofile);

    % Set current frame to 1
    cur_frame = 1;

    % For each frame in the video, perform the following operations: 
    while hasFrame(video)

       % Read the next frame of the video
       frame = readFrame(video);

       disp(sprintf('\nRead Frame %d', cur_frame));
        
       % Only show debug images for first frame
       if cur_frame == 1
        figure; title(sprintf('Original Image | time: %f | frame: %d', video.CurrentTime, cur_frame));
        imshow(frame);
       end

       disp('Preprocessing...');

       % Pre-process the image
       ima_pre = preprocess(frame);

       if cur_frame == 1
           figure; title('Image After Pre-Processing'); imshow(ima_pre);
       end

       disp('Segmenting...');
       % Segment the Pre-processed image using active contouring
       ima_seg = segment(ima_pre); 

       if cur_frame == 1
           figure; title('Image After Segmentation'); imshow(ima_seg);
       end

       disp('Labeling...');
       [frame_objects, frame_positions, frame_count] = label(ima_seg, ima_pre);
       
       if cur_frame == 1
          figure; title('Labeled Components'); imshow(ima_seg);
          hold on;
          plot(frame_positions(1:frame_count-1,2,:) , frame_positions(1:frame_count-1,1,:), 'go');
       end

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
       if cur_frame == number_of_frames
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

end

