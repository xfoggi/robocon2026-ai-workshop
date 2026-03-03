"""
Log Analyzer — Robot Framework Library
RoboCon 2026 Workshop: Integrating AI & Robot Framework
Author: David Fogl, Continero

Reference implementation for Exercise 4 (Option 1: Log Analyzer).
This library uses the OpenAI API to classify test failures, analyze
test results, generate failure reports, and suggest fixes.
"""

from openai import OpenAI


class log_analyzer:
    """Robot Framework library for AI-powered test failure analysis.

    Connects to OpenAI to classify, analyze, and report on test failures.
    Each public method becomes a Robot Framework keyword.

    Examples:
        | Library | log_analyzer.py | api_key=${API_KEY} |
        | Library | log_analyzer.py | api_key=${API_KEY} | model=gpt-4o |
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    VALID_CATEGORIES = ['environment', 'data', 'code_bug', 'flaky']

    def __init__(self, api_key=None, model="gpt-4o"):
        """Initialize the Log Analyzer with an OpenAI API key.

        Args:
            api_key: Your OpenAI API key. Can also use OPENAI_API_KEY env var.
            model: The model to use (default: gpt-4o).
        """
        self.client = OpenAI(api_key=api_key)
        self.model = model

    def _ask(self, prompt, system_message):
        """Internal helper to call OpenAI chat completions.

        Args:
            prompt: The user message.
            system_message: The system role instruction.

        Returns:
            The AI response as a string.
        """
        response = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": system_message},
                {"role": "user", "content": prompt},
            ],
        )
        return response.choices[0].message.content

    def classify_failure(self, error_message):
        """Classify a test failure into one of four categories.

        Analyzes the error message and returns exactly one of:
        - environment: infrastructure, network, timeout, service-down issues
        - data: bad test data, missing fixtures, data mismatch
        - code_bug: assertion failures, logic errors, wrong expected values
        - flaky: intermittent failures, race conditions, timing issues

        Args:
            error_message: The error message from a failed test.

        Returns:
            One of: environment, data, code_bug, flaky

        Examples:
            | ${category}= | Classify Failure | ConnectionRefusedError: localhost:5432 |
            | Should Be Equal | ${category} | environment |
        """
        prompt = (
            f"Classify this test failure error message into exactly ONE category.\n\n"
            f"Categories:\n"
            f"- environment: infrastructure, network, timeout, service unavailable\n"
            f"- data: bad test data, missing fixtures, unexpected data format\n"
            f"- code_bug: assertion failure, logic error, wrong expected value\n"
            f"- flaky: intermittent, race condition, timing, works-on-retry\n\n"
            f"Error message:\n{error_message}\n\n"
            f"Respond with ONLY the category name (one word), nothing else."
        )
        result = self._ask(
            prompt,
            "You are a test failure classifier. Respond with exactly one word: "
            "environment, data, code_bug, or flaky. Nothing else.",
        )
        # Normalize the response — strip whitespace, lowercase
        category = result.strip().lower().replace('"', '').replace("'", '')
        # Validate against known categories; default to code_bug if unrecognized
        if category not in self.VALID_CATEGORIES:
            category = 'code_bug'
        return category

    def analyze_test_results(self, results_summary):
        """Analyze a multi-line test results summary and classify each failure.

        Takes a text block containing multiple test failure messages
        (one per line or separated by blank lines) and returns a structured
        analysis with each failure classified.

        Args:
            results_summary: Multi-line string of test failures.

        Returns:
            Structured analysis with each failure classified.

        Examples:
            | ${analysis}= | Analyze Test Results | FAIL: Login Test - ConnectionTimeout\\nFAIL: Cart Test - AssertionError |
        """
        prompt = (
            f"Analyze these test results. For each failure, provide:\n"
            f"- Test name (if identifiable)\n"
            f"- Error type\n"
            f"- Category (environment / data / code_bug / flaky)\n"
            f"- Brief explanation\n\n"
            f"Test results:\n{results_summary}\n\n"
            f"Format as a numbered list."
        )
        return self._ask(
            prompt,
            "You are a test results analyst. Classify each failure precisely. "
            "Use only these categories: environment, data, code_bug, flaky.",
        )

    def generate_failure_report(self, results_summary):
        """Generate a human-readable Markdown report from test results.

        Creates a well-structured report with:
        - Summary statistics (total failures, by category)
        - Detailed breakdown of each failure
        - Recommended actions

        Args:
            results_summary: Multi-line string of test failures.

        Returns:
            A complete Markdown-formatted failure report.

        Examples:
            | ${report}= | Generate Failure Report | FAIL: Login - Timeout\\nFAIL: Search - AssertionError |
            | Should Contain | ${report} | # |
        """
        prompt = (
            f"Generate a Markdown failure report from these test results.\n\n"
            f"Include these sections:\n"
            f"1. **Summary** — total failures, count by category\n"
            f"2. **Failure Details** — table with: Test Name | Category | Error | Severity\n"
            f"3. **Recommended Actions** — prioritized list of what to fix first\n\n"
            f"Test results:\n{results_summary}\n\n"
            f"Use proper Markdown formatting with headers, tables, and bullet points."
        )
        return self._ask(
            prompt,
            "You are a QA reporting specialist. Create clear, actionable Markdown reports. "
            "Classify failures as: environment, data, code_bug, or flaky.",
        )

    def suggest_fixes(self, error_message, test_name=""):
        """Suggest fixes for a specific test failure.

        Provides actionable fix suggestions including:
        - Root cause analysis
        - Specific code changes
        - Prevention strategies

        Args:
            error_message: The error message from the failed test.
            test_name: Name of the failed test for context (optional).

        Returns:
            Actionable fix suggestions as a string.

        Examples:
            | ${fixes}= | Suggest Fixes | ElementNotFound: id=submit-btn | Login Form Test |
        """
        context = f" in test '{test_name}'" if test_name else ""
        prompt = (
            f"A Robot Framework test{context} failed with this error:\n"
            f"{error_message}\n\n"
            f"Provide:\n"
            f"1. **Root Cause**: What most likely caused this\n"
            f"2. **Quick Fix**: Immediate change to make the test pass\n"
            f"3. **Proper Fix**: The right way to solve the underlying issue\n"
            f"4. **Prevention**: How to prevent this in the future\n\n"
            f"Be specific and actionable. Include code snippets where helpful."
        )
        return self._ask(
            prompt,
            "You are a senior Robot Framework test engineer and debugging expert. "
            "Give specific, actionable advice with code examples when relevant.",
        )
