<template>
  <div class="auth-page">
    <div class="auth-card">
      <div class="auth-header">
        <img src="@/assets/logo.png" alt="RSU Logo" class="auth-logo" />
        <h1 class="brand">TraceIt</h1>
        <p class="subtitle">Alumni Tracer Registration</p>
      </div>

      <!-- Alumni Full Registration Wizard -->
      <template v-if="true">
        <!-- Stepper -->
        <div class="stepper">
          <div
            v-for="(step, index) in stepTitles"
            :key="index"
            class="step-item"
            :class="{ active: currentStep === index + 1, completed: currentStep > index + 1 }"
          >
            <div class="step-badge">{{ index + 1 }}</div>
            <span class="step-title">{{ step }}</span>
          </div>
        </div>

        <form @submit.prevent="handleNext">
          <!-- Step 1: Account & Personal Info -->
          <div v-if="currentStep === 1" class="form-step">
            <h3 class="step-heading">Step 1: Account Credentials & Personal Details</h3>

            <div class="grid">
              <label class="field">
                <span>Email Address (Account Username) *</span>
                <input
                  v-model="formData.email"
                  type="email"
                  required
                  placeholder="you@example.com"
                />
              </label>

              <label class="field">
                <span>Password *</span>
                <input
                  v-model="formData.password"
                  type="password"
                  required
                  minlength="6"
                  placeholder="Minimum 6 characters"
                />
              </label>

              <label class="field">
                <span>Full Name *</span>
                <input
                  v-model="formData.full_name"
                  type="text"
                  required
                  placeholder="e.g. Juan Dela Cruz"
                />
              </label>

              <label class="field">
                <span>Maiden Name (if married)</span>
                <input
                  v-model="formData.maiden_name"
                  type="text"
                  placeholder="Optional"
                />
              </label>

              <label class="field">
                <span>Sex Assigned at Birth *</span>
                <select v-model="formData.sex_assigned_at_birth" required>
                  <option value="" disabled>Select…</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                </select>
              </label>

              <label class="field">
                <span>Gender *</span>
                <input
                  v-model="formData.gender"
                  type="text"
                  required
                  placeholder="e.g. Male, Female, Non-binary"
                />
              </label>

              <label class="field checkbox-field">
                <input v-model="formData.is_pwd" type="checkbox" />
                <span>Person with Disability (PWD)</span>
              </label>

              <label class="field">
                <span>Civil Status *</span>
                <select v-model="formData.civil_status" required>
                  <option value="" disabled>Select…</option>
                  <option value="single">Single</option>
                  <option value="married">Married</option>
                  <option value="widowed">Widowed</option>
                  <option value="separated">Separated</option>
                  <option value="divorced">Divorced</option>
                </select>
              </label>

              <label class="field">
                <span>Citizenship *</span>
                <input v-model="formData.citizenship" type="text" required />
              </label>

              <label class="field">
                <span>Birthday *</span>
                <input v-model="formData.birthday" type="date" required />
              </label>

              <label class="field">
                <span>Mobile No. *</span>
                <input
                  v-model="formData.mobile_no"
                  type="tel"
                  required
                  placeholder="09XXXXXXXXX"
                />
              </label>

              <label class="field">
                <span>Social Media Profile Link</span>
                <input
                  v-model="formData.social_media_link"
                  type="url"
                  placeholder="https://facebook.com/yourprofile"
                />
              </label>

              <label class="field full-width">
                <span>Home Address *</span>
                <textarea
                  v-model="formData.home_address"
                  rows="2"
                  required
                  placeholder="Complete permanent address"
                ></textarea>
              </label>
            </div>
          </div>

          <!-- Step 2: Education -->
          <EducationStep
            v-else-if="currentStep === 2"
            v-model="formData"
            :campuses="campuses"
          />

          <!-- Step 3: Employment -->
          <EmploymentStep
            v-else-if="currentStep === 3"
            v-model="formData"
          />

          <!-- Step 4: Privacy & Submit -->
          <PrivacyStep
            v-else-if="currentStep === 4"
            v-model="formData"
          />

          <div v-if="errorMessage" class="error-banner">⚠️ {{ errorMessage }}</div>

          <!-- Actions Bar -->
          <div class="wizard-actions">
            <button
              type="button"
              class="btn-prev"
              :disabled="currentStep === 1 || loading"
              @click="prevStep"
            >
              ← Previous
            </button>

            <button
              v-if="currentStep < 4"
              type="submit"
              class="btn-next"
            >
              Next Step →
            </button>

            <button
              v-else
              type="button"
              class="btn-submit"
              :disabled="loading || !formData.data_privacy_consent"
              @click="handleFullSubmit"
            >
              {{ loading ? 'Creating Account…' : 'Complete Registration' }}
            </button>
          </div>
        </form>
      </template>

      <p class="switch-auth">
        Already have an account?
        <router-link to="/login">Log In</router-link>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'

import EducationStep from '@/components/forms/EducationStep.vue'
import EmploymentStep from '@/components/forms/EmploymentStep.vue'
import PrivacyStep from '@/components/forms/PrivacyStep.vue'

const router = useRouter()
const authStore = useAuthStore()

const currentStep = ref(1)
const stepTitles = ['Account & Personal', 'Education', 'Employment', 'Privacy & Submit']
const loading = ref(false)
const errorMessage = ref('')

const defaultCampuses = [
  { id: '1', name: 'RSU Main Campus (Odiongan)' },
  { id: '2', name: 'RSU Romblon Campus' },
  { id: '3', name: 'RSU Cajidiocan Campus' },
  { id: '4', name: 'RSU San Fernando Campus' },
  { id: '5', name: 'RSU Magdiwang Campus' },
  { id: '6', name: 'RSU Calatrava Campus' },
  { id: '7', name: 'RSU Santa Maria Campus' },
  { id: '8', name: 'RSU San Agustin Campus' },
]

const campuses = ref<{ id: string; name: string }[]>(defaultCampuses)

const formData = ref({
  role: 'alumni' as 'alumni' | 'admin',
  email: '',
  password: '',

  // Personal Info
  full_name: '',
  maiden_name: '',
  sex_assigned_at_birth: '',
  gender: '',
  is_pwd: false,
  civil_status: '',
  citizenship: 'Filipino',
  birthday: '',
  mobile_no: '',
  email_address: '',
  social_media_link: '',
  home_address: '',

  // Education
  campus_id: defaultCampuses[0]!.id,
  degree_completed: '',
  year_graduated: 2024 as '' | 2024 | 2025,

  // Employment
  employment_status: '',
  employment_type: null as string | null,
  position_job_title: null as string | null,
  employer_company_name: null as string | null,
  monthly_income_range: null as string | null,

  // Consent
  data_privacy_consent: false,
  subscribe_news: true,
  subscribe_notifications: true,
})

onMounted(async () => {
  try {
    const { data } = await supabase.from('campuses').select('id, name').order('name')
    if (data && data.length > 0) {
      campuses.value = data
      if (!formData.value.campus_id) {
        formData.value.campus_id = data[0]!.id
      }
    }
  } catch {
    // fallback defaults
  }
})

function validateCurrentStep(): boolean {
  errorMessage.value = ''

  if (currentStep.value === 1) {
    if (!formData.value.email || !formData.value.password) {
      errorMessage.value = 'Please enter a valid account email and password.'
      return false
    }
    if (formData.value.password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters long.'
      return false
    }
    if (
      !formData.value.full_name ||
      !formData.value.sex_assigned_at_birth ||
      !formData.value.gender ||
      !formData.value.civil_status ||
      !formData.value.citizenship ||
      !formData.value.birthday ||
      !formData.value.mobile_no ||
      !formData.value.home_address
    ) {
      errorMessage.value = 'Please fill out all required personal information fields before proceeding.'
      return false
    }
  } else if (currentStep.value === 2) {
    if (!formData.value.campus_id || !formData.value.degree_completed || !formData.value.year_graduated) {
      errorMessage.value = 'Please complete all required education fields (Campus, Degree, Year Graduated).'
      return false
    }
  } else if (currentStep.value === 3) {
    if (!formData.value.employment_status) {
      errorMessage.value = 'Please select your current employment status.'
      return false
    }

    const isEmployed = ['employed_full_time', 'employed_part_time', 'self_employed'].includes(
      formData.value.employment_status
    )

    if (isEmployed) {
      if (
        !formData.value.employment_type ||
        !formData.value.position_job_title ||
        !formData.value.employer_company_name ||
        !formData.value.monthly_income_range
      ) {
        errorMessage.value = 'Please complete all required employment fields (Sector, Position, Employer, Salary Range).'
        return false
      }
    }
  }

  return true
}

function handleNext() {
  if (validateCurrentStep()) {
    if (currentStep.value < 4) {
      currentStep.value++
      errorMessage.value = ''
    }
  }
}

function prevStep() {
  if (currentStep.value > 1) {
    currentStep.value--
    errorMessage.value = ''
  }
}

async function handleAdminRegister() {
  if (!formData.value.email || !formData.value.password || !formData.value.full_name) {
    errorMessage.value = 'Please fill out all required fields.'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const { data, error } = await supabase.auth.signUp({
      email: formData.value.email,
      password: formData.value.password,
      options: {
        data: {
          full_name: formData.value.full_name,
          role: 'admin',
        },
      },
    })

    if (error || !data.user) {
      authStore.setMockUser('admin')
      authStore.user!.email = formData.value.email
      authStore.user!.user_metadata = { full_name: formData.value.full_name, role: 'admin' }
    } else {
      await authStore.fetchRole()
    }
    router.push('/admin')
  } catch {
    authStore.setMockUser('admin')
    router.push('/admin')
  } finally {
    loading.value = false
  }
}

async function handleFullSubmit() {
  if (!validateCurrentStep()) return

  if (!formData.value.data_privacy_consent) {
    errorMessage.value = 'You must accept the Data Privacy Notice to submit your registration.'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    // 1. Create Supabase Auth user
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: formData.value.email,
      password: formData.value.password,
      options: {
        data: {
          full_name: formData.value.full_name,
          role: 'alumni',
        },
      },
    })

    if (authError) {
      if (authError.message.toLowerCase().includes('already registered')) {
        throw new Error('This email already has an account or pending registration. Please use a different email or contact the Alumni Office.')
      }
      throw new Error(`Unable to create your account: ${authError.message}`)
    }

    const userId = authData.user?.id
    if (!userId) {
      throw new Error('Your account could not be created. Please try again.')
    }

    // An authenticated session is required by Supabase RLS to save the
    // registration under the newly created user.
    if (!authData.session) {
      throw new Error('Your account was created, but email confirmation is enabled in Supabase. Disable Confirm email for this project, then register with a new email.')
    }

    await authStore.fetchRole()

    // 2. Insert into alumni_registrations
    const payload = {
      user_id: userId,
      full_name: formData.value.full_name,
      maiden_name: formData.value.maiden_name || null,
      sex_assigned_at_birth: formData.value.sex_assigned_at_birth,
      gender: formData.value.gender,
      is_pwd: formData.value.is_pwd,
      civil_status: formData.value.civil_status,
      citizenship: formData.value.citizenship,
      birthday: formData.value.birthday,
      mobile_no: formData.value.mobile_no,
      email_address: formData.value.email,
      social_media_link: formData.value.social_media_link || null,
      home_address: formData.value.home_address,
      campus_id: formData.value.campus_id,
      degree_completed: formData.value.degree_completed,
      year_graduated: formData.value.year_graduated || 2024,
      employment_status: formData.value.employment_status,
      employment_type: formData.value.employment_type || null,
      position_job_title: formData.value.position_job_title || null,
      employer_company_name: formData.value.employer_company_name || null,
      monthly_income_range: formData.value.monthly_income_range || null,
      data_privacy_consent: formData.value.data_privacy_consent,
      subscribe_news: formData.value.subscribe_news,
      subscribe_notifications: formData.value.subscribe_notifications,
      status: 'pending',
      updated_at: new Date().toISOString(),
    }

    const { error: registrationError } = await supabase
      .from('alumni_registrations')
      .insert([payload])

    if (registrationError) {
      throw new Error(`Your registration could not be saved: ${registrationError.message}`)
    }

    router.push('/registration-submitted')
  } catch (e) {
    console.error('Registration failed:', e)
    errorMessage.value = e instanceof Error ? e.message : 'Failed to submit registration. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(15, 45, 18, 0.78), rgba(27, 94, 32, 0.85)),
    url('@/assets/bg.jpg') center/cover no-repeat;
  padding: 2.5rem 1rem;
}

.auth-card {
  width: 100%;
  max-width: 820px;
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  padding: 2.5rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.4);
}

.auth-header {
  text-align: center;
  margin-bottom: 1.5rem;
}

.auth-logo {
  height: 64px;
  width: auto;
  margin: 0 auto 0.5rem;
  display: block;
  object-fit: contain;
}

.brand {
  color: #1b5e20;
  font-size: 2rem;
  margin: 0;
  font-weight: 800;
}

.subtitle {
  color: #555;
  margin: 0.25rem 0 0;
  font-size: 0.95rem;
}



.stepper {
  display: flex;
  justify-content: space-between;
  margin-bottom: 2rem;
  gap: 0.5rem;
}

.step-item {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: #f4f7f4;
  border-radius: 8px;
  opacity: 0.6;
  transition: all 0.2s ease;
}

.step-item.active {
  opacity: 1;
  background: #eef7ee;
  border: 1px solid #2e7d32;
}

.step-item.completed {
  opacity: 0.9;
  background: #e8f5e9;
}

.step-badge {
  width: 26px;
  height: 26px;
  border-radius: 50%;
  background: #aaa;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 0.8rem;
  flex-shrink: 0;
}

.step-item.active .step-badge,
.step-item.completed .step-badge {
  background: #2e7d32;
}

.step-title {
  font-size: 0.82rem;
  font-weight: 600;
  color: #2e2e2e;
}

.step-heading {
  color: #1b5e20;
  font-size: 1.1rem;
  margin: 0 0 1.25rem;
}

.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.1rem 1.2rem;
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
  padding: 0.65rem 0.8rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  outline: none;
  font-family: inherit;
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
  padding-top: 1.4rem;
}

.checkbox-field input {
  width: 16px;
  height: 16px;
  accent-color: #2e7d32;
}

.wizard-actions {
  display: flex;
  justify-content: space-between;
  margin-top: 2rem;
  padding-top: 1.25rem;
  border-top: 1px solid #e8f5e9;
}

.btn-prev {
  background: #f0f0f0;
  color: #444;
  border: none;
  padding: 0.65rem 1.2rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
}

.btn-prev:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.btn-next,
.btn-submit,
.btn-primary {
  background: #2e7d32;
  color: #ffffff;
  border: none;
  padding: 0.65rem 1.4rem;
  border-radius: 8px;
  font-weight: 700;
  cursor: pointer;
}

.btn-next:hover,
.btn-submit:hover:not(:disabled),
.btn-primary:hover:not(:disabled) {
  background: #1b5e20;
}

.btn-submit:disabled,
.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.error-banner {
  background-color: #ffebee;
  color: #c62828;
  border: 1px solid #ffcdd2;
  padding: 0.85rem 1.1rem;
  border-radius: 8px;
  font-size: 0.88rem;
  font-weight: 600;
  margin-top: 1.25rem;
}

.switch-auth {
  text-align: center;
  font-size: 0.88rem;
  color: #666;
  margin-top: 2rem;
  padding-top: 1rem;
  border-top: 1px dashed #e2ece3;
}

.switch-auth a {
  color: #2e7d32;
  font-weight: 600;
  text-decoration: none;
}

@media (max-width: 640px) {
  .auth-page {
    padding: 1.25rem 0.75rem;
  }
  .auth-card {
    padding: 1.5rem 1.1rem;
    border-radius: 12px;
  }
  .brand {
    font-size: 1.7rem;
  }
  .grid {
    grid-template-columns: 1fr;
  }
  .stepper {
    display: flex;
    flex-direction: row;
    overflow-x: auto;
    padding-bottom: 0.5rem;
    margin-bottom: 1.25rem;
    gap: 0.5rem;
    -webkit-overflow-scrolling: touch;
  }
  .step-item {
    flex: 0 0 auto;
    padding: 0.5rem 0.75rem;
  }
  .wizard-actions {
    flex-direction: column-reverse;
    gap: 0.75rem;
  }
  .btn-prev,
  .btn-next,
  .btn-submit {
    width: 100%;
    text-align: center;
    padding: 0.8rem 1rem;
  }
}
</style>
