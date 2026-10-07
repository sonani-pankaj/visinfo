# Changelog

All notable implementation changes to this project should be documented here.

## [Unreleased]

### Changed - 2026-10-06
- Refactored Flutter codebase to `lib/src` best-practice structure:
  - moved app shell to [app.dart](./apps/visinfo_flutter/lib/src/app/app.dart),
  - moved shared code to [core/](./apps/visinfo_flutter/lib/src/core),
  - moved feature code to [features/](./apps/visinfo_flutter/lib/src/features),
  - kept [main.dart](./apps/visinfo_flutter/lib/main.dart) as thin bootstrap.
- Updated imports to align with the new structure, including test imports.
- Added explicit Flutter structure conventions to [.github/copilot-instructions.md](./.github/copilot-instructions.md).

### Changed - 2026-10-06
- Strengthened Copilot coding governance in [.github/copilot-instructions.md](./.github/copilot-instructions.md) to require:
  - concise, minimal implementation style,
  - maintainable and extension-friendly design,
  - secure coding standards,
  - explicit quality gates before finalizing changes.

### Added - 2026-10-06
- Added repository Copilot guardrails in [.github/copilot-instructions.md](./.github/copilot-instructions.md) to enforce:
  - targeted range-based reads,
  - surgical edits,
  - compatibility protection for existing behavior,
  - mandatory changelog updates for new implementations.
- Added persistent implementation memory in [IMPLEMENTATION_MEMORY.md](./IMPLEMENTATION_MEMORY.md) to track implemented features and stability expectations.

### Existing baseline recorded
- Flutter app structure, auth foundation, repository scaffolding, metadata extraction pipeline baseline, sync queue scaffold, and Supabase schema/RLS/storage migrations are captured in [IMPLEMENTATION_MEMORY.md](./IMPLEMENTATION_MEMORY.md).

---

## Change entry template (copy for future updates)
### Added/Changed/Fixed - YYYY-MM-DD
- Summary:
- Impacted files:
  - [file1](./path/to/file1)
  - [file2](./path/to/file2)
- Compatibility notes:
  - Existing behavior preserved/changed:
  - Migration/rollout notes:
