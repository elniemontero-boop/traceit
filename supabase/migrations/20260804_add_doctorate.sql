-- Migration to add is_doctorate column to alumni_registrations
ALTER TABLE public.alumni_registrations
  ADD COLUMN IF NOT EXISTS is_doctorate BOOLEAN DEFAULT FALSE;
