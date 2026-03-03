# RoboCon 2026 Workshop — Integrating AI & Robot Framework

**Date:** March 3, 2026
**Instructor:** David Fogl, Continero

---

## Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Set your API keys (keys will be shared during the workshop)
cp .env.example .env
# Edit .env and fill in your keys, then:
export $(grep -v '^#' .env | xargs)

# 3. Verify your setup
python verify_setup.py
```

---

## Directory Overview

```
code-examples/
|-- requirements.txt          # Python dependencies
|-- .env.example              # API key template
|-- verify_setup.py           # Environment verification script
|
|-- block-2-vibe-coding/      # Morning vibe coding demo
|   `-- README.md
|
|-- block-3-ai-deep-dive/     # Skills, Agents, MCP
|   `-- README.md
|
|-- block-5-ai-library/       # Building the RF AI library (starter + finished)
|   `-- README.md
|
`-- block-6-exercises/        # Hands-on exercises
    `-- README.md
```

Each block directory contains its own **README.md** with detailed instructions, code samples, and explanations for that section of the workshop.

---

## Cheatsheet

A single-page reference covering Robot Framework syntax, AI integration patterns, and MCP basics is available at:

[workshop-cheatsheet.md](../workshop-cheatsheet.md)

---

## Troubleshooting

If `verify_setup.py` reports failures, check:

- **Python version** — You need Python 3.10 or newer.
- **Missing packages** — Run `pip install -r requirements.txt` again.
- **API keys** — Keys will be provided at the start of the workshop. Set them via environment variables or a `.env` file.
- **`robot` not found** — Make sure `robotframework` is installed and your PATH includes the Python scripts directory.

For live help, ask in the workshop chat or raise your hand.
