# Gem Hart
Gem Hart is a little game that was a lesson for students to make a Mine Sweeper type of project. It is a grid of treasure chests, that open when tapped, revealing nothing, treasure, or a bomb. This is distinct as the treasure can be various types of gems, which are hints to any neighboring bombs. The gems can be accumulated as points, which are stored between games if all bombs are flagged and / or all safe chests have been opened. When enough points are gathered, options to play larger grids become available.

It was built in Lua on Codea on an iPad, which app allowed it to be exported to Xcode. The app translated the Lua to Cocoa, Apple’s version of Objective-C.

## Installation
The following features might help you install this software:
- Written in Lua on Codea, Version 1.5?
- Exported to Xcode 6.3
- iPad app
- Deployment Target 7.1
- Numerous.framework libraries are included automatically by Codea.

## How to Use Gem Hart
This game is pretty easy to use and understand, especially for anyone who has played Mine Sweeper:
- Launch the app
- Tap on a treasure chest
- Deal with the revelation
- Bomb means game over
- Blue gem means one bomb is touching the chest
- Green gem means two bombs are touching
- Orange gem means three bombs
- 2 green gems means 4 bombs, etc.
- Make a long-touch on a closed chest to mark it with a flag, or to remove a flag
- Find all the safe chests to win
- Tap the top right button to see value of all found gems
- Play 9 X 9 grids, then move on to 11 X 11 and 13 X 13 once enough gems have been gathered

## Bugs
As of April 2016, it is not appearing on the App Store even though it is labeled *Ready for Sale*. 

Also, when Xcode 7.3 tries to build it, it works fine on the Simulator, but fails for some unknown reason when trying to build on a real iPad. There may be missing libraries from Codea now. Furthermore, when re-exported on the latest version of Coda, 2.5, it stalls when building. 

Awaiting communication from Codea.

## Contact 
Send any messages about bugs, issues, requests, praise, etc. to ransomkb@yahoo.com.

## License
Copyright 2015 Ransom Kennicott Barber
