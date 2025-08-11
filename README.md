# Bambulab-P1S-Custom-Start-and-End-GCode
A faster and cleaner start and end gcode for P1S

WARNING:
I cannot be held responsible for any damage or unwanted effect as result of using this code in your machine.

I highly suggest to test the code by:
 - in the slicer, after applying the code to the machine settings, with a empty plate
 - right click and add a primitive form, select cube
 - scale the cube, uncheck "uniform scale" and set dimensions to: 1.2 (or x3 nozzle size) x 25 x 0.2
 - this way the printer will execute the start gcode, then make 3 passes 25mm long, and then execute the end gcode
 - keep your hand near the power switch to turn the printer off in case something not expected happens

Firmware updates and slicer updates may brake the code, so testing it after any update is recomended
