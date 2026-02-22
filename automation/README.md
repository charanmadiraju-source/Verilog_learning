# Verilog Lab Automation – Run All Experiments with Vivado

This folder contains scripts that automatically run **every level experiment**
in the repository through Xilinx Vivado, capture **simulation waveform PNGs**
and **RTL schematic PNGs**, and then bundle everything into a single
**B.Tech-style PDF lab report**.

---

## Quick Start

### Windows

1. Open a **Command Prompt** (no need for admin rights).
2. Navigate to this folder (or just double-click `run_all.bat`).
3. To run **all 12 levels**:
   ```bat
   run_all.bat
   ```
4. To run a **single level** (e.g. Level 1):
   ```bat
   run_level.bat 1
   ```
5. To run a **range** (e.g. Levels 1–3):
   ```bat
   run_level.bat 1 3
   ```

The final PDF is saved to:
```
automation\output\Verilog_Lab_Report_With_Images.pdf
```

### Linux / macOS

```bash
cd automation
chmod +x run_all.sh
./run_all.sh             # all 12 levels
./run_all.sh 1 1         # level 1 only
./run_all.sh 1 3         # levels 1-3
```

---

## Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| **Xilinx Vivado** | 2022.x+ | Add `<Vivado>\bin` to `PATH`, or set `VIVADO_PATH` |
| **Python** | 3.9+ | Must be on `PATH` |
| **fpdf2** | 2.8.x | `pip install fpdf2` |
| **Pillow** | any | `pip install Pillow` |

The batch/shell scripts will automatically install `fpdf2` and `Pillow` if
they are not already present.

---

## File Overview

```
automation/
├── run_all.bat               Windows: run all levels
├── run_all.sh                Linux/macOS: run all levels
├── run_level.bat             Windows: run a single level or range
├── vivado_run_all.tcl        Vivado Tcl: simulation + schematic capture
├── generate_pdf_with_images.py  Python: PDF assembly with images
└── README.md                 This file
```

### `vivado_run_all.tcl`
Master Tcl script that Vivado executes in batch mode.  For each experiment it:
1. Creates a throw-away Vivado project in `<output>/vivado_work/`.
2. Adds all `.v` source files (RTL + testbench).
3. Sets the testbench as the simulation top and runs the simulation.
4. Exports the waveform window as a PNG (`waveform.png`).
5. Elaborates the RTL design and exports the schematic as a PNG (`schematic.png`).
6. Writes a `summary.json` file consumed by the PDF generator.

### `generate_pdf_with_images.py`
Python PDF generator.  It reads `summary.json` and the PNG files, then builds
a **10-section lab report** for each experiment:

| # | Section |
|---|---------|
| 1 | Aim |
| 2 | Apparatus / Requirements |
| 3 | Theory |
| 4 | Algorithm / Design Methodology |
| 5 | Verilog RTL Source Code |
| 6 | Testbench / Simulation Code |
| **7** | **Simulation Waveform (Vivado PNG)** |
| **8** | **RTL Schematic Diagram (Vivado PNG)** |
| 9 | Expected Simulation Results |
| 10 | Result & Conclusion |

If a PNG is missing (e.g. Vivado had an error for that experiment) a labelled
placeholder is inserted so the rest of the report is unaffected.

---

## Customisation

### Change Vivado part / device
Edit the `create_project` line in `vivado_run_all.tcl`:
```tcl
create_project -force $proj_name $proj_dir -part xc7a35tcpg236-1
```
Replace `xc7a35tcpg236-1` with your FPGA part number (it only matters for
synthesis/implementation; behavioural simulation works with any part).

### Run only specific levels
**Windows**
```bat
SET LEVEL_START=3
SET LEVEL_END=5
CALL run_all.bat
```
or use:
```bat
run_level.bat 3 5
```

**Linux**
```bash
./run_all.sh 3 5
```

### Custom output directory
**Windows** – edit `OUTPUT_DIR` at the top of `run_all.bat`, or pass via env:
```bat
SET OUTPUT_DIR=C:\MyReports
CALL run_all.bat
```

**Linux** – third argument:
```bash
./run_all.sh 1 12 /home/user/my_reports
```

### Skip Vivado and only rebuild the PDF
If you already have the PNG images from a previous Vivado run:
```bash
# Linux / macOS
python3 generate_pdf_with_images.py ./output

# Windows
python generate_pdf_with_images.py output
```

---

## Output Directory Structure

After a successful run:
```
output/
├── summary.json                  Vivado run results
├── vivado_run_all.log            Script log
├── vivado.log                    Vivado log
├── vivado.jou                    Vivado journal
├── vivado_work/                  Temporary project files (can be deleted)
├── level1/
│   ├── exp01_basic_gates_module/
│   │   ├── waveform.png          Simulation waveform screenshot
│   │   ├── schematic.png         RTL schematic screenshot
│   │   ├── sim.log               Simulation console output
│   │   └── wave.wcfg             Waveform configuration
│   └── ...
├── level2/
│   └── ...
└── Verilog_Lab_Report_With_Images.pdf   ← final deliverable
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `vivado: command not found` | Add Vivado's `bin/` to `PATH`, or set `VIVADO_PATH` in `run_all.bat` / as env var |
| `python: command not found` | Install Python 3.9+, or set `PYTHON_EXE` env var to the full path |
| Some images are blank / missing | Check `output/vivado_run_all.log` for errors on specific experiments |
| PDF is too large | Reduce PNG resolution in the Tcl script (`export_simulation_image -scale_factor 0.5`) |
| Simulation takes too long | Reduce `LEVEL_END` or comment out heavy levels (8–12) in `run_all.bat` |

---

## Notes

- Vivado project files are created under `output/vivado_work/` and can be
  safely deleted after the PDF is generated.
- The VCD waveform databases are **not** committed to git (see `.gitignore`).
- The PDF generator (`generate_pdf_with_images.py`) reuses the theory and
  algorithm database from the root-level `generate_level_lab_report.py` so
  all knowledge stays in one place.
