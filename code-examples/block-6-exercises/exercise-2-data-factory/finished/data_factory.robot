*** Settings ***
Documentation    Exercise 2 — FINISHED: AI-Powered Test Data Factory
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
Library          ai_library.py    api_key=%{OPENAI_API_KEY}
Library          OperatingSystem


*** Test Cases ***
Generate Product Catalog Data
    [Documentation]    Generate 10 product records with realistic edge cases.
    ${description}=    Catenate
    ...    E-commerce product catalog. Each product has: name (string), price (number),
    ...    category (string), stock_quantity (integer). Include edge cases: one free item
    ...    (price 0), one very expensive item (price > 10000), one out-of-stock item
    ...    (stock_quantity 0), one product with special characters in the name (e.g. umlauts,
    ...    ampersand). Categories should include Electronics, Books, Clothing, Food.
    ${data}=    Generate Test Data    ${description}    json    10
    Log    Product Catalog:\n${data}
    Should Not Be Empty    ${data}
    Should Contain    ${data}    price
    Should Contain    ${data}    category
    Should Contain    ${data}    name
    Should Contain    ${data}    stock_quantity
    Create File    ${CURDIR}/product_catalog.json    ${data}

Generate User Profiles
    [Documentation]    Generate 8 international user profiles with unicode and boundary ages.
    ${description}=    Catenate
    ...    International user profiles for testing. Each profile has: first_name, last_name,
    ...    email, age (integer), country. Requirements: at least 2 names with non-ASCII
    ...    characters (Czech diacritics like Ruzicka, Japanese characters, French accents),
    ...    include boundary ages (exactly 0, 17, 18, 120), at least 5 different countries
    ...    across different continents. Emails must be realistic but fictional.
    ${data}=    Generate Test Data    ${description}    json    8
    Log    User Profiles:\n${data}
    Should Not Be Empty    ${data}
    Should Contain    ${data}    email
    Should Contain    ${data}    country
    Should Contain    ${data}    first_name
    Should Contain    ${data}    age
    Create File    ${CURDIR}/user_profiles.json    ${data}

Generate Related Records
    [Documentation]    Generate users first, then orders that reference user IDs.
    ...    This demonstrates passing AI output back as context for a second call.
    ${user_desc}=    Catenate
    ...    User records for an e-commerce system. Each user has: user_id (integer starting
    ...    from 1001), name, email, membership_level (bronze/silver/gold). Generate exactly
    ...    4 users.
    ${users}=    Generate Test Data    ${user_desc}    json    4
    Log    Users:\n${users}
    Should Contain    ${users}    user_id
    ${order_prompt}=    Catenate
    ...    Given these existing users:\n${users}\n\nGenerate 6 orders in JSON array format.
    ...    Each order has: order_id (integer starting from 5001), user_id (MUST reference one
    ...    of the user_ids above), product_name, quantity (integer), total_price (number).
    ...    Distribute orders across multiple users — at least 2 users should have orders.
    ...    Return ONLY the JSON array, no markdown formatting.
    ${orders}=    Ask AI    ${order_prompt}    system_message=You are a test data generator. Return only raw JSON, no explanations, no markdown code fences.
    Log    Orders:\n${orders}
    Should Contain    ${orders}    order_id
    Should Contain    ${orders}    user_id
    Create File    ${CURDIR}/users.json     ${users}
    Create File    ${CURDIR}/orders.json    ${orders}
