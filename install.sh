#!/bin/sh
set -e

REPO="soeasy13142/program_init"
VERSION="${1:-main}"
SHARE_DIR="${HOME}/.local/share/project-init"
BIN_DIR="${HOME}/.local/bin"

# Unsupported OS check
case "$(uname -s)" in
  Darwin|Linux) ;;
  *)            echo "Unsupported OS"; exit 1 ;;
esac

echo "Installing project-init v${VERSION}..."

# Create directory structure
mkdir -p "${SHARE_DIR}/bin"
mkdir -p "${SHARE_DIR}/lib"
mkdir -p "${SHARE_DIR}/templates/presets"
mkdir -p "${BIN_DIR}"

download_file() {
  src="$1"
  dst="$2"
  url="https://raw.githubusercontent.com/${REPO}/${VERSION}/${src}"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dst" >/dev/null 2>&1
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$url" -O "$dst"
  else
    echo "  Neither curl nor wget found"
    exit 1
  fi
}

echo "  Downloading from ${REPO}..."

# Download main script
download_file "bin/project-init" "${SHARE_DIR}/bin/project-init"
chmod +x "${SHARE_DIR}/bin/project-init"

# Download lib files
download_file "lib/helpers.sh" "${SHARE_DIR}/lib/helpers.sh"
download_file "lib/template.sh" "${SHARE_DIR}/lib/template.sh"
download_file "lib/questions.sh" "${SHARE_DIR}/lib/questions.sh"

# Download templates
download_file "templates/universal.md" "${SHARE_DIR}/templates/universal.md"
download_file "templates/presets/cli-tool.md" "${SHARE_DIR}/templates/presets/cli-tool.md"
download_file "templates/presets/web-app.md" "${SHARE_DIR}/templates/presets/web-app.md"
download_file "templates/presets/ts-lib.md" "${SHARE_DIR}/templates/presets/ts-lib.md"
download_file "templates/presets/next-app.md" "${SHARE_DIR}/templates/presets/next-app.md"

# Install wrapper in PATH
cat > "${BIN_DIR}/project-init" << 'WRAPPER'
#!/bin/sh
exec ~/.local/share/project-init/bin/project-init "$@"
WRAPPER
chmod +x "${BIN_DIR}/project-init"

echo "  Installed to ${SHARE_DIR}"
echo "  Wrapper at ${BIN_DIR}/project-init"

# Check PATH
case ":${PATH}:" in
  *:"${BIN_DIR}":*)
    ;;
  *)
    echo ""
    echo "  Warning: ${BIN_DIR} is not in your PATH."
    echo "    Add this to your shell profile:"
    echo "      export PATH=\"\$HOME/.local/bin:\$PATH"
    ;;
esac

echo ""
echo "  Done! Run: project-init --help"
