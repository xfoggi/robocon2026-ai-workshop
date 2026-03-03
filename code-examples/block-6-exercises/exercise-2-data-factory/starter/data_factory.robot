*** Settings ***
Documentation    Exercise 2: AI-Powered Test Data Factory
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
...
...              GOAL: Use Generate Test Data to create realistic, edge-case-rich
...              test data sets. Save them to files for use in other tests.
Library          ai_library.py    api_key=%{OPENAI_API_KEY}
Library          OperatingSystem


*** Test Cases ***
Generate Product Catalog Data
    [Documentation]    Generate a product catalog with realistic edge cases.
    ...    Each product should have: name, price, category, stock_quantity.
    ...    Include edge cases: zero price (free item), very high price,
    ...    zero stock (out of stock), special characters in names.
    # TODO: Call Generate Test Data with a detailed description
    #       asking for 10 products in JSON format.
    #
    # ${data}=    Generate Test Data    <your description here>    json    10
    # Log    ${data}
    # Should Contain    ${data}    price
    # Should Contain    ${data}    category
    # Create File    ${CURDIR}/product_catalog.json    ${data}
    Skip    TODO: Implement product catalog generation

Generate User Profiles
    [Documentation]    Generate international user profiles with unicode characters.
    ...    Each profile: first_name, last_name, email, age, country.
    ...    Include: non-ASCII names (accents, CJK characters),
    ...    boundary ages (0, 17, 18, 120, 150), diverse countries.
    # TODO: Call Generate Test Data asking for 8 international user
    #       profiles with boundary values and unicode names.
    #
    # ${data}=    Generate Test Data    <your description here>    json    8
    # Log    ${data}
    # Should Contain    ${data}    email
    # Should Contain    ${data}    country
    # Create File    ${CURDIR}/user_profiles.json    ${data}
    Skip    TODO: Implement user profile generation

# ──────────────────────────────────────────────────────────────
# STRETCH GOAL: Generate Related Records
# ──────────────────────────────────────────────────────────────
# Generate users FIRST, then generate orders that reference
# the user IDs from the first data set.
#
# Hint: Store the user data in a variable, then pass it into
# the second Generate Test Data call as context.
#
# Generate Related Records
#     ${users}=    Generate Test Data    ...
#     ${orders}=    Ask AI
#     ...    Given these users:\n${users}\n\nGenerate 5 orders ...
#     ...    system_message=You are a test data generator...
#     Create File    ${CURDIR}/users.json     ${users}
#     Create File    ${CURDIR}/orders.json    ${orders}
