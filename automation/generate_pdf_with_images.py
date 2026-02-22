#!/usr/bin/env python3
"""
generate_pdf_with_images.py
============================
Generates a comprehensive B.Tech-style lab report PDF that includes:
  - Waveform simulation screenshots (PNG) captured by Vivado
  - RTL schematic screenshots (PNG) captured by Vivado
  - Full Verilog RTL + testbench source code
  - Aim, Apparatus, Theory, Algorithm, Expected Results, Conclusion

This script is the **PDF generation** step after vivado_run_all.tcl has
run the simulations and exported the PNG images.

Usage
-----
    python generate_pdf_with_images.py <output_dir> [pdf_output]

Arguments
---------
    output_dir   Directory written by vivado_run_all.tcl (contains
                 level*/exp_name/waveform.png, level*/exp_name/schematic.png
                 and summary.json).
    pdf_output   (optional) Path for the PDF file.
                 Default: <output_dir>/Verilog_Lab_Report_With_Images.pdf

Dependencies
------------
    pip install fpdf2==2.8.6 Pillow

Notes
-----
  - If a waveform or schematic PNG is missing the section is rendered as a
    placeholder note so the rest of the report is unaffected.
  - The REPO_ROOT is determined automatically by resolving the path of this
    script: it assumes this file lives inside   <repo>/automation/
"""

from __future__ import annotations

import json
import sys
import textwrap
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from fpdf import FPDF
from fpdf.enums import XPos, YPos

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT  = SCRIPT_DIR.parent          # automation/ is one level inside repo
LEVEL_ROOT = REPO_ROOT / "experiments"

# ---------------------------------------------------------------------------
# Import shared knowledge base from the sibling generator script so we don't
# duplicate 800 lines of theory / algorithm text.
# ---------------------------------------------------------------------------
sys.path.insert(0, str(REPO_ROOT))
try:
    import generate_level_lab_report as _base
    CATEGORY_DB        = _base.CATEGORY_DB
    FALLBACK_CATEGORY  = _base.FALLBACK_CATEGORY
    LEVEL_DESC         = _base.LEVEL_DESC
    APPARATUS          = _base.APPARATUS
    _safe_text         = _base._safe_text
    _parse_verilog_header = _base._parse_verilog_header
    _get_category      = _base._get_category
    _build_aim         = _base._build_aim
    _experiment_title  = _base._experiment_title
    _experiment_number = _base._experiment_number
    _level_number      = _base._level_number
    _build_expected_results = _base._build_expected_results
except ImportError:
    # Fallback: minimal definitions if the base script is not found
    LEVEL_DESC = {}
    APPARATUS  = "Xilinx Vivado Design Suite (Simulator + Waveform Viewer). PC with min 4 GB RAM."
    CATEGORY_DB = []
    FALLBACK_CATEGORY = {"theory": "", "algorithm": [], "expected_results_heading": ""}

    def _safe_text(s): return s
    def _parse_verilog_header(p): return {}
    def _get_category(n): return FALLBACK_CATEGORY
    def _build_aim(d, r, h): return f"Design and simulate {d.name}."
    def _experiment_title(d):
        import re
        m = re.match(r"exp(\d+)_", d.name)
        if m:
            rest = d.name[m.end():].replace("_"," ").title()
            return f"Experiment {int(m.group(1))}: {rest}"
        return d.name
    def _experiment_number(p):
        import re
        m = re.search(r"exp(\d+)", p.name)
        return int(m.group(1)) if m else 0
    def _level_number(p):
        import re
        m = re.search(r"level(\d+)", p.name)
        return int(m.group(1)) if m else 0
    def _build_expected_results(n, c, h): return "See simulation waveform."


# ---------------------------------------------------------------------------
# PDF helpers  (mirror of those in generate_level_lab_report.py)
# ---------------------------------------------------------------------------

class LabReportPDF(FPDF):
    def __init__(self) -> None:
        super().__init__(format="A4")
        self.set_auto_page_break(auto=True, margin=18)
        self._header_text = "Verilog HDL Lab Report"

    def header(self) -> None:
        if self.page_no() > 1:
            self.set_font("Helvetica", "I", 8)
            self.cell(0, 8, _safe_text(self._header_text),
                      new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="R")
            self.set_draw_color(180, 180, 180)
            self.line(self.l_margin, self.get_y(),
                      self.w - self.r_margin, self.get_y())
            self.ln(2)

    def footer(self) -> None:
        self.set_y(-13)
        self.set_font("Helvetica", "I", 8)
        self.set_draw_color(180, 180, 180)
        self.line(self.l_margin, self.get_y(),
                  self.w - self.r_margin, self.get_y())
        self.ln(1)
        self.cell(0, 8, f"Page {self.page_no()}", align="C")


def _h1(pdf: LabReportPDF, text: str) -> None:
    pdf.set_font("Helvetica", "B", 14)
    pdf.set_fill_color(30, 60, 120)
    pdf.set_text_color(255, 255, 255)
    pdf.cell(0, 8, _safe_text(text), fill=True,
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.set_text_color(0, 0, 0)
    pdf.ln(1)


def _h2(pdf: LabReportPDF, text: str) -> None:
    pdf.set_font("Helvetica", "B", 11)
    pdf.set_fill_color(210, 220, 240)
    pdf.cell(0, 7, _safe_text("  " + text), fill=True,
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.ln(1)


def _body(pdf: LabReportPDF, text: str, font_size: int = 10) -> None:
    pdf.set_font("Helvetica", "", font_size)
    pdf.set_x(pdf.l_margin)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.multi_cell(pw, 5.5, _safe_text(text))
    pdf.ln(1)


def _bullet_list(pdf: LabReportPDF, items: List[str]) -> None:
    pdf.set_font("Helvetica", "", 10)
    for i, item in enumerate(items, 1):
        pdf.set_x(pdf.l_margin)
        pw = pdf.w - pdf.l_margin - pdf.r_margin
        pdf.multi_cell(pw, 5.5, _safe_text(f"  {i}. {item}"))
    pdf.ln(1)


def _code_block(pdf: LabReportPDF, file_path: Path) -> None:
    """Render Verilog source code in a monospace box."""
    code_text = file_path.read_text(encoding="utf-8", errors="replace").replace("\t", "    ")
    printable_w = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.set_font("Helvetica", "B", 8)
    pdf.set_fill_color(200, 210, 235)
    pdf.cell(0, 6, f"  {_safe_text(file_path.name)}",
             fill=True, border=1,
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.set_font("Courier", "", 7.5)
    pdf.set_fill_color(248, 248, 248)
    char_w = pdf.get_string_width("M") or 4.5
    max_cols = max(int(printable_w / char_w), 40)
    for raw_line in code_text.splitlines():
        safe_line = _safe_text(raw_line)
        if not safe_line.strip():
            pdf.cell(0, 3, "", new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            continue
        chunks = textwrap.wrap(safe_line, max_cols, expand_tabs=False,
                               replace_whitespace=False, drop_whitespace=False)
        if not chunks:
            chunks = [safe_line]
        for chunk in chunks:
            pdf.set_x(pdf.l_margin)
            pdf.multi_cell(printable_w, 4, chunk, fill=True)
    pdf.ln(2)


def _insert_image(pdf: LabReportPDF, img_path: Optional[str],
                  caption: str, max_height: float = 80.0) -> None:
    """Insert a PNG image with a caption.  If img_path is None or missing,
    render a placeholder box."""
    pdf.ln(1)
    pdf.set_font("Helvetica", "BI", 9)
    pdf.cell(0, 5, _safe_text(caption),
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")

    printable_w = pdf.w - pdf.l_margin - pdf.r_margin

    if img_path and Path(img_path).is_file():
        # Determine image dimensions to fit within page width
        try:
            from PIL import Image as PILImage
            with PILImage.open(img_path) as im:
                img_w_px, img_h_px = im.size
            # Scale to fit width, cap height
            ratio = img_h_px / max(img_w_px, 1)
            render_w = min(printable_w, 180.0)
            render_h = render_w * ratio
            if render_h > max_height:
                render_h = max_height
                render_w = render_h / max(ratio, 0.01)
            pdf.set_x(pdf.l_margin + (printable_w - render_w) / 2)
            pdf.image(img_path, w=render_w, h=render_h)
        except Exception as exc:
            # If Pillow is unavailable, insert without explicit size
            try:
                pdf.image(img_path, w=printable_w)
            except Exception as exc2:
                _placeholder(pdf, f"[Image error: {exc2}]")
    else:
        reason = "not generated" if img_path else "simulation not run"
        _placeholder(pdf, f"[{caption} – image {reason}]")
    pdf.ln(2)


def _placeholder(pdf: LabReportPDF, msg: str) -> None:
    """Draw a dashed-border placeholder box."""
    pdf.set_draw_color(160, 160, 160)
    pdf.set_fill_color(250, 250, 250)
    pdf.set_font("Helvetica", "I", 9)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.set_x(pdf.l_margin)
    pdf.multi_cell(pw, 20, _safe_text(msg), border=1, align="C", fill=True)
    pdf.ln(1)


def _divider(pdf: LabReportPDF) -> None:
    pdf.set_draw_color(180, 180, 180)
    pdf.line(pdf.l_margin, pdf.get_y(), pdf.w - pdf.r_margin, pdf.get_y())
    pdf.ln(3)


# ---------------------------------------------------------------------------
# Cover page
# ---------------------------------------------------------------------------

def add_cover_page(pdf: LabReportPDF, experiment_count: int,
                   level_count: int) -> None:
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 10)
    pdf.set_text_color(80, 80, 80)
    pdf.cell(0, 8, "Department of Electronics & Communication Engineering",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_font("Helvetica", "", 9)
    pdf.cell(0, 6, "B.Tech Programme - Digital Design Laboratory",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.ln(10)

    pdf.set_draw_color(30, 60, 120)
    pdf.set_line_width(1)
    pdf.rect(pdf.l_margin - 2, pdf.get_y() - 2,
             pdf.w - pdf.l_margin - pdf.r_margin + 4, 44)
    pdf.set_line_width(0.2)

    pdf.set_font("Helvetica", "B", 22)
    pdf.set_text_color(30, 60, 120)
    pdf.cell(0, 14, "Verilog HDL Laboratory",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_font("Helvetica", "B", 16)
    pdf.set_text_color(0, 0, 0)
    pdf.cell(0, 10, "Complete Lab Record with Simulation Waveforms",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.cell(0, 9, "& RTL Schematic Diagrams",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.ln(14)

    pdf.set_font("Helvetica", "", 11)
    pdf.set_text_color(30, 30, 30)
    details = [
        ("Subject",            "Digital Design & HDL Laboratory (ECE3xx)"),
        ("Total Experiments",  str(experiment_count)),
        ("Levels",             str(level_count)),
        ("HDL Standard",       "IEEE Std 1364-2005 (Verilog)"),
        ("Simulation Tool",    "Xilinx Vivado"),
        ("Date Generated",     datetime.now().strftime("%d %B %Y")),
    ]
    col_w = (pdf.w - pdf.l_margin - pdf.r_margin) / 2
    for label, val in details:
        pdf.set_font("Helvetica", "B", 10)
        pdf.cell(col_w * 0.45, 7, _safe_text(label + ":"))
        pdf.set_font("Helvetica", "", 10)
        pdf.cell(col_w * 0.55, 7, _safe_text(val),
                 new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.ln(8)

    pdf.set_font("Helvetica", "I", 9)
    pdf.set_text_color(80, 80, 80)
    pdf.set_x(pdf.l_margin)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.multi_cell(pw, 6,
        "This lab record contains all experiments organised by difficulty level. "
        "Each entry provides Aim, Apparatus, Theory, Algorithm, Verilog RTL source, "
        "Testbench source, Vivado simulation waveform screenshot, RTL schematic "
        "diagram, Expected Simulation Results and Conclusion.")
    pdf.set_text_color(0, 0, 0)


# ---------------------------------------------------------------------------
# Table of Contents
# ---------------------------------------------------------------------------

def add_toc(pdf: LabReportPDF,
            toc_entries: List[Tuple[str, str, int]]) -> None:
    pdf.add_page()
    _h1(pdf, "Table of Contents")
    pdf.set_font("Helvetica", "", 9)
    current_level = ""
    for level_label, title, page in toc_entries:
        if level_label != current_level:
            current_level = level_label
            pdf.ln(2)
            pdf.set_font("Helvetica", "B", 10)
            pdf.cell(0, 6, _safe_text(level_label),
                     new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            pdf.set_font("Helvetica", "", 9)
        title_safe = _safe_text("  " + title)
        page_str   = str(page)
        title_w    = pdf.w - pdf.l_margin - pdf.r_margin - 14
        pdf.cell(title_w, 5.5, title_safe)
        pdf.cell(14, 5.5, page_str, align="R",
                 new_x=XPos.LMARGIN, new_y=YPos.NEXT)


# ---------------------------------------------------------------------------
# Level divider page
# ---------------------------------------------------------------------------

def add_level_divider(pdf: LabReportPDF, level_num: int,
                      exp_count: int) -> None:
    pdf.add_page()
    pdf.ln(30)
    pdf.set_font("Helvetica", "B", 32)
    pdf.set_text_color(30, 60, 120)
    pdf.cell(0, 18, f"Level {level_num}",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_font("Helvetica", "", 14)
    pdf.set_text_color(60, 60, 60)
    desc = LEVEL_DESC.get(level_num, "")
    pdf.set_x(pdf.l_margin)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.multi_cell(pw, 9, _safe_text(desc), align="C")
    pdf.ln(6)
    pdf.set_font("Helvetica", "I", 11)
    pdf.set_text_color(100, 100, 100)
    plural = "s" if exp_count != 1 else ""
    pdf.cell(0, 8, f"({exp_count} experiment{plural})",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_text_color(0, 0, 0)


# ---------------------------------------------------------------------------
# Single experiment page
# ---------------------------------------------------------------------------

def add_experiment(pdf: LabReportPDF,
                   level_label: str,
                   exp_dir: Path,
                   rtl_files: List[Path],
                   tb_files: List[Path],
                   sim_png: Optional[str],
                   sch_png: Optional[str]) -> None:

    pdf.add_page()
    pdf._header_text = (
        f"Verilog HDL Lab Report  |  {level_label}  |  {_experiment_title(exp_dir)}"
    )

    title = _experiment_title(exp_dir)
    _h1(pdf, title)
    pdf.set_font("Helvetica", "", 9)
    pdf.set_text_color(80, 80, 80)
    all_files = rtl_files + tb_files
    pdf.cell(0, 5,
             _safe_text(f"Folder: {exp_dir.relative_to(REPO_ROOT)}  |  "
                        f"Files: {', '.join(f.name for f in all_files)}"),
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.set_text_color(0, 0, 0)
    pdf.ln(2)

    primary = rtl_files[0] if rtl_files else (tb_files[0] if tb_files else None)
    header  = _parse_verilog_header(primary) if primary else {}
    cat     = _get_category(exp_dir.name)

    # 1. Aim
    _h2(pdf, "1. Aim")
    _body(pdf, _build_aim(exp_dir, rtl_files, header))

    # 2. Apparatus
    _h2(pdf, "2. Apparatus / Requirements")
    _body(pdf, APPARATUS)

    # 3. Theory
    _h2(pdf, "3. Theory")
    _body(pdf, cat.get("theory", FALLBACK_CATEGORY.get("theory", "")))

    # 4. Algorithm
    _h2(pdf, "4. Algorithm / Design Methodology")
    _bullet_list(pdf, cat.get("algorithm", FALLBACK_CATEGORY.get("algorithm", [])))

    # 5. RTL Source Code
    _h2(pdf, "5. Verilog RTL Source Code")
    if rtl_files:
        for f in rtl_files:
            _code_block(pdf, f)
    else:
        _body(pdf, "(No separate RTL file - see testbench below.)")

    # 6. Testbench
    _h2(pdf, "6. Testbench / Simulation Code")
    if tb_files:
        for f in tb_files:
            _code_block(pdf, f)
    else:
        _body(pdf, "(No testbench file found in this folder.)")

    # 7. Simulation Waveform (image from Vivado)
    _h2(pdf, "7. Simulation Waveform (Vivado)")
    _insert_image(pdf, sim_png, "Figure 1: Simulation Waveform", max_height=90)

    # 8. RTL Schematic Diagram (image from Vivado)
    _h2(pdf, "8. RTL Schematic Diagram (Vivado)")
    _insert_image(pdf, sch_png, "Figure 2: RTL Schematic", max_height=90)

    # 9. Expected Simulation Results
    _h2(pdf, "9. Expected Simulation Results")
    exp_results = _build_expected_results(exp_dir.name, cat, header)
    _body(pdf, exp_results, font_size=9)
    _body(pdf,
          "Verify that the waveform above matches the expected truth table / "
          "timing diagram. The testbench self-checking logic prints 'PASS' "
          "when all assertions succeed.",
          font_size=9)

    # 10. Result & Conclusion
    _h2(pdf, "10. Result & Conclusion")
    short = title.split(":", 1)[-1].strip() if ":" in title else title
    _body(pdf,
          f"The {short} was successfully designed and simulated in Verilog HDL "
          f"using Xilinx Vivado. The simulation waveform and RTL schematic "
          f"confirm that the circuit behaves correctly for all applied stimulus "
          f"vectors.",
          font_size=10)

    _divider(pdf)


# ---------------------------------------------------------------------------
# Discovery helpers
# ---------------------------------------------------------------------------

def discover_experiments(summary_map: Dict[str, dict]):
    """
    Yield (level_label, level_num, exp_dir, rtl_files, tb_files, sim_png, sch_png)
    for every experiment found in experiments/level*/.
    sim_png / sch_png come from the Vivado summary (may be '' if not generated).
    """
    from typing import Iterable
    import re

    for level_dir in sorted(LEVEL_ROOT.glob("level*"), key=_level_number):
        if not level_dir.is_dir():
            continue
        lvl_num = _level_number(level_dir)
        level_label = f"Level {lvl_num}"
        for exp_dir in sorted(level_dir.iterdir(), key=_experiment_number):
            if not exp_dir.is_dir():
                continue
            all_v  = sorted(exp_dir.glob("*.v"))
            if not all_v:
                continue
            rtl = [f for f in all_v if not f.stem.endswith("_tb")]
            tb  = [f for f in all_v if f.stem.endswith("_tb")]
            key = exp_dir.name
            info = summary_map.get(key, {})
            sim_png = info.get("sim_png") or ""
            sch_png = info.get("sch_png") or ""
            yield level_label, lvl_num, exp_dir, rtl, tb, sim_png, sch_png


def load_summary(output_dir: Path) -> Dict[str, dict]:
    """Load summary.json from the Vivado run output directory."""
    summary_path = output_dir / "summary.json"
    if not summary_path.exists():
        print(f"  [WARN] summary.json not found at {summary_path}")
        print("         Images will not be included. Run vivado_run_all.tcl first.")
        return {}
    try:
        entries = json.loads(summary_path.read_text(encoding="utf-8"))
        return {e["name"]: e for e in entries if "name" in e}
    except Exception as exc:
        print(f"  [WARN] Could not parse summary.json: {exc}")
        return {}


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    if len(sys.argv) < 2:
        print(__doc__)
        raise SystemExit(
            "Usage: python generate_pdf_with_images.py <output_dir> [pdf_output]"
        )

    output_dir = Path(sys.argv[1]).resolve()
    pdf_output = (
        Path(sys.argv[2]).resolve()
        if len(sys.argv) >= 3
        else output_dir / "Verilog_Lab_Report_With_Images.pdf"
    )

    print(f"Output directory : {output_dir}")
    print(f"PDF output       : {pdf_output}")

    summary_map = load_summary(output_dir)
    if summary_map:
        print(f"  Loaded {len(summary_map)} experiment results from summary.json")

    raw = list(discover_experiments(summary_map))
    if not raw:
        raise SystemExit("No experiments found under experiments/level*/")

    sim_count = sum(1 for *_, sim, sch in raw if sim)
    sch_count = sum(1 for *_, sim, sch in raw if sch)
    print(f"  {len(raw)} experiments | {sim_count} waveform PNGs | {sch_count} schematic PNGs")

    # Group by level
    levels_seen: Dict[int, List] = {}
    for level_label, lvl_num, exp_dir, rtl, tb, sim_png, sch_png in raw:
        levels_seen.setdefault(lvl_num, []).append(
            (level_label, exp_dir, rtl, tb, sim_png, sch_png)
        )

    # -- First pass: count pages (body only) to build correct TOC -----------
    body_pdf = LabReportPDF()
    toc_entries: List[Tuple[str, str, int]] = []
    for lvl_num in sorted(levels_seen):
        entries = levels_seen[lvl_num]
        add_level_divider(body_pdf, lvl_num, len(entries))
        for level_label, exp_dir, rtl, tb, sim_png, sch_png in entries:
            page_in_body = body_pdf.page
            add_experiment(body_pdf, level_label, exp_dir, rtl, tb, sim_png, sch_png)
            toc_entries.append((level_label, _experiment_title(exp_dir), page_in_body))

    toc_page_count = max(3, (len(toc_entries) + 39) // 40)
    offset = 1 + toc_page_count   # cover + TOC

    toc_adjusted = [
        (lbl, title, pg + offset)
        for lbl, title, pg in toc_entries
    ]

    # -- Second pass: build final PDF ---------------------------------------
    final_pdf = LabReportPDF()
    add_cover_page(final_pdf, len(raw), len(levels_seen))
    add_toc(final_pdf, toc_adjusted)
    while final_pdf.page < offset:
        final_pdf.add_page()

    for lvl_num in sorted(levels_seen):
        entries = levels_seen[lvl_num]
        add_level_divider(final_pdf, lvl_num, len(entries))
        for level_label, exp_dir, rtl, tb, sim_png, sch_png in entries:
            add_experiment(final_pdf, level_label, exp_dir, rtl, tb, sim_png, sch_png)

    pdf_output.parent.mkdir(parents=True, exist_ok=True)
    final_pdf.output(str(pdf_output))
    print(f"\nWrote {pdf_output}  ({final_pdf.page} pages)")


if __name__ == "__main__":
    main()
