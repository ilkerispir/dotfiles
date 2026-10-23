#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"
readonly BACKUP_DIR

# link <source> <target>: symlink target to source. A pre-existing real file or
# directory is moved into BACKUP_DIR instead of being deleted.
link() {
	local src="$1" target="$2"
	mkdir -p "$(dirname "$target")"
	if [ -L "$target" ]; then
		unlink "$target"
	elif [ -e "$target" ]; then
		mkdir -p "$BACKUP_DIR"
		mv "$target" "$BACKUP_DIR/$(basename "$target")"
	fi
	ln -sf "$src" "$target"
}

# suppress shell login message
[[ ! -e ~/.hushlogin ]] && touch ~/.hushlogin

for f in .zshrc \
	.Brewfile \
	.vimrc \
	.editorconfig \
	.gitconfig \
	.git-commit-template \
	.gitignore_global \
	.oh-my-posh.omp.yaml \
	.claude.omp.yaml \
	.tmux.conf; do
	link "$SCRIPT_DIR/$f" "$HOME/$f"
done

# Ghostty config file (macOS only)
if [[ "$(uname -s)" == "Darwin" ]]; then
	link "$SCRIPT_DIR/ghostty_config" \
		"$HOME/Library/Application Support/com.mitchellh.ghostty/config"
fi

# Claude config files (symlink files preserving directory structure, skills
# are handled separately below)
while IFS= read -r -d '' f; do
	relative="${f#$SCRIPT_DIR/.claude/}"
	case "$relative" in
		skills/*) continue ;;
	esac
	link "$f" "$HOME/.claude/$relative"
done < <(find "$SCRIPT_DIR/.claude" -type f -print0)

# Claude skills: link each skill individually, ~/.claude/skills also holds
# skills managed elsewhere (e.g. synced/) that must not be touched.
mkdir -p "$HOME/.claude/skills"
for s in "$SCRIPT_DIR"/.claude/skills/*; do
	link "$s" "$HOME/.claude/skills/$(basename "$s")"
done

if [ -d "$BACKUP_DIR" ]; then
	echo "Existing files were backed up to $BACKUP_DIR"
fi
echo "DONE"
