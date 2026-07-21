#!/bin/sh
set -euo pipefail

# Colors (disabled if not terminal)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  CYAN='\033[0;36m'
  NC='\033[0m' # No Color
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; NC=''
fi

log_info()   { printf "${CYAN}  ➜${NC} %s\n" "$*"; }
log_success() { printf "${GREEN}  ✅${NC} %s\n" "$*"; }
log_warn()   { printf "${YELLOW}  ⚠️${NC} %s\n" "$*"; }
log_error()  { printf "${RED}  ✗${NC} %s\n" "$*"; }

check_dependencies() {
  missing=0
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      log_error "Missing dependency: $cmd"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" -eq 0 ] || exit 1
}
