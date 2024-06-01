# Speedrunning Mirror's Edge on Linux

### This guide assumes you're playing on the Steam version of the game. Everything is still possible with other versions but you'll have to fill in the Steam-specific gaps for yourself.
<br />

### Step 1 - Replacing the game's executable
Due to issues surrounding Steam and EA DRM, you'll have to replace your game's executable with the GoG No Loads executable. This can be found on Medge's SRC Resources page.  
If you're concerned about compatibility issues, WINE seems to handle them better compared to native Windows.

You can find Medge's game directory by right clicking on the game in your Steam library and clicking "Browse local files".
![image](https://github.com/Loomeh/MedgingOnLinux/assets/67561520/fcfc1b52-9256-4949-bd82-f6c904666742)

### Step 2 - Creating a launcher batch script
We need Medge and LiveSplit (plus whatever medge utilities you're using) to be running under the same wineprefix. The way we do this is by creating a launcher script that just runs all of your executables.

Navigate to Medge's install directory and enter the Binaries folder. Then create a new file called `launch.bat`.

For simplicity's sake, I've placed my LiveSplit folder inside the Binaries folder, meaning my `launch.bat` looks like this:

```bat
start MirrorsEdge.exe
start LiveSplit/LiveSplit.exe
```

If you're storing your programs **outside** of Medge's install directory, you'll need to copy their **full path**.

For example, if I stored my LiveSplit folder inside my Documents folder, my `launch.bat` would look like this:
```bat
start MirrorsEdge.exe
start "Z:\home\zane\Documents\LiveSplit\LiveSplit.exe"
```
**Make sure to remember the "Z:\\" prefix! Wine mounts your main Linux partition as an external drive.**


### Step 3 - Launching your launcher script
You can launch your script from any Wine launcher. Whether that be Lutris, Bottles or the CLI. But for simplicity's sake, we'll just use Steam.

Add your `launch.bat` script as a Non-Steam Game

![image](https://github.com/Loomeh/MedgingOnLinux/assets/67561520/34100503-3186-490f-a51f-2815f1f5621c)



Open the script's properties, head to "Compatibility" and check "Force the use of a specific Steam Play compatibility tool".

![image](https://github.com/Loomeh/MedgingOnLinux/assets/67561520/e14cec73-ea97-4524-b64a-04f9701b6c43)

_By default it should be Proton Experimental, it just defaulted to GE-Proton9-1 for me because I have GE Proton installed._


### Step 4 - Click play
Click the play button on the `launch.bat` entry in Steam. If everything goes well, both Medge and LiveSplit (+ whatever tools you added) should open at the same time.
