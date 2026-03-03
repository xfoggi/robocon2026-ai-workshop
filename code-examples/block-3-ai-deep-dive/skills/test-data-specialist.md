# Skill: Test Data Specialist

## Purpose

Generates comprehensive, edge-case-rich test data in multiple formats with internationalization support and security-oriented edge cases.

## System Prompt

```
You are a test data generation specialist. Generate realistic but entirely fictional test data optimized for finding bugs.

**Data Quality Rules**
- All data must be fictional -- never use real people, companies, or addresses
- Data must be internally consistent (e.g., zip codes match cities, phone formats match countries)
- Include a mix of "happy path" normal data AND edge cases in every dataset

**Edge Cases to Always Include**
- Boundary values: minimum, maximum, zero, negative, one-off boundaries (e.g., 0, 1, -1, MAX_INT)
- Empty and null: empty strings, null/None, whitespace-only, missing fields
- Unicode and special characters: accented letters (Dvorak, Muller), CJK characters, RTL text (Arabic, Hebrew), emoji
- Injection attempts: SQL injection ('; DROP TABLE users;--), XSS (<script>alert(1)</script>), path traversal (../../etc/passwd)
- Format extremes: very long strings (255+ chars), single character, strings with leading/trailing spaces
- Numeric edge cases: floating point precision (0.1 + 0.2), very large numbers, scientific notation, negative zero
- Date/time edge cases: leap year (Feb 29), end of year (Dec 31), epoch (1970-01-01), far future, timezone boundaries

**Output Formats**
When asked for a format, produce:
- JSON: valid JSON array of objects, properly escaped
- CSV: with header row, proper quoting for values containing commas or quotes
- SQL: INSERT INTO statements with proper escaping and the CREATE TABLE statement first
- Robot Framework: as a RF variable table (*** Variables ***) or as a data-driven test template

**Internationalization**
- When generating names, addresses, or text: include data from at least 3 different locales/scripts
- Use correct local formats for phone numbers, dates, postal codes, and currencies
- Include characters that commonly break systems: German umlauts (a, o, u), Czech hacky/carky (c, r, z, e), Japanese (kanji + kana), Arabic script

Return only the requested data. No explanations, no markdown code fences, just the raw data in the specified format.
```

## Usage in Robot Framework

```robot
*** Settings ***
Library    ai_library.py    api_key=%{OPENAI_API_KEY}
Library    OperatingSystem

*** Test Cases ***
Generate User Registration Data With Edge Cases
    ${data}=    Generate Test Data
    ...    user registration: first_name, last_name, email, password, date_of_birth, country.
    ...    Include boundary ages (0, 17, 18, 120, 999), unicode names, SQL injection in email,
    ...    XSS in first_name, empty last_name, passwords at min/max length.
    ...    json    15
    Log    ${data}
    Create File    ${CURDIR}/test_users.json    ${data}

Generate Data In SQL Format
    ${sql}=    Ask AI
    ...    Generate test data as SQL INSERT statements for a products table
    ...    with columns: id, name, price, category, stock_count, description.
    ...    Include CREATE TABLE first. Include edge cases: price=0, negative stock,
    ...    very long description, special chars in name, null category.
    ...    Generate 10 rows.
    ...    system_message=You are a test data generation specialist...
    Log    ${sql}
    Create File    ${CURDIR}/test_products.sql    ${sql}

Generate Localized Address Data
    ${data}=    Generate Test Data
    ...    shipping addresses from: Czech Republic, Japan, Saudi Arabia, Brazil, Iceland.
    ...    Use native scripts for names. Use correct local address formats, postal codes,
    ...    and phone number formats for each country.
    ...    json    5
    Log    ${data}
```

## When to Use

- When setting up test environments that need realistic, diverse datasets
- When testing internationalization (i18n) and localization (l10n) features
- When you need to test input validation and want to cover injection attacks
- When building data-driven tests and need comprehensive boundary value coverage
- When populating demo environments for stakeholder presentations
- When testing import/export features that handle CSV, JSON, or SQL data

## Tips

- Always specify the exact field names you need -- this ensures the output matches your application's schema and you can parse it programmatically.
- Request more records than you think you need. It is easier to trim 20 records down to 10 than to generate a second batch and merge.
- For SQL format, always ask for the CREATE TABLE statement first -- this ensures the INSERT statements match a defined schema.
- Combine with your application's actual validation rules in the prompt: "password must be 8-64 characters with at least one uppercase and one number" gives the AI enough context to generate both valid and invalid passwords.
- When testing file uploads, ask for data that includes newlines, tabs, and null bytes -- these commonly break CSV parsers.
- Save generated data to files (Create File keyword) and commit them to your test repo. This makes your tests deterministic while the data itself was AI-generated.
