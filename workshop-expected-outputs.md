# Workshop — Expected Outputs Reference
## What correct results look like at each stage

Use this when helping a participant debug — compare their output to these.

---

## verify_setup.py

**Correct (basic):**
```
1) Python version      -> green checkmark, Python 3.10+
2) Python packages     -> 5 green checkmarks (robot, openai, google.genai, mcp, requests)
3) Robot Framework CLI -> green checkmark, Robot Framework 7.x
4) Environment vars    -> green (if keys set) or yellow warning (OK, keys come later)
Result: 9 passed
```

**Correct (--test-keys):**
```
5) API key verification
   OpenAI API responded: "Hello!"
   Gemini API responded: "Hello!"
Result: 11 passed
```

---

## first_ai_test.robot (OpenAI)

**Correct output (5 tests, ~30-60 seconds):**
```
AI Should Answer Questions About Robot Framework    | PASS |
AI Should Generate Test Data For User Registration  | PASS |
AI Should Review A Test And Find Issues             | PASS |
AI Should Generate Test Cases From Requirements     | PASS |
AI Should Explain An Error Message                  | PASS |
5 tests, 5 passed, 0 failed
```

**What to check in log.html:**
- "AI Response:" should contain a meaningful paragraph about RF
- "Generated Data:" should be valid JSON with email fields
- "Review:" should mention issues like hardcoded credentials, missing teardown
- "Generated Tests:" should contain `*** Test Cases ***` and RF syntax
- "Explanation:" should mention element interactability and suggest waits

---

## first_gemini_test.robot (Gemini)

**Same structure, 5 tests passing.** Responses will differ in style from OpenAI.
Gemini tends to be more verbose, may include markdown formatting.

---

## model_comparison.robot

**Correct output (3 tests, ~60-90 seconds — calls both APIs per test):**
```
Compare AI Responses To Same Question       | PASS |
Compare Test Data Generation                | PASS |
Compare Test Review Quality                 | PASS |
3 tests, 3 passed, 0 failed
```

**In log.html:** You'll see side-by-side responses labeled "=== OpenAI ===" and "=== Gemini ===".

---

## practical_patterns.robot

**Correct output (7 tests, ~90-120 seconds):**
```
AI Validates API Response Structure              | PASS |
AI Checks Error Message Quality                  | PASS |
Generate Edge Case Emails For Testing            | PASS |
Generate Localized Test Data                     | PASS |
Generate Test Plan From Suite                    | PASS |
Generate Release Notes From Test Results         | PASS |
Generate Tests From User Story                   | PASS |
7 tests, 7 passed, 0 failed
```

**Note:** The API validation test calls jsonplaceholder.typicode.com — needs internet.

---

## Exercise 1: custom_keyword.robot

**Correct output (3 tests):**
```
Translate Text To Czech                        | PASS |
Convert Pattern Description To Regex           | PASS |
Summarize Technical Report For Manager         | PASS |
3 tests, 3 passed, 0 failed
```

**What to check:** Translation should NOT contain "Hello", regex should contain "@", summary should be shorter than the original.

---

## Exercise 2: data_factory.robot

**Correct output (3 tests):**
```
Generate Product Catalog Data                  | PASS |
Generate User Profiles                         | PASS |
Generate Related Records                       | PASS |
3 tests, 3 passed, 0 failed
```

**Creates files:** product_catalog.json, user_profiles.json, users.json, orders.json in the exercise directory.

---

## Exercise 3: suite_generator.robot

**Correct output (2 tests, ~60-90 seconds — multi-step AI calls):**
```
Generate Tests For Search Feature              | PASS |
AI Self-Review Loop                            | PASS |
2 tests, 2 passed, 0 failed
```

**Creates files:** generated_search_tests.robot, v1_auth_tests.robot, v2_auth_tests.robot. The v2 should be notably improved over v1.

---

## Exercise 4: log_analyzer_test.robot

**Correct output (8 tests):**
```
Classify Environment Failure                   | PASS |
Classify Data Failure                          | PASS |
Classify Code Bug Failure                      | PASS |
Classify Flaky Failure                         | PASS |
Analyze Multiple Test Results                  | PASS |
Generate Failure Report                        | PASS |
Suggest Fixes For Connection Error             | PASS |
Suggest Fixes For Assertion Error              | PASS |
8 tests, 8 passed, 0 failed
```

**Note:** Classification tests check exact string matches (e.g., "environment", "data"). AI occasionally misclassifies — if a test fails, re-run once before debugging.

---

## Common Failure Patterns & Quick Fixes

| You see this | The problem is | Quick fix |
|-------------|---------------|-----------|
| `expected 0 arguments, got 1` | Class name doesn't match filename | Rename class to match: `ai_library.py` -> `class ai_library:` |
| `expected 1 to 3 arguments, got 7` | Multi-line `...` created separate args | Use `Catenate` to build string first |
| `got multiple values for argument` | Same as above, but with a named arg | Use `Catenate` for the prompt, then pass it |
| `No keyword with name 'Ask AI' found` | Library import failed silently | Check `Library` line in Settings, verify .py file exists |
| `Variable '${OPENAI_API_KEY}' not found` | Wrong syntax for env var | Use `%{OPENAI_API_KEY}` (percent, not dollar) for env vars |
| `AuthenticationError` | Bad API key | Re-export the key, check for trailing spaces |
| `RateLimitError` | Shared key hit limit | Wait 30 seconds, retry |
| Test passes but assertion fails on AI content | AI response varies between runs | Make assertions lenient: check for `***` not exact text |
| `Should Contain` seems to ignore second argument | `#` starts a comment in RF | Escape it: `\#` |
