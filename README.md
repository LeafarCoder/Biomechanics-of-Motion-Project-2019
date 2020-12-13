# Biomechanics of Motion - Project 2019


Project for the course of Biomechanics of Motion (Fall 2019) lectured in [IST](http://tecnico.ulisboa.pt/) from the University of Lisbon.
Programmed in Matlab.

## Motions studied

This project focused on 2D analysis of human mechanical motion. Hence, human motions that occur mainly along a single 2D plane are chosen.

Two different motions were studied: a simple **walk stride** and a **deadlift** exercise.

| | |
:----:|:------:
| | |
Walk stride example | Stick-figure constructed from the collected lab data
<img src="/gifs/gait_example.gif" alt="drawing" width="300"/> | <img src="/gifs/gait_stickman_50fps.gif" alt="drawing" width="500"/>
| | |
| | |
Deadlift example | Stick-figure constructed from the collected lab data
<img src="/gifs/deadlift_example.gif" alt="drawing" width="500"/> | <img src="/gifs/deadlift_stickman_50fps.gif" alt="drawing" width="500"/>


## PCA correction

In a laboratory environment, the subject is asked to walk in the direction of one of the main axis of the laboratory, so that all points can be projected onto a known plane for 2D analysis of the movement.
In practice, this is very hard to achieve and small deviations always happen. To correct for this, we use [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis) (Principal Component Analysis) to detect the main direction of the movement and then project it back onto a known plane.

In this example, PCA is used to force the initial movement (in red) to happen in the X direction (in blue):

![gif](/gifs/gait_simulation_30fps.gif)


The benefits of this correction are clear when both versions (corrected and non-corrected) of the gait analysis are compared below.

At least two big artifacts observed in the non-corrected which disapear after the PCA correction: the feet go under the floor level and the arm movement is not natural (the subject walked with a healthy natural gate).

| Non-corrected gait motion | Corrected gait motion |
:---:|:---:
<img src="/gifs/gait_stickman_noPCA_50fps.gif" alt="drawing" width="500"/> | <img src="/gifs/gait_stickman_50fps.gif" alt="drawing" width="500"/>

