-- Apply this migration to existing Supabase projects.
-- It upgrades older announcement tables and allows only administrators to
-- publish or remove announcements.

create extension if not exists "uuid-ossp";

create table if not exists public.announcements (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  content text not null,
  category text not null default 'General',
  is_pinned boolean not null default false,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

-- Older versions of the project created the table without some of these fields.
alter table public.announcements
  add column if not exists title text,
  add column if not exists content text,
  add column if not exists category text not null default 'General',
  add column if not exists is_pinned boolean not null default false,
  add column if not exists created_by uuid references auth.users(id),
  add column if not exists created_at timestamptz not null default now();

-- The earliest version of this project called the message column `body`.
-- Preserve existing messages and stop that legacy column from blocking inserts
-- made by the current app, which uses `content`.
do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'announcements'
      and column_name = 'body'
  ) then
    update public.announcements
    set content = body
    where content is null and body is not null;

    alter table public.announcements
      alter column body drop not null;
  end if;
end;
$$;

-- Another legacy schema used `posted_by` as a required author field.
-- Keep existing values while allowing the current app's `created_by` field.
do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'announcements'
      and column_name = 'posted_by'
  ) then
    update public.announcements
    set created_by = posted_by
    where created_by is null and posted_by is not null;

    alter table public.announcements
      alter column posted_by drop not null;
  end if;
end;
$$;

alter table public.announcements enable row level security;

drop policy if exists "Admins can create announcements" on public.announcements;
create policy "Admins can create announcements"
on public.announcements for insert
with check (public.is_admin());

drop policy if exists "Admins can delete announcements" on public.announcements;
create policy "Admins can delete announcements"
on public.announcements for delete
using (public.is_admin());

-- Make PostgREST recognize the new columns immediately.
notify pgrst, 'reload schema';
