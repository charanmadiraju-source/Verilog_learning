#!/usr/bin/env python3
"""Generate a consolidated lab report PDF for all level experiments.

The report walks the `experiments/level*` directories, pulls every `.v` file
(RTL + testbench), and embeds the source code into a single PDF that mimics a
complete lab book. Run this from the repository root:

    python generate_level_lab_report.py

Dependencies: `fpdf2` (install via `pip install fpdf2==2.8.6`).
"""

from __future__ import annotations

from datetime import datetime
from pathlib import Path
import re
from typing import Iterable, List, Tuple

from fpdf import FPDF


REPO_ROOT = Path(__file__).resolve().parent
LEVEL_ROOT = REPO_ROOT / "experiments"
OUTPUT_PDF = REPO_ROOT / "Lab_Report_Level_Experiments.pdf"


def _level_number(path: Path) -> int:
    match = re.search(r"level(\d+)", path.name, re.IGNORECASE)
    return int(match.group(1)) if match else 0


def _experiment_number(path: Path) -> int:
    match = re.search(r"exp(\d+)", path.name, re.IGNORECASE)
    return int(match.group(1)) if match else 0


def _experiment_title(exp_dir: Path) -> str:
    """Convert folder name like `exp01_basic_gates_module` to a title."""
    name = exp_dir.name
    match = re.match(r"exp(\d+)_", name, re.IGNORECASE)
    if match:
        number = match.group(1)
        rest = name[match.end() :]
        return f"Experiment {number}: {rest.replace('_', ' ').replace('-', ' ').title()}"
    return name.replace("_", " ").replace("-", " ").title()


def discover_experiments() -> Iterable[Tuple[str, Path, List[Path]]]:
    """Yield (level_label, experiment_dir, verilog_files) tuples."""
    for level_dir in sorted(LEVEL_ROOT.glob("level*"), key=_level_number):
        if not level_dir.is_dir():
            continue
        level_label = f"Level {_level_number(level_dir)}"
        for exp_dir in sorted(level_dir.iterdir(), key=_experiment_number):
            if not exp_dir.is_dir():
                continue
            verilog_files = sorted(exp_dir.glob("*.v"))
            if not verilog_files:
                continue
            yield level_label, exp_dir, verilog_files


class LabReportPDF(FPDF):
    def __init__(self) -> None:
        super().__init__(format="A4")
        self.set_auto_page_break(auto=True, margin=15)

    def footer(self) -> None:
        self.set_y(-12)
        self.set_font("Helvetica", "I", 8)
        self.cell(0, 10, f"Page {self.page_no()}", align="C")


def add_cover_page(pdf: LabReportPDF, experiment_count: int) -> None:
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 20)
    pdf.cell(0, 14, "Verilog Level Experiments", ln=1, align="C")
    pdf.cell(0, 10, "Comprehensive Lab Report", ln=1, align="C")
    pdf.ln(6)
    pdf.set_font("Helvetica", "", 12)
    pdf.multi_cell(
        0,
        7,
        (
            "This lab book consolidates every experiment found under the "
            "`experiments/level*` directories. Each entry includes the RTL "
            "and accompanying testbench source code to mirror a complete "
            "B.Tech-style lab record."
        ),
    )
    pdf.ln(4)
    pdf.set_font("Helvetica", "", 11)
    pdf.cell(0, 8, f"Generated on: {datetime.now().strftime('%Y-%m-%d')}", ln=1)
    pdf.cell(0, 8, f"Total experiments: {experiment_count}", ln=1)
    pdf.ln(2)


def add_experiment(pdf: LabReportPDF, level_label: str, exp_dir: Path, files: List[Path]) -> None:
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 15)
    pdf.cell(0, 9, f"{level_label} - {_experiment_title(exp_dir)}", ln=1)
    pdf.set_font("Helvetica", "", 11)
    pdf.cell(0, 7, f"Folder: {exp_dir.relative_to(REPO_ROOT)}", ln=1)
    pdf.cell(0, 7, f"Files: {', '.join(f.name for f in files)}", ln=1)
    pdf.ln(3)
    pdf.set_font("Helvetica", "B", 12)
    pdf.cell(0, 7, "Source Code", ln=1)

    for file_path in files:
        pdf.ln(2)
        pdf.set_font("Helvetica", "B", 11)
        pdf.cell(0, 6, file_path.name, ln=1)
        pdf.set_font("Courier", "", 8)
        code_text = file_path.read_text(encoding="utf-8").replace("\t", "    ")
        for line in code_text.splitlines():
            if not line:
                pdf.ln(2)
                continue
            line = (
                line.replace("–", "-")
                .replace("—", "-")
                .replace("“", '"')
                .replace("”", '"')
            )
            printable_width = pdf.w - pdf.l_margin - pdf.r_margin
            approx_char_width = pdf.get_string_width("M")
            max_chars = int(printable_width // approx_char_width) if approx_char_width else 120
            max_chars = max(max_chars, 1)
            for segment in [line[i : i + max_chars] for i in range(0, len(line), max_chars)]:
                pdf.multi_cell(printable_width, 4, segment)


def main() -> None:
    experiments = list(discover_experiments())
    if not experiments:
        raise SystemExit("No experiments found under experiments/level*")

    pdf = LabReportPDF()
    add_cover_page(pdf, len(experiments))
    for level_label, exp_dir, files in experiments:
        add_experiment(pdf, level_label, exp_dir, files)

    pdf.output(OUTPUT_PDF)
    print(f"Wrote {OUTPUT_PDF}")


if __name__ == "__main__":
    main()
