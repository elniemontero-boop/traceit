import type { AlumniRegistration, Campus, Announcement, UserProfile } from './database'

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      alumni_registrations: {
        Row: AlumniRegistration
        Insert: Omit<AlumniRegistration, 'id' | 'created_at' | 'updated_at' | 'status'> & {
          id?: string
          created_at?: string
          updated_at?: string
          status?: 'pending' | 'approved' | 'declined'
        }
        Update: Partial<AlumniRegistration>
      }
      campuses: {
        Row: Campus
        Insert: Omit<Campus, 'id'> & { id?: string }
        Update: Partial<Campus>
      }
      announcements: {
        Row: Announcement
        Insert: Omit<Announcement, 'id' | 'created_at'> & { id?: string; created_at?: string }
        Update: Partial<Announcement>
      }
      user_profiles: {
        Row: UserProfile
        Insert: UserProfile
        Update: Partial<UserProfile>
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}
