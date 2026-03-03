"""
Robot Framework MCP Server
===========================
A Model Context Protocol server that exposes Robot Framework operations
as tools for AI assistants. Uses the FastMCP pattern for simplicity.

Tools provided:
  - run_robot_test: Execute a .robot test file
  - list_test_suites: Find all .robot files in a directory
  - get_test_results: Parse output.xml for test results summary
  - get_test_log: Extract keyword-level details for a specific test

Usage:
    python rf_mcp_server.py

Configure in your MCP client (e.g. Claude Desktop) as:
    {
        "mcpServers": {
            "robot-framework": {
                "command": "python",
                "args": ["rf_mcp_server.py"]
            }
        }
    }
"""

import glob
import json
import os
import subprocess

from mcp.server.fastmcp import FastMCP

mcp = FastMCP(name="robot-framework")


@mcp.tool()
def run_robot_test(test_file: str, variables: dict | None = None) -> str:
    """Run a Robot Framework test file and return the execution results.

    Executes the given .robot file using the `robot` command. Optional
    variables are passed as --variable flags. Returns a JSON object with
    the return code, stdout, and stderr from the execution.

    Args:
        test_file: Path to the .robot file to execute.
        variables: Optional dict of variable name-value pairs
                   (e.g. {"BROWSER": "chrome", "URL": "https://example.com"}).

    Returns:
        JSON string with keys: return_code, stdout, stderr.
    """
    try:
        if not os.path.isfile(test_file):
            return json.dumps({
                "error": f"Test file not found: {test_file}"
            })

        cmd = ["robot"]

        if variables:
            for name, value in variables.items():
                cmd.extend(["--variable", f"{name}:{value}"])

        cmd.append(test_file)

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=300,
        )

        return json.dumps({
            "return_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        })

    except subprocess.TimeoutExpired:
        return json.dumps({
            "error": "Test execution timed out after 300 seconds"
        })
    except FileNotFoundError:
        return json.dumps({
            "error": "The 'robot' command was not found. "
                     "Is Robot Framework installed? (pip install robotframework)"
        })
    except Exception as e:
        return json.dumps({"error": str(e)})


@mcp.tool()
def list_test_suites(directory: str = ".") -> str:
    """List all Robot Framework test suite files in a directory.

    Recursively searches the given directory for files matching *.robot
    and returns their paths.

    Args:
        directory: Root directory to search (default: current directory).

    Returns:
        JSON array of file paths to .robot files.
    """
    try:
        if not os.path.isdir(directory):
            return json.dumps({
                "error": f"Directory not found: {directory}"
            })

        pattern = os.path.join(directory, "**", "*.robot")
        files = sorted(glob.glob(pattern, recursive=True))

        return json.dumps(files)

    except Exception as e:
        return json.dumps({"error": str(e)})


@mcp.tool()
def get_test_results(output_xml: str = "output.xml") -> str:
    """Parse Robot Framework output.xml and return a results summary.

    Reads the output.xml file produced by a test run and extracts
    high-level statistics: suite name, total/pass/fail counts, and
    details of any failed tests.

    Args:
        output_xml: Path to the output.xml file (default: output.xml).

    Returns:
        JSON object with suite_name, total, passed, failed, and
        a list of failed_tests (each with name and message).
    """
    try:
        if not os.path.isfile(output_xml):
            return json.dumps({
                "error": f"Output file not found: {output_xml}"
            })

        from robot.api import ExecutionResult

        result = ExecutionResult(output_xml)
        suite = result.suite
        stats = result.statistics.total

        failed_tests = []
        for test in suite.tests:
            if test.status == "FAIL":
                failed_tests.append({
                    "name": test.name,
                    "message": test.message,
                })

        # Also check nested suites for failed tests
        def collect_failed(suite_obj):
            for test in suite_obj.tests:
                if test.status == "FAIL":
                    failed_tests.append({
                        "name": test.name,
                        "message": test.message,
                    })
            for child_suite in suite_obj.suites:
                collect_failed(child_suite)

        # Reset and do a full recursive collection
        failed_tests = []
        collect_failed(suite)

        return json.dumps({
            "suite_name": suite.name,
            "total": stats.total,
            "passed": stats.passed,
            "failed": stats.failed,
            "failed_tests": failed_tests,
        })

    except Exception as e:
        return json.dumps({"error": str(e)})


@mcp.tool()
def get_test_log(test_name: str, output_xml: str = "output.xml") -> str:
    """Extract keyword-level execution details for a specific test.

    Parses output.xml and finds the test matching the given name,
    then returns a breakdown of each keyword that was executed,
    including its status and any messages. Useful for debugging
    specific test failures.

    Args:
        test_name: Name of the test case to look up.
        output_xml: Path to the output.xml file (default: output.xml).

    Returns:
        JSON object with test name, status, and a list of keywords
        (each with name, status, and messages).
    """
    try:
        if not os.path.isfile(output_xml):
            return json.dumps({
                "error": f"Output file not found: {output_xml}"
            })

        from robot.api import ExecutionResult

        result = ExecutionResult(output_xml)

        def find_test(suite_obj, name):
            for test in suite_obj.tests:
                if test.name == name:
                    return test
            for child_suite in suite_obj.suites:
                found = find_test(child_suite, name)
                if found:
                    return found
            return None

        test = find_test(result.suite, test_name)

        if test is None:
            return json.dumps({
                "error": f"Test not found: {test_name}"
            })

        def extract_keywords(keyword_obj):
            """Recursively extract keyword information."""
            kw_info = {
                "name": keyword_obj.kwname if hasattr(keyword_obj, 'kwname') else keyword_obj.name,
                "status": keyword_obj.status,
                "messages": [
                    msg.message for msg in keyword_obj.messages
                ] if hasattr(keyword_obj, 'messages') else [],
            }

            # Include child keywords if any
            children = []
            if hasattr(keyword_obj, 'keywords'):
                for child_kw in keyword_obj.keywords:
                    children.append(extract_keywords(child_kw))
            elif hasattr(keyword_obj, 'body'):
                for item in keyword_obj.body:
                    if hasattr(item, 'kwname') or hasattr(item, 'name'):
                        children.append(extract_keywords(item))

            if children:
                kw_info["keywords"] = children

            return kw_info

        keywords = []
        body = test.body if hasattr(test, 'body') else test.keywords
        for kw in body:
            if hasattr(kw, 'kwname') or hasattr(kw, 'name'):
                keywords.append(extract_keywords(kw))

        return json.dumps({
            "test_name": test.name,
            "status": test.status,
            "message": test.message,
            "keywords": keywords,
        })

    except Exception as e:
        return json.dumps({"error": str(e)})


if __name__ == "__main__":
    mcp.run(transport="stdio")
