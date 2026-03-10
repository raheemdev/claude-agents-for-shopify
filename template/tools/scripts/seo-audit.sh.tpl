#!/usr/bin/env bash
set -euo pipefail

# seo-audit.sh — Run a Lighthouse SEO audit for the store
#
# This is a single-client repo. The default URL is baked in from the template.
#
# Usage:
#   ./tools/scripts/seo-audit.sh
#   ./tools/scripts/seo-audit.sh <url>
#
# Examples:
#   ./tools/scripts/seo-audit.sh                          # uses default store URL
#   ./tools/scripts/seo-audit.sh https://custom-url.com   # override with custom URL
#
# Pre-requisites:
#   - Google Lighthouse CLI: npm install -g lighthouse
#   - Google Chrome installed

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# --- URL resolution ---

DEFAULT_URL="https://%%CLIENT_DOMAIN%%"
STORE_URL="${1:-$DEFAULT_URL}"

# --- Validation ---

# Validate URL format
if [[ ! "$STORE_URL" =~ ^https?:// ]]; then
  echo "Error: Store URL must start with http:// or https://"
  echo "  Got: $STORE_URL"
  echo ""
  echo "Usage: $0 [url]"
  echo ""
  echo "Examples:"
  echo "  $0"
  echo "  $0 https://custom-url.com"
  exit 1
fi

# Check for Lighthouse CLI
if ! command -v lighthouse &>/dev/null; then
  echo "Error: Lighthouse CLI not found."
  echo "  Install it: npm install -g lighthouse"
  exit 1
fi

# --- Setup ---

AUDIT_DIR="$REPO_ROOT/seo/audits"
mkdir -p "$AUDIT_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_FILE="$AUDIT_DIR/seo-audit-$TIMESTAMP"

echo "=== SEO Audit ==="
echo "  URL:    $STORE_URL"
echo "  Output: $OUTPUT_FILE.json"
echo ""

# --- Run Lighthouse ---

echo "Running Lighthouse SEO audit..."

lighthouse "$STORE_URL" \
  --only-categories=seo \
  --output=json,html \
  --output-path="$OUTPUT_FILE" \
  --chrome-flags="--headless --no-sandbox" \
  --quiet

if [[ $? -eq 0 ]]; then
  echo ""
  echo "Audit complete."
  echo ""

  # Extract and display SEO score from JSON
  if command -v jq &>/dev/null && [[ -f "$OUTPUT_FILE.json" ]]; then
    SEO_SCORE=$(jq '.categories.seo.score * 100' "$OUTPUT_FILE.json" 2>/dev/null || echo "N/A")
    echo "  SEO Score: $SEO_SCORE / 100"
    echo ""

    # List failed audits
    echo "  Failed checks:"
    jq -r '.audits | to_entries[] | select(.value.score != null and .value.score < 1) | "    - \(.value.title)"' "$OUTPUT_FILE.json" 2>/dev/null || true
    echo ""
  fi

  echo "Files saved:"
  echo "  JSON: $OUTPUT_FILE.json"
  echo "  HTML: $OUTPUT_FILE.html"
  echo ""
  echo "Next: Review results and update seo/ documentation as needed."
else
  echo "Error: Lighthouse audit failed."
  exit 1
fi
