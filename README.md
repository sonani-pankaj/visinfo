# Visinfo

Cross-platform photo intelligence app for Android, iOS, and Web.

## V1 scope
- Capture/upload photos
- Organize with custom tags and collections
- Cloud sync with Supabase
- Mobile-only on-device metadata extraction (local LLM)
- Web supports upload/view/tag/collections (no local LLM extraction in V1)

## Project layout
- `apps/visinfo_flutter` — Flutter app for Android/iOS/Web
- `supabase/migrations` — SQL schema and RLS migrations

### Flutter folder structure
- `lib/main.dart` — bootstrap only
- `lib/src/app/` — app shell/router composition
- `lib/src/core/` — shared config, observability, and cross-cutting concerns
- `lib/src/features/` — feature modules (auth, capture, library, metadata, sync, etc.)

## Quick start
1. Install Flutter SDK.
2. Create a Supabase project.
3. Provide runtime vars:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Run:
   ```bash
   flutter pub get
   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
   ```

## Database migrations
- [001_init_visinfo.sql](./supabase/migrations/001_init_visinfo.sql): core tables, RLS, and entitlement scaffold.
- [002_storage_and_indexes.sql](./supabase/migrations/002_storage_and_indexes.sql): storage buckets/policies, indexes, and update triggers.

## Foundation implemented
- Auth service and login page with email/password
- Repository contracts + Supabase implementations for photos, tags, and collections
- Local-first sync queue service scaffold
- Mobile-only metadata extraction gate with EXIF fallback path
- Basic observability logger wiring for metadata and sync workflows
- Sync queue unit tests scaffold in [sync_queue_service_test.dart](./apps/visinfo_flutter/test/sync_queue_service_test.dart)

## Project memory and change tracking
- Implementation memory (feature baseline and compatibility constraints): [IMPLEMENTATION_MEMORY.md](./IMPLEMENTATION_MEMORY.md)
- Ongoing implementation changelog: [CHANGELOG.md](./CHANGELOG.md)
