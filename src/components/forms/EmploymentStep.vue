<template>
  <div class="form-step">
    <div class="grid">
      <label class="field full-width">
        <span>Employment Status *</span>
        <select v-model="modelValue.employment_status" required>
          <option value="" disabled>Select your current employment status…</option>
          <option value="employed_full_time">Employed (Full-Time)</option>
          <option value="employed_part_time">Employed (Part-Time)</option>
          <option value="self_employed">Self-Employed / Entrepreneur</option>
          <option value="unemployed">Unemployed</option>
          <option value="further_studies">Pursuing Further Studies / Student</option>
        </select>
      </label>

      <template v-if="isEmployed">
        <label class="field">
          <span>Employment Sector / Type *</span>
          <select v-model="modelValue.employment_type" required>
            <option value="" disabled>Select sector…</option>
            <option value="government">Government / Public Sector</option>
            <option value="private">Private Sector / Corporate</option>
            <option value="ngo">Non-Profit / NGO</option>
            <option value="business_owner">Business Owner</option>
            <option value="freelance">Freelance / Contractual</option>
          </select>
        </label>

        <label class="field">
          <span>Position / Job Title *</span>
          <input
            v-model="modelValue.position_job_title"
            type="text"
            required
            placeholder="e.g. Software Engineer, Teacher, Manager"
          />
        </label>

        <label class="field">
          <span>Employer / Company Name *</span>
          <input
            v-model="modelValue.employer_company_name"
            type="text"
            required
            placeholder="e.g. Acme Corp Philippines"
          />
        </label>

        <label class="field">
          <span>Monthly Gross Salary / Income Range *</span>
          <select v-model="modelValue.monthly_income_range" required>
            <option value="" disabled>Select salary range…</option>
            <option value="below_10k">Below ₱10,000</option>
            <option value="10k_20k">₱10,000 – ₱20,000</option>
            <option value="20k_30k">₱20,000 – ₱30,000</option>
            <option value="30k_50k">₱30,000 – ₱50,000</option>
            <option value="50k_above">₱50,000 and above</option>
          </select>
        </label>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  modelValue: {
    employment_status: string
    employment_type: string | null
    position_job_title: string | null
    employer_company_name: string | null
    monthly_income_range: string | null
    [key: string]: any
  }
}>()

const isEmployed = computed(() => {
  return ['employed_full_time', 'employed_part_time', 'self_employed'].includes(
    props.modelValue.employment_status
  )
})
</script>

<style scoped>
.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.1rem;
}

.full-width {
  grid-column: 1 / -1;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  font-size: 0.85rem;
  color: #2e2e2e;
}

.field input,
.field select {
  padding: 0.6rem 0.75rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  font-family: inherit;
  outline: none;
  transition: border-color 0.15s ease;
}

.field input:focus,
.field select:focus {
  border-color: #2e7d32;
}

@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr;
  }
}
</style>
