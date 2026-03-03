```robot
*** Settings ***
Library           SeleniumLibrary
Library           String
Library           DateTime
Library           RPA.Email.ImapSmtp
Resource          Locators.robot

Suite Setup       Open Browser And Go To Login Page
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}                         http://example.com
${LOGIN_PAGE}                       ${BASE_URL}/login
${FORGOT_PASSWORD_PAGE}             ${BASE_URL}/forgot-password
${EMAIL}                            user@example.com
${PASSWORD}                         Pass1234
${INVALID_PASSWORD}                 wrongpass
${TOTPS_SECRET_KEY}                 JBSWY3DPEHPK3PXP
${ACCOUNT_LOCK_RETRY_COUNT}         5
${SESSION_EXPIRY_DURATION}          30 minutes

*** Test Cases ***
Login With Valid Email And Password
    [Documentation]    Validate that user can login with valid email and password.
    Open Login Page
    Enter Credentials    ${EMAIL}    ${PASSWORD}
    Submit Login
    Page Should Contain    Welcome

Reject Weak Password That Lacks Uppercase And Number
    [Documentation]    Ensure login is rejected if password lacks required characters.
    Open Login Page
    Enter Credentials    ${EMAIL}    weakpass
    Submit Login
    Page Should Contain    Invalid password

Lock Account After Multiple Failed Login Attempts
    [Documentation]    Account should lock after ${ACCOUNT_LOCK_RETRY_COUNT} consecutive failed login attempts.
    Open Login Page
    Attempt Failed Logins
    Page Should Contain    Account locked

Forgot Password Sends Reset Email
    [Documentation]    Verify that "Forgot password" functionality sends a reset email.
    Open Browser And Go To URL    ${FORGOT_PASSWORD_PAGE}
    Input Text         ${loc_email}    ${EMAIL}
    Click Button       ${loc_reset_password_button}
    Page Should Contain    Reset link sent
    Check Reset Email Received

Session Expires After Inactivity
    [Documentation]    Validate session expires after ${SESSION_EXPIRY_DURATION} of inactivity.
    [Setup]    Configure Session Timeout Properly
    Open Login Page
    Enter Credentials    ${EMAIL}    ${PASSWORD}
    Submit Login
    Wait Until Page Contains    Welcome
    Simulate Inactivity And Verify Session Expiry

Enable Two Factor Authentication
    [Documentation]    Verify users can enable Two Factor Authentication (TOTP).
    Open Browser And Go To URL    ${BASE_URL}/account/security
    Enter Credentials    ${EMAIL}    ${PASSWORD}
    Submit Login
    Page Should Contain    Security Settings
    Input Text            ${loc_totp_secret}    ${TOTPS_SECRET_KEY}
    Click Button          ${loc_enable_totp_button}
    Page Should Contain   Two-factor authentication enabled

Test Logout Functionality
    [Documentation]    Verify that logout functionality works correctly.
    Open Login Page
    Enter Credentials    ${EMAIL}    ${PASSWORD}
    Submit Login
    Page Should Contain    Welcome
    Click Element          ${loc_logout_button}
    Page Should Contain    Login

*** Keywords ***
Open Browser And Go To Login Page
    Open Browser    ${BASE_URL}    Chrome
    Go To           ${LOGIN_PAGE}
    Maximize Browser Window

Open Login Page
    Go To           ${LOGIN_PAGE}

Enter Credentials
    [Arguments]    ${email}    ${password}
    Input Text     ${loc_email}    ${email}
    Input Text     ${loc_password}    ${password}

Submit Login
    Click Button   ${loc_login_button}

Attempt Failed Logins
    : FOR    ${i}    IN RANGE    ${ACCOUNT_LOCK_RETRY_COUNT}
    \   Enter Credentials     ${EMAIL}    ${INVALID_PASSWORD}
    \   Submit Login
    \   Page Should Contain   Invalid credentials
    Enter Credentials         ${EMAIL}    ${INVALID_PASSWORD}
    Submit Login

Simulate Inactivity And Verify Session Expiry
    Configure Session Timeout Properly
    Wait Until Keyword Succeeds   10s    5 min    Refresh Page
    Page Should Contain           Session expired

Check Reset Email Received
    Open Mailbox And Verify Subject

Open Mailbox And Verify Subject
    [Arguments]    ${subject}=Password Reset
    Open Mailbox    user@example.com    your_email_password_alias
    Wait For Email    subject=${subject}    timeout=2 min

Configure Session Timeout Properly
    # Configure server or application settings for session timeout if not feasible to set it directly in test.

Close Browser
    [Teardown]    Close All Browsers
```