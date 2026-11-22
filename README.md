# OnWatch
## Premise 
You have to save your completely frozen over town while a monster is after you! Can you do it?
Here's how it works : 
- You'll be working on a puzzle that'll defrost your town and save everyone
- However, a monster will be hunting you : so you have to be on the look out for that
- There'll be a timer running in the background, you'll be unable to view the timer as you work; but you'll able to hear the timer as you work
- Slide up the puzzle before the timer ends and stop moving entirely (aka stop clicking around)

In essence : Work on your puzzle + occasionally look up and stop moving to avoid the monster's detection

Can you do it? Can you save your town?

**Live Demo**: https://who-li.itch.io/onwatch

**Made by**: Juli (@julietasegovia) and Armitha (@ashokamrita07-sys)

## How it works
### Timer & Gameflow
We have an alarm component that runs a countdown. The countdown's timer is a random ammount between 10 and 30 seconds. The timer is synced with an audio cue (a clocks tick) each second that passes giving the player a cue on how much time they have left.

The game tracks the cursor input for solving the puzzles, it recieves no other input. Once the timer's out the alarm sound goes off and the player will loose if a cursor input is detected. The alarm and the freezing state both last 5 seconds before the timer resets and the monster goes back to sleep.

The monster is represented by a background image. That's just a sprite that pops up while the alarm goes off.

### Puzzles
#### Math Puzzle

#### Camfire Puzzle

#### Scrambled Numbers Puzzle

#### Word Search Puzzle

### Leaderboard
