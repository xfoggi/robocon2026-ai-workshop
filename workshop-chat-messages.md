# Workshop Chat Messages — Copy & Paste Reference
## Quick-paste messages for Google Meet chat, organized by time block

---

## 09:00 — Welcome

```
Welcome to the RoboCon 2026 Workshop: Integrating AI & Robot Framework!

Cheat sheet: [paste link or attach file]
Code examples: [paste repo link]

We'll share API keys shortly. For now, let's get your environments set up.
```

---

## 09:30 — Setup

```
SETUP COMMANDS — copy and paste these:

mkdir rf-ai-workshop && cd rf-ai-workshop
python3 -m venv venv
source venv/bin/activate
pip install robotframework openai google-genai mcp robotframework-requests
```

```
VERIFY YOUR SETUP:

python3 verify_setup.py

Green checkmarks = good, red X = fix it, yellow = OK for now (keys come next)
```

```
API KEYS — set these in your terminal:

export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="AIza..."
```

```
WINDOWS USERS:

set OPENAI_API_KEY=sk-...
set GEMINI_API_KEY=AIza...

(PowerShell)
$env:OPENAI_API_KEY="sk-..."
$env:GEMINI_API_KEY="AIza..."
```

```
VERIFY KEYS WORK:

python3 verify_setup.py --test-keys
```

---

## 09:45 — Vibe Coding Demo

```
VIBE CODING PROMPT 1 — Create the AI library:

Create a Robot Framework Python library called ai_library.py that wraps the OpenAI API. It should have these keywords: Ask AI, Generate Test Data, Review Test, Generate Test Cases, Generate Keywords, Explain Error. Use the openai library. Include proper docstrings so the keywords show help in RF. Set ROBOT_LIBRARY_SCOPE to GLOBAL.
```

```
VIBE CODING PROMPT 2 — Create test cases:

Now create a .robot test file called first_ai_test.robot that imports this library and has 5 test cases exercising each keyword. Use the environment variable OPENAI_API_KEY.
```

```
VIBE CODING PROMPT 3 — Add Gemini variant:

Add a Gemini variant — create gemini_library.py with the same interface but using google-genai. And create a comparison test that runs the same prompt through both models.
```

```
YOUR TURN — try this prompt in your AI tool of choice:

Create a Robot Framework Python library that does [something you need at work]. Make it a proper RF library with ROBOT_LIBRARY_SCOPE and docstrings.

Ideas if you're not sure what to build:
- A library that validates email addresses using AI
- A library that generates localized test data for your country
- A library that summarizes test logs into a report
```

---

## 10:45 — AI Deep Dive (after break)

```
SKILLS FOLDER — ready-to-use QA prompts:

block-3-ai-deep-dive/skills/
  qa-test-reviewer.md              — AI reviews your RF tests
  rf-library-generator.md          — generates proper RF Python libraries
  test-data-specialist.md          — edge-case test data generation
  error-diagnostician.md           — classifies and explains failures
  mcp-server-builder.md            — builds FastMCP servers
  rf-style-conventions.md          — RF formatting, naming & syntax rules
  rf-python-library-conventions.md — Python library RF conventions
  rf-test-architecture.md          — test design patterns & anti-patterns

Try copying a system prompt from one of these into the system_message argument of Ask AI!
```

```
MCP SERVER EXAMPLE:

block-3-ai-deep-dive/mcp/finished/rf_mcp_server.py

This is a complete MCP server that lets AI agents run RF tests, list suites, and read results.
```

---

## 13:00 — Choose Your Path (after lunch)

```
CHOOSE YOUR PATH:

PATH A — Manual Coding:
Open block-5-ai-library/openai/starter/ai_library.py
Fill in the TODOs. I'll guide you on screen.

PATH B — Vibe Coding:
Open block-2-vibe-coding/vibe-prompts.md
Use the prompts with your AI tool of choice.

BOTH PATHS: If you get stuck, the finished version is at:
block-5-ai-library/openai/finished/
```

```
IMPORTANT RF GOTCHA — class naming:

Your class name MUST match the filename:
  ai_library.py     -> class ai_library:
  gemini_library.py -> class gemini_library:

NOT class AILibrary or class GeminiLibrary!
RF matches them by name (with underscores).
```

```
IMPORTANT RF GOTCHA — multi-line strings:

Use Catenate for long prompts, NOT Set Variable with ...:

# CORRECT:
${prompt}=    Catenate
...    line one of my prompt
...    line two of my prompt
${result}=    Ask AI    ${prompt}

# WRONG (each ... becomes a separate argument!):
${result}=    Ask AI
...    line one
...    line two
```

```
RUN YOUR FIRST TEST:

export OPENAI_API_KEY="sk-..."
robot --pythonpath block-5-ai-library/openai/finished block-5-ai-library/openai/finished/first_ai_test.robot

Then open log.html to see AI responses!
```

---

## 14:15 — Gemini Comparison

```
GEMINI — the key difference:

# OpenAI
response = self.client.chat.completions.create(
    model=self.model,
    messages=[{"role": "system", ...}, {"role": "user", ...}]
)
return response.choices[0].message.content

# Gemini (google-genai SDK)
response = self.client.models.generate_content(
    model=self.model, contents=prompt,
    config=types.GenerateContentConfig(system_instruction=system_message)
)
return response.text
```

```
RUN THE COMPARISON TEST:

robot --pythonpath block-5-ai-library/openai/finished --pythonpath block-5-ai-library/gemini/finished block-5-ai-library/comparison/finished/model_comparison.robot
```

---

## 14:45 — Exercises

```
EXERCISES — pick whichever interests you:

1. Custom AI Keyword     (block-6-exercises/exercise-1-custom-keyword/)
2. AI Test Data Factory   (block-6-exercises/exercise-2-data-factory/)
3. Test Suite Generator   (block-6-exercises/exercise-3-test-generator/)
4. Vibe Coding Challenge  (block-6-exercises/exercise-4-vibe-challenge/)

Each has starter/ (begin here) and finished/ (reference).
Full instructions: block-6-exercises/README.md
```

```
SETUP FOR EXERCISES — copy the library to your exercise folder:

cp block-5-ai-library/openai/finished/ai_library.py block-6-exercises/exercise-1-custom-keyword/starter/

Or use --pythonpath:
robot --pythonpath block-5-ai-library/openai/finished block-6-exercises/exercise-1-custom-keyword/starter/my_exercise.robot
```

---

## 16:00 — Wrap-up

```
RESOURCES TO TAKE HOME:

Code examples: [repo link] — everything from today including:
  - 5 QA skill prompts (block-3-ai-deep-dive/skills/)
  - Complete AI libraries for OpenAI + Gemini
  - MCP server example
  - 4 exercises with solutions

Robot Framework: robotframework.org
Claude Code (free): claude.ai/claude-code
MCP Spec: modelcontextprotocol.io
RF MCP Project: github.com/robotframework/robotframework-mcp
RF Slack: robotframework.slack.com

Questions after today: david.fogl@continero.com

Recording + transcript will be shared within a couple of days.
Enjoy the rest of RoboCon this week!
```

---

## Quick Troubleshooting (paste when someone has an issue)

```
MISSING MODULE? Run:
pip install robotframework openai google-genai mcp robotframework-requests
```

```
API KEY NOT WORKING? Check:
echo $OPENAI_API_KEY
echo $GEMINI_API_KEY

If empty, re-export them:
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="AIza..."
```

```
IMPORT FAILED? Two options:

1. Copy the .py file to the same folder as your .robot file
2. Use --pythonpath: robot --pythonpath /path/to/library/ my_test.robot
```

```
"expected 0 arguments, got 1" ERROR?
Your class name doesn't match the filename.
ai_library.py needs: class ai_library:  (NOT class AILibrary)
```

```
"expected N arguments, got M" ERROR?
Your multi-line ... continuation is creating separate arguments.
Use Catenate to build the string first, then pass it to the keyword.
See Section 7 of the cheat sheet.
```
