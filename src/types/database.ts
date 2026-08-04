export type RegistrationStatus = 'pending' | 'approved' | 'declined'

export interface Campus {
  id: string
  name: string
  code: string
  created_at?: string
}

export interface AlumniRegistration {
  id: string
  user_id: string
  full_name: string
  maiden_name: string | null
  sex_assigned_at_birth: string
  gender: string
  is_pwd: boolean
  pwd_details?: string | null
  civil_status: string
  citizenship: string
  birthday: string
  mobile_no: string
  email_address: string
  social_media_link: string | null
  home_address: string
  campus_id: string
  degree_completed: string
  is_bachelors?: boolean
  is_masters?: boolean
  year_graduated: number
  employment_status: string
  employment_type: string | null
  position_job_title: string | null
  employer_company_name: string | null
  monthly_income_range: string | null
  data_privacy_consent: boolean
  subscribe_news: boolean
  subscribe_notifications: boolean
  status: RegistrationStatus
  reviewed_by: string | null
  reviewed_at: string | null
  admin_remarks: string | null
  created_at: string
  updated_at: string
  campuses?: { name: string } | null
}

export interface Announcement {
  id: string
  title: string
  content: string
  category: string
  is_pinned: boolean
  created_at: string
  created_by?: string
  author_name?: string
}

export interface UserProfile {
  id: string
  user_id: string
  email: string
  full_name: string
  role: 'admin' | 'alumni'
  created_at: string
}