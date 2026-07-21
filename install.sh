#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
REPO="soeasy13142/project-init"
VERSION="${1:-main}"

# Detect platform
case "$(uname -s)" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux" ;;
  *)      echo "Unsupported OS"; exit 1 ;;
esac

echo "Installing project-init v${VERSION}..."

mkdir -p "$INSTALL_DIR"

# Download the script directly from GitHub
echo "  Downloading from ${REPO}..."
if command -v curl >/dev/null 2>&1; then
  if curl -fsSL "https://raw.githubusercontent.com/${REPO}/${VERSION}/bin/project-init" -o "${INSTALL_DIR}/project-init"; then
    chmod +x "${INSTALL_DIR}/project-init"
    echo "  ✅ Installed to ${INSTALL_DIR}/project-init"
  else
    echo "  ✗ Download failed"
    exit 1
  fi
elif command -v wget >/dev/null 2>&1; then
  wget -q "https://raw.githubusercontent.com/${REPO}/${VERSION}/bin/project-init" -O "${INSTALL_DIR}/project-init"
  chmod +x "${INSTALL_DIR}/project-init"
  echo "  ✅ Installed to ${INSTALL_DIR}/project-init"
else
  echo "  ✗ Neither curl nor wget found"
  exit 1
fi

# Also download templates
TEMPLATE_DIR="${HOME}/.local/share/project-init/templates"
mkdir -p "$TEMPLATE_DIR/presets"

for tmpl in universal.md presets/cli-tool.md presets/web-app.md; do
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "https://raw.githubusercontent.com/${REPO}/${VERSION}/templates/${tmpl}" \
      -o "${TEMPLATE_DIR}/${tmpl}" >/dev/null 2>&1
  else
    wget -q "https://raw.githubusercontent.com/${REPO}/${VERSION}/templates/${tmpl}" \
      -O "${TEMPLATE_DIR}/${tmpl}"
  fi
done
echo "  ✅ Templates installed to ${TEMPLATE_DIR}"

# Check PATH
case ":${PATH}:" in
  *:"${INSTALL_DIR}":*)
    ;;
  *)
    echo ""
    echo "  ⚠️  ${INSTALL_DIR} is not in your PATH."
    echo "     Add this to your shell profile:"
    echo "       export PATH=\"\$HOME/.local/bin:\$PATH\""
    ;;
esac

echo ""
echo "  Done! Run: project-init --help"
