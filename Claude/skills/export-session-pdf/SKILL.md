---
name: export-session-pdf
description: >
  Export the current Claude conversation to a polished, well-formatted PDF file.
  Use this skill whenever the user asks to export, save, download, or print the
  conversation / session / chat history as a PDF. Triggers include phrases like
  "export this session", "save our conversation", "generate a PDF of this chat",
  "download this conversation", "print this session", or any similar request to
  persist the dialogue as a file. Also trigger when the user asks to "share" or
  "archive" the conversation as a document.
---

# Export Session to PDF

Exports the current Claude conversation to a beautifully formatted PDF.

## Workflow

### Step 1 — Reconstruct the conversation

Gather every message from the conversation in context into a JSON structure:

```json
{
  "title": "Descriptive session title (infer from conversation topic)",
  "date": "Month DD, YYYY (today's date)",
  "messages": [
    {"role": "user",      "content": "...exact content..."},
    {"role": "assistant", "content": "...exact content..."}
  ]
}
```

**Rules for reconstructing messages:**
- Include **all** messages, starting from the very first user message.
- Do **not** include system messages, tool calls/results, or internal reasoning — only user and assistant turns visible to the user.
- Preserve exact content: code blocks (with ``` fences), bullet points, line breaks.
- For the title: summarize the session topic in 4–7 words.
- If the user provided a custom title, use that instead.

### Step 2 — Write the JSON to a temp file

```python
import json

data = { ... }  # your reconstructed conversation

with open("/home/claude/session_export.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
```

### Step 3 — Run the PDF generator script

The script lives at `scripts/generate_pdf.py` **relative to this SKILL.md**.
When the skill is installed at `/home/claude/export-session-pdf/`, the full path is:

```bash
python3 /home/claude/export-session-pdf/scripts/generate_pdf.py \
    /home/claude/session_export.json \
    /mnt/user-data/outputs/session_export.pdf
```

> If the skill was installed elsewhere, substitute the actual skill directory for
> `/home/claude/export-session-pdf`. The script is always at `<skill_dir>/scripts/generate_pdf.py`.

The script uses only `reportlab`, which is pre-installed in the environment — no `pip install` needed.

### Step 4 — Present the file

Call `present_files` with the output path:

```
/mnt/user-data/outputs/session_export.pdf
```

Then confirm: how many messages were exported and the session title used.

---

## Output design

The generated PDF features:
- **Header**: session title + date + message count
- **Message bubbles**: user messages (soft blue) and Claude messages (warm white), each labeled "YOU" or "CLAUDE"
- **Code blocks**: monospace font with grey background
- **Long messages**: flow naturally across page breaks — no blank whitespace gaps
- **Footer**: page numbers + session title on every page
- **Format**: A4, clean typography, print-ready

---

## Tips & edge cases

| Situation | Handling |
|-----------|----------|
| Very long messages | Script splits tables at paragraph boundaries — no blank pages |
| Code-heavy session | ` ``` ` fences in content are rendered as monospace code blocks |
| User requests a custom filename | Use it: `<name>.pdf` |
| Conversation not yet complete | Export whatever messages exist in context so far |
| User wants only part of the session | Ask which messages (first N, a topic range) and filter accordingly |

---

## Script location

`scripts/generate_pdf.py` (relative to this SKILL.md)

Read this file if you need to understand or modify the PDF generation logic.