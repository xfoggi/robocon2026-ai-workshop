*** Settings ***
Documentation    Exercise 1 — FINISHED: Three custom AI-powered keywords.
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
Library          ai_library.py    api_key=%{OPENAI_API_KEY}


*** Keywords ***
Translate To Czech
    [Documentation]    Translate any text to Czech using AI.
    [Arguments]    ${text}
    ${result}=    Ask AI
    ...    Translate the following text to Czech. Return ONLY the translation, nothing else.\n\n${text}
    ...    system_message=You are a professional translator specializing in Czech. Return only the translated text with no commentary.
    RETURN    ${result}

Text To Regex
    [Documentation]    Convert a plain-English pattern description into a regular expression.
    [Arguments]    ${description}
    ${result}=    Ask AI
    ...    Convert this description into a regular expression pattern:\n\n${description}\n\nReturn ONLY the regex pattern, no explanation.
    ...    system_message=You are a regex expert. Return only the raw regex pattern — no delimiters, no flags, no explanation.
    RETURN    ${result}

Summarize For Manager
    [Documentation]    Turn a technical text into a brief non-technical summary.
    [Arguments]    ${technical_text}
    ${result}=    Ask AI
    ...    Summarize the following technical text for a non-technical manager. Keep it to 2-3 sentences. Focus on business impact.\n\n${technical_text}
    ...    system_message=You are a senior engineering manager who excels at translating technical details into clear business language. Be concise.
    RETURN    ${result}


*** Test Cases ***
Translate Text To Czech
    [Documentation]    Verify AI can translate English text to Czech.
    ${translated}=    Translate To Czech    Hello, how are you today?
    Log    Translation: ${translated}
    Should Not Be Empty    ${translated}
    # Czech translations typically contain diacritics
    Should Not Contain    ${translated}    Hello

Convert Pattern Description To Regex
    [Documentation]    Verify AI produces a valid regex from plain English.
    ${regex}=    Text To Regex    An email address — starts with letters/numbers/dots, then @, then a domain with a dot
    Log    Regex: ${regex}
    Should Not Be Empty    ${regex}
    Should Contain    ${regex}    @

Summarize Technical Report For Manager
    [Documentation]    Verify AI produces a concise non-technical summary.
    ${technical}=    Catenate
    ...    The CI/CD pipeline failed at the integration test stage due to a race condition
    ...    in the database connection pool. The connection limit of 20 was exhausted when
    ...    parallel test threads exceeded the pool size. We patched the pool configuration
    ...    to scale dynamically up to 50 connections and added retry logic with exponential
    ...    backoff. The fix reduced flaky test failures by 94%.
    ${summary}=    Summarize For Manager    ${technical}
    Log    Summary: ${summary}
    Should Not Be Empty    ${summary}
    # Summary should be shorter than the original
    ${summary_len}=    Get Length    ${summary}
    ${original_len}=    Get Length    ${technical}
    Should Be True    ${summary_len} < ${original_len}
