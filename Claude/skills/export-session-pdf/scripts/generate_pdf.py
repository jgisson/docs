#!/usr/bin/env python3
"""
Generate a polished PDF export of a Claude conversation session.

Usage:
    python3 generate_pdf.py <input.json> <output.pdf>

Input JSON format:
{
  "title": "Session Title (optional)",
  "date": "March 28, 2026 (optional)",
  "messages": [
    {"role": "user", "content": "Hello"},
    {"role": "assistant", "content": "Hi there!"}
  ]
}
"""

import json
import re
import sys
from datetime import datetime

from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, HRFlowable, Table, TableStyle
)
from reportlab.pdfgen import canvas as pdfcanvas


# ─── Color palette ────────────────────────────────────────────────────────────
USER_BG      = colors.HexColor("#EEF2FF")
ASST_BG      = colors.HexColor("#FAF9F7")
BORDER_COLOR = colors.HexColor("#D8D3CC")
LABEL_USER   = colors.HexColor("#3D63DD")
LABEL_ASST   = colors.HexColor("#D97757")
TEXT_DARK    = colors.HexColor("#1A1A1A")
TEXT_LIGHT   = colors.HexColor("#888888")
CODE_BG      = colors.HexColor("#EFEFEF")
CODE_TEXT    = colors.HexColor("#2D2D2D")

PAGE_W, PAGE_H = A4
LEFT_MARGIN  = 2.2 * cm
RIGHT_MARGIN = 2.2 * cm
TOP_MARGIN   = 2.5 * cm
BOT_MARGIN   = 2.5 * cm
CONTENT_W    = PAGE_W - LEFT_MARGIN - RIGHT_MARGIN
BUBBLE_W     = CONTENT_W - 0.2 * cm

VPAD = 8
HPAD = 12


# ─── Styles ───────────────────────────────────────────────────────────────────
def build_styles():
    base = getSampleStyleSheet()

    def s(name, parent="Normal", **kw):
        return ParagraphStyle(name, parent=base[parent], **kw)

    return {
        "title": s("STitle",
            fontSize=22, leading=28, textColor=TEXT_DARK,
            spaceAfter=4, fontName="Helvetica-Bold", alignment=TA_CENTER),
        "subtitle": s("SSubtitle",
            fontSize=10, leading=14, textColor=TEXT_LIGHT,
            spaceAfter=2, alignment=TA_CENTER),
        "label_user": s("SLabelUser",
            fontSize=7.5, leading=10, textColor=LABEL_USER,
            fontName="Helvetica-Bold"),
        "label_asst": s("SLabelAsst",
            fontSize=7.5, leading=10, textColor=LABEL_ASST,
            fontName="Helvetica-Bold"),
        "body": s("SBody",
            fontSize=10, leading=15.5, textColor=TEXT_DARK,
            fontName="Helvetica", wordWrap="CJK"),
        "code": s("SCode",
            fontSize=8.5, leading=13, textColor=CODE_TEXT,
            fontName="Courier", backColor=CODE_BG, wordWrap="CJK"),
        "footer": s("SFooter",
            fontSize=8, leading=10, textColor=TEXT_LIGHT, alignment=TA_CENTER),
    }


# ─── Text helpers ─────────────────────────────────────────────────────────────
def escape(text):
    return (text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;"))


def apply_inline_markup(text):
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    text = re.sub(r"\*(.+?)\*",     r"<i>\1</i>", text)
    return text


def parse_content(raw, styles):
    """Return flat list of flowables from message content."""
    result = []
    body = styles["body"]
    code = styles["code"]

    parts = raw.split("```")
    for i, part in enumerate(parts):
        if i % 2 == 1:
            # Code block
            lines = part.split("\n")
            if lines and lines[0].strip() and " " not in lines[0].strip():
                lines = lines[1:]  # strip language tag
            for line in "\n".join(lines).strip().split("\n"):
                result.append(Paragraph(escape(line) or "\u00a0", code))
        else:
            # Normal text
            for para in part.split("\n\n"):
                text = para.strip()
                if not text:
                    continue
                joined = "<br/>".join(
                    apply_inline_markup(escape(l)) for l in text.split("\n")
                )
                result.append(Paragraph(joined, body))

    return result or [Paragraph("\u00a0", body)]


# ─── Bubble builder ───────────────────────────────────────────────────────────
def message_block(msg, styles):
    """
    Build a message bubble as a multi-row Table.

    KEY DESIGN for correct page-break behaviour:
    - Each row holds exactly one Paragraph — ReportLab splits at row boundaries.
    - We use per-edge line commands (LINEABOVE/LINEBELOW/LINEBEFORE/LINEAFTER)
      instead of BOX. When the table splits across pages, BOX only draws the
      outer rectangle of the *first* chunk — leaving blank space as the rest of
      the message jumps to the next page. Per-edge commands let us keep left
      and right borders on ALL rows (always visible) and top/bottom only on
      the first/last row, so the border renders correctly on every page.
    - NOSPLIT is intentionally absent so long messages flow without whitespace.
    """
    role    = msg.get("role", "user")
    content = msg.get("content", "")
    is_user = (role == "user")

    bg          = USER_BG if is_user else ASST_BG
    label_style = styles["label_user"] if is_user else styles["label_asst"]
    label_text  = "YOU" if is_user else "CLAUDE"

    content_rows = parse_content(content, styles)

    rows = (
        [[Paragraph(label_text, label_style)]]
        + [[f] for f in content_rows]
        + [[Paragraph("\u00a0", styles["body"])]]   # bottom padding row
    )
    n    = len(rows)
    last = n - 1

    tbl = Table(rows, colWidths=[BUBBLE_W], splitByRow=1)
    tbl.setStyle(TableStyle([
        ("BACKGROUND",    (0, 0),    (-1, -1),    bg),

        ("LEFTPADDING",   (0, 0),    (-1, -1),    HPAD),
        ("RIGHTPADDING",  (0, 0),    (-1, -1),    HPAD),

        # Label row: top space + tight bottom
        ("TOPPADDING",    (0, 0),    (0, 0),      VPAD),
        ("BOTTOMPADDING", (0, 0),    (0, 0),      3),
        # Content rows
        ("TOPPADDING",    (0, 1),    (-1, last-1), 1),
        ("BOTTOMPADDING", (0, 1),    (-1, last-1), 3),
        # Bottom spacer row
        ("TOPPADDING",    (0, last), (-1, last),  0),
        ("BOTTOMPADDING", (0, last), (-1, last),  VPAD),

        # ── Border (per-edge so splitting across pages renders correctly) ──
        ("LINEBEFORE",    (0, 0),    (0, -1),     0.6, BORDER_COLOR),  # left: all rows
        ("LINEAFTER",     (-1, 0),   (-1, -1),    0.6, BORDER_COLOR),  # right: all rows
        ("LINEABOVE",     (0, 0),    (-1, 0),     0.6, BORDER_COLOR),  # top: first row only
        ("LINEBELOW",     (0, last), (-1, last),  0.6, BORDER_COLOR),  # bottom: last row only

        ("VALIGN",        (0, 0),    (-1, -1),    "TOP"),
    ]))

    return [tbl, Spacer(1, 10)]


# ─── Footer canvas ────────────────────────────────────────────────────────────
class FooterCanvas(pdfcanvas.Canvas):
    def __init__(self, *args, session_title="Claude Session", **kwargs):
        super().__init__(*args, **kwargs)
        self._session_title = session_title
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self._draw_footer(num_pages)
            pdfcanvas.Canvas.showPage(self)
        pdfcanvas.Canvas.save(self)

    def _draw_footer(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(TEXT_LIGHT)
        y = BOT_MARGIN - 1 * cm
        self.drawString(LEFT_MARGIN, y, self._session_title)
        self.drawRightString(
            PAGE_W - RIGHT_MARGIN, y,
            f"Page {self._pageNumber} of {page_count}"
        )
        self.setStrokeColor(BORDER_COLOR)
        self.setLineWidth(0.5)
        self.line(LEFT_MARGIN, y + 10, PAGE_W - RIGHT_MARGIN, y + 10)
        self.restoreState()


# ─── Main ─────────────────────────────────────────────────────────────────────
def generate(input_path, output_path):
    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    messages  = data.get("messages", [])
    title     = data.get("title", "Claude Conversation")
    date_str  = data.get("date", datetime.now().strftime("%B %d, %Y"))
    msg_count = len(messages)
    styles    = build_styles()
    session_title = title[:60] + ("…" if len(title) > 60 else "")

    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        leftMargin=LEFT_MARGIN,
        rightMargin=RIGHT_MARGIN,
        topMargin=TOP_MARGIN,
        bottomMargin=BOT_MARGIN,
        title=title,
        author="Claude by Anthropic",
        subject="Conversation export",
    )

    story = []
    story.append(Spacer(1, 0.5 * cm))
    story.append(Paragraph(escape(title), styles["title"]))
    story.append(Spacer(1, 0.2 * cm))
    story.append(Paragraph(f"{date_str}  ·  {msg_count} messages", styles["subtitle"]))
    story.append(Spacer(1, 0.4 * cm))
    story.append(HRFlowable(width="100%", thickness=1, color=BORDER_COLOR, spaceAfter=14))

    for msg in messages:
        story.extend(message_block(msg, styles))

    story.append(Spacer(1, 0.8 * cm))
    story.append(HRFlowable(width="100%", thickness=0.5, color=BORDER_COLOR,
                             spaceBefore=6, spaceAfter=6))
    story.append(Paragraph("Exported from Claude by Anthropic", styles["footer"]))

    doc.build(
        story,
        canvasmaker=lambda *a, **kw: FooterCanvas(*a, session_title=session_title, **kw),
    )
    print(f"✓ PDF saved to: {output_path}")
    print(f"  {msg_count} messages exported")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 generate_pdf.py <input.json> <output.pdf>")
        sys.exit(1)
    generate(sys.argv[1], sys.argv[2])