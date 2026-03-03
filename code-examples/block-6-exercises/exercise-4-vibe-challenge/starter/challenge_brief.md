# Exercise 4: Vibe Coding Challenge

**RoboCon 2026 Workshop — Integrating AI & Robot Framework**

## The Rules

1. **Pick one project** from the three options below
2. **You should NOT write code manually** — describe what you want and let AI build it
3. Use Claude Code, Cursor, ChatGPT, or any AI coding assistant
4. You have **20 minutes** — focus on getting a working prototype
5. Share your result with the group at the end

---

## Option 1: Log Analyzer

Build a Robot Framework library that reads test failure messages and uses AI to classify and analyze them.

### Required Keywords

| Keyword | Description |
|---------|-------------|
| `Classify Failure` | Takes an error message, returns category: `environment`, `data`, `code_bug`, or `flaky` |
| `Analyze Test Results` | Takes a multi-line test results summary, classifies each failure |
| `Generate Failure Report` | Creates a human-readable Markdown report from results |
| `Suggest Fixes` | Takes an error message and test name, returns AI-powered fix suggestions |

### Expected Files

- `log_analyzer.py` — the RF library (uses OpenAI SDK)
- `log_analyzer_test.robot` — tests that exercise every keyword

### Acceptance Criteria

- [ ] All four keywords exist and are callable from Robot Framework
- [ ] `Classify Failure` returns exactly one of the four categories
- [ ] `Generate Failure Report` produces valid Markdown
- [ ] `Suggest Fixes` returns actionable suggestions
- [ ] The test suite passes (with a valid API key)

---

## Option 2: API Test Generator

Build a Robot Framework library that takes an API description and generates a complete test suite.

### Required Keywords

| Keyword | Description |
|---------|-------------|
| `Generate API Tests` | Takes API description (endpoints, methods), generates full .robot file |
| `Generate Auth Tests` | Generates tests specifically for authentication/authorization edge cases |
| `Generate Error Tests` | Generates tests for error handling (4xx, 5xx responses) |

### Expected Files

- `api_generator.py` — the RF library
- `api_generator_test.robot` — tests that verify generation works

### Acceptance Criteria

- [ ] All three keywords exist and are callable
- [ ] Generated .robot files contain valid RF syntax (`*** Settings ***`, `*** Test Cases ***`)
- [ ] Generated tests cover GET, POST, PUT, DELETE methods
- [ ] Error tests include 400, 401, 403, 404, 500 scenarios
- [ ] The test suite passes (with a valid API key)

---

## Option 3: Test Prioritizer

Build a Robot Framework library that analyzes a test suite and uses AI to rank tests by risk and importance.

### Required Keywords

| Keyword | Description |
|---------|-------------|
| `Analyze Test Suite` | Reads a .robot file, returns structured analysis of each test |
| `Prioritize Tests` | Ranks tests by risk/importance, returns ordered list |
| `Suggest Smoke Suite` | Picks the minimal set of tests for a smoke run |
| `Estimate Coverage Gaps` | Identifies what the suite does NOT cover |

### Expected Files

- `test_prioritizer.py` — the RF library
- `test_prioritizer_test.robot` — tests that verify analysis works

### Acceptance Criteria

- [ ] All four keywords exist and are callable
- [ ] `Prioritize Tests` returns tests in ranked order with reasoning
- [ ] `Suggest Smoke Suite` returns a subset (not the full suite)
- [ ] `Estimate Coverage Gaps` identifies specific missing scenarios
- [ ] The test suite passes (with a valid API key)

---

## Suggested Prompts

Here are prompts you can give your AI assistant to get started:

### For Claude Code / Cursor

```
Create a Robot Framework Python library called log_analyzer.py that uses
the OpenAI API to classify test failures. It should have these keywords:
- classify_failure(error_message) — returns one of: environment, data, code_bug, flaky
- analyze_test_results(results_summary) — classifies each failure in a summary
- generate_failure_report(results_summary) — creates a Markdown report
- suggest_fixes(error_message, test_name) — suggests how to fix the failure

Use ROBOT_LIBRARY_SCOPE = 'GLOBAL'. Accept api_key and model in __init__.
Then create log_analyzer_test.robot that tests all four keywords.
```

### For ChatGPT / General

```
I'm building a Robot Framework library in Python. The library should:
1. Connect to OpenAI API
2. Classify test failure messages into categories
3. Generate reports
4. Suggest fixes

Please create the complete Python file and a Robot Framework test file.
```

---

## Tips

- Start with the simplest keyword first, get it working, then expand
- If the AI generates broken code, paste the error back and ask it to fix it
- You can use the `ai_library.py` from earlier as a reference for structure
- Remember: `ROBOT_LIBRARY_SCOPE = 'GLOBAL'` and proper docstrings make RF happy
