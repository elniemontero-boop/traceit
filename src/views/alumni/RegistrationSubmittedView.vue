<template>
  <div class="submitted-page">
    <div class="card">
      <div class="icon-wrap">🎉</div>
      <h1>Registration Submitted!</h1>
      <p class="desc">
        Thank you for completing your Alumni Tracer Form. Your submission has been received and is currently set to <strong>Pending Admin Review</strong>.
      </p>
      <div class="info-box">
        <h3>What happens next?</h3>
        <ul>
          <li>The RSU Alumni Office will review your information.</li>
          <li>Once approved, you will receive an official verification badge.</li>
          <li>You can monitor your application status anytime on your dashboard.</li>
        </ul>
      </div>
      <div class="actions">
        <router-link to="/dashboard" class="btn-primary">Go to Dashboard</router-link>
        <router-link to="/profile" class="btn-secondary">View My Profile</router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// Confirmation view
</script>

<style scoped>
.submitted-page {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 2rem 0;
}

.card {
  background: #ffffff;
  border-radius: 12px;
  padding: 3rem 2.5rem;
  max-width: 560px;
  width: 100%;
  text-align: center;
  box-shadow: 0 4px 16px rgba(27, 94, 32, 0.08);
  border: 1px solid #d7ecd8;
}

.icon-wrap {
  font-size: 3.5rem;
  margin-bottom: 1rem;
}

h1 {
  color: #1b5e20;
  margin: 0 0 1rem;
  font-size: 1.8rem;
}

.desc {
  color: #555;
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0 0 1.5rem;
}

.info-box {
  background: #eef7ee;
  border: 1px solid #d7ecd8;
  border-radius: 8px;
  padding: 1.25rem;
  text-align: left;
  margin-bottom: 2rem;
}

.info-box h3 {
  margin: 0 0 0.5rem;
  color: #1b5e20;
  font-size: 0.95rem;
}

.info-box ul {
  margin: 0;
  padding-left: 1.2rem;
  color: #4a4a4a;
  font-size: 0.88rem;
  line-height: 1.5;
}

.actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.btn-primary {
  background: #2e7d32;
  color: #fff;
  padding: 0.75rem 1.4rem;
  border-radius: 8px;
  font-weight: 700;
  text-decoration: none;
}

.btn-secondary {
  background: #f0f0f0;
  color: #333;
  padding: 0.75rem 1.4rem;
  border-radius: 8px;
  font-weight: 600;
  text-decoration: none;
}
</style>
