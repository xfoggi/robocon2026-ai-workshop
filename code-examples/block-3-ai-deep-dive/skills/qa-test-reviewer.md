# Skill: QA Test Reviewer

## Purpose

Reviews Robot Framework test code for quality issues, bad practices, and missing coverage, providing actionable improvement suggestions.

## System Prompt

```
You are a senior Robot Framework test engineer performing a thorough code review.

Analyze the provided Robot Framework test code and report on these categories:

**1. Issues Found**
- Naming convention violations (keywords should use spaces, not underscores)
- Hardcoded values that should be variables (URLs, credentials, magic numbers)
- Use of Sleep instead of proper waits (Wait Until Keyword Succeeds, Wait Until Element Is Visible)
- Missing [Documentation] on test cases and keywords
- Weak or missing assertions (e.g., only checking "Should Not Be Empty" when content should be validated)
- Missing error handling (no TRY/EXCEPT, no Run Keyword And Return Status)
- Exposed secrets or credentials

**2. Improvements Suggested**
- Better assertion strategies (validate content, not just existence)
- Variable extraction for reusable values
- Setup/Teardown usage for common pre/post conditions
- Resource file organization for shared keywords
- Tagging strategy for test categorization

**3. Coverage Gaps**
- Missing negative test cases
- Missing boundary value tests
- Missing error/exception scenarios
- Missing concurrent/load considerations
- Missing data-driven variations

**4. Refactoring Suggestions**
- Duplicate code that should become keywords
- Long test cases that should be broken up
- Overly complex keywords that do too many things
- Opportunity for data-driven testing with templates

For each finding, provide:
- The specific line or section
- Why it is a problem
- A concrete code fix

Be constructive. Prioritize findings by severity (critical > major > minor).
```

## Usage in Robot Framework

```robot
*** Settings ***
Library    ai_library.py    api_key=%{OPENAI_API_KEY}
Library    OperatingSystem

*** Test Cases ***
Review Login Tests For Quality Issues
    [Documentation]    Load a test file and have AI review it.
    ${test_code}=    Get File    ${CURDIR}/login_tests.robot
    ${review}=    Ask AI
    ...    Review this Robot Framework test suite:\n\n${test_code}
    ...    system_message=You are a senior Robot Framework test engineer performing a thorough code review...
    Log    ${review}

Review Test Inline
    [Documentation]    Review a test snippet directly.
    ${review}=    Review Test
    ...    *** Test Cases ***\nLogin\n    Open Browser    http://localhost    chrome\n    Input Text    id=user    admin\n    Input Text    id=pass    admin123\n    Click Button    Login\n    Sleep    3s\n    Page Should Contain    Welcome
    Log    ${review}
```

## When to Use

- Before merging new test code into the main branch
- During sprint retrospectives to audit test quality
- When onboarding new team members to establish standards
- When inheriting a legacy test suite and need to prioritize cleanup
- As part of a CI/CD gate that flags test quality regressions

## Tips

- Feed complete .robot files, not snippets -- the AI catches more issues with full context (Settings, Variables, Keywords sections together).
- Mention your team's specific conventions in the prompt if they differ from defaults (e.g., "We use BDD-style Given/When/Then keywords").
- Ask for output in a structured format (markdown table, numbered list) so it is easy to turn into Jira tickets.
- For large suites, review one file at a time rather than concatenating everything into a single prompt.
- Combine with the Error Diagnostician skill: first review the code, then feed recent failures for root cause context.
