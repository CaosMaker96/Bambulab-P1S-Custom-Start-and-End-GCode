;============================================================
;=========== End G-code for Bambu Lab P1S WITH AMS ==========
;======== Author: CaosMaker =========== Version: 2.0 ========
;============ Please read readme.md for info ================
;============================================================
; https://github.com/CaosMaker96/Bambulab-P1S-Ultimate-Start-and-End-gCode


M400                                         ; wait for buffer to clear
G92 E0                                       ; zero the extruder
G1 E-0.6 F300                                ; retract
G91                                          ; incremental positioning
G1 Z2 F1500                                  ; lift
G90                                          ; absolute positioning
M106 P1 S180
M106 P2 S120
M106 P3 S120                                 ; fans to mid power
M140 S0                                      ; turn off bed

;===== Cut filament and pull back to AMS (disabled) =======
;===== Remove semicolon to enable =========================
;  G1 X65 Y245 F12000                         ; go to purge area
;  G1 Y265 F3000
;  G1 X100 F12000                             ; wipe
;  M620 S255
;  G1 X20 Y50 F12000                          ; go to cut area
;  G92 E0
;  G1 E-12 F200                               ; retract 12 mm
;  G1 Y-3                                     ; cut
;  M621 S255                                  ; retract to ams
;  T255                                       ; ams status: no filament loaded


;===== wipe nozzle ========================================
M104 S140                                    ; extruder to 140
G1 X65 Y245 F12000                           ; go to purge area
G1 Y265 F3000

G1 X100 F18000                               ; first wipe
G1 X60 Y265
G1 X100 F5000                                ; second wipe
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000  
G1 X65 F5000
M400

G29.2 S0                                     ; ABL off
M400 S3                                      ; wait
M106 P1 S0
M106 P2 S0
M106 P3 S0                                   ; all fan off

;===== park and lower bed =================================
G1 X65 Y245 F12000                           ; go to purge area
G1 Y265 F3000
M104 S0                                      ; extruder off
{if (max_layer_z + 25.0) < 250}
   M17 Z0.4                                  ; lower z current to reduce impact
   G1 Z{max_layer_z + 25.0} F600             ; lift 25 mm if there is space
{endif}

;===== end timelapse ======================================
M622.1 S1                                    ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400                                     ; wait all motion done
    M991 S0 P-1                              ; end smooth timelapse at safe pos
M623                                         ; end of "timelapse_record_flag"

;===== Restore currents and magnitudes ====================
M17 X0.8 Y0.8 Z0.5                           ; motors to 45% power
M220 S100                                    ; Reset feedrate magnitude
M201.2 K1.0                                  ; Reset acc magnitude
M73.2   R1.0                                 ; Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0        ; reset display

;==========================================================
;== Disclaimer: In any case the author cannot be held  ====
;==== responsible for any damage or unwanted effect as ====
;== result of using this code on any machine. Please read =
;===== the readme.md file to properly test the code. ======
;==========================================================

