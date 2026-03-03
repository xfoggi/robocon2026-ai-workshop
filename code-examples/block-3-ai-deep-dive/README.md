# Block 3: AI Deep Dive -- Skills, Agents, and MCP

This block explains the three layers of the AI stack that matter for test automation: Skills (prompt templates), Agents (autonomous loops), and MCP (tool connectivity).

---

## The AI Stack

```
+------------------------------------------------------------------+
|                        YOUR QA WORKFLOW                           |
+------------------------------------------------------------------+
         |                    |                    |
         v                    v                    v
+------------------+  +------------------+  +------------------+
|     SKILLS       |  |     AGENTS       |  |       MCP        |
|  Prompt templates|  |  Observe-Think-  |  |  Tool connection |
|  for specific    |  |  Act loops that  |  |  protocol that   |
|  QA tasks        |  |  work toward a   |  |  lets AI use     |
|                  |  |  goal            |  |  external tools   |
+------------------+  +------------------+  +------------------+
         |                    |                    |
         v                    v                    v
+------------------------------------------------------------------+
|                     AI MODEL (LLM)                                |
|          OpenAI GPT-4o  |  Google Gemini  |  Claude              |
+------------------------------------------------------------------+
         |                    |                    |
         v                    v                    v
+------------------------------------------------------------------+
|                    INTERFACE LAYER                                 |
|       API calls  |  Chat UI  |  IDE integration  |  MCP client   |
+------------------------------------------------------------------+
         |                    |                    |
         v                    v                    v
+------------------------------------------------------------------+
|                  CONTEXT + TOOLS                                  |
|    Your code  |  Test results  |  Jira tickets  |  Databases     |
+------------------------------------------------------------------+
```

The key insight: the model is the same in all cases. What changes is the **context** you provide and the **tools** the model can access.

---

## Skills

A **skill** is a reusable prompt template designed for a specific QA task. Think of it as a recipe: a well-crafted system message plus a structured user prompt that consistently produces high-quality output.

Skills are the simplest and most practical layer. You use them today, right now, with any AI model.

### How Skills Work

```
+-------------------+     +-------------------+     +-------------------+
|   SYSTEM PROMPT   | --> |    USER PROMPT    | --> |    AI RESPONSE    |
|   (the skill)     |     |   (your input)    |     |   (structured     |
|   Defines role,   |     |   Test code,      |     |    output)        |
|   rules, format   |     |   requirements,   |     |                   |
|                   |     |   error messages   |     |                   |
+-------------------+     +-------------------+     +-------------------+
```

### Available Skills

| Skill | File | What It Does |
|-------|------|-------------|
| QA Test Reviewer | [skills/qa-test-reviewer.md](skills/qa-test-reviewer.md) | Reviews RF tests for quality issues and bad practices |
| RF Library Generator | [skills/rf-library-generator.md](skills/rf-library-generator.md) | Generates proper RF Python libraries with all conventions |
| Test Data Specialist | [skills/test-data-specialist.md](skills/test-data-specialist.md) | Creates edge-case-rich test data in multiple formats |
| Error Diagnostician | [skills/error-diagnostician.md](skills/error-diagnostician.md) | Diagnoses RF test failures and suggests fixes |
| MCP Server Builder | [skills/mcp-server-builder.md](skills/mcp-server-builder.md) | Generates MCP servers for AI-tool integration |
| **RF Style Conventions** | [skills/rf-style-conventions.md](skills/rf-style-conventions.md) | Enforces official RF formatting, naming, and syntax rules |
| **RF Python Library Conventions** | [skills/rf-python-library-conventions.md](skills/rf-python-library-conventions.md) | Ensures Python libraries follow RF class naming, scoping, and docs rules |
| **RF Test Architecture** | [skills/rf-test-architecture.md](skills/rf-test-architecture.md) | Guides test design: abstraction, data-driven, setup/teardown patterns |

Each skill file contains the system prompt (ready to copy-paste), RF usage examples, and prompt engineering tips.

---

## Agents

An **agent** is an AI system that operates in an autonomous loop: it observes the current state, thinks about what to do next, takes an action, and repeats until the goal is achieved.

### The Observe-Think-Act Loop

```
        +---> OBSERVE ---+
        |     Read test  |
        |     results,   |
        |     code, logs |
        |                v
     REPEAT         THINK
     until          Analyze what
     goal is        happened, decide
     achieved       next step
        ^                |
        |                v
        +---- ACT <------+
              Run test,
              edit code,
              create file
```

### Agent Examples in QA

| Agent | What It Does |
|-------|-------------|
| **Claude Code** | Reads your codebase, edits files, runs commands, iterates until done |
| **Cursor Agent** | Similar loop inside VS Code -- reads context, proposes changes, applies them |
| **CI/CD AI Agent** | Monitors test failures, diagnoses issues, opens fix PRs automatically |

### Key Difference: Skill vs Agent

- **Skill:** One prompt in, one response out. You drive the loop.
- **Agent:** You give a goal, the AI drives the loop. It decides what to read, what to change, and when it is done.

In the workshop, you already used an agent (Claude Code) during the vibe coding demo. Now you understand the mechanism behind it.

---

## MCP (Model Context Protocol)

**MCP** is an open protocol (created by Anthropic) that standardizes how AI models connect to external tools and data sources. Think of it as a USB port for AI -- plug in any tool, and the AI can use it.

### MCP Architecture

```
+-------------------+         +-------------------+
|    MCP CLIENT     |         |    MCP SERVER     |
|   (AI assistant)  | <-----> |   (your tool)     |
|                   |  JSON   |                   |
|   Claude Code     |  over   |   RF Test Runner  |
|   Cursor          |  stdio  |   Database Query  |
|   Claude Desktop  |   or    |   Jira Integration|
|   VS Code         |  HTTP   |   Git History     |
+-------------------+         +-------------------+
         |                             |
         v                             v
   AI decides which              Tool executes
   tool to call and              and returns
   with what arguments           results
```

### What MCP Provides

| Component | Purpose | Example |
|-----------|---------|---------|
| **Tools** | Actions the AI can take | Run a test, query a database, create a Jira ticket |
| **Resources** | Data the AI can read | Test results, configuration files, API specs |
| **Prompts** | Reusable prompt templates | Pre-built analysis prompts for specific tasks |

### Without MCP vs With MCP

**Without MCP:**
```
You run tests --> copy output --> paste into AI chat --> read suggestion --> manually apply fix
```

**With MCP:**
```
You tell AI "fix the failing tests" --> AI runs tests, reads output, edits code, re-runs --> done
```

### Getting Started with MCP

```bash
# Install the MCP Python SDK
pip install mcp

# Example: a minimal MCP server
# See: block-3-ai-deep-dive/mcp/ for starter and finished examples
```

The MCP Server Builder skill (in the skills/ directory) can generate custom MCP servers for your specific use cases.

---

## Directory Structure

```
block-3-ai-deep-dive/
|-- README.md              <-- You are here
|-- skills/
|   |-- qa-test-reviewer.md
|   |-- rf-library-generator.md
|   |-- test-data-specialist.md
|   |-- error-diagnostician.md
|   |-- mcp-server-builder.md
|   |-- rf-style-conventions.md
|   |-- rf-python-library-conventions.md
|   `-- rf-test-architecture.md
`-- mcp/
    |-- starter/           <-- MCP server template (fill in the TODOs)
    `-- finished/          <-- Complete MCP server reference
```

---

## Key Takeaways

1. **Skills are the 80/20.** A well-crafted system prompt dramatically improves AI output quality. Start here.
2. **Agents are skills in a loop.** The magic of Claude Code and Cursor is not a different model -- it is the observe-think-act loop with tool access.
3. **MCP is the future of AI tooling.** It turns AI from a text generator into a tool user. The Robot Framework community is actively building MCP integrations.
