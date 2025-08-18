Ultimate start and end gcode for Bambulab P1S printers


<p align="center">
    <a href="https://github.com/CaosMaker96/Bambulab-P1S-Ultimate-Start-and-End-gCode/releases/latest" alt="Download latest release">
        <img src="https://img.shields.io/badge/Download-latest-green?logo=github"/></a>
    <a href="https://www.reddit.com/r/BambuLab/comments/1mnecrl/ultimate_p1s_custom_start_and_end_gcode/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button" alt="Reddit Post">
        <img src="https://img.shields.io/badge/Reddit-post-orange?logo=reddit"/></a>
    <a href="https://www.paypal.com/donate/?hosted_button_id=3CAVKXE62BZBN" alt="Donations">
        <img src="https://img.shields.io/badge/Buy_me-a_coffee-blue?logo=paypal"/></a>



</p>

## Why change your default start and end gcode?

 - Faster print start times<br>
 - Better nozzle wipe<br>
 - Less filament wasted when purging, also when loading a new filament from the ams<br>
 - Option to not retract to ams after print<br>
 - Clean and commented code, easy to understand<br>
 - No vibration calibration unless I check the bed level option in the slicer and the printer does all the bed mesh again, as nothing should change from the last calibration stored in memory<br>
 - No trash gcode from the x1 and no useless movement<br>
 - Do the bed leveling, homing and vibration calibration before the filament load and purge, to minimize oozing and time with hot hotend cooking filament<br>


 ## Customizable
 If you want, feel free to scroll through the code and change what you want, with everything explained it's easy to change purge values, remove the priming line, adjust how much the bed lowers after the print.

## How it works?
The order of operation is:<br>
 - Reset machine status
 - Preheat and home
 - Check if the previous mesh is ok, if not, make another one
 - Do the complete bed mesh if it was checked, also do the vibration calibration
 - Prepare AMS if needed
 - Purge and wipe
 - Nozzle load line
 - Print

After print:
 - Lift
 - Option to unload ams
 - Wipe
 - End timelapse
 - Lower bed just 25mm
 - Reset

## WARNING:
<u><b>I cannot be held responsible for any damage or unwanted effect as result of using this code in a machine.</b></u>

<b>I highly suggest to test the code by:</b>
 - in the slicer, after applying the code to the machine settings, with a empty plate
 - right click and add a primitive form, select cube
 - scale the cube, uncheck "uniform scale" and set dimensions to: 1.2 (or x3 nozzle size) x 25 x 0.2
 - this way the printer will execute the start gcode, then make 3 passes 25mm long, and then execute the end gcode
 - keep your hand near the power switch to turn the printer off in case something not expected happens

<b>Firmware updates and slicer updates may brake the code, so testing it after any update is recomended</b>

## To Do List and known issues
 - Change that if bed mesh is not valid, and "do bed calibration" is checked in the slicer, the printer will do the bed mesh twice.
 - Implement wiping on the A1 wiper

## Contributors and credits
Special thanks to reddit user u/tasty_beverage with cleaning the code and removing more junk<br>
Part of the code is from github user Justagwas, specialy the bed mesh verification<br>


