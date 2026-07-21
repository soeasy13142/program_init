#!/bin/sh
set -eu  # -o pipefail omitted for dash compatibility

SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "$0")" && pwd)}"
# helpers.sh is sourced by the entry point (bin/project-init) before this file

# render_template template_file output_file [VAR1=val1 VAR2=val2 ...]
# Renders a template file using envsubst, replacing {{VAR}} placeholders.
# Exports provided variables so envsubst can substitute them.
render_template() {
  template_file="$1"
  output_file="$2"
  shift 2

  # Export all provided variables
  for pair in "$@"; do
    case "$pair" in
      *=*)
        key="${pair%%=*}"
        val="${pair#*=}"
        export "$key"="$val"
        ;;
    esac
  done

  if [ ! -f "$template_file" ]; then
    log_error "Template not found: $template_file"
    exit 1
  fi

  # Create output directory if needed
  mkdir -p "$(dirname "$output_file")"

  # envsubst replaces $VAR and ${VAR}; convert {{VAR}} to $VAR then substitute
  # Iterate to resolve nested placeholders (e.g. placeholders inside preset content)
  content=$(sed 's/{{\([a-zA-Z_][a-zA-Z_0-9]*\)}}/$\1/g' "$template_file")
  content=$(echo "$content" | envsubst)
  while echo "$content" | grep -q '{{[a-zA-Z_][a-zA-Z_0-9]*}}'; do
    content=$(echo "$content" | sed 's/{{\([a-zA-Z_][a-zA-Z_0-9]*\)}}/$\1/g')
    content=$(echo "$content" | envsubst)
  done
  printf '%s\n' "$content" > "$output_file"

  log_success "Generated: $output_file"
}
