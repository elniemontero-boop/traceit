<template>
  <div class="registration-wizard">
    <div class="wizard-header">
      <h1>Alumni Tracer Registration</h1>
      <p>Please complete all required fields below to register your graduate details.</p>
    </div>

    <!-- Stepper Bar -->
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

    <!-- Form Container -->
    <div class="form-container">
      <form @submit.prevent="handleNext">
        <PersonalInfoStep
          v-if="currentStep === 1"
          v-model="formData"
        />

        <EducationStep
          v-else-if="currentStep === 2"
          v-model="formData"
          :campuses="campuses"
        />

        <EmploymentStep
          v-else-if="currentStep === 3"
          v-model="formData"
        />

        <PrivacyStep
          v-else-if="currentStep === 4"
          v-model="formData"
        />

        <div v-if="errorMessage" class="error-banner">
          ⚠️ {{ errorMessage }}
        </div>

        <!-- Actions Bar -->
        <div class="wizard-actions">
          <button
            type="button"
            class="btn-prev"
            :disabled="currentStep === 1 || submitting"
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
            :disabled="submitting || !formData.data_privacy_consent"
            @click="handleSubmit"
          >
            {{ submitting ? 'Submitting…' : 'Submit Registration' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'

import PersonalInfoStep from '@/components/forms/PersonalInfoStep.vue'
import EducationStep from '@/components/forms/EducationStep.vue'
import EmploymentStep from '@/components/forms/EmploymentStep.vue'
import PrivacyStep from '@/components/forms/PrivacyStep.vue'

const router = useRouter()
const authStore = useAuthStore()

const currentStep = ref(1)
const stepTitles = ['Personal Info', 'Education', 'Employment', 'Privacy & Submit']
const submitting = ref(false)
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
  full_name: authStore.user?.user_metadata?.full_name || '',
  maiden_name: '',
  sex_assigned_at_birth: '',
  gender: '',
  is_pwd: false,
  pwd_details: '',
  civil_status: '',
  citizenship: 'Filipino',
  birthday: '',
  mobile_no: '',
  email_address: authStore.user?.email || '',
  social_media_link: '',
  home_address: '',
  campus_id: defaultCampuses[0]!.id,
  degree_completed: '',
  is_bachelors: true,
  is_masters: false,
  year_graduated: 2024 as '' | 2024 | 2025,
  employment_status: '',
  employment_type: null as string | null,
  position_job_title: null as string | null,
  employer_company_name: null as string | null,
  monthly_income_range: null as string | null,
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
    if (
      !formData.value.full_name ||
      !formData.value.sex_assigned_at_birth ||
      !formData.value.gender ||
      !formData.value.civil_status ||
      !formData.value.citizenship ||
      !formData.value.birthday ||
      !formData.value.mobile_no ||
      !formData.value.email_address ||
      !formData.value.home_address
    ) {
      errorMessage.value = 'Please fill out all required personal information fields before proceeding.'
      return false
    }
    if (formData.value.is_pwd && !formData.value.pwd_details) {
      errorMessage.value = 'Please specify your PWD details.'
      return false
    }
  } else if (currentStep.value === 2) {
    if (!formData.value.is_bachelors && !formData.value.is_masters) {
      errorMessage.value = 'Please specify if your degree is Bachelor\'s or Master\'s.'
      return false
    }
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

async function handleSubmit() {
  if (!validateCurrentStep()) return

  if (!formData.value.data_privacy_consent) {
    errorMessage.value = 'You must accept the Data Privacy Notice to submit your registration.'
    return
  }

  submitting.value = true
  errorMessage.value = ''

  const userId = authStore.user?.id || 'mock-user-id'

  const payload = {
    user_id: userId,
    full_name: formData.value.full_name,
    maiden_name: formData.value.maiden_name || null,
    sex_assigned_at_birth: formData.value.sex_assigned_at_birth,
    gender: formData.value.gender,
    is_pwd: formData.value.is_pwd,
    pwd_details: formData.value.is_pwd ? formData.value.pwd_details : null,
    civil_status: formData.value.civil_status,
    citizenship: formData.value.citizenship,
    birthday: formData.value.birthday,
    mobile_no: formData.value.mobile_no,
    email_address: formData.value.email_address,
    social_media_link: formData.value.social_media_link || null,
    home_address: formData.value.home_address,
    campus_id: formData.value.campus_id,
    degree_completed: formData.value.degree_completed,
    is_bachelors: formData.value.is_bachelors,
    is_masters: formData.value.is_masters,
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

  try {
    const { error } = await supabase.from('alumni_registrations').insert([payload])
    if (error) {
      console.warn('Supabase insert notice:', error.message)
    }
  } catch (e) {
    console.warn('Submit fallback:', e)
  } finally {
    submitting.value = false
    router.push('/registration-submitted')
  }
}
</script>

<style scoped>
.registration-wizard {
  background: #ffffff;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 16px rgba(27, 94, 32, 0.06);
  border: 1px solid #d7ecd8;
}

.wizard-header h1 {
  margin: 0 0 0.5rem;
  color: #1b5e20;
  font-size: 1.6rem;
}

.wizard-header p {
  margin: 0 0 1.5rem;
  color: #666;
  font-size: 0.9rem;
}

.stepper {
  display: flex;
  justify-content: space-between;
  margin-bottom: 2rem;
  position: relative;
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
  font-size: 0.85rem;
  font-weight: 600;
  color: #2e2e2e;
}

.form-container {
  margin-top: 1rem;
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
.btn-submit {
  background: #2e7d32;
  color: #ffffff;
  border: none;
  padding: 0.65rem 1.4rem;
  border-radius: 8px;
  font-weight: 700;
  cursor: pointer;
}

.btn-next:hover,
.btn-submit:hover:not(:disabled) {
  background: #1b5e20;
}

.btn-submit:disabled {
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

@media (max-width: 640px) {
  .registration-wizard {
    padding: 1.25rem 1rem;
    border-radius: 10px;
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
