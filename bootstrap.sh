#!/bin/bash
# Set up a fresh Mac: command line tools, Homebrew packages, dotfiles and
# macOS defaults. Safe to re-run.
set -euo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Xcode command line tools (git, compilers), needed by Homebrew
if ! xcode-select -p >/dev/null 2>&1; then
	xcode-select --install
	echo "Finish the Xcode command line tools install, then re-run this script."
	exit 1
fi

# Homebrew itself is not installed here on purpose: running a remote script
# unattended is a supply chain risk. Review and run the official installer.
if ! command -v brew >/dev/null 2>&1 && [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if ! command -v brew >/dev/null 2>&1; then
	echo "Homebrew is missing. Install it from https://brew.sh, then re-run this script."
	exit 1
fi

# GitHub login first, the private Antero and personal taps need credentials
brew install gh git
if ! gh auth status >/dev/null 2>&1; then
	gh auth login
fi
gh auth setup-git

# All packages, casks and VS Code extensions
brew bundle --file="$SCRIPT_DIR/.Brewfile"

# Dotfiles (existing files are backed up, not deleted)
"$SCRIPT_DIR/install_symlinks.sh"

# macOS preferences
"$SCRIPT_DIR/macos_defaults.sh"

cat <<'EOF'

Done. Remaining manual steps:
  - Open a new terminal (zinit installs its plugins on first start).
  - Sign in to 1Password, then create or restore SSH and signing keys.
  - Install company managed apps through MDM (GlobalProtect, Okta Verify, Drata).
EOF
