*** Settings ***
Documentation    Compare OpenAI and Gemini outputs side by side.
...              Demonstrates model portability — same interface, different backends.
...              Run: robot --pythonpath ../../openai/finished --pythonpath ../../gemini/finished model_comparison.robot
Library          ai_library.py    api_key=%{OPENAI_API_KEY}    WITH NAME    OpenAI
Library          gemini_library.py    api_key=%{GEMINI_API_KEY}    WITH NAME    Gemini


*** Variables ***
${TEST_PROMPT}    Generate 3 test cases for a password reset feature. Be concise.
${DATA_PROMPT}    European customer with name, email, address, and phone number


*** Test Cases ***
Compare AI Responses To Same Question
    [Documentation]    Send the same prompt to both models and compare.
    ${openai_answer}=    OpenAI.Ask AI    ${TEST_PROMPT}
    ${gemini_answer}=    Gemini.Ask AI    ${TEST_PROMPT}
    Log    === OpenAI Response ===\n${openai_answer}
    Log    === Gemini Response ===\n${gemini_answer}
    Should Not Be Empty    ${openai_answer}
    Should Not Be Empty    ${gemini_answer}

Compare Test Data Generation
    [Documentation]    Compare test data quality between models.
    ${openai_data}=    OpenAI.Generate Test Data    ${DATA_PROMPT}    json    3
    ${gemini_data}=    Gemini.Generate Test Data    ${DATA_PROMPT}    json    3
    Log    === OpenAI Data ===\n${openai_data}
    Log    === Gemini Data ===\n${gemini_data}
    Should Contain    ${openai_data}    email
    Should Contain    ${gemini_data}    email

Compare Test Review Quality
    [Documentation]    Both models review the same flawed test.
    ${bad_test}=    Catenate    SEPARATOR=\n
    ...    *** Test Cases ***
    ...    Checkout
    ...    ${SPACE * 4}Click Element${SPACE * 4}buy-btn
    ...    ${SPACE * 4}Sleep${SPACE * 4}5s
    ...    ${SPACE * 4}Page Should Contain${SPACE * 4}Thank you
    ${openai_review}=    OpenAI.Review Test    ${bad_test}
    ${gemini_review}=    Gemini.Review Test    ${bad_test}
    Log    === OpenAI Review ===\n${openai_review}
    Log    === Gemini Review ===\n${gemini_review}
    Should Not Be Empty    ${openai_review}
    Should Not Be Empty    ${gemini_review}
