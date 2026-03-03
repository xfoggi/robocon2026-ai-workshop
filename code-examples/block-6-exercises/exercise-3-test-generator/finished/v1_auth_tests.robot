```robot
*** Settings ***
Library           SeleniumLibrary
Library           String
Library           DateTime

Suite Setup       Setup Suite
Suite Teardown    Teardown Suite

*** Variables ***
${BASE_URL}                      http://example.com
${LOGIN_PAGE}                    ${BASE_URL}/login
${FORGOT_PASSWORD_PAGE}          ${BASE_URL}/forgot-password
${EMAIL}                         user@example.com
${PASSWORD}                      Pass1234
${INVALID_PASSWORD}              wrongpass
${TOTPS_SECRET_KEY}              JBSWY3DPEHPK3PXP
${ACCOUNT_LOCK_DURATION}         30 minutes
${ACCOUNT_LOCK_RETRY_COUNT}      5
${SESSION_EXPIRY_DURATION}       30 minutes

*** Test Cases ***
Login With Valid Email And Password
    [Documentation]    Validate that user can login with valid email and password.
    Open Browser       ${LOGIN_PAGE}    Chrome
    Input Text         id=email    ${EMAIL}
    Input Text         id=password    ${PASSWORD}
    Click Button       id=login
    Page Should Contain    Welcome
    [Teardown]    Close Browser

Reject Weak Password That Lacks Uppercase And Number
    [Documentation]    Ensure login is rejected if password lacks required characters.
    Open Browser       ${LOGIN_PAGE}    Chrome
    Input Text         id=email    ${EMAIL}
    Input Text         id=password    weakpass
    Click Button       id=login
    Page Should Contain    Invalid password
    [Teardown]    Close Browser

Lock Account After Multiple Failed Login Attempts
    [Documentation]    Account should lock after ${ACCOUNT_LOCK_RETRY_COUNT} consecutive failed login attempts.
    [Setup]    Open Browser    ${LOGIN_PAGE}    Chrome
    : FOR    ${i}    IN RANGE    ${ACCOUNT_LOCK_RETRY_COUNT}
    \   Input Text    id=email    ${EMAIL}
    \   Input Text    id=password    ${INVALID_PASSWORD}
    \   Click Button    id=login
    \   Page Should Contain    Invalid credentials
    Input Text         id=email    ${EMAIL}
    Input Text         id=password    ${INVALID_PASSWORD}
    Click Button       id=login
    Page Should Contain    Account locked
    [Teardown]    Close Browser

Forgot Password Sends Reset Email
    [Documentation]    Verify that "Forgot password" functionality sends a reset email.
    Open Browser       ${FORGOT_PASSWORD_PAGE}    Chrome
    Input Text         id=email    ${EMAIL}
    Click Button       id=reset-password
    Page Should Contain    Reset link sent
    [Teardown]    Close Browser

Session Expires After Inactivity
    [Documentation]    Validate session expires after ${SESSION_EXPIRY_DURATION} of inactivity.
    [Setup]    Open Browser    ${LOGIN_PAGE}    Chrome
    Input Text         id=email    ${EMAIL}
    Input Text         id=password    ${PASSWORD}
    Click Button       id=login
    Page Should Contain    Welcome
    Sleep               ${SESSION_EXPIRY_DURATION}
    Refresh Page
    Page Should Contain    Session expired
    [Teardown]    Close Browser

Enable Two Factor Authentication
    [Documentation]    Verify users can enable Two Factor Authentication (TOTP).
    [Setup]    Open Browser    ${BASE_URL}/account/security    Chrome
    Input Text         id=email    ${EMAIL}
    Input Text         id=password    ${PASSWORD}
    Click Button       id=login
    Page Should Contain    Security Settings
    Input Text         id=totp-secret    ${TOTPS_SECRET_KEY}
    Click Button       id=enable-totp
    Page Should Contain    Two-factor authentication enabled
    [Teardown]    Close Browser

*** Keywords ***
Setup Suite
    Log    Suite Setup: Initializing environment

Teardown Suite
    Log    Suite Teardown: Cleaning up environment
```