#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# setup.sh — Initialize the theme for %%CLIENT_DOMAIN%%
#
# Pulls an existing theme from Shopify or starts fresh with Dawn.
# Theme files are placed at the repo root (where Shopify CLI expects them).
#
# Usage:
#   ./setup.sh
# =============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STORE="%%MYSHOPIFY_URL%%"

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

success() { echo -e "  ${GREEN}✔${RESET} $1"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET} $1"; }
error()   { echo -e "\n  ${RED}✖ ERROR:${RESET} $1" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}Store:${RESET} ${STORE}"
echo -e "${BOLD}Theme dir:${RESET} ${REPO_ROOT} (repo root)"
echo ""

echo -e "${BOLD}What would you like to do?${RESET}"
echo ""
echo "  1) Pull an existing theme from Shopify"
echo "  2) Start fresh with a clean Dawn theme"
echo ""
read -rp "Choice [1/2]: " CHOICE

case "$CHOICE" in
  1)
    # -------------------------------------------------------------------
    # Option 1: Pull an existing theme (requires Shopify CLI)
    # -------------------------------------------------------------------
    if ! command -v shopify &>/dev/null; then
      error "Shopify CLI not found. Install it: npm install -g @shopify/cli"
    fi

    echo ""
    echo -e "${BLUE}${BOLD}Fetching themes from ${STORE}...${RESET}"
    echo ""

    THEME_LIST=$(shopify theme list --store "$STORE" 2>&1) || error "Failed to list themes. Are you logged in? Run: shopify auth login --store $STORE"

    echo "$THEME_LIST"
    echo ""

    read -rp "Enter the Theme ID to pull: " THEME_ID

    if [[ -z "$THEME_ID" ]]; then
      error "No Theme ID provided."
    fi

    if ! [[ "$THEME_ID" =~ ^[0-9]+$ ]]; then
      error "Theme ID must be a number. Got: $THEME_ID"
    fi

    echo ""
    echo -e "${BLUE}${BOLD}Pulling theme ${THEME_ID}...${RESET}"

    shopify theme pull --store "$STORE" --theme "$THEME_ID" --path "$REPO_ROOT"

    success "Theme pulled successfully"
    ;;

  2)
    # -------------------------------------------------------------------
    # Option 2: Start fresh with Dawn
    # -------------------------------------------------------------------
    echo ""
    echo -e "${BLUE}${BOLD}Downloading latest Dawn theme from GitHub...${RESET}"

    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/Shopify/dawn.git "$TEMP_DIR"

    # Copy Dawn theme directories into repo root
    for dir in assets config layout locales sections snippets templates; do
      if [[ -d "$TEMP_DIR/$dir" ]]; then
        cp -a "$TEMP_DIR/$dir" "$REPO_ROOT/"
      fi
    done

    # Copy Dawn root files (e.g., .theme-check.yml)
    for file in "$TEMP_DIR"/.theme-check.yml; do
      [[ -f "$file" ]] && cp "$file" "$REPO_ROOT/"
    done

    rm -rf "$TEMP_DIR"

    success "Dawn theme downloaded (latest from https://github.com/Shopify/dawn)"
    ;;

  *)
    error "Invalid choice. Enter 1 or 2."
    ;;
esac

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  Setup complete!${RESET}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════${RESET}"
echo ""
echo -e "  ${BOLD}Store:${RESET}     $STORE"
echo -e "  ${BOLD}Theme at:${RESET}  $REPO_ROOT"
echo ""
echo -e "${YELLOW}${BOLD}  Next steps:${RESET}"
echo "    1. Fill in the Client Config section in CLAUDE.md"
echo "    2. Review the theme files"
echo "    3. Commit: git add -A && git commit -m 'feat: initialize theme'"
echo "    4. Start developing: claude"
echo ""
