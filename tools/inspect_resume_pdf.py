#!/usr/bin/env python3
"""Report page count, word count and ATS-hostile characters for a resume PDF.

Used by tools/check_resume.ps1. Applicant tracking systems often garble
characters outside Latin-1, so any non-ASCII output here is worth removing
from _data/resume_ats.yml or the renderers.

Word draws its native list bullet in the Symbol font, which text extraction
reports as U+2022 or U+FFFD. That is expected structure (parsers read the
list XML, not the glyph), so those two characters are not flagged.
"""

from __future__ import annotations

import sys
from pathlib import Path

from pypdf import PdfReader

# Word's list-bullet glyph as seen by text extraction; not a real problem.
LIST_MARKERS = {"\u2022", "\ufffd"}


def main(path: str) -> int:
    reader = PdfReader(path)
    pages = [" ".join((page.extract_text() or "").split()) for page in reader.pages]
    text = " ".join(pages)
    exotic = sorted({c for c in text if ord(c) > 127} - LIST_MARKERS)

    breakdown = ", ".join(
        f"p{index + 1}={len(page.split())}w" for index, page in enumerate(pages)
    )
    status = "OK" if len(pages) <= 2 and not exotic else "CHECK"
    detail = f"{len(pages)} pages ({breakdown}), {len(text.split())} words"
    if exotic:
        detail += f", non-ascii={exotic}"
    print(f"[{status}] {Path(path).name}: {detail}")
    return 0 if status == "OK" else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
