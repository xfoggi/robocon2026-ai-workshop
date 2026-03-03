# Block 5: Building the AI Library

In this block, you build a Robot Framework Python library that connects RF to AI models. There are two paths -- pick the one that matches your style.

---

## What You Will Build

A Python library (`ai_library.py`) with these Robot Framework keywords:

| Keyword | What It Does |
|---------|-------------|
| **Ask AI** | Send any prompt to an AI model, get a response |
| **Generate Test Data** | Create realistic test data in JSON, CSV, or SQL format |
| **Review Test** | AI reviews RF test code for issues and improvements |
| **Generate Test Cases** | Turn requirements into complete RF test cases |
| **Generate Keywords** | Create reusable RF keywords from a description |
| **Explain Error** | AI diagnoses a test failure and suggests fixes |

Plus a Gemini variant (`gemini_library.py`) with the same interface, and a comparison test that runs both side by side.

---

## Path A: Manual Coding

For those who prefer to understand every line by writing it themselves.

### Steps

1. **Open the starter file:**
   ```
   block-5-ai-library/openai/starter/
   ```
   This contains a skeleton with `TODO` comments marking where you need to add code.

2. **Fill in the TODOs:**
   - Initialize the OpenAI client in `__init__`
   - Implement each keyword method
   - Write proper docstrings with RF Examples format
   - Add error handling

3. **Test your implementation:**
   ```bash
   # Create your own test file, or copy the finished one to test against:
   cp openai/finished/first_ai_test.robot openai/starter/
   robot --pythonpath openai/starter openai/starter/first_ai_test.robot
   ```

4. **Compare with the finished version:**
   ```
   block-5-ai-library/openai/finished/
   ```
   Check how your implementation differs. There is no single "correct" solution -- but the finished version shows best practices.

5. **Repeat for Gemini (optional):**
   ```
   block-5-ai-library/gemini/starter/
   block-5-ai-library/gemini/finished/
   ```

### Key Things to Get Right

- `ROBOT_LIBRARY_SCOPE = 'GLOBAL'` as a class attribute
- Docstrings with `Examples:` sections using pipe format (this is what RF uses for keyword docs)
- Accept `api_key` in `__init__` so it can be passed from RF: `Library    ai_library.py    api_key=%{OPENAI_API_KEY}`
- Return strings from all keywords (RF handles string conversion, but explicit is better)

---

## Path B: Vibe Coding

For those who want to experience the AI-assisted development workflow.

### Steps

1. **Open your AI coding tool** (Claude Code, Cursor, Copilot, or ChatGPT).

2. **Use the prompts from Block 2:**
   See [../block-2-vibe-coding/vibe-prompts.md](../block-2-vibe-coding/vibe-prompts.md) for the exact prompts.

3. **Follow the sequence:**
   - Prompt 1: Generate `ai_library.py` (OpenAI wrapper)
   - Prompt 2: Generate `first_ai_test.robot` (test cases)
   - Prompt 3: Generate `gemini_library.py` + comparison test
   - Prompt 4: Add SQL output format support

4. **Review what the AI generated.** Compare it against the finished versions in this directory.

5. **Run the tests:**
   ```bash
   robot --pythonpath . your_generated_test.robot
   ```

### What to Watch For

- Does the generated library follow RF conventions? (Check ROBOT_LIBRARY_SCOPE, docstrings, naming)
- Are the test cases meaningful or just smoke tests?
- Does the Gemini library have the exact same interface as the OpenAI one?
- Did the AI hallucinate any APIs that do not exist?

---

## Running the Tests

All test files need the AI library on the Python path. There are two ways:

### Option 1: Use --pythonpath

```bash
# Run from the code-examples root directory
robot --pythonpath block-5-ai-library/openai/finished block-5-ai-library/openai/finished/first_ai_test.robot

# Or cd into the finished directory and run directly
cd block-5-ai-library/openai/finished
robot first_ai_test.robot
```

### Option 2: Copy the library

```bash
# Copy ai_library.py to the same directory as your .robot file
cp block-5-ai-library/openai/finished/ai_library.py block-6-exercises/exercise-1-custom-keyword/
```

### Required Environment Variables

```bash
export OPENAI_API_KEY="your-key-here"    # For OpenAI library
export GEMINI_API_KEY="your-key-here"    # For Gemini library (optional)
```

Keys will be provided at the start of the workshop.

---

## Directory Structure

```
block-5-ai-library/
|-- README.md                  <-- You are here
|-- openai/
|   |-- starter/               <-- Skeleton with TODOs (Path A start here)
|   `-- finished/              <-- Complete reference implementation
|-- gemini/
|   |-- starter/               <-- Gemini skeleton with TODOs
|   `-- finished/              <-- Complete Gemini implementation
|-- comparison/
|   `-- finished/              <-- Side-by-side model comparison test
`-- patterns/
    `-- finished/              <-- Advanced usage patterns (AI assertions, data gen, etc.)
```

---

## Stuck?

- **Path A:** Open the finished version and read through it. Then close it and try again.
- **Path B:** If the AI generates something wrong, paste the error message back and say "fix this".
- **Both paths:** Ask David for help -- unmute or drop a message in chat.
