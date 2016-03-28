% Closes all figures
close all; 

% Video filename
video = 'copepod_video.mp4';

% Number of frame process
number_of_frames = 20;

% Run Copepod Tracking
copepod_count = Copepods(video, number_of_frames);