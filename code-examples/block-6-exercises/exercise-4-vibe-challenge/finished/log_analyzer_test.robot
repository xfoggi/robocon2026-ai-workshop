*** Settings ***
Documentation    Tests for the Log Analyzer library (Exercise 4, Option 1).
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
Library          log_analyzer.py    api_key=%{OPENAI_API_KEY}


*** Variables ***
${ENV_ERROR}       ConnectionRefusedError: could not connect to server at localhost:5432 - Connection refused. Is the server running on that host and accepting TCP/IP connections?
${DATA_ERROR}      AssertionError: Expected user fixture 'test_user_42' not found in database. Available fixtures: test_user_1, test_user_2
${BUG_ERROR}       AssertionError: Expected status code 200 but got 500. Response body: {"error": "NullPointerException in UserService.getProfile()"}
${FLAKY_ERROR}     TimeoutError: Element 'id=loading-spinner' did not disappear within 5 seconds. Test passed on previous 3 runs.

${RESULTS_SUMMARY}    SEPARATOR=\n
...    FAIL: Login Test - ConnectionRefusedError: cannot connect to auth-service:8080
...    FAIL: Search Test - AssertionError: Expected 10 results but got 0
...    FAIL: Checkout Test - TimeoutError: Payment gateway did not respond within 30s
...    FAIL: Profile Test - AssertionError: Expected "John" but got "null" in name field
...    FAIL: Dashboard Test - StaleElementReferenceException: element is not attached to the page document


*** Test Cases ***
Classify Environment Failure
    [Documentation]    Connection errors should be classified as environment issues.
    ${category}=    Classify Failure    ${ENV_ERROR}
    Log    Category: ${category}
    Should Be Equal    ${category}    environment

Classify Data Failure
    [Documentation]    Missing fixture errors should be classified as data issues.
    ${category}=    Classify Failure    ${DATA_ERROR}
    Log    Category: ${category}
    Should Be Equal    ${category}    data

Classify Code Bug Failure
    [Documentation]    Server-side errors with stack traces should be classified as code bugs.
    ${category}=    Classify Failure    ${BUG_ERROR}
    Log    Category: ${category}
    Should Be Equal    ${category}    code_bug

Classify Flaky Failure
    [Documentation]    Intermittent timing issues should be classified as flaky.
    ${category}=    Classify Failure    ${FLAKY_ERROR}
    Log    Category: ${category}
    Should Be Equal    ${category}    flaky

Analyze Multiple Test Results
    [Documentation]    Analyze a batch of failures and verify structured output.
    ${analysis}=    Analyze Test Results    ${RESULTS_SUMMARY}
    Log    Analysis:\n${analysis}
    Should Not Be Empty    ${analysis}
    # The analysis should mention categories
    Should Contain    ${analysis}    environment    ignore_case=True

Generate Failure Report
    [Documentation]    Generate a Markdown report and verify it has the expected structure.
    ${report}=    Generate Failure Report    ${RESULTS_SUMMARY}
    Log    Report:\n${report}
    Should Not Be Empty    ${report}
    # Markdown report should contain headers
    Should Contain    ${report}    \#
    # Should mention summary or action items
    Should Contain    ${report}    Summary    ignore_case=True

Suggest Fixes For Connection Error
    [Documentation]    Verify fix suggestions are actionable and relevant.
    ${fixes}=    Suggest Fixes    ${ENV_ERROR}    Login Test
    Log    Fix Suggestions:\n${fixes}
    Should Not Be Empty    ${fixes}
    # Suggestions should reference the actual problem
    Should Contain    ${fixes}    connect    ignore_case=True

Suggest Fixes For Assertion Error
    [Documentation]    Verify fix suggestions address assertion failures properly.
    ${fixes}=    Suggest Fixes    ${BUG_ERROR}    Profile API Test
    Log    Fix Suggestions:\n${fixes}
    Should Not Be Empty    ${fixes}
    Should Contain    ${fixes}    fix    ignore_case=True
