-- TraceIt complete Supabase setup (safe to run more than once)
create extension if not exists "uuid-ossp";

create table if not exists public.campuses (
  id uuid primary key default uuid_generate_v4(),
  name text not null unique,
  code text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.user_profiles (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null,
  role text not null default 'alumni' check (role in ('admin', 'alumni')),
  created_at timestamptz not null default now()
);

-- Upgrade older campus tables that were created before the `code` column.
alter table public.campuses add column if not exists code text;
create unique index if not exists campuses_name_unique on public.campuses (name);

create table if not exists public.alumni_registrations (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  full_name text not null,
  maiden_name text,
  sex_assigned_at_birth text not null,
  gender text not null,
  is_pwd boolean not null default false,
  civil_status text not null,
  citizenship text not null default 'Filipino',
  birthday date not null,
  mobile_no text not null,
  email_address text not null,
  social_media_link text,
  home_address text not null,
  campus_id uuid references public.campuses(id),
  degree_completed text not null,
  year_graduated integer not null,
  employment_status text not null,
  employment_type text,
  position_job_title text,
  employer_company_name text,
  monthly_income_range text,
  data_privacy_consent boolean not null default true,
  subscribe_news boolean not null default true,
  subscribe_notifications boolean not null default true,
  status text not null default 'pending' check (status in ('pending', 'approved', 'declined')),
  reviewed_by uuid references auth.users(id),
  reviewed_at timestamptz,
  admin_remarks text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Upgrade older registration tables without removing existing records.
alter table public.alumni_registrations
  add column if not exists maiden_name text,
  add column if not exists sex_assigned_at_birth text,
  add column if not exists gender text,
  add column if not exists is_pwd boolean default false,
  add column if not exists civil_status text,
  add column if not exists citizenship text default 'Filipino',
  add column if not exists birthday date,
  add column if not exists mobile_no text,
  add column if not exists email_address text,
  add column if not exists social_media_link text,
  add column if not exists home_address text,
  add column if not exists campus_id uuid references public.campuses(id),
  add column if not exists degree_completed text,
  add column if not exists year_graduated integer,
  add column if not exists employment_status text,
  add column if not exists employment_type text,
  add column if not exists position_job_title text,
  add column if not exists employer_company_name text,
  add column if not exists monthly_income_range text,
  add column if not exists data_privacy_consent boolean default true,
  add column if not exists subscribe_news boolean default true,
  add column if not exists subscribe_notifications boolean default true,
  add column if not exists status text default 'pending',
  add column if not exists reviewed_by uuid references auth.users(id),
  add column if not exists reviewed_at timestamptz,
  add column if not exists admin_remarks text,
  add column if not exists updated_at timestamptz default now();

create table if not exists public.announcements (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  content text not null,
  category text not null default 'General',
  is_pinned boolean not null default false,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

-- Upgrade announcement tables created by older versions of the app.
alter table public.announcements
  add column if not exists title text,
  add column if not exists content text,
  add column if not exists category text not null default 'General',
  add column if not exists is_pinned boolean not null default false,
  add column if not exists created_by uuid references auth.users(id),
  add column if not exists created_at timestamptz not null default now();

-- Preserve messages from an older schema that used `body` instead of `content`.
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

-- Preserve compatibility with an older required `posted_by` author column.
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

insert into public.campuses (name, code) values
  ('RSU Main Campus (Odiongan)', 'MAIN'),
  ('RSU Romblon Campus', 'ROMBLON'),
  ('RSU Cajidiocan Campus', 'CAJIDIOCAN'),
  ('RSU San Fernando Campus', 'SAN_FERNANDO'),
  ('RSU Magdiwang Campus', 'MAGDIWANG'),
  ('RSU Calatrava Campus', 'CALATRAVA'),
  ('RSU Santa Maria Campus', 'STA_MARIA'),
  ('RSU San Agustin Campus', 'SAN_AGUSTIN')
on conflict (name) do update set code = excluded.code;

create unique index if not exists campuses_code_unique
  on public.campuses (code)
  where code is not null;

-- Every newly registered Auth user gets an alumni profile. Admin accounts are
-- promoted manually below, never from editable browser metadata.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.user_profiles (user_id, email, full_name, role)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'full_name', new.email, 'Alumni'),
    'alumni'
  )
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Also create profiles for accounts that existed before this script was run.
insert into public.user_profiles (user_id, email, full_name, role)
select
  id,
  coalesce(email, ''),
  coalesce(raw_user_meta_data ->> 'full_name', email, 'Alumni'),
  'alumni'
from auth.users
on conflict (user_id) do nothing;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists alumni_registrations_set_updated_at on public.alumni_registrations;
create trigger alumni_registrations_set_updated_at
  before update on public.alumni_registrations
  for each row execute procedure public.set_updated_at();

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.user_profiles
    where user_id = auth.uid() and role = 'admin'
  );
$$;

alter table public.campuses enable row level security;
alter table public.user_profiles enable row level security;
alter table public.alumni_registrations enable row level security;
alter table public.announcements enable row level security;

drop policy if exists "Anyone can view campuses" on public.campuses;
create policy "Anyone can view campuses" on public.campuses
  for select using (true);

drop policy if exists "Users can view own profile" on public.user_profiles;
create policy "Users can view own profile" on public.user_profiles
  for select using (auth.uid() = user_id or public.is_admin());

drop policy if exists "Alumni can view own registration" on public.alumni_registrations;
create policy "Alumni can view own registration" on public.alumni_registrations
  for select using (auth.uid() = user_id);

drop policy if exists "Admins can view all alumni registrations" on public.alumni_registrations;
create policy "Admins can view all alumni registrations" on public.alumni_registrations
  for select using (public.is_admin());

drop policy if exists "Alumni can insert own registration" on public.alumni_registrations;
create policy "Alumni can insert own registration" on public.alumni_registrations
  for insert with check (auth.uid() = user_id and status = 'pending');

drop policy if exists "Alumni can update own pending registration" on public.alumni_registrations;
create policy "Alumni can update own pending registration" on public.alumni_registrations
  for update using (auth.uid() = user_id and status = 'pending')
  with check (auth.uid() = user_id and status = 'pending');

drop policy if exists "Admins can review alumni registrations" on public.alumni_registrations;
create policy "Admins can review alumni registrations" on public.alumni_registrations
  for update using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "Anyone can view announcements" on public.announcements;
create policy "Anyone can view announcements" on public.announcements
  for select using (true);

drop policy if exists "Admins can manage announcements" on public.announcements;
create policy "Admins can manage announcements" on public.announcements
  for all using (public.is_admin()) with check (public.is_admin());

grant usage on schema public to anon, authenticated;
grant select on public.campuses, public.announcements to anon, authenticated;
grant select on public.user_profiles, public.alumni_registrations to authenticated;
grant insert, update on public.alumni_registrations to authenticated;
grant insert, update, delete on public.announcements to authenticated;
grant execute on function public.is_admin() to authenticated;

notify pgrst, 'reload schema';

-- IMPORTANT: Replace this email with the email you use for the admin login.
-- Run this statement after editing it to promote that account.
-- update public.user_profiles set role = 'admin' where email = 'YOUR_ADMIN_EMAIL';
