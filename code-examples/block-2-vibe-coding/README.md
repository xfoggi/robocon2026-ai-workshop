# Block 2: Vibe Coding

## What Is Vibe Coding?

Vibe coding is a development approach where you describe what you want in natural language and let AI generate the code. You steer the direction; the AI does the typing.

The term was coined by Andrej Karpathy in early 2025:

> "There's a new kind of coding I call 'vibe coding', where you fully give in to the vibes, embrace exponentials, and forget that the code even exists."

For test automation, vibe coding means: you describe the test library, the test cases, or the automation framework you need, and AI generates it. You review, iterate, and ship.

## Tools for Vibe Coding

| Tool | How It Works | Best For |
|------|-------------|----------|
| **Claude Code** | Terminal-based AI agent that reads/writes files directly | Full project scaffolding, multi-file changes |
| **Cursor** | VS Code fork with built-in AI chat and inline editing | Day-to-day coding with AI assistance |
| **GitHub Copilot** | Inline code completion in VS Code / JetBrains | Autocomplete while you type, small suggestions |
| **ChatGPT / Claude chat** | Copy-paste between browser and editor | Quick one-off generation, exploring ideas |
| **VS Code + Claude extension** | Claude integrated into VS Code sidebar | Contextual help with open files as context |

In this workshop, we will use **Claude Code** for the live demo and you can use whichever tool you prefer during exercises.

## The Vibe Coding Workflow

```
1. DESCRIBE    -->    2. REVIEW    -->    3. ITERATE    -->    4. TEST
   Tell AI            Read what         Ask for fixes,       Run it.
   what you           it generated.     additions,           Does it work?
   need.              Does it make      improvements.        If not, go
                      sense?                                 back to 3.
```

**Step 1 -- Describe:** Write a clear prompt. Be specific about the structure, naming, and behavior you want. The more detail, the better the first draft.

**Step 2 -- Review:** Read every line the AI generates. Understand it before accepting it. Look for: correct imports, proper error handling, sensible defaults, and no hallucinated APIs.

**Step 3 -- Iterate:** Tell the AI what to change. This is a conversation, not a one-shot. "Add error handling", "Use environment variables instead of hardcoded keys", "Make the timeout configurable".

**Step 4 -- Test:** Run the code. If it fails, paste the error back to the AI and let it fix it. This is the feedback loop that makes vibe coding effective.

## Three Key Skills for Effective Vibe Coding

**1. Prompt Precision**
Vague prompts produce vague code. Instead of "make a test library", say "Create a Robot Framework Python library called RestValidator with ROBOT_LIBRARY_SCOPE = GLOBAL that has these keywords: Validate JSON Schema, Assert Status Code, Extract Nested Value."

**2. Review Discipline**
AI-generated code looks confident even when it is wrong. Always check: Does the import exist? Is the API call correct? Are there off-by-one errors? Does the error handling actually handle errors?

**3. Incremental Building**
Start small and add features one prompt at a time. "Create the basic library with Ask AI keyword" first, then "Add Generate Test Data keyword", then "Add error handling to all keywords". Each step is reviewable.

## Live Demo Prompts

The exact prompts used during the live demo are documented in:

[vibe-prompts.md](vibe-prompts.md)

You can replay these prompts yourself with any AI coding tool to recreate the demo.
