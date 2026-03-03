*** Settings ***
Documentation    Exercise 3 — FINISHED: AI Test Suite Generator with Self-Review Loop
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
Library          ai_library.py    api_key=%{OPENAI_API_KEY}
Library          OperatingSystem


*** Test Cases ***
Generate Tests For Search Feature
    [Documentation]    Generate a complete test suite from bookstore search requirements.
    ${requirements}=    Catenate    SEPARATOR=\n
    ...    Online bookstore search feature:
    ...    - Users can search by title, author, or ISBN
    ...    - Search results show book cover, title, author, price
    ...    - Results are paginated (20 per page)
    ...    - Empty search shows "Please enter a search term"
    ...    - No results shows "No books found for <query>"
    ...    - Search supports partial matches
    ...    - Special characters in search should not cause errors
    ${tests}=    Generate Test Cases    ${requirements}
    Log    Generated Tests:\n${tests}
    Should Not Be Empty    ${tests}
    Should Contain    ${tests}    Test Cases    ignore_case=True
    Create File    ${CURDIR}/generated_search_tests.robot    ${tests}
    Log    Saved to generated_search_tests.robot

AI Self-Review Loop
    [Documentation]    Generate tests, review them with AI, then improve based on feedback.
    ...    Demonstrates a multi-step AI workflow: generate -> review -> improve.

    # Step 1: Generate initial test suite (v1)
    ${requirements}=    Catenate    SEPARATOR=\n
    ...    User authentication system:
    ...    - Login with email and password
    ...    - Password must be at least 8 characters with one uppercase and one number
    ...    - Account locks after 5 failed attempts for 30 minutes
    ...    - "Forgot password" sends reset email
    ...    - Session expires after 30 minutes of inactivity
    ...    - Users can enable two-factor authentication (TOTP)
    ${v1}=    Generate Test Cases    ${requirements}
    Log    === V1 Tests ===\n${v1}
    Should Not Be Empty    ${v1}

    # Step 2: Review v1 with AI
    ${review}=    Review Test    ${v1}
    Log    === Review ===\n${review}
    Should Not Be Empty    ${review}

    # Step 3: Feed v1 + review back to AI to produce improved v2
    ${improve_prompt}=    Catenate
    ...    Here is a Robot Framework test suite and a code review of it.
    ...    Please produce an improved version that addresses ALL the review feedback.
    ...    Return ONLY the complete improved Robot Framework code, ready to run.\n\n
    ...    Original test suite:\n${v1}\n\n
    ...    Code review feedback:\n${review}
    ${v2}=    Ask AI    ${improve_prompt}    system_message=You are a senior Robot Framework test engineer. Produce clean, complete, improved test code. Return only the Robot Framework code, no explanations.
    Log    === V2 Tests (Improved) ===\n${v2}
    Should Not Be Empty    ${v2}

    # Step 4: Save both versions for comparison
    Create File    ${CURDIR}/v1_auth_tests.robot    ${v1}
    Create File    ${CURDIR}/v2_auth_tests.robot    ${v2}
    Log    Saved v1 and v2 for comparison. Diff them to see improvements!
