*** Settings ***
Documentation    Exercise 3: AI Test Suite Generator
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
...
...              GOAL: Use Generate Test Cases to produce a complete test suite
...              from requirements, then save it as a .robot file.
Library          ai_library.py    api_key=%{OPENAI_API_KEY}
Library          OperatingSystem


*** Test Cases ***
Generate Tests For Search Feature
    [Documentation]    Generate a full test suite for a bookstore search feature.
    ${requirements}=    Set Variable
    ...    Online bookstore search feature:
    ...    - Users can search by title, author, or ISBN
    ...    - Search results show book cover, title, author, price
    ...    - Results are paginated (20 per page)
    ...    - Empty search shows "Please enter a search term"
    ...    - No results shows "No books found for <query>"
    ...    - Search supports partial matches
    ...    - Special characters in search should not cause errors

    # TODO: Call Generate Test Cases with the requirements above
    #       and save the result to a .robot file.
    #
    # ${tests}=    Generate Test Cases    ${requirements}
    # Log    ${tests}
    # Should Contain    ${tests}    *** Test Cases ***
    # Create File    ${CURDIR}/generated_search_tests.robot    ${tests}
    Skip    TODO: Generate test cases and save to file

# ──────────────────────────────────────────────────────────────
# STRETCH GOAL: AI Self-Review Loop
# ──────────────────────────────────────────────────────────────
# 1. Generate test cases (v1)
# 2. Feed v1 into Review Test to get feedback
# 3. Feed v1 + feedback back into Ask AI to produce improved v2
# 4. Save both versions so you can compare
#
# AI Self-Review Loop
#     ${v1}=        Generate Test Cases    ...
#     ${review}=    Review Test    ${v1}
#     ${v2}=        Ask AI    Improve this test suite based on the review ...\n${v1}\n\nReview:\n${review}
#     Create File    ${CURDIR}/v1_tests.robot    ${v1}
#     Create File    ${CURDIR}/v2_tests.robot    ${v2}
