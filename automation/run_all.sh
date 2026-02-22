#!/usr/bin/env bash
# =============================================================================
#  run_all.sh  –  Linux / macOS launcher for the Verilog Lab Report automation
# =============================================================================
#
#  What this does
#  --------------
#  1. Validates that vivado is on PATH (or uses VIVADO_PATH env var).
#  2. Runs vivado_run_all.tcl in batch mode:
#       - Creates a temporary Vivado project per experiment
#       - Runs behavioural simulation  -> exports waveform PNG
#       - Runs RTL elaboration          -> exports schematic PNG
#       - Writes   output/summary.json
#  3. Runs generate_pdf_with_images.py to build the final PDF.
#
#  Prerequisites
#  -------------
#   - Xilinx Vivado 2022.x or later installed
#   - Python 3.9+ on PATH
#   - fpdf2 and Pillow:   pip install fpdf2 Pillow
#
#  Usage
#  -----
#   chmod +x run_all.sh
#   ./run_all.sh [level_start] [level_end] [output_dir]
#
#  Examples
#  --------
#   ./run_all.sh               # run all 12 levels
#   ./run_all.sh 1 3           # run levels 1-3 only
#   ./run_all.sh 1 12 ./out    # specify custom output directory
#
#  Environment variables (override defaults)
#  -----------------------------------------
#   VIVADO_PATH   Full path to vivado binary (if not on PATH)
#   PYTHON_EXE    Python executable to use    (default: python3)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

LEVEL_START="${1:-1}"
LEVEL_END="${2:-12}"
OUTPUT_DIR="${3:-$SCRIPT_DIR/output}"

TCL_SCRIPT="$SCRIPT_DIR/vivado_run_all.tcl"
PY_SCRIPT="$SCRIPT_DIR/generate_pdf_with_images.py"
PDF_OUT="$OUTPUT_DIR/Verilog_Lab_Report_With_Images.pdf"

# ---------------------------------------------------------------------------
# Colour output helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
echo ""
echo "========================================================"
echo "  Verilog Lab Automation – Linux / macOS Runner"
echo "========================================================"
echo "  Repo root   : $REPO_ROOT"
echo "  Script dir  : $SCRIPT_DIR"
echo "  Output dir  : $OUTPUT_DIR"
echo "  Levels      : $LEVEL_START to $LEVEL_END"
echo "========================================================"
echo ""

# ---------------------------------------------------------------------------
# Step 0: Create output directory
# ---------------------------------------------------------------------------
info "Creating output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# ---------------------------------------------------------------------------
# Step 1: Locate vivado
# ---------------------------------------------------------------------------
if [[ -n "${VIVADO_PATH:-}" ]]; then
    if [[ ! -x "$VIVADO_PATH" ]]; then
        error "VIVADO_PATH not executable: $VIVADO_PATH"
    fi
    VIVADO_EXE="$VIVADO_PATH"
elif command -v vivado &>/dev/null; then
    VIVADO_EXE="vivado"
else
    # Try common install locations
    for candidate in \
        /tools/Xilinx/Vivado/*/bin/vivado \
        /opt/Xilinx/Vivado/*/bin/vivado \
        ~/Xilinx/Vivado/*/bin/vivado \
        /usr/local/Xilinx/Vivado/*/bin/vivado; do
        if [[ -x "$candidate" ]]; then
            VIVADO_EXE="$candidate"
            break
        fi
    done
    if [[ -z "${VIVADO_EXE:-}" ]]; then
        error "vivado not found on PATH or in common locations.\n       Set VIVADO_PATH or add Vivado's bin dir to your PATH."
    fi
fi
success "Vivado: $VIVADO_EXE"

# ---------------------------------------------------------------------------
# Step 2: Locate Python
# ---------------------------------------------------------------------------
PYTHON_EXE="${PYTHON_EXE:-}"
if [[ -z "$PYTHON_EXE" ]]; then
    for py in python3 python; do
        if command -v "$py" &>/dev/null; then
            PYTHON_EXE="$py"
            break
        fi
    done
fi
[[ -z "$PYTHON_EXE" ]] && error "python3 / python not found on PATH."
success "Python: $PYTHON_EXE ($($PYTHON_EXE --version 2>&1))"

# ---------------------------------------------------------------------------
# Step 3: Check / install Python dependencies
# ---------------------------------------------------------------------------
info "Checking Python dependencies (fpdf2, Pillow)..."
if ! "$PYTHON_EXE" -c "import fpdf; import PIL" &>/dev/null; then
    warn "fpdf2 or Pillow not found – installing..."
    "$PYTHON_EXE" -m pip install --quiet fpdf2 Pillow || \
        error "pip install failed. Run: pip install fpdf2 Pillow"
fi
success "Python dependencies OK."

# ---------------------------------------------------------------------------
# Step 4: Run Vivado batch simulation + schematic export
# ---------------------------------------------------------------------------
echo ""
info "Running Vivado batch simulation and schematic export..."
info "This may take several minutes for all levels ($LEVEL_START-$LEVEL_END)."
info "Log: $OUTPUT_DIR/vivado_run_all.log"
echo ""

set +e   # allow Vivado to fail without aborting the script
"$VIVADO_EXE" -mode batch \
    -source "$TCL_SCRIPT" \
    -tclargs "$REPO_ROOT" "$OUTPUT_DIR" "$LEVEL_START" "$LEVEL_END" \
    -log "$OUTPUT_DIR/vivado.log" \
    -journal "$OUTPUT_DIR/vivado.jou"
VIVADO_EXIT=$?
set -e

if [[ $VIVADO_EXIT -ne 0 ]]; then
    warn "Vivado exited with code $VIVADO_EXIT."
    warn "Some images may be missing. Continuing with PDF generation."
fi

# ---------------------------------------------------------------------------
# Step 5: Generate PDF with images
# ---------------------------------------------------------------------------
echo ""
info "Generating PDF report..."

"$PYTHON_EXE" "$PY_SCRIPT" "$OUTPUT_DIR" "$PDF_OUT"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo "========================================================"
echo -e "  ${GREEN}DONE!${NC}"
echo "  PDF report: $PDF_OUT"
echo "========================================================"
echo ""

# Auto-open PDF if a viewer is available
if command -v xdg-open &>/dev/null; then
    xdg-open "$PDF_OUT" &
elif command -v open &>/dev/null; then
    open "$PDF_OUT"
fi
