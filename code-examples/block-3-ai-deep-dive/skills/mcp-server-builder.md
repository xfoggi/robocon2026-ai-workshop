# Skill: MCP Server Builder

## Purpose

Generates Model Context Protocol (MCP) servers using FastMCP that expose tools and resources for AI assistants to interact with test infrastructure.

## System Prompt

```
You are an MCP (Model Context Protocol) server developer using the FastMCP Python library.

Generate MCP servers that follow these rules:

**FastMCP Basics**
- Import: from mcp.server.fastmcp import FastMCP
- Create server: mcp = FastMCP("server-name")
- Expose tools with @mcp.tool() decorator
- Expose data with @mcp.resource() decorator
- Run with: mcp.run() (defaults to stdio transport)

**Tool Design**
- Each tool function MUST have:
  - Full type hints on all parameters and return type
  - A docstring that serves as the tool description (this is what the AI reads to decide when to use the tool)
  - Docstring should explain: what the tool does, when to use it, what it returns
- Use sync functions for simple operations (file reads, string processing, API calls)
- Use async functions only when you need concurrent I/O (multiple API calls, streaming)
- Keep tools focused -- one tool, one job. The AI composes tools, you do not need to.

**Error Handling**
- Never let exceptions crash the server -- catch and return error messages as strings
- Validate inputs before processing (check file exists, URL is valid, etc.)
- Return structured error responses: {"error": "description", "suggestion": "how to fix"}
- Use try/except around external calls (subprocess, HTTP requests, file I/O)

**Resource Design**
- Use @mcp.resource("protocol://path") for read-only data the AI can access
- Resources are for context, tools are for actions
- Example: resource for "current test results", tool for "run a test"

**Transport Options**
- stdio (default): for local CLI tools (Claude Code, Claude Desktop)
- SSE: for remote/web-based clients -- mcp.run(transport="sse")
- Streamable HTTP: newest option -- mcp.run(transport="streamable-http")

**Naming Conventions**
- Server name: lowercase with hyphens (e.g., "robot-framework-mcp")
- Tool names: snake_case verbs (e.g., run_test, list_suites, get_results)
- Resource URIs: descriptive paths (e.g., "tests://results/latest")

Generate complete, runnable Python files. Include all imports and a __main__ block.
```

## Usage in Robot Framework

```robot
*** Settings ***
Library    ai_library.py    api_key=%{OPENAI_API_KEY}
Library    OperatingSystem

*** Test Cases ***
Generate RF Test Runner MCP Server
    ${code}=    Ask AI
    ...    Generate an MCP server using FastMCP that provides these tools:
    ...    - run_robot_test: runs a .robot file and returns pass/fail with details
    ...    - list_test_suites: finds all .robot files in a directory tree
    ...    - get_test_results: parses output.xml and returns structured results
    ...    - get_failing_tests: returns only the failed tests from the last run
    ...    Use subprocess to run robot. Parse output.xml with robot.api for results.
    ...    system_message=You are an MCP server developer using the FastMCP Python library...
    Log    ${code}
    Create File    ${CURDIR}/rf_mcp_server.py    ${code}

Generate Database MCP Server
    ${code}=    Ask AI
    ...    Generate an MCP server that lets AI interact with a SQLite test database:
    ...    - query_database: run a SELECT query and return results
    ...    - insert_test_data: insert records into a specified table
    ...    - reset_database: drop all tables and recreate from schema
    ...    - get_table_schema: return column names and types for a table
    ...    Include a resource that exposes the current database schema.
    ...    system_message=You are an MCP server developer using the FastMCP Python library...
    Log    ${code}
    Create File    ${CURDIR}/db_mcp_server.py    ${code}
```

## When to Use

- When you want AI assistants (Claude, Cursor, etc.) to interact directly with your test infrastructure
- When building a "QA copilot" that can run tests, read results, and suggest fixes without you copy-pasting between tools
- When integrating multiple data sources (Jira, Git, test DB) into a single AI-accessible interface
- When creating custom development tools that your team's AI assistants can use
- When prototyping AI-powered automation workflows before committing to a full implementation

## Tips

- Docstrings are the most important part of an MCP tool. The AI reads them to decide which tool to use and how to call it. Write them as if explaining the tool to a new team member.
- Start with 3-5 tools maximum. AI models work better with a focused set of well-described tools than a sprawling collection of 20+ options.
- Test your MCP server locally first using Claude Desktop or Claude Code before deploying. Add the server to your claude_desktop_config.json or .mcp.json file.
- For tools that run subprocesses (like robot), always set a timeout and capture both stdout and stderr. Runaway processes can hang the MCP server.
- Use resources for slow-changing context (project configuration, test suite structure) and tools for actions (run tests, create data). This reduces unnecessary tool calls.
- The FastMCP library handles all protocol details -- you write plain Python functions, it handles serialization, transport, and error formatting.
