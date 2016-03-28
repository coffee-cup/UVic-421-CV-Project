***********************************************
*                                             *
*           CENG 421 Final Project            *
*              Copepod Tracking               *
*                 Jake Runzer                 *
*	           Doug Ball                  *
*                                             *
***********************************************

How to run:

To run the code with the provided video simply run the main script.
The video 'copepod_video.mp4' needs to be in the same path as the code and named respectively.

To change the video or number of frames to run on, change the variable
values in the main script or run the 'Copepods' function manually.

The function definition of Copepods is

	function [ copepod_count ] = Copepods( videofile, number_of_frames )
	
To run without errors a 64-bit codec that supports mp4 file formatting must be downloaded or previously present. 
Because of this issue, the code was unable to run on the lab computers; it was however, able to run on both our mac and windows systems.
