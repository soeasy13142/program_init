# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-07-21

### Added

- Scaffold project directory structure
- Add shared `universal.md` template
- Add `cli-tool` preset template
- Add `web-app` preset template
- Add `helpers.sh` with log functions and dependency check
- Add `template.sh` with envsubst-based template rendering
- Add `questions.sh` with interactive Q&A flow
- Implement `project-init` CLI entry point
- Add `install.sh` for curl|bash install

### Fixed

- Replace `pipefail` with `set -eu` for dash compatibility
- Address final review findings
- Remove placeholder project types from README usage example

### Docs

- Add project-init design spec
- Add v0.1 MVP implementation plan
- Add README.md and MIT license
