# RoboCon 2026 Workshop — Cheat Sheet
## Integrating AI & Robot Framework | March 3, 2026

---

## 1. Setup Verification

**Quickest way — run the verification script:**
```bash
python3 verify_setup.py
```
Green checkmarks = good, red X = needs fixing, yellow = optional (API keys set later).

**Manual checks:**
```bash
# Check Python version (need 3.10+)
python3 --version

# Check Robot Framework
robot --version

# Check pip packages
pip list | grep -i "robotframework\|openai\|google-genai"
```

**If something is missing:**
```bash
# Install Robot Framework
pip install robotframework

# Install OpenAI library
pip install openai

# Install Google Gemini library (new SDK, replaces deprecated google-generativeai)
pip install google-genai

# Install requests library (for API testing examples)
pip install robotframework-requests
```

---

## 2. Project Setup

```bash
# Create project folder
mkdir rf-ai-workshop && cd rf-ai-workshop

# (Optional) Create virtual environment
python -m venv venv
source venv/bin/activate        # macOS/Linux
venv\Scripts\activate           # Windows

# Install all dependencies at once
pip install robotframework openai google-genai mcp robotframework-requests
```

---

## 3. API Keys

API keys will be shared in the Google Meet chat during the workshop.

**Set them as environment variables:**
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

**Or pass directly in your .robot file:**
```robot
Library    ai_library.py    api_key=sk-your-key-here
```

---

## 4. Running Tests

```bash
# Run a single test file
robot my_test.robot

# Run with --pythonpath (when .py and .robot are in different folders)
robot --pythonpath path/to/library/ my_test.robot

# Run with verbose output
robot --loglevel DEBUG my_test.robot

# Run a specific test case
robot --test "AI Should Generate Test Data" my_test.robot

# Run and save output to a folder
robot --outputdir results my_test.robot
```

**After running:** Open `log.html` in your browser to see detailed results.

**Workshop example with --pythonpath:**
```bash
# From the code-examples/ root directory:
robot --pythonpath block-5-ai-library/openai/finished block-5-ai-library/openai/finished/first_ai_test.robot
```

---

## 5. Vibe Coding — AI Coding Tools

Vibe coding = describe what you want in natural language, let AI generate the code, review and iterate.

**Claude Code (terminal):**
```bash
# Install (requires Node.js)
npm install -g @anthropic-ai/claude-code

# Launch in your project folder
cd rf-ai-workshop
claude
```

Then describe what you want:
> "Create a Robot Framework Python library called ai_library.py that wraps the OpenAI API with keywords for Ask AI, Generate Test Data, Review Test, Generate Test Cases, and Explain Error."

**Claude Code (VSCode):** Install the Claude Code extension from the marketplace. Use it to edit code inline, explain selections, and chat in the sidebar.

**Other tools:** Cursor, GitHub Copilot, ChatGPT, Claude.ai, Google Gemini — same concept, different interface. Use whichever you have access to.

**The vibe coding workflow:**
1. Describe your intent clearly
2. Let AI generate the code
3. Review — does it look right?
4. Iterate — tell AI what to fix or add
5. Test — run it and verify

**Three key skills:** Knowing what to ask for, recognizing good vs bad output, iterating with feedback.

---

## 6. Quick Reference — AI Library Keywords

| Keyword | What it does | Example |
|---------|-------------|---------|
| `Ask AI` | Send any prompt, get a response | `${r}= Ask AI What is Robot Framework?` |
| `Generate Test Data` | Create test data from a description | `${d}= Generate Test Data user profiles json 5` |
| `Review Test` | AI reviews RF test code | `${r}= Review Test ${test_code}` |
| `Generate Test Cases` | Turn requirements into RF tests | `${t}= Generate Test Cases ${requirements}` |
| `Generate Keywords` | Create reusable RF keywords | `${k}= Generate Keywords API testing utils` |
| `Explain Error` | AI explains a test failure | `${e}= Explain Error ${error_msg}` |

---

## 7. Quick Reference — Robot Framework Basics

```robot
*** Settings ***
Library    ai_library.py    api_key=%{OPENAI_API_KEY}
Library    OperatingSystem
Library    Collections

*** Variables ***
${MY_VAR}    some value
@{MY_LIST}    item1    item2    item3

*** Test Cases ***
My Test Case
    [Documentation]    What this test does.
    ${result}=    Ask AI    my prompt
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Contain    ${result}    expected text

*** Keywords ***
My Custom Keyword
    [Arguments]    ${arg1}    ${arg2}=default
    [Documentation]    What this keyword does.
    ${result}=    Ask AI    ${arg1}
    RETURN    ${result}
```

**Multi-line strings — use `Catenate`, NOT `Set Variable`:**
```robot
# WRONG — ... creates a list of separate items, not one string!
${text}=    Set Variable
...    line one
...    line two

# CORRECT — Catenate joins into one string
${text}=    Catenate
...    line one
...    line two

# With newlines between lines:
${text}=    Catenate    SEPARATOR=\n
...    line one
...    line two
```

**Multi-line keyword arguments — same problem:**
```robot
# WRONG — each ... line becomes a separate argument!
${data}=    Generate Test Data
...    long description
...    that spans lines
...    json    5

# CORRECT — build the string first, then pass it
${desc}=    Catenate
...    long description
...    that spans lines
${data}=    Generate Test Data    ${desc}    json    5
```

---

## 8. Model Comparison — When to Use What

| Model | Best for | Speed | Cost |
|-------|---------|-------|------|
| **GPT-4o** | Code generation, general QA tasks | Fast | Medium |
| **Gemini 2.5 Flash** | Bulk data generation, quick tasks | Very fast | Low |
| **Gemini 2.5 Pro** | Complex reasoning, long documents | Medium | Medium |
| **Claude Sonnet** | Long context, detailed analysis | Fast | Medium |
| **Claude Opus** | Complex reasoning, architecture | Slower | Higher |

**Rule of thumb:** Start with GPT-4o or Gemini Flash. Switch to Pro/Opus models only if you need better quality for specific tasks.

---

## 9. Three Approaches — When to Use What

| Approach | When to use | Example |
|----------|-------------|---------|
| **API call in code** | Predictable, repeatable tasks in CI/CD | Test data generation, automated assertions |
| **Vibe coding** | Building new things, prototyping, one-off work | Creating a new RF library from scratch |
| **AI agent via MCP** | Complex workflows across multiple tools | "Read Jira, generate tests, run them, report to Slack" |

---

## 10. MCP (Model Context Protocol) — Quick Reference

MCP is an open standard that lets AI models connect to external tools. Think of it as a USB port for AI.

```
┌──────────────┐     MCP      ┌──────────────────────┐
│   AI Model   │◄────────────►│  MCP Server (Tool)   │
│ (Claude,     │   Protocol   │  - Jira connector    │
│  GPT, etc.)  │              │  - Git connector      │
└──────────────┘              │  - RF test runner     │
                              └──────────────────────┘
```

**Why it matters for testers:**
- AI reads your Jira tickets and generates test cases
- AI runs your RF tests and interprets results
- AI checks Git commits to identify what needs regression testing

**Getting started:**
```bash
pip install mcp
```

**RF MCP project:** [github.com/robotframework/robotframework-mcp](https://github.com/robotframework/robotframework-mcp)

---

## 11. Prompt Engineering Tips

**Be specific:**
```
❌ "Generate test data"
✅ "Generate 5 JSON records of European customers with: full name, email, phone in local format, address with postal code"
```

**Set the role:**
```
❌ Ask AI    Review my test
✅ Ask AI    Review my test    system_message=You are a senior QA engineer with 10 years of Robot Framework experience.
```

**Request format:**
```
❌ "Give me test cases"
✅ "Generate Robot Framework test cases. Return only .robot code, no explanations. Include [Documentation] for each test."
```

---

## 12. Common Issues & Fixes

| Problem | Fix |
|---------|-----|
| `ModuleNotFoundError: No module named 'openai'` | `pip install openai` |
| `AuthenticationError` | Check your API key is set correctly |
| `RateLimitError` | Wait a moment and retry; we're sharing keys |
| `robot: command not found` | `pip install robotframework` or check PATH |
| `Import failed: ai_library.py` | Use `--pythonpath` or copy .py to same folder as .robot |
| `Library 'xxx' expected 0 arguments, got 1` | Class name must match filename (e.g. `ai_library.py` → `class ai_library:`) |
| `expected N arguments, got M` | Multi-line `...` creates separate args — use `Catenate` first (see Section 7) |
| `Should Contain` ignoring second argument | `#` starts a comment in RF — escape it: `\#` |
| AI returns markdown formatting | Add to prompt: "Return only raw data, no markdown" |
| Response too long / truncated | Add to prompt: "Be concise, max 200 words" |

---

## 13. Workshop Code Structure

```
code-examples/
├── verify_setup.py                    # Run this first!
├── requirements.txt                   # pip install -r requirements.txt
├── .env.example                       # API key template
│
├── block-2-vibe-coding/
│   └── vibe-prompts.md               # Exact prompts for vibe coding
│
├── block-3-ai-deep-dive/
│   ├── skills/                        # 5 reusable QA skill prompts
│   └── mcp/                           # MCP server (starter + finished)
│
├── block-5-ai-library/
│   ├── openai/
│   │   ├── starter/ai_library.py      # Fill in the TODOs
│   │   └── finished/                  # Working reference + test
│   ├── gemini/                        # Same structure, Gemini SDK
│   ├── comparison/finished/           # Side-by-side model comparison
│   └── patterns/finished/             # 7 production patterns
│
└── block-6-exercises/
    ├── exercise-1-custom-keyword/     # Build your own keyword
    ├── exercise-2-data-factory/       # AI test data generation
    ├── exercise-3-test-generator/     # Generate test suites from specs
    └── exercise-4-vibe-challenge/     # Build a mini-project with AI
```

Each exercise has `starter/` (begin here) and `finished/` (reference solution).

---

## 14. Useful Links

- **Robot Framework:** [robotframework.org](https://robotframework.org)
- **RF User Guide:** [robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- **Claude Code:** [claude.ai/claude-code](https://claude.ai/claude-code) (free)
- **OpenAI API Docs:** [platform.openai.com/docs](https://platform.openai.com/docs)
- **Google AI Studio:** [aistudio.google.com](https://aistudio.google.com)
- **MCP Spec:** [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **RF MCP Project:** [github.com/robotframework/robotframework-mcp](https://github.com/robotframework/robotframework-mcp)
- **RF Slack:** [robotframework.slack.com](https://robotframework.slack.com)
- **RoboCon:** [robocon.io](https://robocon.io)
- **David's email:** david.fogl@continero.com
- **Continero:** [continero.com](https://www.continero.com)

---

*Good luck and have fun! — David*
