<template>
  <div class="contact">
    <section class="page-header">
      <h1>Contact Us</h1>
      <p>Have questions about TraceIt or your registration? Reach out to us.</p>
    </section>

    <section class="content-section">
      <div class="contact-grid">
        <div class="contact-card">
          <span class="contact-icon">📍</span>
          <h3>Office Address</h3>
          <p>Romblon State University<br />Main Campus, Odiongan, Romblon</p>
        </div>

        <div class="contact-card">
          <span class="contact-icon">📧</span>
          <h3>Email</h3>
          <p>alumni.traceit@rsu.edu.ph</p>
        </div>

        <div class="contact-card">
          <span class="contact-icon">📞</span>
          <h3>Phone</h3>
          <p>(042) 567-1234</p>
        </div>
      </div>

      <div class="contact-form-wrapper">
        <h2>Send Us a Message</h2>
        <form @submit.prevent="handleSubmit" class="contact-form">
          <label class="field">
            <span>Full Name</span>
            <input v-model="form.name" type="text" required />
          </label>

          <label class="field">
            <span>Email</span>
            <input v-model="form.email" type="email" required />
          </label>

          <label class="field">
            <span>Message</span>
            <textarea v-model="form.message" rows="5" required></textarea>
          </label>

          <p v-if="submitted" class="success-text">
            Thanks for reaching out! We'll get back to you soon.
          </p>

          <button type="submit" class="btn-primary">Send Message</button>
        </form>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'

const form = reactive({
  name: '',
  email: '',
  message: '',
})

const submitted = ref(false)

function handleSubmit() {
  // NOTE: this form does not send anywhere yet — no backend/email
  // wired up. Hook this up later (e.g. an Edge Function + email
  // provider, or a "contact_messages" table) if you want it functional.
  submitted.value = true
  form.name = ''
  form.email = ''
  form.message = ''
}
</script>

<style scoped>
.contact {
  display: flex;
  flex-direction: column;
}

.page-header {
  background-color: #1b5e20;
  color: #ffffff;
  text-align: center;
  padding: 3.5rem 1.5rem;
}

.page-header h1 {
  margin: 0 0 0.5rem;
  font-size: 2.2rem;
}

.page-header p {
  color: #dcedc8;
  margin: 0;
  font-size: 1rem;
}

.content-section {
  max-width: 800px;
  margin: 0 auto;
  padding: 3rem 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

.contact-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
}

.contact-card {
  background-color: #ffffff;
  border: 1px solid #d7ecd8;
  border-radius: 12px;
  padding: 1.75rem 1.25rem;
  text-align: center;
}

.contact-icon {
  font-size: 1.8rem;
  display: block;
  margin-bottom: 0.6rem;
}

.contact-card h3 {
  color: #1b5e20;
  margin: 0 0 0.5rem;
  font-size: 1rem;
}

.contact-card p {
  color: #4a4a4a;
  font-size: 0.9rem;
  line-height: 1.5;
  margin: 0;
}

.contact-form-wrapper h2 {
  color: #1b5e20;
  font-size: 1.3rem;
  margin: 0 0 1.2rem;
}

.contact-form {
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  font-size: 0.9rem;
  color: #2e2e2e;
}

.field input,
.field textarea {
  padding: 0.65rem 0.8rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.95rem;
  font-family: inherit;
  outline: none;
  resize: vertical;
  transition: border-color 0.15s ease;
}

.field input:focus,
.field textarea:focus {
  border-color: #2e7d32;
}

.success-text {
  color: #2e7d32;
  font-size: 0.9rem;
  margin: 0;
}

.btn-primary {
  background-color: #2e7d32;
  color: #ffffff;
  border: none;
  padding: 0.75rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.btn-primary:hover {
  background-color: #1b5e20;
}
</style>