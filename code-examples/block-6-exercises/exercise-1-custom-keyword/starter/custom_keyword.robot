*** Settings ***
Documentation    Exercise 1: Build Your Own AI-Powered Keyword
...              RoboCon 2026 Workshop — Integrating AI & Robot Framework
...
...              GOAL: Create a custom keyword that uses Ask AI internally.
...              Your keyword should accept arguments, call Ask AI with a tailored
...              system_message, and RETURN the result.
Library          ai_library.py    api_key=%{OPENAI_API_KEY}


*** Keywords ***
# ──────────────────────────────────────────────────────────────
# YOUR KEYWORD GOES HERE
# ──────────────────────────────────────────────────────────────
#
# Template:
#
# My Custom Keyword
#     [Arguments]    ${input_text}
#     ${result}=    Ask AI    Your prompt using ${input_text}
#     ...    system_message=You are a specialist in ...
#     RETURN    ${result}
#
# ──────────────────────────────────────────────────────────────
# IDEAS — pick one (or invent your own!):
#
#   1. Translate Text — translate any text to a target language
#      [Arguments]    ${text}    ${target_language}
#
#   2. Summarize For Manager — turn technical text into a short
#      non-technical summary suitable for a status report
#      [Arguments]    ${technical_text}
#
#   3. Text To Regex — describe a pattern in plain English,
#      get back a regular expression
#      [Arguments]    ${description}
#
#   4. Plain English To SQL — describe a query in words,
#      get back a SQL SELECT statement
#      [Arguments]    ${description}    ${table_name}
#
# ──────────────────────────────────────────────────────────────


*** Test Cases ***
Test My Custom Keyword
    [Documentation]    Replace the Skip below with a call to your keyword.
    Skip    Implement your keyword above first!
