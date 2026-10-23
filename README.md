# ilker's macOS Setup

## New Mac quick start

1. Sign in to the Mac and install Homebrew from https://brew.sh.
2. Clone this repo (`git clone https://github.com/ilkerispir/dotfiles ~/workspace/dotfiles`).
3. Run `~/workspace/dotfiles/bootstrap.sh`. It installs the Xcode command line
   tools, logs in to GitHub, runs `brew bundle` (`.Brewfile`), links the
   dotfiles (`install_symlinks.sh`) and applies `macos_defaults.sh`.
4. Open a new terminal, then follow the manual steps it prints.

The sections below describe the same steps in detail.

## Download Xcode

Install Xcode from the App Store. This will take a lot of time, so start with this.

## OS Settings

> TODO: find `defaults write` commands for these.

- Invert Trackpad Scroll Direction to non-natural.
- Show battery percentage on menu bar.
- Show date on menu bar.
- Keyboard &rarr; Text &rarr; Uncheck autocorrect and such settings.
- Remove useless items from the Dock.
- Move Dock to right, make it smaller.
- Drag `Downloads` folder next to the Trash on the Dock.
  - Right Click &rarr; Sort by Date Added.
- Show Path Bar on Finder.
- Move $HOME folder to Finder sidebar.

- Set shortcuts
  - Accessibility: Invert colors: Cmd+Shift+I
  - Screenshots:
    - Uncheck all
    - Save selected area to file: Cmd+Shift+4
    - Save selected area to clipboard: Cmd+Shift+2
- Hot Corners:
  - Top-left: Put Display to Sleep
  - Clear other corners

Tweaks:

```
defaults write NSGlobalDomain AppleShowScrollBars -string "Always" # show scrollbar always
defaults write com.apple.finder AppleShowAllFiles true   # Show hidden files
defaults write com.apple.finder ShowStatusBar -bool true # Show Finder statusbar

# Default Finder location is the home folder
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

chflags nohidden ~/Library                               # Unhide ~/Library
defaults write com.apple.screencapture location ~/Downloads # default screenshot path

# disable smart quotes and dashes
defaults write 'Apple Global Domain' NSAutomaticDashSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticQuoteSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticPeriodSubstitutionEnabled 0
```

## Shell

- Make sure zsh is installed.
- `.zshrc` bootstraps [zinit](https://github.com/zdharma-continuum/zinit) on
  first launch (it clones the repo over HTTPS), so the first shell start takes
  a while and needs network access.
- The prompt is oh-my-posh (`.oh-my-posh.omp.yaml`), installed via `.Brewfile`.

## Package manager

- Install Homebrew &mdash;to `$HOME/.homebrew` instead of /usr/local:

      git clone https://github.com/Homebrew/brew.git $HOME/.homebrew

- Run `which brew` to confirm the one in home directory is picked up.
- Run `brew analytics off`

## Installing software manually

- Download Dropbox
  - Sign in 
  - Sync only 1Password
- Download iPassword 6
  - Choose .opvault file from Dropbox
  - Go to Software Licenses &rarr; open the 1Password license file
  - Accept to use 1Password Mini when prompted

## Installing software via Homebrew

All software installed on the system must be listed in `.Brewfile`. This is
symlinked at `~/.Brewfile` and used by `brew bundle`.

To install all the software, add it to `.Brewfile` and run:

    brew bundle --global

Some stuff will take long, in that case, identify which packages and update
`.Brewfile` to install them with `args: ['force-bottle']` or do a one-off
`brew install --force-bottle [pkg]` install.

Some things that require manual installation after Homebrew:

```sh
# if pip requires sudo, something is wrong, because the
# Homebrew bundle should install a $USER-writable over system-python.
    
pip install virtualenv
pip install virtualenvwrapper
```

## Post-Installation Configuration

- **Rectangle**
  - Security->Accessibility: Give access
  - Launch at Login
- **Clipy**
  - Launch at Login
  - Hide from Menu Bar
  - Set history size to 200
  - Set paste key to <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd>
- **fzf** completion scripts:

      "$HOMEBREW_PREFIX"/opt/fzf/install

- **vim** plugins (vim-go + gopls):

      vim +PlugInstall +GoInstallBinaries +qall

## Settings Sync

- Clone this repo and run `install_symlinks.sh`
    - Existing files (e.g. `~/.zshrc`, `~/.claude/settings.json`) are moved to
      `~/.dotfiles_backup/<timestamp>/` before being replaced by symlinks.
    - Open a new terminal to take effect.
- iTerm2->Preferences->Load Preferences From: com.googlecode.iterm2.plist directory.
    - Restart iTerm2.

- VSCode:
  - Install "Settings Sync" extension and reload.
  - Run '> Sync: Download Settings'
  - Enter gist ID in `vscode.sync` file to prompt.
  - Once extensions are installed 'Reload' (or Restart)
  - Run '> Sync: Update/Upload Settings'
  - Create a token with 'gist' permissions and save it to the prompt
  - Wait for the Sync Summary.

## Git Setup

Identity, pager, diff colours and credential helpers are in `.gitconfig`
(symlinked to `~/.gitconfig` by `install_symlinks.sh`). Log in with the GitHub
CLI so HTTPS credentials work:

    gh auth login

Commit signing is not enabled by default. To sign commits, set up a key
(`gitsign` is installed via `.Brewfile`, or use GPG/SSH signing) and add
`signingkey` and `commit.gpgsign` to `.gitconfig`.

Generate key with a password:

    ssh-keygen -f $HOME/.ssh/github_rsa

(You may want to redact hostname from the public key.)

Add key to the keychain:

    ssh-add $HOME/.ssh/github_rsa          # company-installed
    /usr/bin/ssh-add $HOME/.ssh/github_rsa # system

Upload the key to GitHub. https://github.com/settings/keys :

    cat ~/.ssh/github_rsa.pub| pbcopy

Save this to ~/.ssh/config:

Test connection:

    ssh -T git@github.com -i ~/.ssh/github_rsa


## Hardware

- Evoluent ergo mouse driver: https://evoluent.com/support/download/
- Das Keyboard
  - Settings &rarr; Keyboard &rarr; Modifier Keys: flip the Option/Command keys for "daskeyboard" profile.
