<template>
  <div class="form-step">
    <div class="grid">
      <label class="field">
        <span>Full Name *</span>
        <input v-model="modelValue.full_name" type="text" required />
      </label>

      <label class="field">
        <span>Maiden Name (if married)</span>
        <input v-model="modelValue.maiden_name" type="text" />
      </label>

      <label class="field">
        <span>Sex Assigned at Birth *</span>
        <select v-model="modelValue.sex_assigned_at_birth" required>
          <option value="" disabled>Select…</option>
          <option value="male">Male</option>
          <option value="female">Female</option>
        </select>
      </label>

      <label class="field">
        <span>Gender *</span>
        <input v-model="modelValue.gender" type="text" required />
      </label>

      <label class="field checkbox-field">
        <input v-model="modelValue.is_pwd" type="checkbox" />
        <span>Person with Disability (PWD)</span>
      </label>

      <label class="field">
        <span>Civil Status *</span>
        <select v-model="modelValue.civil_status" required>
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
        <input v-model="modelValue.citizenship" type="text" required />
      </label>

      <label class="field">
        <span>Birthday *</span>
        <input v-model="modelValue.birthday" type="date" required />
      </label>

      <label class="field">
        <span>Mobile No. *</span>
        <input v-model="modelValue.mobile_no" type="tel" required placeholder="09XXXXXXXXX" />
      </label>

      <label class="field">
        <span>Email Address *</span>
        <input v-model="modelValue.email_address" type="email" required />
      </label>

      <label class="field">
        <span>Social Media Profile Link</span>
        <input v-model="modelValue.social_media_link" type="url" placeholder="https://facebook.com/yourprofile" />
      </label>

      <label class="field full-width">
        <span>Home Address *</span>
        <textarea v-model="modelValue.home_address" rows="2" required></textarea>
      </label>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: {
    full_name: string
    maiden_name: string
    sex_assigned_at_birth: string
    gender: string
    is_pwd: boolean
    civil_status: string
    citizenship: string
    birthday: string
    mobile_no: string
    email_address: string
    social_media_link: string
    home_address: string
    [key: string]: any
  }
}>()
</script>

<style scoped>
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
  padding: 0.6rem 0.75rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  font-family: inherit;
  outline: none;
  transition: border-color 0.15s ease;
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

@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr;
  }
  .checkbox-field {
    padding-top: 0.5rem;
  }
}
</style>