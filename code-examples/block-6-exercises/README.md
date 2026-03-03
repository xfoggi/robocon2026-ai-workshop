# Block 6: Hands-On Exercises

Pick whichever exercise interests you most -- there is no required order. Each exercise has a **Basic** version (guided, ~15 min) and a **Stretch** version (open-ended, +10-15 min) for those who want more challenge.

---

## Overview

| # | Exercise | What You Build | Time |
|---|----------|---------------|------|
| 1 | [Custom AI Keyword](#exercise-1-custom-ai-keyword) | A reusable keyword that uses AI for a practical task | ~20 min |
| 2 | [AI Test Data Factory](#exercise-2-ai-test-data-factory) | A test data generator with edge cases and multiple formats | ~20 min |
| 3 | [Test Suite Generator](#exercise-3-test-suite-generator) | A complete test suite generated from requirements, then reviewed by AI | ~20 min |
| 4 | [Vibe Coding Challenge](#exercise-4-vibe-coding-challenge) | A mini-project built entirely through AI-assisted development | ~30 min |

---

## How to Run

### Option A: Use --pythonpath (recommended)

Point Robot Framework to the directory containing `ai_library.py`:

```bash
# From the code-examples root directory
robot --pythonpath . block-6-exercises/exercise-1-custom-keyword/starter/my_exercise.robot
```

Or use the finished library from block-5:

```bash
robot --pythonpath block-5-ai-library/openai/finished/ block-6-exercises/exercise-1-custom-keyword/starter/my_exercise.robot
```

### Option B: Copy the library

Copy `ai_library.py` into the exercise directory you are working in:

```bash
cp block-5-ai-library/openai/finished/ai_library.py block-6-exercises/exercise-1-custom-keyword/starter/
```

Then import it without a path prefix:

```robot
Library    ai_library.py    api_key=%{OPENAI_API_KEY}
```

### Environment Variables

Make sure your API key is set:

```bash
export OPENAI_API_KEY="your-key-here"
```

---

## Exercise 1: Custom AI Keyword

**Directory:** [exercise-1-custom-keyword/](exercise-1-custom-keyword/)

**Goal:** Create a custom Robot Framework keyword that uses `Ask AI` to do something useful.

**Basic:** Build a keyword for one of these tasks:
- Translate text between languages
- Summarize long text into bullet points
- Convert natural language to regex
- Generate a SQL query from plain English

**Stretch:** Build a keyword library (3+ keywords) around a theme from your real work -- API testing utilities, data quality checks, or test reporting helpers. Package it as a reusable `.resource` file.

---

## Exercise 2: AI Test Data Factory

**Directory:** [exercise-2-data-factory/](exercise-2-data-factory/)

**Goal:** Build a test data generator that creates realistic, edge-case-rich data for a domain you actually test.

**Basic:** Use `Generate Test Data` to create datasets for a real scenario:
- E-commerce products with price edge cases
- User profiles with unicode names and boundary ages
- API payloads with injection attempts

**Stretch:** Generate data in multiple formats (JSON, CSV, SQL INSERT), create related datasets (users + their orders), or build a keyword that generates data and validates it against a schema.

---

## Exercise 3: Test Suite Generator

**Directory:** [exercise-3-test-generator/](exercise-3-test-generator/)

**Goal:** Feed AI a feature description and get a complete, runnable test suite back.

**Basic:** Use `Generate Test Cases` with a feature description (search functionality, shopping cart, password reset) and review what the AI produces. What did it get right? What is missing?

**Stretch:** Build a self-review loop -- generate tests, review them with `Review Test`, then feed the review back to improve the tests. Compare v1 vs v2.

---

## Exercise 4: Vibe Coding Challenge

**Directory:** [exercise-4-vibe-challenge/](exercise-4-vibe-challenge/)

**Goal:** Build something from scratch using only AI-assisted development. You describe, the AI codes.

**Basic:** Use your AI tool of choice to generate:
1. A Python library with a specific purpose (JSON validator, log analyzer, API tester)
2. A Robot Framework test suite that uses it
3. Run it and iterate until it works

**Stretch:** Build a complete mini-project:
- **Log Analyzer:** AI reads test logs and classifies failures (environment, data, code, flaky)
- **API Test Generator:** Give it a Swagger/OpenAPI spec, it generates RF tests
- **Test Prioritizer:** AI analyzes a test suite and ranks tests by risk

---

## Exercise Directory Structure

Each exercise follows the same pattern:

```
exercise-N-name/
|-- starter/       <-- Start here. Contains skeleton files or instructions.
`-- finished/      <-- Reference solution. Look here if you get stuck.
```

---

## Done Early?

Try these bonus challenges:

- **Mix models:** Run the same exercise with both OpenAI and Gemini, compare the quality of output.
- **Prompt engineering:** Try different system messages and see what produces the best results.
- **Error handling:** Add try/except to the Python library to handle API failures, rate limits, and timeouts gracefully.
- **Share your work:** Turn your best keywords into a `.resource` file and share it with your neighbor.
