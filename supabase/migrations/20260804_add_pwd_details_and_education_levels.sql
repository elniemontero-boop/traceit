-- Migration to add pwd_details, is_bachelors, and is_masters to alumni_registrations
ALTER TABLE public.alumni_registrations
  ADD COLUMN IF NOT EXISTS pwd_details TEXT,
  ADD COLUMN IF NOT EXISTS is_bachelors BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS is_masters BOOLEAN DEFAULT FALSE;
