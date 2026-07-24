# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-07-24

### Added

- Scaffold project directory structure
- Add shared `universal.md` template
- Add `cli-tool` preset template
- Add `web-app` preset template
- Add `ts-lib` and `next-app` preset templates
- Add `shell-script` preset template
- Add `helpers.sh` with log functions and dependency check
- Add `template.sh` with envsubst-based template rendering
- Add `questions.sh` with interactive Q&A flow
- Implement `project-init` CLI entry point
- Add `install.sh` for curl|bash install
- Add `--preset` flag for custom template path
- Add `--types` flag for batch init of multiple types
- Add `--non-interactive` alias for `-y`
- Add `CHANGELOG.md` and issue/PR templates
- Add bats test framework for lib modules
- Add GitHub Actions CI workflow (shellcheck + bats)
- Add HANDOFF mechanism with `docs/handover/` directory
- Add `-c` / `--claude-only` mode for existing projects
- Ensure `.claude/` directory created in both full and claude-only modes

### Fixed

- Replace `pipefail` with `set -eu` for dash compatibility
- Address initial review findings
- Remove placeholder project types from README usage example
- Correct `install.sh` REPO URL from `project-init` to `program_init`
- Resolve all 7 documented bugs (install.sh 404, CUSTOM_RULES unused, doc repo names, OS variable unused, printf format string)

### Changed

- Upgrade `universal.md` template per official Claude spec with numbered DO/DON'T
- Refactor CLAUDE.md template with modular layout (module boundaries, architecture diagram)
- Rewrite README with community-standard badges and structure
- Update `install.sh` with new presets and consistent repo references

### Docs

- Add project-init design spec
- Add v0.1 MVP implementation plan
- Add bug report, feature request, and pull request templates
- Add handover documentation workflow
