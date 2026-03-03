#!/usr/bin/env python3
"""
RoboCon 2026 Workshop — Environment Verification Script

Run this script to check that your workshop environment is correctly set up.

Usage:
    python verify_setup.py              # Basic checks (imports, CLI, env vars)
    python verify_setup.py --test-keys  # Also ping OpenAI and Gemini APIs
"""

import argparse
import os
import shutil
import subprocess
import sys

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

PASS = "\033[92m\u2713\033[0m"   # green checkmark
FAIL = "\033[91m\u2717\033[0m"   # red X
WARN = "\033[93m!\033[0m"        # yellow warning

passed = 0
failed = 0
warned = 0


def ok(msg: str) -> None:
    global passed
    passed += 1
    print(f"  {PASS} {msg}")


def fail(msg: str, hint: str | None = None) -> None:
    global failed
    failed += 1
    print(f"  {FAIL} {msg}")
    if hint:
        print(f"      Hint: {hint}")


def warn(msg: str, hint: str | None = None) -> None:
    global warned
    warned += 1
    print(f"  {WARN} {msg}")
    if hint:
        print(f"      Hint: {hint}")


def mask_key(key: str) -> str:
    """Show only the first 8 characters of an API key."""
    if len(key) <= 8:
        return key[:2] + "***"
    return key[:8] + "***"


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_python_version() -> None:
    """Require Python 3.10+."""
    print("\n1) Python version")
    v = sys.version_info
    version_str = f"{v.major}.{v.minor}.{v.micro}"
    if (v.major, v.minor) >= (3, 10):
        ok(f"Python {version_str}")
    else:
        fail(
            f"Python {version_str} — need 3.10 or newer",
            hint="Install Python 3.10+ from https://www.python.org/downloads/",
        )


def check_imports() -> None:
    """Try importing every required package."""
    print("\n2) Required Python packages")
    packages = {
        "robot": "robotframework",
        "openai": "openai",
        "google.genai": "google-genai",
        "mcp": "mcp",
        "requests": "robotframework-requests  (or: requests)",
    }
    for module, pip_name in packages.items():
        try:
            __import__(module)
            ok(f"import {module}")
        except ImportError:
            fail(
                f"import {module} — not installed",
                hint=f"pip install {pip_name}",
            )


def check_robot_cli() -> None:
    """Verify the `robot` command is on PATH."""
    print("\n3) Robot Framework CLI")
    robot_path = shutil.which("robot")
    if robot_path:
        try:
            result = subprocess.run(
                ["robot", "--version"],
                capture_output=True,
                text=True,
                timeout=10,
            )
            version_line = (result.stdout or result.stderr).strip().split("\n")[0]
            ok(f"robot CLI available — {version_line}")
        except Exception as exc:
            fail(f"robot CLI found but failed to run: {exc}")
    else:
        fail(
            "robot CLI not found on PATH",
            hint="pip install robotframework   (then restart your terminal)",
        )


def check_env_vars() -> None:
    """Check that API key env vars are set (warn only — not a hard failure)."""
    print("\n4) Environment variables")

    openai_key = os.environ.get("OPENAI_API_KEY", "")
    gemini_key = os.environ.get("GEMINI_API_KEY", "")

    if openai_key:
        ok(f"OPENAI_API_KEY is set ({mask_key(openai_key)})")
    else:
        warn(
            "OPENAI_API_KEY is not set",
            hint="Copy .env.example to .env, fill in your key, then run:  source .env  "
                 "(or export it manually)",
        )

    if gemini_key:
        ok(f"GEMINI_API_KEY is set ({mask_key(gemini_key)})")
    else:
        warn(
            "GEMINI_API_KEY is not set",
            hint="Copy .env.example to .env, fill in your key, then run:  source .env  "
                 "(or export it manually)",
        )


def _run_api_test(code: str, timeout: int = 30) -> str:
    """Run an API test snippet in a subprocess with timeout.

    Returns the stdout on success, or raises an exception on failure/timeout.
    """
    result = subprocess.run(
        [sys.executable, "-c", code],
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip().split("\n")[-1])
    return result.stdout.strip()


def test_openai_key() -> None:
    """Send a trivial prompt to the OpenAI API."""
    key = os.environ.get("OPENAI_API_KEY", "")
    if not key:
        fail("Cannot test OpenAI — OPENAI_API_KEY not set")
        return
    try:
        code = (
            "import os\n"
            "from openai import OpenAI\n"
            "client = OpenAI(api_key=os.environ['OPENAI_API_KEY'], timeout=20.0)\n"
            "r = client.chat.completions.create(\n"
            "    model='gpt-4o-mini',\n"
            "    messages=[{'role': 'user', 'content': \"Say 'hello' in one word.\"}],\n"
            "    max_tokens=5,\n"
            ")\n"
            "print(r.choices[0].message.content.strip())\n"
        )
        reply = _run_api_test(code, timeout=30)
        ok(f"OpenAI API responded: \"{reply}\"")
    except subprocess.TimeoutExpired:
        fail(
            "OpenAI API call timed out (30s)",
            hint="Check your network connection. The API may be slow.",
        )
    except Exception as exc:
        fail(
            f"OpenAI API call failed: {exc}",
            hint="Double-check your OPENAI_API_KEY and network connection.",
        )


def test_gemini_key() -> None:
    """Send a trivial prompt to the Gemini API."""
    key = os.environ.get("GEMINI_API_KEY", "")
    if not key:
        fail("Cannot test Gemini — GEMINI_API_KEY not set")
        return
    try:
        code = (
            "import os\n"
            "from google import genai\n"
            "from google.genai import types\n"
            "client = genai.Client(api_key=os.environ['GEMINI_API_KEY'])\n"
            "r = client.models.generate_content(\n"
            "    model='gemini-2.0-flash',\n"
            "    contents=\"Say 'hello' in one word.\",\n"
            "    config=types.GenerateContentConfig(max_output_tokens=10),\n"
            ")\n"
            "print(r.text.strip())\n"
        )
        reply = _run_api_test(code, timeout=30)
        ok(f"Gemini API responded: \"{reply}\"")
    except subprocess.TimeoutExpired:
        fail(
            "Gemini API call timed out (30s)",
            hint="Check your network connection. The API may be slow.",
        )
    except Exception as exc:
        fail(
            f"Gemini API call failed: {exc}",
            hint="Double-check your GEMINI_API_KEY and network connection.",
        )


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Verify your RoboCon 2026 workshop environment."
    )
    parser.add_argument(
        "--test-keys",
        action="store_true",
        help="Also send a test prompt to OpenAI and Gemini to verify API keys.",
    )
    args = parser.parse_args()

    print("=" * 60)
    print("  RoboCon 2026 Workshop — Environment Check")
    print("=" * 60)

    check_python_version()
    check_imports()
    check_robot_cli()
    check_env_vars()

    if args.test_keys:
        print("\n5) API key verification (--test-keys)")
        test_openai_key()
        test_gemini_key()

    # Summary
    print("\n" + "=" * 60)
    parts = [f"\033[92m{passed} passed\033[0m"]
    if failed:
        parts.append(f"\033[91m{failed} failed\033[0m")
    if warned:
        parts.append(f"\033[93m{warned} warnings\033[0m")
    print(f"  Result: {', '.join(parts)}")

    if failed:
        print("\n  Some checks failed. Please fix the issues above and re-run:")
        print("      python verify_setup.py")
    elif warned:
        print("\n  All critical checks passed. Warnings are non-blocking — you can")
        print("  set the API keys later when the workshop begins.")
    else:
        print("\n  Everything looks good. You are ready for the workshop!")

    print("=" * 60)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
