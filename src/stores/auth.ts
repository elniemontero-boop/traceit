import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

export interface AuthUser {
  id: string
  email: string
  user_metadata?: {
    full_name?: string
    role?: 'admin' | 'alumni'
  }
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<AuthUser | null>(null)
  const role = ref<'admin' | 'alumni' | null>(null)
  const approvalStatus = ref<'pending' | 'approved' | 'declined' | null>(null)
  const loading = ref(true)
  const initialized = ref(false)

  const isLoggedIn = computed(() => !!user.value)
  const isAdmin = computed(() => role.value === 'admin')
  const isAlumni = computed(() => role.value === 'alumni')
  const isApprovedAlumni = computed(() => isAlumni.value && approvalStatus.value === 'approved')

  async function fetchRole() {
    if (!user.value) {
      role.value = null
      approvalStatus.value = null
      return
    }

    try {
      // Roles must come from the database. User metadata and email addresses
      // are client-controlled and must never grant administrator privileges.
      const { data, error } = await supabase
        .from('user_profiles')
        .select('role')
        .eq('user_id', user.value.id)
        .maybeSingle()

      if (!error && data?.role) {
        role.value = data.role
        return
      }

      // Default role to alumni
      role.value = 'alumni'
    } catch {
      role.value = 'alumni'
    }
  }

  async function fetchApprovalStatus() {
    if (!user.value || role.value !== 'alumni') {
      approvalStatus.value = null
      return null
    }

    const { data, error } = await supabase
      .from('alumni_registrations')
      .select('status')
      .eq('user_id', user.value.id)
      .maybeSingle()

    approvalStatus.value = !error && data ? data.status : null
    return approvalStatus.value
  }

  async function init() {
    if (initialized.value) return
    loading.value = true

    try {
      const { data: sessionData } = await supabase.auth.getSession()
      if (sessionData.session?.user) {
        const u = sessionData.session.user
        user.value = {
          id: u.id,
          email: u.email || '',
          user_metadata: u.user_metadata as any,
        }
        await fetchRole()
        await fetchApprovalStatus()
      } else {
        // Check for local storage mock user for offline dev testing
        const storedMock = localStorage.getItem('traceit_mock_user')
        if (storedMock) {
          const parsed = JSON.parse(storedMock)
          user.value = parsed.user
          role.value = parsed.role
          approvalStatus.value = parsed.approvalStatus || (parsed.role === 'alumni' ? 'approved' : null)
        }
      }
    } catch (e) {
      console.warn('Auth init check:', e)
    } finally {
      loading.value = false
      initialized.value = true
    }

    supabase.auth.onAuthStateChange(async (_event, session) => {
      if (session?.user) {
        const u = session.user
        user.value = {
          id: u.id,
          email: u.email || '',
          user_metadata: u.user_metadata as any,
        }
        await fetchRole()
        await fetchApprovalStatus()
      } else {
        const storedMock = localStorage.getItem('traceit_mock_user')
        if (!storedMock) {
          user.value = null
          role.value = null
          approvalStatus.value = null
        }
      }
    })
  }

  function setMockUser(selectedRole: 'admin' | 'alumni') {
    const mockId = selectedRole === 'admin' ? 'mock-admin-001' : 'mock-alumni-001'
    const mockEmail = selectedRole === 'admin' ? 'admin@rsu.edu.ph' : 'alumni@rsu.edu.ph'
    const mockName = selectedRole === 'admin' ? 'Admin User' : 'Juan Dela Cruz'

    user.value = {
      id: mockId,
      email: mockEmail,
      user_metadata: {
        full_name: mockName,
        role: selectedRole,
      },
    }
    role.value = selectedRole
    approvalStatus.value = selectedRole === 'alumni' ? 'approved' : null

    localStorage.setItem(
      'traceit_mock_user',
      JSON.stringify({ user: user.value, role: selectedRole, approvalStatus: approvalStatus.value })
    )
  }

  async function signOut() {
    try {
      await supabase.auth.signOut()
    } catch {
      // ignore
    }
    localStorage.removeItem('traceit_mock_user')
    user.value = null
    role.value = null
    approvalStatus.value = null
  }

  return {
    user,
    role,
    loading,
    initialized,
    isLoggedIn,
    isAdmin,
    isAlumni,
    isApprovedAlumni,
    approvalStatus,
    init,
    fetchRole,
    fetchApprovalStatus,
    setMockUser,
    signOut,
  }
})
