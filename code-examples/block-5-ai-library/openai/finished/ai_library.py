"""
Robot Framework AI Library — OpenAI Integration
RoboCon 2026 Workshop: Integrating AI & Robot Framework
Author: David Fogl, Continero

This library wraps the OpenAI API for use in Robot Framework tests.
It provides keywords for asking AI questions, generating test data,
reviewing tests, generating test cases from requirements,
generating reusable keywords, and explaining test failures.
"""

from openai import OpenAI


class ai_library:
    """Robot Framework library for AI-powered testing.

    This library connects Robot Framework to OpenAI's API, enabling
    AI-assisted test automation workflows. Each public method becomes
    a Robot Framework keyword automatically.

    Examples:
        | Library | ai_library.py | api_key=${API_KEY} |
        | Library | ai_library.py | api_key=${API_KEY} | model=gpt-4o |
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, api_key=None, model="gpt-4o"):
        """Initialize the AI Library with an OpenAI API key.

        Args:
            api_key: Your OpenAI API key. Can also be set via OPENAI_API_KEY env var.
            model: The model to use (default: gpt-4o).
        """
        self.client = OpenAI(api_key=api_key)
        self.model = model

    def ask_ai(self, prompt, system_message="You are a helpful QA assistant."):
        """Send a prompt to AI and return the response.

        This is the foundational keyword — all other keywords use it
        internally. You can also call it directly for custom prompts.

        Args:
            prompt: The question or instruction to send.
            system_message: Context for the AI's role (optional).

        Returns:
            The AI's response as a string.

        Examples:
            | ${answer}= | Ask AI | What is Robot Framework? |
            | ${answer}= | Ask AI | Explain keyword-driven testing | system_message=You are a testing instructor. |
        """
        response = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": system_message},
                {"role": "user", "content": prompt}
            ]
        )
        return response.choices[0].message.content

    def generate_test_data(self, description, format="json", count=5):
        """Generate test data based on a description.

        Uses AI to create realistic but fictional test data. Includes
        edge cases like special characters, long strings, and boundary
        values to improve test coverage.

        Args:
            description: What kind of data to generate (e.g., "user registration form").
            format: Output format — json, csv, or table (default: json).
            count: Number of records to generate (default: 5).

        Returns:
            Generated test data as a string in the requested format.

        Examples:
            | ${data}= | Generate Test Data | user registration with name, email, phone | json | 5 |
            | ${data}= | Generate Test Data | European addresses with special characters | csv | 10 |
        """
        prompt = (
            f"Generate {count} test data records for: {description}. "
            f"Return as {format}. Include realistic but fictional data. "
            f"Include edge cases like special characters, long strings, and boundary values."
        )
        return self.ask_ai(
            prompt,
            "You are a test data generator. Return only the data in the requested format. "
            "No explanations, no markdown formatting, just the raw data."
        )

    def review_test(self, test_code):
        """Have AI review a Robot Framework test for improvements.

        Analyzes the provided test code and returns actionable feedback
        covering issues, improvements, missing coverage, and refactoring
        suggestions.

        Args:
            test_code: The Robot Framework test code to review.

        Returns:
            Review comments and suggestions.

        Examples:
            | ${review}= | Review Test | *** Test Cases ***\\nLogin Test\\n    Open Browser    http://example.com    chrome |
        """
        prompt = (
            f"Review this Robot Framework test and provide:\n"
            f"1. Issues found (bugs, bad practices)\n"
            f"2. Improvements suggested\n"
            f"3. Missing test coverage\n"
            f"4. Refactoring suggestions\n\n"
            f"Test code:\n{test_code}"
        )
        return self.ask_ai(
            prompt,
            "You are a senior Robot Framework test engineer. "
            "Be specific, actionable, and constructive in your review."
        )

    def generate_test_cases(self, requirements, framework="robot"):
        """Generate test cases from requirements.

        Takes a feature description or user story and produces complete,
        ready-to-run Robot Framework test cases with documentation,
        setup/teardown, and variables.

        Args:
            requirements: Feature description or user story.
            framework: Output format — robot or gherkin (default: robot).

        Returns:
            Complete test cases ready to run.

        Examples:
            | ${tests}= | Generate Test Cases | Login page with email and password, remember me checkbox |
            | ${tests}= | Generate Test Cases | REST API with CRUD operations for users | framework=gherkin |
        """
        prompt = (
            f"Based on these requirements, generate complete Robot Framework test cases.\n\n"
            f"Requirements:\n{requirements}\n\n"
            f"Generate:\n"
            f"1. At least 5 test cases covering happy path and edge cases\n"
            f"2. Use descriptive test case names\n"
            f"3. Include Setup and Teardown if needed\n"
            f"4. Add [Documentation] to each test case\n"
            f"5. Use variables for configurable values\n\n"
            f"Return only the Robot Framework code, ready to run."
        )
        return self.ask_ai(
            prompt,
            "You are a senior Robot Framework test engineer. "
            "Write clean, maintainable, well-documented tests."
        )

    def generate_keywords(self, description):
        """Generate reusable Robot Framework keywords from a description.

        Creates well-structured keyword definitions that follow RF
        best practices: single responsibility, proper arguments,
        return values, and documentation.

        Args:
            description: What the keywords should do.

        Returns:
            Robot Framework keyword definitions.

        Examples:
            | ${keywords}= | Generate Keywords | API testing utilities for REST endpoints |
            | ${keywords}= | Generate Keywords | Database verification keywords for user table |
        """
        prompt = (
            f"Create reusable Robot Framework keywords for: {description}\n\n"
            f"Requirements:\n"
            f"- Each keyword should do one thing well\n"
            f"- Include [Arguments] and [Return] where appropriate\n"
            f"- Add [Documentation] to each keyword\n"
            f"- Follow Robot Framework naming conventions (spaces, not underscores)\n\n"
            f"Return only Robot Framework code."
        )
        return self.ask_ai(
            prompt,
            "You are a Robot Framework expert. Write clean, reusable keywords."
        )

    def explain_error(self, error_message, context=""):
        """Have AI explain a test error and suggest fixes.

        Analyzes a test failure error message and provides a clear
        explanation of what went wrong, the likely cause, how to fix
        it, and how to prevent it in the future.

        Args:
            error_message: The error message from a failed test.
            context: Additional context about what the test was doing (optional).

        Returns:
            Explanation and suggested fixes.

        Examples:
            | ${explanation}= | Explain Error | ElementNotFound: id=login-btn |
            | ${explanation}= | Explain Error | TimeoutException: Loading took too long | context=Testing a page with heavy JavaScript |
        """
        prompt = (
            f"A Robot Framework test failed with this error:\n{error_message}\n"
        )
        if context:
            prompt += f"\nContext: {context}\n"
        prompt += (
            "\nExplain:\n"
            "1. What went wrong\n"
            "2. Most likely cause\n"
            "3. How to fix it\n"
            "4. How to prevent it in the future"
        )
        return self.ask_ai(
            prompt,
            "You are a Robot Framework debugging expert. Be clear and specific."
        )
