<template>
  <div class="review-page">
    <router-link to="/admin/alumni" class="back-link">← Back to Alumni List</router-link>

    <div v-if="loading" class="loading-text">Loading registration…</div>

    <div v-else-if="!registration" class="empty-state">Registration not found.</div>

    <template v-else>
      <div class="header-row">
        <h1>{{ registration.full_name }}</h1>
        <span class="status-badge" :class="`status-${registration.status}`">
          {{ registration.status }}
        </span>
      </div>

      <div class="details-card">
        <h2>Part 1: Personal Information</h2>
        <div class="details-grid">
          <div class="detail-item"><span class="label">Full Name</span><span>{{ registration.full_name }}</span></div>
          <div class="detail-item"><span class="label">Maiden Name</span><span>{{ registration.maiden_name || '—' }}</span></div>
          <div class="detail-item"><span class="label">Sex Assigned at Birth</span><span>{{ registration.sex_assigned_at_birth }}</span></div>
          <div class="detail-item"><span class="label">Gender</span><span>{{ registration.gender }}</span></div>
          <div class="detail-item"><span class="label">PWD</span><span>{{ registration.is_pwd ? (registration.pwd_details ? `Yes (${registration.pwd_details})` : 'Yes') : 'No' }}</span></div>
          <div class="detail-item"><span class="label">Civil Status</span><span>{{ registration.civil_status }}</span></div>
          <div class="detail-item"><span class="label">Citizenship</span><span>{{ registration.citizenship }}</span></div>
          <div class="detail-item"><span class="label">Birthday</span><span>{{ registration.birthday }}</span></div>
          <div class="detail-item"><span class="label">Mobile No.</span><span>{{ registration.mobile_no }}</span></div>
          <div class="detail-item"><span class="label">Email</span><span>{{ registration.email_address }}</span></div>
          <div class="detail-item"><span class="label">Social Media</span><span>{{ registration.social_media_link || '—' }}</span></div>
          <div class="detail-item full-width"><span class="label">Home Address</span><span>{{ registration.home_address }}</span></div>
        </div>
      </div>

      <div class="details-card">
        <h2>Part 2: Education</h2>
        <div class="details-grid">
          <div class="detail-item"><span class="label">Campus</span><span>{{ registration.campuses?.name ?? '—' }}</span></div>
          <div class="detail-item"><span class="label">Degree Level</span><span>{{ formatDegreeLevel(registration) }}</span></div>
          <div class="detail-item"><span class="label">Degree Completed</span><span>{{ registration.degree_completed }}</span></div>
          <div class="detail-item"><span class="label">Year Graduated</span><span>{{ registration.year_graduated }}</span></div>
        </div>
      </div>

      <div class="details-card">
        <h2>Part 3: Employment</h2>
        <div class="details-grid">
          <div class="detail-item"><span class="label">Employment Status</span><span>{{ formatLabel(registration.employment_status) }}</span></div>
          <div class="detail-item"><span class="label">Employment Type</span><span>{{ registration.employment_type ? formatLabel(registration.employment_type) : '—' }}</span></div>
          <div class="detail-item"><span class="label">Position / Job Title</span><span>{{ registration.position_job_title || '—' }}</span></div>
        </div>
      </div>

      <div class="details-card">
        <h2>Part 4: Privacy Preferences</h2>
        <div class="details-grid">
          <div class="detail-item"><span class="label">Data Privacy Consent</span><span>{{ registration.data_privacy_consent ? 'Yes' : 'No' }}</span></div>
          <div class="detail-item"><span class="label">Subscribed to News</span><span>{{ registration.subscribe_news ? 'Yes' : 'No' }}</span></div>
          <div class="detail-item"><span class="label">Subscribed to Notifications</span><span>{{ registration.subscribe_notifications ? 'Yes' : 'No' }}</span></div>
        </div>
      </div>

      <div class="review-card">
        <h2>Admin Decision</h2>

        <label class="field">
          <span>Remarks (optional, shown to alumni if declined)</span>
          <textarea v-model="remarks" rows="3" placeholder="e.g. Missing valid ID, please resubmit."></textarea>
        </label>

        <p v-if="errorMessage" class="error-text">{{ errorMessage }}</p>
        <p v-if="successMessage" class="success-text">{{ successMessage }}</p>

        <div class="decision-actions">
          <button
            type="button"
            class="btn-decline"
            :disabled="processing"
            @click="handleDecision('declined')"
          >
            {{ processing && pendingDecision === 'declined' ? 'Declining…' : 'Decline' }}
          </button>
          <button
            type="button"
            class="btn-approve"
            :disabled="processing"
            @click="handleDecision('approved')"
          >
            {{ processing && pendingDecision === 'approved' ? 'Approving…' : 'Approve' }}
          </button>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'

const props = defineProps<{ id: string }>()
const router = useRouter()
const authStore = useAuthStore()

interface FullRegistration {
  id: string
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
  degree_completed: string
  is_bachelors?: boolean
  is_masters?: boolean
  year_graduated: number
  employment_status: string
  employment_type: string | null
  position_job_title: string | null
  data_privacy_consent: boolean
  subscribe_news: boolean
  subscribe_notifications: boolean
  status: string
  campuses: { name: string } | null
}

function formatDegreeLevel(reg: FullRegistration): string {
  const levels: string[] = []
  if (reg.is_bachelors) levels.push("Bachelor's")
  if (reg.is_masters) levels.push("Master's")
  return levels.length > 0 ? levels.join(', ') : '—'
}

const loading = ref(true)
const processing = ref(false)
const pendingDecision = ref<'approved' | 'declined' | null>(null)
const errorMessage = ref('')
const successMessage = ref('')
const registration = ref<FullRegistration | null>(null)
const remarks = ref('')

onMounted(async () => {
  const { data, error } = await supabase
    .from('alumni_registrations')
    .select('*, campuses(name)')
    .eq('id', props.id)
    .maybeSingle()

  if (!error && data) {
    registration.value = data as unknown as FullRegistration
  }

  loading.value = false
})

async function handleDecision(decision: 'approved' | 'declined') {
  if (!registration.value) return

  errorMessage.value = ''
  successMessage.value = ''
  processing.value = true
  pendingDecision.value = decision

  const { error } = await supabase
    .from('alumni_registrations')
    .update({
      status: decision,
      reviewed_by: authStore.user!.id,
      reviewed_at: new Date().toISOString(),
      admin_remarks: remarks.value || null,
      updated_at: new Date().toISOString(),
    })
    .eq('id', registration.value.id)

  processing.value = false

  if (error) {
    errorMessage.value = error.message
    return
  }

  successMessage.value = `Registration ${decision} successfully.`
  registration.value.status = decision

  setTimeout(() => {
    router.push('/admin/alumni')
  }, 1200)
}

function formatLabel(value: string) {
  return value
    .split('_')
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(' ')
}
</script>

<style scoped>
.review-page {
  max-width: 800px;
}

.back-link {
  display: inline-block;
  color: #2e7d32;
  font-size: 0.85rem;
  text-decoration: none;
  margin-bottom: 1.2rem;
}

.back-link:hover {
  text-decoration: underline;
}

.loading-text,
.empty-state {
  color: #558b2f;
  font-size: 0.9rem;
}

.header-row {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.header-row h1 {
  color: #1b5e20;
  font-size: 1.4rem;
  margin: 0;
}

.status-badge {
  font-size: 0.75rem;
  font-weight: 700;
  padding: 0.25rem 0.7rem;
  border-radius: 999px;
  text-transform: capitalize;
}

.status-badge.status-pending { background-color: #fff8e1; color: #f9a825; }
.status-badge.status-approved { background-color: #e8f5e9; color: #2e7d32; }
.status-badge.status-declined { background-color: #fdecea; color: #c62828; }

.details-card {
  background-color: #ffffff;
  border: 1px solid #d7ecd8;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.2rem;
}

.details-card h2 {
  color: #1b5e20;
  font-size: 1rem;
  margin: 0 0 1rem;
}

.details-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem 1.5rem;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  font-size: 0.88rem;
}

.detail-item.full-width {
  grid-column: 1 / -1;
}

.detail-item .label {
  font-size: 0.75rem;
  color: #558b2f;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.review-card {
  background-color: #f1f8f1;
  border: 1px solid #d7ecd8;
  border-radius: 12px;
  padding: 1.5rem;
}

.review-card h2 {
  color: #1b5e20;
  font-size: 1rem;
  margin: 0 0 1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  font-size: 0.88rem;
  margin-bottom: 1rem;
}

.field textarea {
  padding: 0.6rem 0.75rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  font-family: inherit;
  outline: none;
  resize: vertical;
}

.field textarea:focus {
  border-color: #2e7d32;
}

.error-text {
  color: #c62828;
  font-size: 0.85rem;
}

.success-text {
  color: #2e7d32;
  font-size: 0.85rem;
}

.decision-actions {
  display: flex;
  gap: 1rem;
  margin-top: 0.5rem;
}

.btn-approve {
  background-color: #2e7d32;
  color: #ffffff;
  border: none;
  padding: 0.7rem 1.4rem;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-approve:hover:not(:disabled) {
  background-color: #1b5e20;
}

.btn-decline {
  background-color: #ffffff;
  color: #c62828;
  border: 1px solid #c62828;
  padding: 0.7rem 1.4rem;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-decline:hover:not(:disabled) {
  background-color: #fdecea;
}

.btn-approve:disabled,
.btn-decline:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media (max-width: 560px) {
  .header-row {
    flex-wrap: wrap;
    gap: 0.5rem;
  }
  .details-card {
    padding: 1.1rem;
  }
  .details-grid {
    grid-template-columns: 1fr;
    gap: 0.85rem;
  }
  .decision-actions {
    flex-direction: column;
    width: 100%;
  }
  .btn-approve,
  .btn-decline {
    width: 100%;
    text-align: center;
    padding: 0.85rem;
  }
}
</style>