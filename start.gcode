;============================================================
;========== Start G-code for Bambu Lab P1S WITH AMS =========
;======== Author: CaosMaker =========== Version: 2.0 ========
;============ Please read readme.md for info ================
;============================================================

;===== Reset machine and prepare for startup ==============
G90
M17 X1.2 Y1.2 Z0.75                          ; reset motor current
M220 S100                                    ; Reset Feedrate
M221 S100                                    ; Reset Flowrate
M73.2 R1.0                                   ; Reset left time magnitude
M204 S10000                                  ; init ACC set to 10m/s^2
G29.1 Z{+0.0}                                ; clear z-trim value first

;===== Turn on fans =======================================
M106 P1 S0                                   ; part
M106 P2 S0                                   ; aux
M106 P3 S0                                   ; chamber
M710 A1 S255                                 ; MC board fan auto

;===== Preheat bed and nozzle then home ===================
M1002 gcode_claim_action :2                  ; display: heating bed
M140 S[bed_temperature_initial_layer_single] ; set bed temp
M104 S140                                    ; set extruder temp to 140 to reduce oozing but melt any residue
G28 X Y                                      ; home x and y
M190 S[bed_temperature_initial_layer_single] ; wait for bed temp
M1002 gcode_claim_action : 7                 ; display: heating hotend
M109 S140                                    ; wait for extruder temp
M1002 gcode_claim_action : 13                ; display: homing
G28 Z                                        ; home z
M400                                         ; wait
G29.2 S1                                     ; enable ABL

;===== Load stored mesh and verify it = From: Justagwas ==
M1002 gcode_claim_action : 1                 ; display: bed leveling
M622 J1                                      ; start mesh verification
  G29 A                                      ; activate stored mesh
  G29 T X70 Y70 I160 J160                    ; probe 5 points
  G29                                        ; run if comparison failed
  M500                                       ; save the new mesh if done
M623                                         ; end mesh verification

;===== bed leveling if checked ============================
M1002 judge_flag g29_before_print_flag       ; if bed leveling is checked in the slicer
M622 J1                                      ; do the bed leveling mesh
  G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
  M400                                       ; wait
  M500                                       ; save
  G1 X128 Y128 Z10 F20000                    ; Mech Mode Fast Check
  M970.3 Q1 A7 B30 C80 H15 K0
  M974 Q1 S2 P0
  M975 S1                                    ; turn on vibration suppression
M623

;===== prepare AMS =========================================
M1002 gcode_claim_action :4                  ; display: loading filament
G1 Z10                                       ; lift z
M620 M
M620 S[initial_extruder]A                    ; switch material if AMS exists
    M109 S250                                ; wait for nozzle purge temp
    G92 E0                                   ; zero the extruder
    G1 E-12 F200                             ; retract 12 mm
    ; Cutter sequence
    G1 X120 F12000
    G1 X20 Y50 F12000                        ; go to cut position
    G1 Y-3                                   ; cut
    T[initial_extruder]
    G1 X65 Y265 F12000                       ; go to park
M621 S[initial_extruder]A
M620.1 E F{filament_max_volumetric_speed[initial_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_extruder]}

;===== purge extruder and nozzle ==========================

M412 S1                                      ; turn on filament runout detection
G1 X65 Y265 F8000                            ; move to purge area
M106 P1 S0                                   ; Part fan off
M1002 gcode_claim_action : 7                 ; display: heating hotend
M109 S250                                    ; set and wait nozzle to common flush temp
M1002 gcode_claim_action : 14                ; display: cleaning nozzle
G92 E0
G1 E20 F200                                  ; purge 25mm
M400
{if initial_tool!=initial_extruder}         ; if the filament has been changed
  G1 E40 F350                                ; extra purge only on change
  M400
{endif}
M104 S-20                                    ; drop nozzle temp to make filament shrink
M106 P1 S255                                 ; Part fan full
M400 S8                                      ; wait 8 sec
M104 S[nozzle_temperature_initial_layer]     ; nozzle at print temperature
G92 E0
G1 E-0.8 F300                                ; retract  
M400                                         ; wait to finish

M106 P1 S125                                 ; Part fan mid power
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000                                ; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000
M400

;===== wipe nozzle ========================================
G1 X65 Y230 F18000                           ; return to park
G1 Y264 F6000
G1 X100 F18000                               ; first wipe
G1 X60 Y265
G1 X100 F5000                                ; second wipe
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X65 F15000
M400                                         ; wait to finish
M106 P1 S0                                   ; Part fan off


;===== fast nozzle load line ==============================
M1002 gcode_claim_action : 7                 ; display: heating hotend
M109 S[nozzle_temperature_initial_layer]     ; wait for extruder temp
G28 X Y                                      ; home xy
G90                                          ; absolute positioning
M83                                          ; extruder to relative pos
G1 X18.0 Y1.0 Z0.28 F18000
G1 E2 F300
G1 X200 E8  F{outer_wall_volumetric_speed/(0.3*0.5)*60}
G1 Y8   E1.5 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G1 X40  E6  F{outer_wall_volumetric_speed/(0.3*0.5)*60}
G1 E-0.6 F300
M106 P1 S0                                   ; aux fan off

{if curr_bed_type=="Textured PEI Plate"}     ; for texture PEI plate
    G29.1 Z{-0.04}                           ; lower z offset
{endif}
M1002 gcode_claim_action : 0                 ; reset status

;==========================================================
;== Disclaimer: In any case the author cannot be held  ====
;==== responsible for any damage or unwanted effect as ====
;== result of using this code on any machine. Please read =
;===== the readme.md file to properly test the code. ======
;==========================================================
