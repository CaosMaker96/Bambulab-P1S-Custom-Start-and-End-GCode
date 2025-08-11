Ultimate start and end gcode for Bambulab P1S printers

<b>Why change your default start and end gcode?</b>

 - Faster print start times<br>
 - Better nozzle wipe<br>
 - Less filament wasted when purging, also when loading a new filament from the ams<br>
 - Option to not retract to ams after print<br>
 - No vibration calibration unless I check the bed level option in the slicer and the printer does all the bed mesh again, as nothing should change from the last calibration stored in memory<br>
 - No trash gcode from the x1 and no useless movement<br>
 - Do the bed leveling, homing and vibration calibration before the filament load and purge, to minimize oozing and time with hot hotend cooking filament<br>

<b>The order of operation is:</b>
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

<u><b>WARNING:</b></u>
<u><b>I cannot be held responsible for any damage or unwanted effect as result of using this code in your machine.</b></u>

<b>I highly suggest to test the code by:</b>
 - in the slicer, after applying the code to the machine settings, with a empty plate
 - right click and add a primitive form, select cube
 - scale the cube, uncheck "uniform scale" and set dimensions to: 1.2 (or x3 nozzle size) x 25 x 0.2
 - this way the printer will execute the start gcode, then make 3 passes 25mm long, and then execute the end gcode
 - keep your hand near the power switch to turn the printer off in case something not expected happens

<b>Firmware updates and slicer updates may brake the code, so testing it after any update is recomended</b>

<b>To Do List and known bugs/problems</b>
 - Change that if bed mesh is not valid, and "do bed calibration" is checked in the slicer, the printer will do the bed mesh twice.
