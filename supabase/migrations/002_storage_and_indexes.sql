-- Visinfo storage buckets, indexes, and updated_at trigger.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists photos_set_updated_at on public.photos;
create trigger photos_set_updated_at
before update on public.photos
for each row execute function public.set_updated_at();

drop trigger if exists collections_set_updated_at on public.collections;
create trigger collections_set_updated_at
before update on public.collections
for each row execute function public.set_updated_at();

create index if not exists photos_user_id_created_at_idx on public.photos(user_id, created_at desc);
create index if not exists tags_user_id_name_idx on public.tags(user_id, name);
create index if not exists collections_user_id_name_idx on public.collections(user_id, name);
create index if not exists photo_tags_photo_id_idx on public.photo_tags(photo_id);
create index if not exists collection_items_collection_id_position_idx on public.collection_items(collection_id, position);
create index if not exists sync_jobs_user_id_status_idx on public.sync_jobs(user_id, status, updated_at desc);

insert into storage.buckets (id, name, public, file_size_limit)
values ('photos', 'photos', false, 52428800)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit)
values ('thumbnails', 'thumbnails', false, 5242880)
on conflict (id) do nothing;

drop policy if exists photos_bucket_user_read on storage.objects;
create policy photos_bucket_user_read on storage.objects
for select using (
  bucket_id = 'photos'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists photos_bucket_user_insert on storage.objects;
create policy photos_bucket_user_insert on storage.objects
for insert with check (
  bucket_id = 'photos'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists photos_bucket_user_update on storage.objects;
create policy photos_bucket_user_update on storage.objects
for update using (
  bucket_id = 'photos'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists photos_bucket_user_delete on storage.objects;
create policy photos_bucket_user_delete on storage.objects
for delete using (
  bucket_id = 'photos'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists thumbnails_bucket_user_read on storage.objects;
create policy thumbnails_bucket_user_read on storage.objects
for select using (
  bucket_id = 'thumbnails'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists thumbnails_bucket_user_insert on storage.objects;
create policy thumbnails_bucket_user_insert on storage.objects
for insert with check (
  bucket_id = 'thumbnails'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists thumbnails_bucket_user_update on storage.objects;
create policy thumbnails_bucket_user_update on storage.objects
for update using (
  bucket_id = 'thumbnails'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists thumbnails_bucket_user_delete on storage.objects;
create policy thumbnails_bucket_user_delete on storage.objects
for delete using (
  bucket_id = 'thumbnails'
  and auth.uid()::text = (storage.foldername(name))[1]
);
