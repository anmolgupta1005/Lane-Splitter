# Rush Hour

## Introduction

Going through the history of computing and electronics, people have harnessed technology not
just to increase the productivity, but also for the entertainment. As the improvement in the
gaming industry is increasing day by day, more powerful computers are needed. The gaming
technology has changed from text based games to graphic and now changing from 2D to 3D
games.


“RUSH HOUR” which was classically known as "lane splitter" has been in the gaming
industry for a while now. The game has always been been played by people of all the age
groups. It is a fun, relaxing game but could sometime cause an addiction too.


The purpose of this project is to recreate this game on FPGA and programming the game using
an HDL. It seems to be a challenge to program a game using a HDL. The major difference here is that,
application developers have absolutely no idea of the hardware or the system, on which their
programs will run. To program in a HDL, one must be aware of the hardware. This implies that
the application is developed with the entire knowledge of the hardware. Is this an added
advantage or just unrequired additional feature? Let’s find it out.


## Gameplay
The implementation of this game is all around the VGA display. Monitor is interfaced with 
FPGA and using the push buttons onboard, the car is controlled. It’s a 3 laned highway on
which the user is driving the car and as the time passes by, traffic increases with increase in the
speed of the car. The screen shows the road, the controlled car in yellow, and the traffic in red.
The landscape involves, grassed planes by the side of the road. The score is continuously
monitored and displayed on the top left part of the screen. When the car crashes, game ends and
the screenplay changes to gameover screen. This screen now has the word ‘CRASHED’
appearing slowly, indicating GAMEOVER. his screen also displays the score flickering in green.
Features of games:
  * Single player game

  * 3laned highway i.e. 3 ways to dodge traffic

  * Dynamic difficulty
  
  * Crash and game over

  * Final score is displayed

  * Animated display of text

  * Multifont


[Watch the video](https://www.youtube.com/watch?v=s36H25OkzVQ)
