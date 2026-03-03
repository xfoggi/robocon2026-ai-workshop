```robot
*** Variables ***
${BASE_URL}            http://example.com
${TITLE_QUERY}         The Great Gatsby
${AUTHOR_QUERY}        F. Scott Fitzgerald
${ISBN_QUERY}          9780743273565
${PARTIAL_QUERY}       Great
${SPECIAL_CHAR_QUERY}  $&*@!
${NO_RESULTS_QUERY}    zxqvbnmlkjh

*** Settings ***
Library              SeleniumLibrary
Library              Collections

*** Test Cases ***
[Documentation]  Test the search by full book title
Search Book By Title
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Enter Search Query   ${TITLE_QUERY}
    Submit Search
    Verify Search Results  ${TITLE_QUERY}

[Documentation]  Test the search by author name
Search Book By Author
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Enter Search Query   ${AUTHOR_QUERY}
    Submit Search
    Verify Search Results  ${AUTHOR_QUERY}

[Documentation]  Test the search by ISBN number
Search Book By ISBN
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Enter Search Query   ${ISBN_QUERY}
    Submit Search
    Verify Search Results  ${TITLE_QUERY}

[Documentation]  Test the search with partial matches
Search Book With Partial Match
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Enter Search Query   ${PARTIAL_QUERY}
    Submit Search
    Verify Partial Search Results  ${PARTIAL_QUERY}

[Documentation]  Test the search with no results found
Search Book With No Results
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Enter Search Query   ${NO_RESULTS_QUERY}
    Submit Search
    Verify No Results Found  ${NO_RESULTS_QUERY}

[Documentation]  Ensure empty search shows proper message
Search Without Query
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Submit Search
    Page Should Contain   Please enter a search term

[Documentation]  Test search with special characters
Search With Special Characters
    [Setup]    Open Browser    ${BASE_URL}    Chrome
    [Teardown]  Close Browser
    Open Search Page
    Enter Search Query   ${SPECIAL_CHAR_QUERY}
    Submit Search
    Page Should Not Contain Error

*** Keywords ***
Open Search Page
    Go To    ${BASE_URL}/search

Enter Search Query
    [Arguments]  ${query}
    Input Text   name=search    ${query}

Submit Search
    Click Button  id=searchButton

Verify Search Results
    [Arguments]  ${query}
    ${results}=    Get Matching Search Results   ${query}
    Should Be True    len(${results}) > 0

Verify Partial Search Results
    [Arguments]  ${query}
    ${results}=    Get Partial Search Results   ${query}
    Should Be True    len(${results}) > 0

Verify No Results Found
    [Arguments]  ${query}
    Page Should Contain    No books found for ${query}

Get Matching Search Results
    [Arguments]  ${query}
    ${results}=    Create List
    :FOR  ${index}  IN RANGE  0  20
    \  ${title}=    Get Text    xpath=(//div[@class="search-result"])[${index+1}]//h2
    \  ${author}=   Get Text    xpath=(//div[@class="search-result"])[${index+1}]//h3
    \  Run Keyword If    '${query}' in '${title}' or '${query}' in '${author}'    Append To List    ${results}    ${index}
    [Return]    ${results}

Get Partial Search Results
    [Arguments]  ${query}
    ${results}=    Create List
    :FOR  ${index}  IN RANGE  0  20
    \  ${title}=    Get Text    xpath=(//div[@class="search-result"])[${index+1}]//h2
    \  Run Keyword If    '${query}' in '${title}'    Append To List    ${results}    ${index}
    [Return]    ${results}
```