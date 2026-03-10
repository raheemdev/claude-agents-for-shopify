#!/usr/bin/env bash
set -euo pipefail
# audit-guard.sh — Ensures CLAUDE.md has been configured before edits

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
CLAUDE_MD="$REPO_ROOT/CLAUDE.md"

if [[ ! -f "$CLAUDE_MD" ]]; then
  echo "EDIT BLOCKED: No CLAUDE.md found at repo root."
  echo "This file must exist with store configuration before editing."
  exit 1
fi

# Check if the Client Config section still has empty values
if grep -q "^- Brand voice:$" "$CLAUDE_MD"; then
  echo "WARNING: CLAUDE.md Client Config section appears unconfigured."
  echo "Fill in your brand voice, colors, typography, apps, and special rules."
  echo "Continuing anyway — but you should configure this soon."
fi

echo "OK: CLAUDE.md found and checked."
exit 0
