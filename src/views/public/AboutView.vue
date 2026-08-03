<template>
  <div class="about">
    <section class="page-header">
      <h1>About TraceIt</h1>
      <p>Learn more about the RSU Alumni Tracer System and its purpose.</p>
    </section>

    <section class="content-section">
      <div class="content-block">
        <h2>What is TraceIt?</h2>
        <p>
          TraceIt is the official Alumni Tracer System of Romblon State
          University (RSU). It was created to help the university keep in
          touch with its graduates, understand where they are in their
          careers, and share opportunities and updates that matter to them.
        </p>
      </div>

      <div class="content-block">
        <h2>Why Alumni Tracing Matters</h2>
        <p>
          Tracking alumni outcomes — employment status, job roles, and
          career paths — helps RSU evaluate how well its academic programs
          prepare graduates for the workforce. This data supports curriculum
          improvement, accreditation requirements, and stronger
          university-industry partnerships.
        </p>
      </div>

      <div class="content-block">
        <h2>Who Can Join</h2>
        <p>
          Registration is currently open to RSU graduates from Academic
          Years 2024 and 2025, across all RSU campuses. Once registered,
          your submission is reviewed by the university administrator
          before your account is fully activated.
        </p>
      </div>

      <div class="content-block">
        <h2>What You Get</h2>
        <ul>
          <li>A personal profile tracking your academic and employment history</li>
          <li>Announcements about alumni events, activities, and opportunities</li>
          <li>Optional email updates, based on your own privacy preferences</li>
        </ul>
      </div>
    </section>

    <section class="cta-section">
      <h2>Ready to get started?</h2>
      <router-link to="/register" class="btn-primary">Register Now</router-link>
    </section>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.about {
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
  gap: 2.2rem;
}

.content-block h2 {
  color: #1b5e20;
  font-size: 1.3rem;
  margin: 0 0 0.75rem;
}

.content-block p {
  color: #4a4a4a;
  line-height: 1.7;
  margin: 0;
}

.content-block ul {
  color: #4a4a4a;
  line-height: 1.8;
  margin: 0;
  padding-left: 1.3rem;
}

.cta-section {
  background-color: #e8f5e9;
  text-align: center;
  padding: 3rem 1.5rem;
}

.cta-section h2 {
  color: #1b5e20;
  font-size: 1.4rem;
  margin: 0 0 1.5rem;
}

.btn-primary {
  background-color: #2e7d32;
  color: #ffffff;
  padding: 0.75rem 1.6rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 700;
  transition: background-color 0.15s ease;
}

.btn-primary:hover {
  background-color: #1b5e20;
}
</style>