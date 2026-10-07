# Visinfo Implementation Memory

This file is the persistent memory for implemented features.  
Update it for every implementation change.

## Stability rules
- Do not remove or change existing behavior unless explicitly requested.
- When changing behavior, document the old behavior, new behavior, and migration impact.
- Keep this memory and [CHANGELOG.md](./CHANGELOG.md) in sync.
- Follow repository Copilot guardrails in [.github/copilot-instructions.md](./.github/copilot-instructions.md), including concise code style, extension-safe design, and secure coding standards.

## Implemented features (current baseline)

### 1) App architecture foundation
- Flutter project skeleton with feature-first structure under [apps/visinfo_flutter/lib/src/](./apps/visinfo_flutter/lib/src/).
- Routing shell with Library, Capture, and Settings pages in [app.dart](./apps/visinfo_flutter/lib/src/app/app.dart).
- Supabase runtime initialization in [main.dart](./apps/visinfo_flutter/lib/main.dart).
- Required config guards in [app_config.dart](./apps/visinfo_flutter/lib/src/core/config/app_config.dart).

### 2) Authentication
- Email/password auth service and providers:
  - [auth_service.dart](./apps/visinfo_flutter/lib/src/features/auth/application/auth_service.dart)
  - [auth_providers.dart](./apps/visinfo_flutter/lib/src/features/auth/application/auth_providers.dart)
- Login/create-account UI in [login_page.dart](./apps/visinfo_flutter/lib/src/features/auth/presentation/login_page.dart).

### 3) Photo library/capture baseline
- Photo domain and repository contracts in:
  - [photo_item.dart](./apps/visinfo_flutter/lib/src/features/library/domain/photo_item.dart)
  - [photo_repository.dart](./apps/visinfo_flutter/lib/src/features/library/domain/photo_repository.dart)
- Supabase photo repository in [supabase_photo_repository.dart](./apps/visinfo_flutter/lib/src/features/library/infrastructure/supabase_photo_repository.dart).
- Capture ingestion service in [photo_ingestion_service.dart](./apps/visinfo_flutter/lib/src/features/capture/application/photo_ingestion_service.dart).

### 4) Metadata extraction baseline (mobile-first)
- Local metadata extractor contract and placeholder local LLM behavior:
  - [metadata_extractor.dart](./apps/visinfo_flutter/lib/src/features/metadata_ai/domain/metadata_extractor.dart)
- Metadata pipeline with fallback behavior and logging:
  - [metadata_pipeline_service.dart](./apps/visinfo_flutter/lib/src/features/metadata_ai/application/metadata_pipeline_service.dart)
- Web is intentionally gated from local LLM extraction in v1.

### 5) Tags and collections baseline
- Tag domain/repository and Supabase implementation:
  - [tag_item.dart](./apps/visinfo_flutter/lib/src/features/tags/domain/tag_item.dart)
  - [tag_repository.dart](./apps/visinfo_flutter/lib/src/features/tags/domain/tag_repository.dart)
  - [supabase_tag_repository.dart](./apps/visinfo_flutter/lib/src/features/tags/infrastructure/supabase_tag_repository.dart)
- Collection domain/repository and Supabase implementation:
  - [collection_item.dart](./apps/visinfo_flutter/lib/src/features/collections/domain/collection_item.dart)
  - [collection_repository.dart](./apps/visinfo_flutter/lib/src/features/collections/domain/collection_repository.dart)
  - [supabase_collection_repository.dart](./apps/visinfo_flutter/lib/src/features/collections/infrastructure/supabase_collection_repository.dart)

### 6) Sync engine baseline
- Queue abstractions and processor:
  - [sync_queue_service.dart](./apps/visinfo_flutter/lib/src/features/sync/application/sync_queue_service.dart)
- In-memory store and no-op executor:
  - [in_memory_sync_store.dart](./apps/visinfo_flutter/lib/src/features/sync/infrastructure/in_memory_sync_store.dart)
  - [noop_sync_executor.dart](./apps/visinfo_flutter/lib/src/features/sync/infrastructure/noop_sync_executor.dart)
- Basic sync tests in [sync_queue_service_test.dart](./apps/visinfo_flutter/test/sync_queue_service_test.dart).

### 9) Flutter folder structure best-practice baseline
- `lib/main.dart` remains a thin bootstrap entrypoint.
- Feature/application code lives under `lib/src/`.
- Separation used:
  - `lib/src/app/` for app shell/router
  - `lib/src/core/` for shared cross-cutting concerns
  - `lib/src/features/<feature>/` grouped by feature with layered folders (`presentation`, `application`, `domain`, `infrastructure`) as needed.

### 7) Backend schema and security baseline
- Core schema and RLS in [001_init_visinfo.sql](./supabase/migrations/001_init_visinfo.sql).
- Storage, indexes, and triggers in [002_storage_and_indexes.sql](./supabase/migrations/002_storage_and_indexes.sql).

### 8) Billing foundation
- Entitlement and feature flag schema scaffolding exists.
- Paid gating is not active in v1.

## Compatibility notes to protect
- Keep login flow functional (email/password sign-in and sign-up).
- Keep mobile-only local extraction behavior (web remains gated in v1).
- Keep existing Supabase table names/columns unless migration explicitly updates all call sites.
- Keep sync queue retry semantics intact unless intentionally redesigned.
