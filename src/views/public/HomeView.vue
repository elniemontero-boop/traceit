<template>
  <div class="home-page">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <div class="hero-brand-header">
          <img src="@/assets/logo.png" alt="RSU Logo" class="hero-logo" />
          <span class="hero-badge">Romblon State University</span>
        </div>
        <h1 class="hero-title">TraceIt Alumni Portal</h1>
        <p class="hero-subtitle">
          Connecting graduates across all campuses, building career networks, and shaping the future of RSU excellence.
        </p>
        <div class="hero-actions">
          <router-link to="/register" class="btn-primary">Register as Alumni</router-link>
          <router-link to="/login" class="btn-secondary">Log In to Portal</router-link>
        </div>
      </div>
    </section>

    <!-- Stats Counter Section -->
    <section class="stats-section">
      <div class="stats-container">
        <div class="stat-card">
          <span class="stat-number">{{ stats.totalCount }}</span>
          <span class="stat-label">Graduates Registered</span>
        </div>
        <div class="stat-card">
          <span class="stat-number">{{ stats.employmentRate }}%</span>
          <span class="stat-label">Employment Rate</span>
        </div>
        <div class="stat-card">
          <span class="stat-number">8</span>
          <span class="stat-label">University Campuses</span>
        </div>
        <div class="stat-card">
          <span class="stat-number">{{ stats.approvedCount }}</span>
          <span class="stat-label">Verified Alumni</span>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="features-section">
      <div class="section-container">
        <h2 class="section-title">Why Complete the Tracer Study?</h2>
        <div class="features-grid">
          <div class="feature-card">
            <div class="feature-icon">🎓</div>
            <h3>Accreditation & Quality</h3>
            <p>Your career data directly contributes to CHED program accreditation and institution quality standards.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">💼</div>
            <h3>Career Development</h3>
            <p>Gain access to university career events, job postings, mentorship programs, and alumni network channels.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🔒</div>
            <h3>Data Privacy Protected</h3>
            <p>Strictly compliant with the Data Privacy Act of 2012. Information is aggregated and processed securely.</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const stats = ref({
  totalCount: 0,
  approvedCount: 0,
  employmentRate: 0,
})

onMounted(async () => {
  try {
    const { data } = await supabase.from('alumni_registrations').select('status, employment_status')
    if (data && data.length > 0) {
      stats.value.totalCount = data.length
      stats.value.approvedCount = data.filter((r) => r.status === 'approved').length
      const employed = data.filter((r) =>
        ['employed_full_time', 'employed_part_time', 'self_employed'].includes(r.employment_status)
      ).length
      stats.value.employmentRate = Math.round((employed / data.length) * 100 * 10) / 10
    }
  } catch {
    // default to 0
  }
})
</script>

<style scoped>
.home-page {
  display: flex;
  flex-direction: column;
}

.hero {
  background: linear-gradient(rgba(15, 45, 18, 0.75), rgba(27, 94, 32, 0.85)),
    url('@/assets/rsubg.jpg') center/cover no-repeat;
  color: #ffffff;
  padding: 6rem 1.5rem;
  text-align: center;
  position: relative;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.hero-brand-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  margin-bottom: 1.25rem;
}

.hero-logo {
  height: 52px;
  width: auto;
  object-fit: contain;
  filter: drop-shadow(0 2px 6px rgba(0, 0, 0, 0.3));
}

.hero-badge {
  display: inline-block;
  background-color: rgba(255, 255, 255, 0.18);
  color: #c8e6c9;
  padding: 0.35rem 1rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.hero-title {
  font-size: 3rem;
  font-weight: 800;
  margin: 0 0 1rem;
  line-height: 1.2;
}

.hero-subtitle {
  font-size: 1.15rem;
  line-height: 1.6;
  color: #e8f5e9;
  margin: 0 0 2rem;
}

.hero-actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
}

.btn-primary {
  background-color: #ffffff;
  color: #1b5e20;
  font-weight: 700;
  padding: 0.85rem 1.8rem;
  border-radius: 8px;
  text-decoration: none;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
}

.btn-secondary {
  background-color: rgba(255, 255, 255, 0.15);
  color: #ffffff;
  font-weight: 600;
  padding: 0.85rem 1.8rem;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  text-decoration: none;
  transition: background 0.15s ease;
}

.btn-secondary:hover {
  background-color: rgba(255, 255, 255, 0.25);
}

.stats-section {
  background-color: #ffffff;
  padding: 3rem 1.5rem;
  border-bottom: 1px solid #e2ece3;
}

.stats-container {
  max-width: 1100px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.5rem;
  text-align: center;
}

.stat-card {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-number {
  font-size: 2.2rem;
  font-weight: 800;
  color: #1b5e20;
}

.stat-label {
  font-size: 0.88rem;
  color: #666;
  font-weight: 500;
  margin-top: 0.25rem;
}

.features-section {
  padding: 4rem 1.5rem;
  background-color: #f5faf5;
}

.section-container {
  max-width: 1100px;
  margin: 0 auto;
}

.section-title {
  text-align: center;
  font-size: 1.8rem;
  font-weight: 700;
  color: #1b5e20;
  margin-bottom: 2.5rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

.feature-card {
  background: #ffffff;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(27, 94, 32, 0.05);
  border: 1px solid #d7ecd8;
}

.feature-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  margin: 0 0 0.75rem;
  color: #2e7d32;
  font-size: 1.15rem;
}

.feature-card p {
  color: #555;
  font-size: 0.9rem;
  line-height: 1.5;
  margin: 0;
}

@media (max-width: 768px) {
  .stats-container {
    grid-template-columns: repeat(2, 1fr);
  }
  .features-grid {
    grid-template-columns: 1fr;
  }
  .hero-title {
    font-size: 2.2rem;
  }
}
</style>
