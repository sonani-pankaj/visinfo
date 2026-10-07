-- Visinfo initial schema
-- Apply in Supabase SQL editor or migration runner.

create extension if not exists "pgcrypto";

create table if not exists public.photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  storage_path text not null,
  captured_at timestamptz,
  latitude double precision,
  longitude double precision,
  device_model text,
  ai_status text not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.photo_metadata (
  photo_id uuid primary key references public.photos(id) on delete cascade,
  title text,
  summary text,
  confidence numeric(5,4) not null default 0,
  raw_model_output jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.tags (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  color text,
  created_at timestamptz not null default now(),
  constraint tags_user_name_uniq unique (user_id, name)
);

create table if not exists public.photo_tags (
  photo_id uuid not null references public.photos(id) on delete cascade,
  tag_id uuid not null references public.tags(id) on delete cascade,
  assigned_by text not null default 'user',
  created_at timestamptz not null default now(),
  primary key (photo_id, tag_id)
);

create table if not exists public.collections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint collections_user_name_uniq unique (user_id, name)
);

create table if not exists public.collection_items (
  collection_id uuid not null references public.collections(id) on delete cascade,
  photo_id uuid not null references public.photos(id) on delete cascade,
  position integer not null default 0,
  created_at timestamptz not null default now(),
  primary key (collection_id, photo_id)
);

create table if not exists public.sync_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  photo_id uuid references public.photos(id) on delete cascade,
  job_type text not null,
  status text not null default 'queued',
  retries integer not null default 0,
  last_error text,
  updated_at timestamptz not null default now()
);

create table if not exists public.feature_flags (
  key text primary key,
  enabled boolean not null default false,
  rollout_percent integer not null default 0 check (rollout_percent >= 0 and rollout_percent <= 100)
);

create table if not exists public.entitlements (
  user_id uuid primary key references auth.users(id) on delete cascade,
  plan_tier text not null default 'free',
  status text not null default 'active',
  renews_at timestamptz
);

alter table public.photos enable row level security;
alter table public.photo_metadata enable row level security;
alter table public.tags enable row level security;
alter table public.photo_tags enable row level security;
alter table public.collections enable row level security;
alter table public.collection_items enable row level security;
alter table public.sync_jobs enable row level security;
alter table public.entitlements enable row level security;

create policy photos_user_isolation on public.photos
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy photo_metadata_user_isolation on public.photo_metadata
  for all using (
    exists (
      select 1 from public.photos p
      where p.id = photo_id and p.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.photos p
      where p.id = photo_id and p.user_id = auth.uid()
    )
  );

create policy tags_user_isolation on public.tags
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy photo_tags_user_isolation on public.photo_tags
  for all using (
    exists (
      select 1
      from public.photos p
      join public.tags t on t.id = tag_id
      where p.id = photo_id and p.user_id = auth.uid() and t.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.photos p
      join public.tags t on t.id = tag_id
      where p.id = photo_id and p.user_id = auth.uid() and t.user_id = auth.uid()
    )
  );

create policy collections_user_isolation on public.collections
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy collection_items_user_isolation on public.collection_items
  for all using (
    exists (
      select 1 from public.collections c
      where c.id = collection_id and c.user_id = auth.uid()
    )
    and exists (
      select 1 from public.photos p
      where p.id = photo_id and p.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.collections c
      where c.id = collection_id and c.user_id = auth.uid()
    )
    and exists (
      select 1 from public.photos p
      where p.id = photo_id and p.user_id = auth.uid()
    )
  );

create policy sync_jobs_user_isolation on public.sync_jobs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy entitlements_user_isolation on public.entitlements
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- feature_flags is intentionally globally readable; writes restricted to service role.
alter table public.feature_flags enable row level security;
create policy feature_flags_read_all on public.feature_flags for select using (true);
