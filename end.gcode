;============================================================
;===== End G-code for Bambu Lab P1S WITH AMS ================
;===== Author: CaosMaker  ===================================
;===== Date: 2025-08-10 =====================================
;============================================================

M400                             ; wait for motion buffer to clear
M17 X1.2 Y1.2 Z0.75              ; reset motor current
M204 S10000
M1002 set_gcode_claim_speed_level :5
G92 E0
G1 E-0.5 F300                    ; Small retract to relieve pressure


;===== Spiral lift and retreat =============================
G91                              ; Relative positioning
G1 Z1 X5 Y5 F3000
G1 X-10 Y5 F3000
G1 X5 Y-10 F3000
G1 Z2 X5 Y5 F3000
G90                              ; Back to absolute positioning

;===== Cut filament and pull back to AMS (disabled) ==========
;===== remove comment for the ams to unload after print ======
;G1 X65 F12000
;G1 Y245 F12000                   ; move to safe pos 
;G1 Y265 F3000
;G1 X100 F12000                   ; wipe
;M620 S255
;G1 X20 Y50 F12000                ; go to cut position
;G92 E0
;G1 E-12 F200                     ; retract 12mm
;G1 Y-3                           ; cut
;M621 S255                        ; retract to ams
;T255                             ; status: no filament loaded

;===== wipe nozzle ===============================
M104 S140                        ; extruder to 140
G1 X65 F12000
G1 Y245 F12000                   ; move to safe pos 
G1 Y265 F3000
G1 X100 F12000                   ; wipe
M400 S3
M140 S0                          ; turn off bed
M106 P2 S125                     ; turn on aux fan
M106 P3 S125                     ; turn on chamber cooling fan
M400

M106 P1 S255                     ; part fan full
G1 X100 F18000                   ; first wipe
G29.2 S0                         ; turn off ABL
G1 X60 Y265
G1 X100 F5000                    ; second wipe
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X110 F5000
M400
M106 P1 S0                       ; Part fan off
M104 S0                          ; nozzle off
M106 P2 S0                       ; turn off aux fan
M106 P3 S0                       ; turn off chamber cooling fan
M106 S0                          ; turn off fan
M400
;===== end timelapse ===============================
M622.1 S1                        ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400                         ; wait all motion done
    M991 S0 P-1                  ; end smooth timelapse at safe pos
    M400 S3                      ; wait for last picture to be taken
M623; end of "timelapse_record_flag"

;===== lower bed 25mm and reset ====================
M400                             ; wait all motion done
M17 S
M17 Z0.4                         ; lower z motor current to reduce impact if there is something in the bottom
{if (max_layer_z + 25.0) < 250}
    G1 Z{max_layer_z + 25.0} F600
{endif}
M400 P100
M17 R                            ; restore z current
M220 S100                        ; Reset feedrate magnitude
M201.2 K1.0                      ; Reset acc magnitude
M73.2   R1.0                     ; Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0
M17 X0.8 Y0.8 Z0.5               ; lower motor current to 45% power


