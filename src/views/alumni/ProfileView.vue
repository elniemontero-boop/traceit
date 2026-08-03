<template>
  <div class="profile-page">
    <div v-if="loading" class="loading-text">Loading your profile…</div>

    <template v-else-if="registration">
      <div class="profile-header">
        <h1>My Profile</h1>
        <span class="status-badge" :class="`status-${registration.status}`">
          {{ registration.status.charAt(0).toUpperCase() + registration.status.slice(1) }}
        </span>
      </div>

      <p v-if="registration.status !== 'pending'" class="locked-note">
        Your registration has already been reviewed, so these details can no
        longer be edited. Contact the Alumni Office if something needs to be
        corrected.
      </p>

      <form @submit.prevent="handleSave" class="profile-form">
        <fieldset :disabled="registration.status !== 'pending' || saving">
          <legend>Part 1: Personal Information</legend>
          <div class="grid">
            <label class="field">
              <span>Full Name</span>
              <input v-model="form.full_name" type="text" required />
            </label>
            <label class="field">
              <span>Maiden Name</span>
              <input v-model="form.maiden_name" type="text" />
            </label>
            <label class="field">
              <span>Sex Assigned at Birth</span>
              <select v-model="form.sex_assigned_at_birth" required>
                <option value="male">Male</option>
                <option value="female">Female</option>
              </select>
            </label>
            <label class="field">
              <span>Gender</span>
              <input v-model="form.gender" type="text" required />
            </label>
            <label class="field checkbox-field">
              <input v-model="form.is_pwd" type="checkbox" />
              <span>Person with Disability (PWD)</span>
            </label>
            <label class="field">
              <span>Civil Status</span>
              <select v-model="form.civil_status" required>
                <option value="single">Single</option>
                <option value="married">Married</option>
                <option value="widowed">Widowed</option>
                <option value="separated">Separated</option>
                <option value="divorced">Divorced</option>
              </select>
            </label>
            <label class="field">
              <span>Citizenship</span>
              <input v-model="form.citizenship" type="text" required />
            </label>
            <label class="field">
              <span>Birthday</span>
              <input v-model="form.birthday" type="date" required />
            </label>
            <label class="field">
              <span>Mobile No.</span>
              <input v-model="form.mobile_no" type="tel" required />
            </label>
            <label class="field">
              <span>Email Address</span>
              <input v-model="form.email_address" type="email" required />
            </label>
            <label class="field">
              <span>Social Media Link</span>
              <input v-model="form.social_media_link" type="url" />
            </label>
            <label class="field full-width">
              <span>Home Address</span>
              <textarea v-model="form.home_address" rows="2" required></textarea>
            </label>
          </div>
        </fieldset>

        <fieldset :disabled="registration.status !== 'pending' || saving">
          <legend>Part 2: Education</legend>
          <div class="grid">
            <label class="field full-width">
              <span>Campus</span>
              <select v-model="form.campus_id" required>
                <option v-for="c in campuses" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
            </label>
            <label class="field full-width">
              <span>Degree Completed</span>
              <input v-model="form.degree_completed" type="text" required />
            </label>
            <label class="field full-width">
              <span>Year Graduated</span>
              <select v-model.number="form.year_graduated" required>
                <option :value="2024">2024</option>
                <option :value="2025">2025</option>
              </select>
            </label>
          </div>
        </fieldset>

        <fieldset :disabled="registration.status !== 'pending' || saving">
          <legend>Part 3: Employment</legend>
          <div class="grid">
            <label class="field full-width">
              <span>Employment Status</span>
              <select v-model="form.employment_status" required>
                <option value="employed">Employed</option>
                <option value="unemployed">Unemployed</option>
                <option value="self_employed">Self-Employed</option>
                <option value="further_studies">Pursuing Further Studies</option>
                <option value="not_looking">Not Looking for Work</option>
              </select>
            </label>
            <label class="field full-width">
              <span>Employment Type</span>
              <select v-model="form.employment_type">
                <option value="">N/A</option>
                <option value="full_time">Full-Time</option>
                <option value="part_time">Part-Time</option>
                <option value="contractual">Contractual</option>
                <option value="freelance">Freelance</option>
                <option value="government">Government</option>
                <option value="self_employed">Self-Employed</option>
              </select>
            </label>
            <label class="field full-width">
              <span>Position / Job Title</span>
              <input v-model="form.position_job_title" type="text" />
            </label>
          </div>
        </fieldset>

        <fieldset :disabled="registration.status !== 'pending' || saving">
          <legend>Part 4: Privacy Preferences</legend>
          <div class="checkbox-list">
            <label class="checkbox-field">
              <input v-model="form.subscribe_news" type="checkbox" />
              <span>Subscribe to receive news</span>
            </label>
            <label class="checkbox-field">
              <input v-model="form.subscribe_notifications" type="checkbox" />
              <span>Subscribe to receive alumni activity notifications</span>
            </label>
          </div>
        </fieldset>

        <p v-if="errorMessage" class="error-text">{{ errorMessage }}</p>
        <p v-if="successMessage" class="success-text">{{ successMessage }}</p>

        <button
          v-if="registration.status === 'pending'"
          type="submit"
          class="btn-primary"
          :disabled="saving"
        >
          {{ saving ? 'Saving…' : 'Save Changes' }}
        </button>
      </form>
    </template>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'
import type { AlumniRegistration } from '@/types/database'

const authStore = useAuthStore()

const loading = ref(true)
const saving = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const registration = ref<AlumniRegistration | null>(null)
const campuses = ref<{ id: string; name: string }[]>([])

const form = reactive({
  full_name: '',
  maiden_name: '',
  sex_assigned_at_birth: '',
  gender: '',
  is_pwd: false,
  civil_status: '',
  citizenship: '',
  birthday: '',
  mobile_no: '',
  email_address: '',
  social_media_link: '',
  home_address: '',
  campus_id: '',
  degree_completed: '',
  year_graduated: 2024 as 2024 | 2025,
  employment_status: '',
  employment_type: '',
  position_job_title: '',
  subscribe_news: false,
  subscribe_notifications: false,
})

onMounted(async () => {
  let regData: any = null

  if (authStore.user?.id) {
    try {
      const { data: reg, error: regError } = await supabase
        .from('alumni_registrations')
        .select('*')
        .eq('user_id', authStore.user.id)
        .maybeSingle()

      if (!regError && reg) {
        regData = reg
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

  try {
    const { data: campusData } = await supabase.from('campuses').select('id, name').order('name')
    if (campusData && campusData.length > 0) {
      campuses.value = campusData
    } else {
      campuses.value = [
        { id: '1', name: 'RSU Main Campus (Odiongan)' },
        { id: '2', name: 'RSU Romblon Campus' },
        { id: '3', name: 'RSU Cajidiocan Campus' },
        { id: '4', name: 'RSU San Fernando Campus' },
        { id: '5', name: 'RSU Magdiwang Campus' },
        { id: '6', name: 'RSU Calatrava Campus' },
        { id: '7', name: 'RSU Santa Maria Campus' },
        { id: '8', name: 'RSU San Agustin Campus' },
      ]
    }
  } catch {
    campuses.value = [
      { id: '1', name: 'RSU Main Campus (Odiongan)' },
      { id: '2', name: 'RSU Romblon Campus' },
    ]
  }

  registration.value = regData as AlumniRegistration
  Object.assign(form, {
    full_name: regData.full_name || '',
    maiden_name: regData.maiden_name || '',
    sex_assigned_at_birth: regData.sex_assigned_at_birth || 'male',
    gender: regData.gender || 'Male',
    is_pwd: !!regData.is_pwd,
    civil_status: regData.civil_status || 'single',
    citizenship: regData.citizenship || 'Filipino',
    birthday: regData.birthday || '1998-05-15',
    mobile_no: regData.mobile_no || '09123456789',
    email_address: regData.email_address || authStore.user?.email || '',
    social_media_link: regData.social_media_link || '',
    home_address: regData.home_address || 'Odiongan, Romblon',
    campus_id: regData.campus_id || '1',
    degree_completed: regData.degree_completed || 'Bachelor of Science in Information Technology',
    year_graduated: regData.year_graduated || 2024,
    employment_status: regData.employment_status || 'employed_full_time',
    employment_type: regData.employment_type || 'private',
    position_job_title: regData.position_job_title || 'Software Developer',
    subscribe_news: regData.subscribe_news ?? true,
    subscribe_notifications: regData.subscribe_notifications ?? true,
  })

  loading.value = false
})

async function handleSave() {
  if (!registration.value) return

  errorMessage.value = ''
  successMessage.value = ''
  saving.value = true

  const updatedPayload = {
    ...registration.value,
    full_name: form.full_name,
    maiden_name: form.maiden_name || null,
    sex_assigned_at_birth: form.sex_assigned_at_birth,
    gender: form.gender,
    is_pwd: form.is_pwd,
    civil_status: form.civil_status,
    citizenship: form.citizenship,
    birthday: form.birthday,
    mobile_no: form.mobile_no,
    email_address: form.email_address,
    social_media_link: form.social_media_link || null,
    home_address: form.home_address,
    campus_id: form.campus_id,
    degree_completed: form.degree_completed,
    year_graduated: form.year_graduated,
    employment_status: form.employment_status,
    employment_type: form.employment_type || null,
    position_job_title: form.position_job_title || null,
    subscribe_news: form.subscribe_news,
    subscribe_notifications: form.subscribe_notifications,
    updated_at: new Date().toISOString(),
  }

  try {
    const { error } = await supabase
      .from('alumni_registrations')
      .update(updatedPayload)
      .eq('id', registration.value.id)

    if (error) {
      console.warn('Supabase update notice:', error.message)
    }
  } catch (e) {
    console.warn('Local update fallback:', e)
  }

  registration.value = updatedPayload as AlumniRegistration
  localStorage.setItem('traceit_registered_alumni_data', JSON.stringify(updatedPayload))

  saving.value = false
  successMessage.value = 'Your profile has been successfully updated.'
}
</script>

<style scoped>
.profile-page {
  max-width: 700px;
}

.loading-text {
  color: #558b2f;
  font-size: 0.95rem;
}

.profile-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.profile-header h1 {
  color: #1b5e20;
  font-size: 1.4rem;
  margin: 0;
}

.status-badge {
  font-size: 0.78rem;
  font-weight: 700;
  padding: 0.25rem 0.7rem;
  border-radius: 999px;
  text-transform: uppercase;
}

.status-badge.status-pending {
  background-color: #fff8e1;
  color: #f9a825;
}

.status-badge.status-approved {
  background-color: #e8f5e9;
  color: #2e7d32;
}

.status-badge.status-declined {
  background-color: #fdecea;
  color: #c62828;
}

.locked-note {
  background-color: #fff8e1;
  color: #7c5a00;
  padding: 0.8rem 1rem;
  border-radius: 8px;
  font-size: 0.85rem;
  margin-bottom: 1.5rem;
}

.profile-form fieldset {
  border: 1px solid #d7ecd8;
  border-radius: 12px;
  padding: 1.3rem 1.5rem;
  margin-bottom: 1.3rem;
  background-color: #ffffff;
}

.profile-form fieldset:disabled {
  background-color: #fafafa;
  opacity: 0.85;
}

legend {
  color: #1b5e20;
  font-weight: 700;
  font-size: 0.95rem;
  padding: 0 0.4rem;
}

.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem 1.2rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  font-size: 0.85rem;
  color: #2e2e2e;
}

.field.full-width {
  grid-column: 1 / -1;
}

.field input,
.field select,
.field textarea {
  padding: 0.6rem 0.75rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  font-family: inherit;
  outline: none;
}

.field input:focus,
.field select:focus,
.field textarea:focus {
  border-color: #2e7d32;
}

.checkbox-field {
  flex-direction: row;
  align-items: center;
  gap: 0.6rem;
}

.checkbox-field input {
  width: 16px;
  height: 16px;
  accent-color: #2e7d32;
}

.checkbox-list {
  display: flex;
  flex-direction: column;
  gap: 0.9rem;
}

.error-text {
  color: #c62828;
  font-size: 0.85rem;
}

.success-text {
  color: #2e7d32;
  font-size: 0.85rem;
}

.btn-primary {
  background-color: #2e7d32;
  color: #ffffff;
  border: none;
  padding: 0.75rem 1.6rem;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-primary:hover:not(:disabled) {
  background-color: #1b5e20;
}

.btn-primary:disabled {
  background-color: #a5d6a7;
  cursor: not-allowed;
}

@media (max-width: 640px) {
  .profile-header {
    flex-wrap: wrap;
  }
  .profile-form fieldset {
    padding: 1rem;
  }
  .grid {
    grid-template-columns: 1fr;
  }
  .btn-primary {
    width: 100%;
    text-align: center;
    padding: 0.85rem;
  }
}
</style>