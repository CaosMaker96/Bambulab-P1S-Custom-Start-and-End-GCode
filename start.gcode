;============================================================
;===== Start G-code for Bambu Lab P1S WITH AMS ==============
;===== Author: CaosMaker ====================================
;===== Date: 2025-08-10 =====================================
;============================================================

;===== Reset machine status =================================
G90
M17 X1.2 Y1.2 Z0.75                          ; Reset motor current do default
M290 X40 Y40 Z2.6666666
M220 S100                                    ; Reset Feedrate
M221 S100                                    ; Reset Flowrate
M73.2 R1.0                                   ; Reset left time magnitude
M1002 set_gcode_claim_speed_level :5
M221 X0 Y0 Z0                                ; turn off soft endstop to prevent protential logic problem
G29.1 Z{+0.0}                                ; clear z-trim value first
M204 S10000                                  ; init ACC set to 10m/s^2

;===== Turn on fans to safe defaults ========================
M106 P1 S125                                 ; Part fan
M106 P2 S50                                  ; AUX fan
M106 P3 S125                                 ; Chamber fan BAMBU
M710 A1 S255                                 ; MC board fan automatic

;===== Preheat bed and nozzle then home ====================
M1002 gcode_claim_action :2
G28 X Y                                      ; Home x and y
M140 S[bed_temperature_initial_layer_single] ; Set bed temp
M190 S[bed_temperature_initial_layer_single] ; Wait for bed temp
M109 S140                                    ; Set extruder temp and wait
G28 Z                                        ; When nozzle is hot, home z
M400

G29.2 S1                                     ; Enable ABL

;===== Load stored mesh and verify it = Author: Justagwas ==
M622 J1                                      ; Start mesh verification logic
M1002 gcode_claim_action :1

                                             ; Load the stored mesh
G29 A                                        ; Activates stored ABL mesh

; Probe 5 points and compare to the stored mesh
G29 T X70 Y70 I160 J160                      ; T=Test mode: checks deviation

; (G29 without A rebuilds mesh)
G29                                          ; This will only run if previous comparison failed

; Save the (possibly new) mesh
M500

M623                                         ; End mesh verification logic
M400

;===== bed leveling if checked ==============================
M1002 judge_flag g29_before_print_flag
M622 J1

   M1002 gcode_claim_action : 1
    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500                                     ; save cali data	

    G1 X128 Y128 Z10 F20000                  ; Mech Mode Fast Check
    M400 P200
    M970.3 Q1 A7 B30 C80  H15 K0
    M974 Q1 S2 P0

    G1 X128 Y128 Z10 F20000
    M400 P200
    M970.3 Q0 A7 B30 C90 Q0 H15 K0
    M974 Q0 S2 P0

    M975 S1                                  ; turn on vibration suppression 
    G1 F30000
    G1 X230 Y15                              ; Mech Mode Fast Check End

M623

;===== prepare AMS ==========
M1002 gcode_claim_action : 4
M620 M
M620 S[initial_extruder]A                    ; switch material if AMS exist
    M109 S[nozzle_temperature_initial_layer]
    G1 X120 F12000
    G92 E0
    G1 E-12                                  ; retract 12mm
    T[initial_extruder]
    G1 X54 F12000                            ; go to safe pos
    G1 Y265
    M400
M621 S[initial_extruder]A
M620.1 E F{filament_max_volumetric_speed[initial_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_extruder]}

;===== purge extruder and nozzle ==========

M1002 gcode_claim_action : 14    
M412 S1                          ; turn on filament runout detection
G1 X65 Y265 F8000                ; move to purge area
M104 S250                        ; set nozzle to common flush temp
M106 P1 S0                       ; Part fan off
G92 E0
G1 E25 F200                      ; clean 25mm
M400
M104 S[nozzle_temperature_initial_layer]
G92 E0
G1 E20 F400                      ; clean 20mm
M400
M106 P1 S255                     ; Part fan full
M400 S2                          ; wait 2 sec
G92 E0
G1 E-0.5 F300                    ; retract
M400 S4                          ; wait 4 sec
G92 E0
G1 E-1 F300                      ; retract
G92 E0
M400 S2                          ; wait 2 sec
M106 P1 S125                     ; Part fan lower
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000                    ; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000
M400
G92 E0

;===== wipe nozzle ===============================
M106 P1 S255                     ; part fan full
G1 X65 Y230 F18000
G1 Y264 F6000
G1 X100 F18000                   ; first wipe
G29.2 S0                         ; turn off ABL
G0 Z5 F12000
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
G1 Z10
G29.2 S1                         ; turn on ABL
M975 S1                          ; turn on vibration supression
M106 P1 S125                     ; Part fan lower power

;===== fast nozzle load line ==========================
G28 X Y                          ; re-home XY 
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000        ;Move to start position
M109 S{nozzle_temperature_initial_layer[initial_extruder]}
G1 Z0.2
G0 E2 F300
G0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
G0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X18 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type={curr_bed_type}
{if curr_bed_type=="Textured PEI Plate"}
G29.1 Z{-0.04} ; for Textured PEI Plate
{endif}
;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan
M109 S[nozzle_temperature_initial_layer]
M975 S1 ; turn on mech mode supression
