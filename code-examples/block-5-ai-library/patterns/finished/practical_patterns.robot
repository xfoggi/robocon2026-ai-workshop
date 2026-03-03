*** Settings ***
Documentation    Practical AI patterns for real-world Robot Framework testing.
...              Each test demonstrates a pattern you can use in production.
...              Run: robot --pythonpath ../../openai/finished practical_patterns.robot
Library          ai_library.py    api_key=%{OPENAI_API_KEY}
Library          RequestsLibrary
Library          OperatingSystem
Library          Collections


*** Test Cases ***

# --- PATTERN 1: AI-Assisted Assertions ---

AI Validates API Response Structure
    [Documentation]    Use AI to validate complex API responses that are hard to check with simple assertions.
    ${response}=    GET    https://jsonplaceholder.typicode.com/users/1
    ${prompt}=    Catenate
    ...    Validate this API response. Check:
    ...    1) All expected user profile fields are present (name, email, phone, address, company)
    ...    2) Email format is valid
    ...    3) Address structure is complete (street, city, zipcode)
    ...    4) No fields are null or empty
    ...    Respond with PASS if everything is valid, FAIL with details if not.
    ...    \n\nResponse:\n${response.text}
    ${validation}=    Ask AI    ${prompt}
    Log    Validation: ${validation}
    Should Contain    ${validation}    PASS    ignore_case=True

AI Checks Error Message Quality
    [Documentation]    AI evaluates whether error messages are user-friendly.
    @{error_messages}=    Create List
    ...    Error: 500
    ...    Sorry, something went wrong. Please try again or contact support at help@example.com.
    ...    NullPointerException at line 42
    FOR    ${msg}    IN    @{error_messages}
        ${quality}=    Ask AI
        ...    Rate this error message for end-user friendliness (1-10) and explain why: "${msg}"
        Log    Message: "${msg}" => ${quality}
    END


# --- PATTERN 2: Smart Test Data Generation ---

Generate Edge Case Emails For Testing
    [Documentation]    AI generates edge-case email addresses that humans often forget to test.
    ${description}=    Catenate
    ...    email addresses for testing, including: valid standard, with plus sign,
    ...    with dots, missing @ symbol, double @, unicode characters,
    ...    very long local part (>64 chars), SQL injection attempt, XSS attempt
    ${emails}=    Generate Test Data    ${description}    json    12
    Log    Edge case emails:\n${emails}

Generate Localized Test Data
    [Documentation]    AI generates test data with international characters and formats.
    ${description}=    Catenate
    ...    customer records from 5 different countries (Czech Republic, Japan, Saudi Arabia, Brazil, Germany).
    ...    Include: full name in native script, local address format, local phone format, email.
    ${data}=    Generate Test Data    ${description}    json    5
    Log    International test data:\n${data}


# --- PATTERN 3: Test Documentation Generation ---

Generate Test Plan From Suite
    [Documentation]    AI reads a test file and generates a test plan document.
    ${test_file}=    Get File    ${CURDIR}/../../openai/finished/first_ai_test.robot
    ${prompt}=    Catenate
    ...    Analyze this Robot Framework test suite and generate a concise test plan including:
    ...    1. Summary of what is being tested
    ...    2. Test coverage (what's covered and what's missing)
    ...    3. Risk areas and recommendations
    ...    4. Suggested additional tests
    ...    \n\nTest Suite:\n${test_file}
    ${doc}=    Ask AI    ${prompt}
    Log    Test Plan:\n${doc}

Generate Release Notes From Test Results
    [Documentation]    AI generates human-readable release notes from test execution summary.
    ${summary}=    Catenate
    ...    Test Run: v2.1.0 Release Candidate
    ...    Total: 145 tests | Passed: 139 | Failed: 4 | Skipped: 2
    ...    Failed: test_checkout_with_expired_card, test_login_ldap_timeout,
    ...    test_report_export_large_dataset, test_mobile_landscape_layout
    ...    New tests added: 12 (shopping cart redesign)
    ...    Execution time: 23 minutes
    ${prompt}=    Catenate
    ...    Generate professional release notes for stakeholders based on this test summary.
    ...    Include: overall quality assessment, risk areas, go/no-go recommendation.
    ...    \n\n${summary}
    ${notes}=    Ask AI    ${prompt}    system_message=You are a QA lead preparing release notes for a product manager.
    Log    Release Notes:\n${notes}


# --- PATTERN 4: AI-Powered Test Case Generation ---

Generate Tests From User Story
    [Documentation]    Turn a user story into executable test cases.
    ${user_story}=    Catenate
    ...    AS A registered user
    ...    I WANT TO reset my password
    ...    SO THAT I can regain access to my account.
    ...    Acceptance criteria:
    ...    - User clicks "Forgot Password" on login page
    ...    - System sends reset link to registered email
    ...    - Link expires after 24 hours
    ...    - New password must meet complexity requirements (8+ chars, uppercase, number)
    ...    - User cannot reuse last 3 passwords
    ...    - Account is locked after 5 failed reset attempts
    ${tests}=    Generate Test Cases    ${user_story}
    Log    Generated Tests:\n${tests}
