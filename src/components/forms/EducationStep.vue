<template>
  <div class="form-step">
    <div class="grid">
      <label class="field full-width">
        <span>Campus *</span>
        <select v-model="modelValue.campus_id" required>
          <option value="" disabled>Select your campus…</option>
          <option v-for="campus in campuses" :key="campus.id" :value="campus.id">
            {{ campus.name }}
          </option>
        </select>
      </label>

      <div class="field full-width">
        <span class="field-label">Degree Level (Select all that apply) *</span>
        <div class="checkbox-group">
          <label class="checkbox-label">
            <input v-model="modelValue.is_bachelors" type="checkbox" />
            <span>Bachelor's Degree</span>
          </label>
          <label class="checkbox-label">
            <input v-model="modelValue.is_masters" type="checkbox" />
            <span>Master's Degree</span>
          </label>
        </div>
      </div>

      <label class="field full-width">
        <span>Degree Program Completed *</span>
        <input
          v-model="modelValue.degree_completed"
          type="text"
          required
          placeholder="e.g. Bachelor of Science in Information Technology / Master of Science in CS"
        />
      </label>

      <label class="field full-width">
        <span>Year Graduated *</span>
        <select v-model.number="modelValue.year_graduated" required>
          <option value="" disabled>Select…</option>
          <option :value="2024">2024</option>
          <option :value="2025">2025</option>
        </select>
      </label>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: {
    campus_id: string
    degree_completed: string
    is_bachelors?: boolean
    is_masters?: boolean
    year_graduated: '' | 2024 | 2025
    [key: string]: any
  }
  campuses: { id: string; name: string }[]
}>()
</script>

<style scoped>
.grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  font-size: 0.85rem;
  color: #2e2e2e;
}

.field-label {
  font-weight: 500;
}

.checkbox-group {
  display: flex;
  gap: 1.5rem;
  margin-top: 0.25rem;
  flex-wrap: wrap;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
  color: #2e2e2e;
}

.checkbox-label input {
  width: 16px;
  height: 16px;
  accent-color: #2e7d32;
}

.field input[type="text"],
.field select {
  padding: 0.6rem 0.75rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  font-family: inherit;
  outline: none;
  transition: border-color 0.15s ease;
}

.field input[type="text"]:focus,
.field select:focus {
  border-color: #2e7d32;
}
</style>