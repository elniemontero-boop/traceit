-- Run this once in the Supabase SQL Editor after replacing the email address.
-- This is required for an account that should be allowed to publish announcements.

update public.user_profiles
set role = 'admin'
where email = 'YOUR_ADMIN_EMAIL';

-- Verify that exactly one row is returned and its role is "admin".
select email, role
from public.user_profiles
where email = 'YOUR_ADMIN_EMAIL';
