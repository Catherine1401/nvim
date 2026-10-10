#!/bin/bash
# Cài cấu hình Neovim: kiểm tra phụ thuộc, tải Neovim và tree-sitter vào $HOME, clone config, đồng bộ plugin, chạy doctor
set -euo pipefail

REPO_URL="${NVIM_CONFIG_REPO:-https://github.com/Catherine1401/nvim.git}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BIN_DIR="$HOME/.local/bin"
NVIM_HOME="$HOME/.local/share/nvim-release"
MIN_NVIM="0.12.0"
MIN_TREE_SITTER="0.26.1"
NVIM_RELEASE_URL="https://github.com/neovim/neovim/releases/latest/download"
TREE_SITTER_RELEASE_URL="https://github.com/tree-sitter/tree-sitter/releases/latest/download"
BASE_TOOLS="git curl tar make"
LOG_FILE="${TMPDIR:-/tmp}/nvim-config-install.log"
ORIGINAL_PATH="$PATH"

say() { printf '%s\n' "$*"; }
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

# Cài vào $HOME nên chạy bằng sudo sẽ đặt file sai chỗ
refuse_sudo() {
	if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
		fail "do not run this installer with sudo; it installs into your home directory and does not need root."
	fi
}

# Chọn tên file bản dựng sẵn theo hệ điều hành và kiến trúc
detect_platform() {
	case "$(uname -s)-$(uname -m)" in
		Linux-x86_64) NVIM_ASSET="nvim-linux-x86_64"; TREE_SITTER_ASSET="tree-sitter-linux-x64" ;;
		Linux-aarch64 | Linux-arm64) NVIM_ASSET="nvim-linux-arm64"; TREE_SITTER_ASSET="tree-sitter-linux-arm64" ;;
		Darwin-arm64) NVIM_ASSET="nvim-macos-arm64"; TREE_SITTER_ASSET="tree-sitter-macos-arm64" ;;
		Darwin-x86_64) NVIM_ASSET="nvim-macos-x86_64"; TREE_SITTER_ASSET="tree-sitter-macos-x64" ;;
		*) fail "unsupported platform: $(uname -s) $(uname -m)" ;;
	esac
}

# a >= b theo số phiên bản
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]; }

# Phiên bản của một lệnh, rỗng nếu chưa cài
tool_version() {
	command -v "$1" >/dev/null 2>&1 || return 0
	"$1" --version 2>/dev/null | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true
}

# In lệnh cài gói phù hợp với trình quản lý gói; cần quyền root nên không tự chạy
print_install_hint() {
	if command -v apt-get >/dev/null 2>&1; then say "  sudo apt install -y git curl tar make gcc"
	elif command -v dnf >/dev/null 2>&1; then say "  sudo dnf install -y git curl tar make gcc"
	elif command -v pacman >/dev/null 2>&1; then say "  sudo pacman -S --needed git curl tar make gcc"
	elif command -v brew >/dev/null 2>&1; then say "  xcode-select --install"
	else say "  install: $BASE_TOOLS and a C compiler (cc, gcc or clang)"
	fi
}

check_base_tools() {
	local missing=""
	for tool in $BASE_TOOLS; do
		command -v "$tool" >/dev/null 2>&1 || missing="$missing $tool"
	done
	if ! command -v cc >/dev/null 2>&1 && ! command -v gcc >/dev/null 2>&1 && ! command -v clang >/dev/null 2>&1; then
		missing="$missing cc"
	fi
	if [ -n "$missing" ]; then
		say "Missing required tools:$missing"
		print_install_hint
		fail "install the tools above, then run this installer again."
	fi
}

install_nvim() {
	local version
	version="$(tool_version nvim)"
	if [ -n "$version" ] && version_ge "$version" "$MIN_NVIM"; then
		say "Neovim $version found."
		return
	fi
	say "Installing Neovim ($NVIM_ASSET) into $NVIM_HOME ..."
	local tmp
	tmp="$(mktemp -d)"
	curl -fsSL "$NVIM_RELEASE_URL/$NVIM_ASSET.tar.gz" -o "$tmp/nvim.tar.gz"
	rm -rf "$NVIM_HOME"
	mkdir -p "$NVIM_HOME" "$BIN_DIR"
	tar -xzf "$tmp/nvim.tar.gz" -C "$NVIM_HOME"
	ln -sf "$NVIM_HOME/$NVIM_ASSET/bin/nvim" "$BIN_DIR/nvim"
	rm -rf "$tmp"
}

install_tree_sitter() {
	local version
	version="$(tool_version tree-sitter)"
	if [ -n "$version" ] && version_ge "$version" "$MIN_TREE_SITTER"; then
		say "tree-sitter $version found."
		return
	fi
	say "Installing tree-sitter CLI into $BIN_DIR ..."
	mkdir -p "$BIN_DIR"
	curl -fsSL "$TREE_SITTER_RELEASE_URL/$TREE_SITTER_ASSET.gz" | gunzip -c > "$BIN_DIR/tree-sitter"
	chmod +x "$BIN_DIR/tree-sitter"
}

# Config đã có và đúng repo thì cập nhật, khác repo thì sao lưu rồi clone
install_config() {
	if [ -d "$CONFIG_DIR/.git" ] && [ "$(git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null)" = "$REPO_URL" ]; then
		say "Updating $CONFIG_DIR ..."
		git -C "$CONFIG_DIR" pull --ff-only
		return
	fi
	if [ -e "$CONFIG_DIR" ]; then
		local backup="$CONFIG_DIR.bak-$(date +%Y%m%d%H%M%S)"
		say "Existing config moved to $backup"
		mv "$CONFIG_DIR" "$backup"
	fi
	say "Cloning $REPO_URL into $CONFIG_DIR ..."
	git clone --depth 1 "$REPO_URL" "$CONFIG_DIR"
}

sync_plugins() {
	say "Installing plugins (this takes a few minutes, log: $LOG_FILE) ..."
	nvim --headless "+Lazy! sync" +qa > "$LOG_FILE" 2>&1 || fail "plugin sync failed, see $LOG_FILE"
}

main() {
	refuse_sudo
	detect_platform
	check_base_tools
	export PATH="$BIN_DIR:$PATH"
	install_nvim
	install_tree_sitter
	install_config
	sync_plugins
	say ""
	say "Checking the installation:"
	if nvim --headless "+lua require('config.health').run()"; then
		say ""
		say "Done. Start Neovim with: nvim"
	else
		say ""
		fail "some required items are missing (listed above). Fix them and run :checkhealth config."
	fi
	case ":$ORIGINAL_PATH:" in *":$BIN_DIR:"*) ;; *) say "Add $BIN_DIR to your PATH: export PATH=\"$BIN_DIR:\$PATH\"" ;; esac
}

main "$@"
