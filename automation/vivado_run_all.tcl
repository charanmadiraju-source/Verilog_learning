# =============================================================================
# vivado_run_all.tcl
# =============================================================================
# Master Vivado Tcl script that runs every level experiment end-to-end:
#   1. Creates a temporary Vivado project for the experiment
#   2. Adds all Verilog source files
#   3. Runs behavioral simulation and exports a waveform PNG
#   4. Runs synthesis and exports an RTL schematic PNG
#   5. Writes results to the output directory consumed by generate_pdf_with_images.py
#
# Usage (batch mode - called by run_all.bat / run_all.sh):
#   vivado -mode batch -source vivado_run_all.tcl \
#          -tclargs <repo_root> <output_dir> [level_start] [level_end]
#
# Arguments (via argv):
#   argv[0] : REPO_ROOT   - absolute path to the cloned repository
#   argv[1] : OUTPUT_DIR  - directory where images + logs are written
#   argv[2] : LEVEL_START - first level to run (default 1)
#   argv[3] : LEVEL_END   - last  level to run (default 12)
# =============================================================================

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
set argc [llength $argv]
if {$argc < 2} {
    puts "ERROR: Usage: vivado -mode batch -source vivado_run_all.tcl -tclargs <repo_root> <output_dir> \[level_start\] \[level_end\]"
    exit 1
}

set REPO_ROOT   [lindex $argv 0]
set OUTPUT_DIR  [lindex $argv 1]
set LEVEL_START [expr {$argc >= 3 ? [lindex $argv 2] : 1}]
set LEVEL_END   [expr {$argc >= 4 ? [lindex $argv 3] : 12}]

# Normalise paths (replace backslashes on Windows)
set REPO_ROOT  [string map {\\ /} $REPO_ROOT]
set OUTPUT_DIR [string map {\\ /} $OUTPUT_DIR]

set EXPERIMENTS_DIR "$REPO_ROOT/experiments"
set VIVADO_WORK_DIR "$OUTPUT_DIR/vivado_work"

file mkdir $OUTPUT_DIR
file mkdir $VIVADO_WORK_DIR

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
set LOG_FILE "$OUTPUT_DIR/vivado_run_all.log"
proc log {msg} {
    global LOG_FILE
    set ts [clock format [clock seconds] -format "%H:%M:%S"]
    set line "\[$ts\] $msg"
    puts $line
    set fh [open $LOG_FILE a]
    puts $fh $line
    close $fh
}

# Write a JSON summary file updated after each experiment
set SUMMARY_FILE "$OUTPUT_DIR/summary.json"
set summary_entries {}

proc write_summary {} {
    global SUMMARY_FILE summary_entries
    set fh [open $SUMMARY_FILE w]
    puts $fh "\["
    set n [llength $summary_entries]
    for {set i 0} {$i < $n} {incr i} {
        set entry [lindex $summary_entries $i]
        if {$i < $n-1} {
            puts $fh "  $entry,"
        } else {
            puts $fh "  $entry"
        }
    }
    puts $fh "\]"
    close $fh
}

# ---------------------------------------------------------------------------
# Helper: find the testbench top module name from a _tb.v file
# ---------------------------------------------------------------------------
proc get_tb_module {tb_file} {
    set fh [open $tb_file r]
    set content [read $fh]
    close $fh
    if {[regexp {module\s+(\w+)} $content -> modname]} {
        return $modname
    }
    return ""
}

# ---------------------------------------------------------------------------
# Helper: find the first non-tb top module from RTL files
# ---------------------------------------------------------------------------
proc get_top_module {rtl_files} {
    foreach f $rtl_files {
        set fh [open $f r]
        set content [read $fh]
        close $fh
        if {[regexp {module\s+(\w+)} $content -> modname]} {
            return $modname
        }
    }
    return ""
}

# ---------------------------------------------------------------------------
# Helper: safe Tcl string to JSON string
# ---------------------------------------------------------------------------
proc json_str {s} {
    set s [string map {\\ \\\\ \" \\\" \n \\n \r \\r \t \\t} $s]
    return "\"$s\""
}

# ---------------------------------------------------------------------------
# Core: run one experiment
# ---------------------------------------------------------------------------
proc run_experiment {level_num exp_dir_path exp_name} {
    global OUTPUT_DIR VIVADO_WORK_DIR summary_entries

    log "  --> $level_num/$exp_name"

    # Paths
    set level_out_dir "$OUTPUT_DIR/level${level_num}/$exp_name"
    file mkdir $level_out_dir

    set proj_dir "$VIVADO_WORK_DIR/level${level_num}_${exp_name}"
    file mkdir $proj_dir

    # Collect .v files
    set all_v [lsort [glob -nocomplain "$exp_dir_path/*.v"]]
    if {[llength $all_v] == 0} {
        log "    SKIP: no .v files found"
        return
    }

    set rtl_files  [list]
    set tb_files   [list]
    foreach f $all_v {
        set bn [file rootname [file tail $f]]
        if {[string match "*_tb" $bn]} {
            lappend tb_files $f
        } else {
            lappend rtl_files $f
        }
    }

    if {[llength $tb_files] == 0} {
        log "    SKIP: no testbench found"
        return
    }

    set tb_file [lindex $tb_files 0]
    set tb_mod  [get_tb_module $tb_file]
    set top_mod [get_top_module $rtl_files]

    if {$tb_mod eq ""} {
        log "    SKIP: could not parse testbench module name"
        return
    }

    # -----------------------------------------------------------------
    # Create Vivado project
    # -----------------------------------------------------------------
    set proj_name "proj_${exp_name}"
    catch {close_project -delete} err

    if {[catch {
        create_project -force $proj_name $proj_dir -part xc7a35tcpg236-1
    } err]} {
        log "    ERROR creating project: $err"
        set entry "{\"level\":$level_num,\"name\":[json_str $exp_name],\"status\":\"error\",\"error\":[json_str $err],\"sim_png\":\"\",\"sch_png\":\"\"}"
        lappend summary_entries $entry
        write_summary
        return
    }

    set_property simulator_language Verilog [current_project]

    # Add RTL sources
    foreach f $rtl_files {
        add_files -norecurse $f
    }
    # Add testbench
    add_files -norecurse -sim_only $tb_file

    # -----------------------------------------------------------------
    # Simulation
    # -----------------------------------------------------------------
    set sim_png ""
    set sim_log ""
    set sim_ok  0

    if {[catch {
        set_property top $tb_mod [get_filesets sim_1]
        set_property top_lib {} [get_filesets sim_1]
        launch_simulation
        # Run until the testbench calls $finish (Tcl: run -all)
        # Falls back to 10ms cap if the simulation does not self-terminate
        if {[catch {run -all} run_err]} {
            log "    WARN: run -all failed ($run_err), trying 10ms cap"
            catch {run 10ms}
        }
        set sim_log "$level_out_dir/sim.log"
    } err]} {
        log "    SIM ERROR: $err"
        set sim_log $err
    } else {
        set sim_ok 1
        # -----------------------------------------------------------------
        # Export waveform PNG via the waveform database
        # -----------------------------------------------------------------
        set sim_png_path "$level_out_dir/waveform.png"
        if {[catch {
            # Add all signals to waveform window
            add_wave [get_signals -r /*]
            # Set a reasonable zoom
            wave zoom full
            # Export the waveform window as PNG
            save_wave_config "$level_out_dir/wave.wcfg"
            # Use the screenshot / export image command
            export_simulation_image -format png -file $sim_png_path
            set sim_png $sim_png_path
            log "    Waveform PNG: $sim_png_path"
        } err2]} {
            # Fallback: try alternative Vivado API
            if {[catch {
                wave export image -format png -file $sim_png_path
                set sim_png $sim_png_path
            } err3]} {
                log "    WARN: Could not export waveform PNG ($err2 / $err3)"
                set sim_png ""
            }
        }
        close_sim
    }

    # -----------------------------------------------------------------
    # Synthesis for RTL schematic
    # -----------------------------------------------------------------
    set sch_png ""
    if {$top_mod ne ""} {
        if {[catch {
            set_property top $top_mod [get_filesets sources_1]
            synth_design -rtl -name rtl_1
            set sch_png_path "$level_out_dir/schematic.png"
            # Show the RTL schematic and export
            show_schematic [get_cells -hierarchical]
            # Export the schematic window
            write_schematic -format png -file $sch_png_path -force -scope all
            set sch_png $sch_png_path
            log "    Schematic PNG: $sch_png_path"
        } err]} {
            log "    WARN: Schematic export error: $err"
            set sch_png ""
        }
    }

    # -----------------------------------------------------------------
    # Close project
    # -----------------------------------------------------------------
    catch {close_project}

    # Record result
    set status [expr {$sim_ok ? "ok" : "sim_error"}]
    set entry [subst {{"level":$level_num,"name":[json_str $exp_name],"status":"$status","sim_png":[json_str $sim_png],"sch_png":[json_str $sch_png],"exp_dir":[json_str $exp_dir_path]}}]
    lappend summary_entries $entry
    write_summary
    log "    Done: status=$status"
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
log "============================="
log "Vivado Batch Run All Experiments"
log "  REPO_ROOT   = $REPO_ROOT"
log "  OUTPUT_DIR  = $OUTPUT_DIR"
log "  Levels      = $LEVEL_START .. $LEVEL_END"
log "============================="

set total 0
set ok    0
set fail  0

for {set lvl $LEVEL_START} {$lvl <= $LEVEL_END} {incr lvl} {
    set level_dir "$EXPERIMENTS_DIR/level${lvl}"
    if {![file isdirectory $level_dir]} {
        log "Level $lvl directory not found – skipping"
        continue
    }
    log "============ Level $lvl ============"
    file mkdir "$OUTPUT_DIR/level${lvl}"

    # Sort experiment directories by experiment number
    set exp_dirs [lsort [glob -nocomplain -type d "$level_dir/exp*"]]
    foreach exp_dir $exp_dirs {
        set exp_name [file tail $exp_dir]
        incr total
        run_experiment $lvl $exp_dir $exp_name
        incr ok
    }
}

log "============================="
log "Finished: $total experiments processed"
log "============================="
write_summary
