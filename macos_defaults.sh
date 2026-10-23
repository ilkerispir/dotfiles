#!/bin/bash
# macOS preferences that can be set from the command line. The rest is listed
# in README.md under "OS Settings".
set -euo pipefail

defaults write NSGlobalDomain AppleShowScrollBars -string "Always" # show scrollbar always
defaults write com.apple.finder AppleShowAllFiles true             # show hidden files
defaults write com.apple.finder ShowStatusBar -bool true           # show Finder statusbar
defaults write com.apple.finder ShowPathbar -bool true             # show Finder path bar

# Default Finder location is the home folder
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Default screenshot path
defaults write com.apple.screencapture location ~/Downloads

# Disable smart quotes, dashes and auto period
defaults write 'Apple Global Domain' NSAutomaticDashSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticQuoteSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticPeriodSubstitutionEnabled 0

chflags nohidden ~/Library # unhide ~/Library

# Dock on the right, smaller
defaults write com.apple.dock orientation -string "right"
defaults write com.apple.dock tilesize -int 40

killall Finder Dock SystemUIServer >/dev/null 2>&1 || true
echo "macOS defaults applied."
