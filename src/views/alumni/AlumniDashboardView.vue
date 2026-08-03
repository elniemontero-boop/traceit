<template>
  <div class="dashboard">
    <div v-if="loading" class="loading-text">Loading your dashboard…</div>

    <template v-else-if="registration">
      <div class="status-card" :class="statusClass">
        <span class="status-icon">{{ statusIcon }}</span>
        <div class="status-text">
          <h2>{{ statusHeading }}</h2>
          <p>{{ statusMessage }}</p>
        </div>
      </div>

      <div class="summary-card">
        <h3>Your Registration Summary</h3>
        <div class="summary-grid">
          <div class="summary-item">
            <span class="label">Full Name</span>
            <span class="value">{{ registration.full_name }}</span>
          </div>
          <div class="summary-item">
            <span class="label">Degree Completed</span>
            <span class="value">{{ registration.degree_completed }}</span>
          </div>
          <div class="summary-item">
            <span class="label">Year Graduated</span>
            <span class="value">{{ registration.year_graduated }}</span>
          </div>
          <div class="summary-item">
            <span class="label">Employment Status</span>
            <span class="value">{{ formatEmploymentStatus(registration.employment_status) }}</span>
          </div>
        </div>
        <router-link to="/profile" class="btn-outline">View Full Profile</router-link>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'
import type { AlumniRegistration } from '@/types/database'

const router = useRouter()
const authStore = useAuthStore()

const loading = ref(true)
const registration = ref<AlumniRegistration | null>(null)

onMounted(async () => {
  let regData: any = null

  if (authStore.user?.id) {
    try {
      const { data, error } = await supabase
        .from('alumni_registrations')
        .select('*')
        .eq('user_id', authStore.user.id)
        .maybeSingle()

      if (!error && data) {
        regData = data
      }
    } catch {
      // ignore
    }
  }

  if (!regData) {
    const stored = localStorage.getItem('traceit_registered_alumni_data')
    if (stored) {
      try {
        regData = JSON.parse(stored)
      } catch {
        // ignore
      }
    }
  }

  if (!regData) {
    regData = {
      id: 'reg-default-001',
      user_id: authStore.user?.id || 'mock-alumni-001',
      full_name: authStore.user?.user_metadata?.full_name || authStore.user?.email || 'Juan Dela Cruz',
      maiden_name: '',
      sex_assigned_at_birth: 'male',
      gender: 'Male',
      is_pwd: false,
      civil_status: 'single',
      citizenship: 'Filipino',
      birthday: '1998-05-15',
      mobile_no: '09123456789',
      email_address: authStore.user?.email || 'alumni@rsu.edu.ph',
      social_media_link: 'https://facebook.com/alumni',
      home_address: 'Odiongan, Romblon',
      campus_id: '1',
      degree_completed: 'Bachelor of Science in Information Technology',
      year_graduated: 2024,
      employment_status: 'employed_full_time',
      employment_type: 'private',
      position_job_title: 'Software Developer',
      employer_company_name: 'Tech Solutions Inc.',
      monthly_income_range: '20k_30k',
      data_privacy_consent: true,
      subscribe_news: true,
      subscribe_notifications: true,
      status: 'pending',
      updated_at: new Date().toISOString(),
    }
    localStorage.setItem('traceit_registered_alumni_data', JSON.stringify(regData))
  }

  registration.value = regData as AlumniRegistration
  loading.value = false
})

const statusClass = computed(() => {
  if (!registration.value) return ''
  return `status-${registration.value.status}`
})

const statusIcon = computed(() => {
  switch (registration.value?.status) {
    case 'approved': return '✅'
    case 'declined': return '⚠️'
    default: return '⏳'
  }
})

const statusHeading = computed(() => {
  switch (registration.value?.status) {
    case 'approved': return 'Registration Approved'
    case 'declined': return 'Registration Declined'
    default: return 'Registration Pending'
  }
})

const statusMessage = computed(() => {
  switch (registration.value?.status) {
    case 'approved':
      return 'Your alumni registration has been approved. You now have full access to announcements and alumni activities.'
    case 'declined':
      return registration.value?.admin_remarks
        ? `Your registration was declined. Reason: ${registration.value.admin_remarks}`
        : 'Your registration was declined. Please contact the alumni office for details.'
    default:
      return 'Your registration is currently under review by the RSU Alumni Office. This usually takes a few business days.'
  }
})

function formatEmploymentStatus(status: string) {
  return status
    .split('_')
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(' ')
}
</script>

<style scoped>
.dashboard {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  max-width: 700px;
}

.loading-text {
  color: #558b2f;
  font-size: 0.95rem;
}

.status-card {
  display: flex;
  align-items: center;
  gap: 1rem;
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid #d7ecd8;
}

.status-card.status-pending {
  background-color: #fff8e1;
  border-color: #ffe0b2;
}

.status-card.status-approved {
  background-color: #e8f5e9;
  border-color: #a5d6a7;
}

.status-card.status-declined {
  background-color: #fdecea;
  border-color: #f5c6cb;
}

.status-icon {
  font-size: 2rem;
}

.status-text h2 {
  margin: 0 0 0.3rem;
  font-size: 1.15rem;
  color: #1b5e20;
}

.status-text p {
  margin: 0;
  font-size: 0.9rem;
  color: #4a4a4a;
  line-height: 1.5;
}

.summary-card {
  background-color: #ffffff;
  border: 1px solid #d7ecd8;
  border-radius: 12px;
  padding: 1.5rem;
}

.summary-card h3 {
  color: #1b5e20;
  margin: 0 0 1.2rem;
  font-size: 1.05rem;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1.2rem;
  margin-bottom: 1.5rem;
}

.summary-item {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.summary-item .label {
  font-size: 0.78rem;
  color: #558b2f;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.summary-item .value {
  font-size: 0.95rem;
  color: #2e2e2e;
  font-weight: 500;
}

.btn-outline {
  display: inline-block;
  border: 1px solid #2e7d32;
  color: #2e7d32;
  padding: 0.6rem 1.3rem;
  border-radius: 8px;
  text-decoration: none;
  font-size: 0.9rem;
  font-weight: 600;
}

.btn-outline:hover {
  background-color: #eef7ee;
}

@media (max-width: 560px) {
  .status-card {
    flex-direction: column;
    align-items: flex-start;
    padding: 1.2rem;
    gap: 0.6rem;
  }
  .summary-card {
    padding: 1.2rem;
  }
  .summary-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  .btn-outline {
    display: block;
    width: 100%;
    text-align: center;
    padding: 0.75rem 1rem;
  }
}
</style>