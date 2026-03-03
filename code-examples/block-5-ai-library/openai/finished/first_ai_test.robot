*** Settings ***
Documentation    First Robot Framework test using our AI Library.
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
Library          ai_library.py    api_key=%{OPENAI_API_KEY}


*** Test Cases ***
AI Should Answer Questions About Robot Framework
    [Documentation]    Basic test — ask AI a question, verify we get a response.
    ${answer}=    Ask AI    What are the three key features of Robot Framework? Be brief.
    Log    AI Response: ${answer}
    Should Not Be Empty    ${answer}
    Should Contain    ${answer}    keyword    ignore_case=True

AI Should Generate Test Data For User Registration
    [Documentation]    Use AI to generate realistic test data for a registration form.
    ${data}=    Generate Test Data
    ...    user registration form with: first name, last name, email, phone number, date of birth
    ...    json    3
    Log    Generated Data:\n${data}
    Should Not Be Empty    ${data}
    Should Contain    ${data}    email

AI Should Review A Test And Find Issues
    [Documentation]    Feed AI a deliberately flawed test and check it finds problems.
    ${bad_test}=    Catenate    SEPARATOR=\n
    ...    *** Test Cases ***
    ...    Login Test
    ...    ${SPACE * 4}Open Browser${SPACE * 4}http://example.com${SPACE * 4}chrome
    ...    ${SPACE * 4}Input Text${SPACE * 4}id=username${SPACE * 4}admin
    ...    ${SPACE * 4}Input Text${SPACE * 4}id=password${SPACE * 4}password123
    ...    ${SPACE * 4}Click Button${SPACE * 4}id=login
    ${review}=    Review Test    ${bad_test}
    Log    Review:\n${review}
    Should Not Be Empty    ${review}

AI Should Generate Test Cases From Requirements
    [Documentation]    Give AI a feature description, get complete test cases back.
    ${requirements}=    Catenate    SEPARATOR=\n
    ...    Shopping cart: users can add items, remove items, change quantity,
    ...    apply discount codes, and proceed to checkout.
    ...    Cart shows item total, tax, and grand total.
    ...    Empty cart shows "Your cart is empty" message.
    ${tests}=    Generate Test Cases    ${requirements}
    Log    Generated Tests:\n${tests}
    Should Not Be Empty    ${tests}
    Should Contain    ${tests}    ***

AI Should Explain An Error Message
    [Documentation]    Test the error explanation feature with a common RF error.
    ${explanation}=    Explain Error
    ...    ElementNotInteractableException: Message: element not interactable
    ...    context=Trying to click a login button on a web page after filling in credentials
    Log    Explanation:\n${explanation}
    Should Not Be Empty    ${explanation}
