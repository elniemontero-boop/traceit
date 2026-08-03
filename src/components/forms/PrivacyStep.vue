<template>
  <div class="form-step">
    <div class="privacy-notice">
      <h3>Data Privacy Notice</h3>
      <p>
        By submitting this form, you agree that Romblon State University may
        collect, store, and process the personal information you've provided
        for the purpose of alumni tracking, reporting, and communication.
        Your data will not be shared with third parties without your consent.
      </p>
    </div>

    <div class="checkbox-list">
      <label class="checkbox-field">
        <input v-model="modelValue.data_privacy_consent" type="checkbox" required />
        <span>
          I have read and agree to the Data Privacy Notice above. *
        </span>
      </label>

      <label class="checkbox-field">
        <input v-model="modelValue.subscribe_news" type="checkbox" />
        <span>
          Subscribe to receive news from Romblon State University.
        </span>
      </label>

      <label class="checkbox-field">
        <input v-model="modelValue.subscribe_notifications" type="checkbox" />
        <span>
          Subscribe to receive notifications about alumni activities.
        </span>
      </label>
    </div>

    <p v-if="!modelValue.data_privacy_consent" class="hint-text">
      You must agree to the Data Privacy Notice before you can submit your
      registration.
    </p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: {
    data_privacy_consent: boolean
    subscribe_news: boolean
    subscribe_notifications: boolean
    [key: string]: any
  }
}>()
</script>

<style scoped>
.privacy-notice {
  background-color: #eef7ee;
  border: 1px solid #d7ecd8;
  border-radius: 10px;
  padding: 1.2rem 1.3rem;
  margin-bottom: 1.5rem;
}

.privacy-notice h3 {
  color: #1b5e20;
  font-size: 1rem;
  margin: 0 0 0.6rem;
}

.privacy-notice p {
  color: #4a4a4a;
  font-size: 0.85rem;
  line-height: 1.6;
  margin: 0;
}

.checkbox-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.checkbox-field {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  font-size: 0.88rem;
  color: #2e2e2e;
  cursor: pointer;
  padding: 0.35rem 0;
}

.checkbox-field input {
  width: 20px;
  height: 20px;
  margin-top: 0.1rem;
  accent-color: #2e7d32;
  flex-shrink: 0;
}

.hint-text {
  font-size: 0.82rem;
  color: #c62828;
  margin: 1.2rem 0 0;
}
</style>