% Closes all figures
close all; 

% Video filename
video = 'good_video.mp4';

% Number of frame process
number_of_frames = 2;

% Run Copepod Tracking
copepod_count = Copepods(video, number_of_frames);