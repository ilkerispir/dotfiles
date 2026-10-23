# ilker's macOS Setup

## New Mac quick start

1. Sign in to the Mac and install Homebrew from https://brew.sh.
2. Clone this repo to `~/workspace/dotfiles` (`.zshrc` looks for it there).
3. Run `~/workspace/dotfiles/bootstrap.sh`. It installs the Xcode command line
   tools, logs in to GitHub, runs `brew bundle` (`.Brewfile`), links the
   dotfiles (`install_symlinks.sh`) and applies `macos_defaults.sh`.
4. Open a new terminal. The first start takes a while because zinit clones its
   plugins from GitHub.

## What is in here

| File | Purpose |
|---|---|
| `.Brewfile` | Every package, app and VS Code extension. Single source of truth. |
| `.zshrc`, `zsh_aliases.inc`, `zsh_functions.inc` | Shell setup (zinit, oh-my-posh, fzf, direnv). |
| `.gitconfig`, `.gitignore_global`, `.git-commit-template` | Git identity, pager and ignores. |
| `.vimrc`, `.tmux.conf`, `.editorconfig` | Editor and terminal multiplexer settings. |
| `ghostty_config`, `.oh-my-posh.omp.yaml` | Terminal and prompt. |
| `.claude/` | Claude Code settings, status line and skills. |
| `install_symlinks.sh` | Links the files above into `$HOME`. Existing files are backed up to `~/.dotfiles_backup/<timestamp>/`. |
| `macos_defaults.sh` | `defaults write` settings. |

## Manual steps

- Download Xcode from the App Store.
- Sign in to 1Password, then restore SSH and signing keys.
- Install company managed apps through MDM (GlobalProtect, Okta Verify, Drata).
- System Settings: invert trackpad scroll to non-natural, show battery
  percentage and date in the menu bar, turn off autocorrect, tidy the Dock.
- Rectangle: grant Accessibility access and enable Launch at Login.
- fzf shell integration: `"$HOMEBREW_PREFIX"/opt/fzf/install`.

## Git

Identity, pager, diff colours and credential helpers are in `.gitconfig`. Log in
with the GitHub CLI so HTTPS credentials work:

    gh auth login

Commit signing is not enabled by default. To sign commits, set up a key
(`gitsign` is installed via `.Brewfile`, or use GPG/SSH signing) and add
`signingkey` and `commit.gpgsign` to `.gitconfig`.

Generate an SSH key with a passphrase and upload it at
https://github.com/settings/keys:

    ssh-keygen -t ed25519 -f ~/.ssh/github_ed25519
    ssh-add --apple-use-keychain ~/.ssh/github_ed25519
    pbcopy < ~/.ssh/github_ed25519.pub
