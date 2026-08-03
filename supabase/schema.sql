-- TraceIt: Romblon State University Alumni Tracer Database Schema

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Campuses Table
CREATE TABLE IF NOT EXISTS public.campuses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed RSU Campuses
INSERT INTO public.campuses (name, code) VALUES
  ('RSU Main Campus (Odiongan)', 'MAIN'),
  ('RSU Romblon Campus', 'ROMBLON'),
  ('RSU Cajidiocan Campus', 'CAJIDIOCAN'),
  ('RSU San Fernando Campus', 'SAN_FERNANDO'),
  ('RSU Magdiwang Campus', 'MAGDIWANG'),
  ('RSU Calatrava Campus', 'CALATRAVA'),
  ('RSU Santa Maria Campus', 'STA_MARIA'),
  ('RSU San Agustin Campus', 'SAN_AGUSTIN')
ON CONFLICT (name) DO NOTHING;

-- 2. User Profiles Table
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'alumni' CHECK (role IN ('admin', 'alumni')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Alumni Registrations Table
CREATE TABLE IF NOT EXISTS public.alumni_registrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  maiden_name TEXT,
  sex_assigned_at_birth TEXT NOT NULL,
  gender TEXT NOT NULL,
  is_pwd BOOLEAN DEFAULT FALSE,
  civil_status TEXT NOT NULL,
  citizenship TEXT NOT NULL DEFAULT 'Filipino',
  birthday DATE NOT NULL,
  mobile_no TEXT NOT NULL,
  email_address TEXT NOT NULL,
  social_media_link TEXT,
  home_address TEXT NOT NULL,
  campus_id UUID REFERENCES public.campuses(id),
  degree_completed TEXT NOT NULL,
  year_graduated INTEGER NOT NULL,
  employment_status TEXT NOT NULL,
  employment_type TEXT,
  position_job_title TEXT,
  employer_company_name TEXT,
  monthly_income_range TEXT,
  data_privacy_consent BOOLEAN DEFAULT TRUE,
  subscribe_news BOOLEAN DEFAULT TRUE,
  subscribe_notifications BOOLEAN DEFAULT TRUE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'declined')),
  reviewed_by UUID REFERENCES auth.users(id),
  reviewed_at TIMESTAMPTZ,
  admin_remarks TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Announcements Table
CREATE TABLE IF NOT EXISTS public.announcements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT DEFAULT 'General',
  is_pinned BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.campuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alumni_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Campuses are viewable by everyone" ON public.campuses FOR SELECT USING (true);
CREATE POLICY "Public announcements viewable by everyone" ON public.announcements FOR SELECT USING (true);
CREATE POLICY "Alumni can view own registration" ON public.alumni_registrations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Alumni can insert own registration" ON public.alumni_registrations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Alumni can update own pending registration" ON public.alumni_registrations FOR UPDATE USING (auth.uid() = user_id AND status = 'pending');
