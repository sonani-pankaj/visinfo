# Copilot Repository Instructions

## Goal
Keep edits fast, safe, and reviewable by working on **small, targeted ranges** instead of whole files.
Write **clean, minimal, maintainable, secure code** that is easy to extend.

## Flutter structure convention (required)
- Keep `lib/main.dart` minimal (bootstrap only).
- Place implementation code under `lib/src/`.
- Use:
  - `lib/src/app/` for app shell and router composition
  - `lib/src/core/` for shared platform/config/observability concerns
  - `lib/src/features/<feature>/` for feature code
- Within features, use layered folders only as needed:
  - `presentation/`, `application/`, `domain/`, `infrastructure/`
- Prefer package imports from `package:visinfo_flutter/src/...` for cross-feature references.

## Persistent project memory
- Treat [IMPLEMENTATION_MEMORY.md](../IMPLEMENTATION_MEMORY.md) as the source of truth for what is already implemented.
- Before implementing new work, check memory entries that overlap with the target feature.
- After implementing any feature change, update memory with:
  - What was added/changed
  - What existing behavior must remain stable
  - Key files touched

## Required behavior
1. **Do not read entire files by default.**  
   - First locate relevant symbols/sections with search.  
   - Then read only the needed line ranges.

2. **Do not rewrite entire files for partial changes.**  
   - Apply minimal, surgical edits to the exact affected blocks.  
   - Preserve unrelated code, formatting, and ordering.

3. **Avoid broad refactors unless explicitly requested.**  
   - No large-scale rename/reformat/restructure without user request.

4. **Scope changes to the request.**  
   - Touch only files directly related to the task.  
   - Do not opportunistically fix unrelated issues.

5. **Keep diffs small and auditable.**  
   - Prefer multiple small focused edits over one wide rewrite.

6. **Do not break existing functionality.**
   - Preserve current behavior unless the user explicitly requests a behavior change.
   - Validate impacted paths after edits (tests/lint/build when available).
   - If a behavior change is intentional, document it in memory and changelog.

7. **Maintain changelog on every implementation change.**
   - For every new implementation or behavior change, update [CHANGELOG.md](../CHANGELOG.md).
   - Include date, summary, impacted files, and compatibility notes.

8. **Write less, cleaner code.**
   - Prefer the smallest complete solution over verbose code.
   - Remove duplication; reuse existing helpers and abstractions.
   - Keep functions focused and short; one clear responsibility per unit.
   - Avoid unnecessary comments; code should be self-explanatory.

9. **Design for maintainability and extension.**
   - Follow SOLID-friendly patterns and clear interfaces.
   - Prefer composition over inheritance unless inheritance is clearly better.
   - Add extension points only where justified by real use cases; avoid over-engineering.
   - Keep naming explicit, consistent, and domain-driven.

10. **Enforce secure coding best practices.**
   - Validate and sanitize all external input.
   - Never hardcode secrets, tokens, keys, or credentials.
   - Apply least-privilege access patterns.
   - Fail safely with explicit errors; avoid silent security fallbacks.
   - Use parameterized queries or safe SDK APIs for data access.
   - Keep dependencies minimal and current when introducing new packages.

11. **Quality gate before finalizing changes.**
   - Run relevant lint/tests/build checks when tools are available.
   - If checks cannot run, state that clearly and do not claim runtime verification.

## Exceptions
Reading or replacing a full file is allowed only when:
- The file is very small and fully relevant, or
- The user explicitly asks for a full-file rewrite, or
- A generated file must be replaced completely.
