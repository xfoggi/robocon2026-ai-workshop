"""
Robot Framework AI Library -- Google Gemini Integration (STARTER TEMPLATE)
RoboCon 2026 Workshop: Integrating AI & Robot Framework
Author: David Fogl, Continero

EXERCISE: Complete the TODO sections to build a working Gemini AI library.

IMPORTANT: This uses the NEW google-genai SDK (not the deprecated google-generativeai).
Install with: pip install google-genai
"""

from google import genai
from google.genai import types


class gemini_library:
    """Robot Framework library using Google Gemini.

    Provides keywords for AI-powered test automation using Gemini models.

    Examples:
        | Library | gemini_library.py | api_key=${GEMINI_KEY} |
        | Library | gemini_library.py | api_key=${GEMINI_KEY} | model=gemini-2.5-pro |
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, api_key=None, model="gemini-2.5-flash"):
        """Initialize the Gemini Library.

        Args:
            api_key: Your Google AI API key.
            model: The Gemini model to use (default: gemini-2.5-flash).
        """
        # TODO: Validate that api_key is provided (raise ValueError if not)
        # TODO: Create the Gemini client using genai.Client(api_key=...)
        # TODO: Store the model name for later use
        pass

    def ask_ai(self, prompt, system_message="You are a helpful QA assistant."):
        """Send a prompt to Gemini and return the response.

        Uses ``client.models.generate_content`` with ``GenerateContentConfig``
        to pass the system instruction separately from the user prompt.

        Args:
            prompt: The question or instruction to send.
            system_message: Context for the AI's role (optional).

        Returns:
            The AI's response as a string.

        Examples:
            | ${answer}= | Ask AI | What is Robot Framework? |
            | ${answer}= | Ask AI | Explain keyword-driven testing | system_message=You are a testing instructor. |
        """
        # TODO: Call self.client.models.generate_content() with:
        #   - model=self.model
        #   - contents=prompt
        #   - config=types.GenerateContentConfig(
        #         system_instruction=system_message,
        #         max_output_tokens=4096,
        #         temperature=0.7,
        #     )
        # TODO: Return response.text
        pass

    def generate_test_data(self, description, format="json", count=5):
        """Generate test data based on a description.

        Args:
            description: What kind of data to generate (e.g., "user registration form").
            format: Output format -- json, csv, or table (default: json).
            count: Number of records to generate (default: 5).

        Returns:
            Generated test data as a string.

        Examples:
            | ${data}= | Generate Test Data | user registration with name, email, phone | json | 5 |
        """
        # TODO: Build a prompt asking AI to generate {count} test data records
        #       for {description} in {format} format
        # TODO: Call self.ask_ai() with a system message for a test data generator
        pass

    def review_test(self, test_code):
        """Have AI review a Robot Framework test for improvements.

        Args:
            test_code: The Robot Framework test code to review.

        Returns:
            Review comments and suggestions.

        Examples:
            | ${review}= | Review Test | *** Test Cases ***\\nLogin Test\\n    ... |
        """
        # TODO: Build a prompt asking AI to review the test code
        #       Include: issues found, improvements, missing coverage, refactoring
        # TODO: Call self.ask_ai() with a senior RF engineer system message
        pass

    def generate_test_cases(self, requirements, framework="robot"):
        """Generate test cases from requirements.

        Args:
            requirements: Feature description or user story.
            framework: Output format -- robot or gherkin (default: robot).

        Returns:
            Complete test cases ready to run.

        Examples:
            | ${tests}= | Generate Test Cases | Login page with email and password |
        """
        # TODO: Build a prompt asking AI to generate RF test cases from requirements
        #       Include: at least 5 cases, descriptive names, Setup/Teardown,
        #       Documentation, variables
        # TODO: Call self.ask_ai() with a senior RF engineer system message
        pass

    def generate_keywords(self, description):
        """Generate reusable Robot Framework keywords from a description.

        Args:
            description: What the keywords should do.

        Returns:
            Robot Framework keyword definitions.

        Examples:
            | ${keywords}= | Generate Keywords | API testing utilities for REST endpoints |
        """
        # TODO: Build a prompt asking AI to create reusable RF keywords
        #       Include: single responsibility, Arguments, Return, Documentation,
        #       naming conventions
        # TODO: Call self.ask_ai() with an RF expert system message
        pass

    def explain_error(self, error_message, context=""):
        """Have AI explain a test error and suggest fixes.

        Args:
            error_message: The error message from a failed test.
            context: Additional context about what the test was doing (optional).

        Returns:
            Explanation and suggested fixes.

        Examples:
            | ${explanation}= | Explain Error | ElementNotFound: id=login-btn |
        """
        # TODO: Build a prompt with the error message
        # TODO: If context is provided, append it to the prompt
        # TODO: Ask AI to explain: what went wrong, likely cause, how to fix,
        #       how to prevent
        # TODO: Call self.ask_ai() with a debugging expert system message
        pass
