# RoboCon 2026 Workshop: Integrating AI & Robot Framework

**Full-day hands-on workshop** | March 3, 2026 | Online (Google Meet)

Learn three ways to combine AI with Robot Framework: API calls in test code, vibe coding with AI assistants, and AI agents via MCP.

**Instructor:** David Fogl, [Continero](https://www.continero.com)

---

## Setup (do this before the workshop)

```bash
# 1. Create a project folder and virtual environment
mkdir rf-ai-workshop && cd rf-ai-workshop
python3 -m venv venv
source venv/bin/activate          # macOS/Linux
# venv\Scripts\activate           # Windows

# 2. Install dependencies
pip install robotframework openai google-genai mcp robotframework-requests

# 3. Clone this repo
git clone https://github.com/xfoggi/robocon2026-ai-workshop.git

# 4. Verify your setup
python3 robocon2026-ai-workshop/code-examples/verify_setup.py
```

Green checkmarks = ready. Yellow warnings about API keys are OK — keys will be shared during the workshop.

### API Keys (provided at the workshop)

```bash
# macOS/Linux
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="AIza..."

# Windows CMD
set OPENAI_API_KEY=sk-...
set GEMINI_API_KEY=AIza...

# Windows PowerShell
$env:OPENAI_API_KEY="sk-..."
$env:GEMINI_API_KEY="AIza..."
```

Then verify keys work:

```bash
python3 robocon2026-ai-workshop/code-examples/verify_setup.py --test-keys
```

---

## What's Inside

### Code Examples

```
code-examples/
├── verify_setup.py                     # Environment checker
├── requirements.txt                    # pip install -r requirements.txt
├── .env.example                        # API key template
│
├── block-2-vibe-coding/                # Vibe coding prompts for the demo
├── block-3-ai-deep-dive/              # AI skills, agents, MCP
│   ├── skills/                         # 8 reusable QA prompt templates
│   └── mcp/                            # MCP server (starter + finished)
├── block-5-ai-library/                # Building the RF AI library
│   ├── openai/                         # OpenAI library (starter + finished)
│   ├── gemini/                         # Gemini library (starter + finished)
│   ├── comparison/                     # Side-by-side model comparison
│   └── patterns/                       # 7 production patterns
└── block-6-exercises/                  # 4 hands-on exercises
    ├── exercise-1-custom-keyword/
    ├── exercise-2-data-factory/
    ├── exercise-3-test-generator/
    └── exercise-4-vibe-challenge/
```

Each block has its own README with instructions. Each exercise has `starter/` (begin here) and `finished/` (reference solution).

### Workshop Reference

| File | What it is |
|------|-----------|
| [workshop-cheatsheet.md](workshop-cheatsheet.md) | Single-page reference: RF syntax, AI keywords, MCP, troubleshooting |
| [workshop-expected-outputs.md](workshop-expected-outputs.md) | What correct test results look like at each stage |

---

## Running Tests

```bash
# Run a test file (library in the same folder)
robot first_ai_test.robot

# Run with library in a different folder (common in this workshop)
robot --pythonpath code-examples/block-5-ai-library/openai/finished \
      code-examples/block-5-ai-library/openai/finished/first_ai_test.robot

# Open results in browser
open log.html
```

---

## Workshop Agenda

| Time | Block | What |
|------|-------|------|
| 09:00 | Welcome | Introductions, agenda, goals |
| 09:30 | Setup | Environment setup, API keys |
| 09:45 | Vibe Coding | Live demo: building an RF AI library with Claude Code |
| 10:30 | *Break* | |
| 10:45 | AI Deep Dive | Skills, agents, MCP — the AI stack for testers |
| 12:00 | *Lunch* | |
| 13:00 | AI Library | Build the OpenAI + Gemini RF library (manual or vibe coding) |
| 14:15 | Comparison | Side-by-side model comparison, production patterns |
| 14:45 | Exercises | Choose from 4 hands-on exercises |
| 15:30 | *Break* | |
| 15:45 | Exercises | Continue + share results |
| 16:15 | Wrap-up | Key takeaways, resources, Q&A |

---

## Common Issues

| Problem | Fix |
|---------|-----|
| `ModuleNotFoundError: No module named 'openai'` | `pip install openai` |
| `Library 'xxx' expected 0 arguments, got 1` | Class name must match filename: `ai_library.py` needs `class ai_library:` |
| `expected N arguments, got M` | Multi-line `...` creates separate args — use `Catenate` first |
| `robot: command not found` | `pip install robotframework` and restart terminal |
| API key errors | Re-export your key: `export OPENAI_API_KEY="sk-..."` |

See the [cheatsheet](workshop-cheatsheet.md) for more troubleshooting.

---

## Links

- [Robot Framework](https://robotframework.org)
- [RF User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [Claude Code](https://claude.ai/claude-code)
- [MCP Spec](https://modelcontextprotocol.io)
- [RF MCP Project](https://github.com/robotframework/robotframework-mcp)
- [RoboCon](https://robocon.io)

---

*Questions? david.fogl@continero.com*
