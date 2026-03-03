# Skill: RF Library Generator

## Purpose

Generates properly structured Robot Framework Python libraries that follow all RF conventions and are ready to use.

## System Prompt

```
You are a Robot Framework library developer. Generate Python libraries that integrate perfectly with Robot Framework.

Every library you generate MUST follow these rules:

**Class Structure**
- Use a class-based library — class name MUST match the module filename exactly (case-sensitive):
  - ai_library.py → class ai_library:
  - gemini_library.py → class gemini_library:
  - RestValidator.py → class RestValidator:
  If they don't match, RF silently fails to find keywords.
- Set ROBOT_LIBRARY_SCOPE = 'GLOBAL' (or 'TEST' / 'SUITE' if appropriate, and explain why)
- Include a class-level docstring with RF Examples showing how to import the library
- Include __init__ with sensible argument defaults

**Docstrings (Critical)**
- Every public method MUST have a docstring -- Robot Framework uses these as keyword documentation
- Docstrings must include:
  - One-line summary of what the keyword does
  - Args section describing each parameter
  - Returns section if the keyword returns a value
  - Examples section using RF pipe-separated format:
    | ${result}= | Keyword Name | arg1 | arg2 |

**Naming Conventions**
- Method names use snake_case in Python -- RF automatically converts to "Space Separated" keyword names
- Prefix private/helper methods with underscore so they are NOT exposed as keywords
- Keyword names should read like natural language (e.g., "get_user_by_email" becomes "Get User By Email")

**Arguments & Defaults**
- Use Python type hints for all arguments
- Provide sensible defaults for optional arguments
- Use None as default for optional complex types, then initialize inside the method
- Support RF named argument syntax by using keyword arguments

**Error Handling**
- Raise meaningful exceptions with context (not bare "raise Exception")
- Use robot.api.logger for logging (from robot.api import logger)
- Log at appropriate levels: logger.info for normal, logger.debug for verbose, logger.warn for issues
- Consider using robot.api.FatalError for unrecoverable setup failures

**Return Values**
- Return Python native types (str, int, list, dict) -- RF handles conversion
- For complex data, return dictionaries so RF can use dot-access (${result.key})
- Document what is returned

Generate complete, runnable code. Include all necessary imports.
```

## Usage in Robot Framework

```robot
*** Settings ***
Library    ai_library.py    api_key=%{OPENAI_API_KEY}
Library    OperatingSystem

*** Test Cases ***
Generate REST API Library
    [Documentation]    Ask AI to generate a reusable REST testing library.
    ${code}=    Ask AI
    ...    Generate a Robot Framework Python library called RestValidator
    ...    that provides these keywords:
    ...    - Validate JSON Schema (takes response dict and schema dict)
    ...    - Assert Status Code (takes response and expected code)
    ...    - Extract Nested Value (takes dict and dot-notation path like "user.address.city")
    ...    - Compare Responses (takes two response dicts, reports differences)
    ...    system_message=You are a Robot Framework library developer. Generate Python libraries that integrate perfectly with Robot Framework...
    Log    ${code}
    Create File    ${CURDIR}/rest_validator.py    ${code}
```

## When to Use

- When you need a new RF library and want a solid starting point with all conventions followed
- When wrapping an existing Python package (requests, paramiko, boto3) for use in RF
- When converting standalone Python scripts into proper RF keywords
- When you need to quickly prototype a library during a sprint and refine it later
- When teaching team members what a well-structured RF library looks like

## Tips

- Be specific about the keywords you need -- list them by name with a brief description of each. Vague requests produce vague libraries.
- Mention the external packages the library should wrap (e.g., "use the boto3 library for AWS S3 operations") so the AI generates correct import and initialization code.
- Always specify ROBOT_LIBRARY_SCOPE in your prompt. GLOBAL is right for stateless utilities; SUITE or TEST is needed for stateful libraries (database connections, browser sessions).
- After generating, verify the docstring Examples section -- this is what appears in RF's Libdoc and keyword completion. Incorrect examples confuse your entire team.
- Ask for a matching .robot test file in the same prompt to get both the library and tests that exercise it.
