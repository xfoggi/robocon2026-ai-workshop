# Vibe Coding Live Demo -- Prompts

These are the exact prompts used during the Block 2 live demo. You can replay them in any AI coding tool (Claude Code, Cursor, ChatGPT, Copilot) to recreate the workshop demo step by step.

---

## Prompt 1: Create the AI Library

> Create a Robot Framework Python library called ai_library.py that wraps the OpenAI API. It should have these keywords: Ask AI, Generate Test Data, Review Test, Generate Test Cases, Generate Keywords, Explain Error. Use the openai library. Include proper docstrings so the keywords show help in RF. Set ROBOT_LIBRARY_SCOPE to GLOBAL.

### What to Watch While AI Generates

- **Class structure:** Does it create a class called `AILibrary`? (RF infers the class name from the filename.)
- **ROBOT_LIBRARY_SCOPE:** Is it set to `'GLOBAL'` as a class attribute, not inside `__init__`?
- **Docstrings:** Does every method have a docstring with an `Examples:` section using the RF pipe format? This is what appears in Libdoc and keyword completion.
- **`__init__` parameters:** Does it accept `api_key` and `model` with sensible defaults? Does it use `OpenAI(api_key=api_key)` correctly?
- **Method signatures:** Are there type hints? Are optional arguments keyword arguments with defaults?

### Expected Output Characteristics

- A single Python file (~120-180 lines)
- 6 public methods (one per keyword) plus `__init__`
- Each method calls `self.client.chat.completions.create()`
- System messages are tailored to each keyword's purpose (e.g., "You are a test data generator" for Generate Test Data)
- The `generate_test_data` method accepts `format` and `count` parameters
- The `review_test` method prompts for issues, improvements, coverage gaps, and refactoring suggestions

---

## Prompt 2: Create Test Cases

> Now create a .robot test file called first_ai_test.robot that imports this library and has 5 test cases exercising each keyword. Use the environment variable OPENAI_API_KEY.

### What to Watch While AI Generates

- **Library import:** Does it use `Library    ai_library.py    api_key=%{OPENAI_API_KEY}`? The `%{VAR}` syntax is RF's way of reading environment variables.
- **Test case names:** Are they descriptive and readable? (e.g., "AI Should Answer Questions About Robot Framework" not "Test 1")
- **Assertions:** Does it go beyond just `Should Not Be Empty`? Look for content-aware assertions like `Should Contain`.
- **Documentation:** Is there a `Documentation` setting in `*** Settings ***`? Do individual test cases have `[Documentation]`?
- **Variable usage:** Does it use `${variables}` properly? Are multi-line values handled with `...` continuation?

### Expected Output Characteristics

- A .robot file with `*** Settings ***`, `*** Test Cases ***` sections
- 5 test cases, each exercising a different keyword
- At least one test that checks the content of the AI response (not just that it is non-empty)
- A test for `Review Test` that feeds in a deliberately flawed test snippet
- A test for `Generate Test Cases` that provides requirements and verifies the output contains RF syntax
- Proper use of `Log` to make test output readable in the RF report

---

## Prompt 3: Add Gemini Variant

> Add a Gemini variant -- create gemini_library.py with the same interface but using google-genai. And create a comparison test that runs the same prompt through both models.

### What to Watch While AI Generates

- **Same interface:** Does `GeminiLibrary` have the exact same method names and signatures as `AILibrary`? This is the key to model portability.
- **Correct SDK:** Does it use `from google import genai` (the `google-genai` package, NOT the deprecated `google-generativeai`)? Watch out for hallucinated package names.
- **Initialization:** Does it call `genai.Client(api_key=api_key)` and store the model name?
- **System message handling:** The new google-genai SDK supports `system_instruction` via `types.GenerateContentConfig`. The AI should use this instead of concatenating system + user prompts.
- **Comparison test:** Does it import both libraries with `WITH NAME` aliases? Does it send the same prompt to both and log both responses?

### Expected Output Characteristics

- `gemini_library.py`: Same structure as `ai_library.py` but using the Gemini SDK
- `model_comparison.robot`: Imports both libraries using `WITH NAME` (e.g., `WITH NAME    OpenAI` and `WITH NAME    Gemini`)
- Comparison tests that call `OpenAI.Ask AI` and `Gemini.Ask AI` with identical prompts
- Both libraries use the same method signatures so they are interchangeable
- The comparison test logs both responses for side-by-side viewing in the RF report

---

## Prompt 4 (VSCode Refinement): Add SQL Output Format

> Add support for generating data in SQL INSERT format, not just JSON and CSV

### What to Watch While AI Generates

- **Minimal change:** Does the AI modify only the `generate_test_data` method, or does it rewrite the entire file? A good AI tool makes surgical edits.
- **Format parameter:** Does it add `"sql"` to the accepted formats? Does it update the docstring to document the new option?
- **Prompt engineering:** Look at how it modifies the prompt sent to the AI model. For SQL format, it should instruct the model to include the CREATE TABLE statement and proper SQL escaping.
- **Backward compatibility:** Does it break existing calls that use `format="json"` or `format="csv"`?

### Expected Output Characteristics

- The `format` parameter now accepts `"json"`, `"csv"`, or `"sql"`
- The docstring's `Examples:` section is updated to show the SQL option
- When `format="sql"` is specified, the AI prompt asks for `CREATE TABLE` + `INSERT INTO` statements
- Existing functionality (JSON, CSV) is unchanged

---

## Tips for Replaying This Demo

1. **Go in order.** Each prompt builds on the previous one. The AI needs the context of what was already generated.
2. **Use a fresh directory.** Start with an empty folder so the AI does not get confused by existing files.
3. **Compare your output.** After each prompt, compare what the AI generated against the finished files in `block-5-ai-library/openai/finished/` and `block-5-ai-library/gemini/finished/`.
4. **Experiment.** Try rephrasing the prompts. Add constraints ("use only standard library, no external packages"). Remove constraints ("generate as many keywords as you think are useful"). See how the output changes.
5. **Break things on purpose.** After generating, introduce a bug and see if the AI can fix it when you paste the error message.
