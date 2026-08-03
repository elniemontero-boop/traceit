<template>
  <div class="admin-dashboard">
    <div class="header-row">
      <div>
        <h1>Admin Control Dashboard</h1>
        <p class="subtitle">Monitor alumni registrations, tracer analytics, and approval requests.</p>
      </div>
    </div>

    <!-- Stat Cards Grid -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-info">
          <span class="stat-val">{{ stats.total }}</span>
          <span class="stat-lbl">Total Registrations</span>
        </div>
      </div>
      <div class="stat-card pending">
        <div class="stat-icon">⏳</div>
        <div class="stat-info">
          <span class="stat-val">{{ stats.pending }}</span>
          <span class="stat-lbl">Pending Review</span>
        </div>
      </div>
      <div class="stat-card approved">
        <div class="stat-icon">✅</div>
        <div class="stat-info">
          <span class="stat-val">{{ stats.approved }}</span>
          <span class="stat-lbl">Approved Alumni</span>
        </div>
      </div>
      <div class="stat-card rate">
        <div class="stat-icon">💼</div>
        <div class="stat-info">
          <span class="stat-val">{{ stats.employmentRate }}%</span>
          <span class="stat-lbl">Employed Rate</span>
        </div>
      </div>
    </div>

    <!-- Quick Navigation Cards -->
    <div class="quick-links">
      <router-link to="/admin/alumni" class="action-card">
        <h3>Alumni Directory</h3>
        <p>Browse, filter, and review submitted tracer forms.</p>
      </router-link>
      <router-link to="/admin/reports" class="action-card">
        <h3>Reports & Analytics</h3>
        <p>Generate employment and accreditation tracer statistics.</p>
      </router-link>
      <router-link to="/admin/announcements" class="action-card">
        <h3>Manage Announcements</h3>
        <p>Post updates, homecoming news, and career notices.</p>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const stats = ref({
  total: 0,
  pending: 0,
  approved: 0,
  declined: 0,
  employmentRate: 0,
})

onMounted(async () => {
  try {
    const { data } = await supabase.from('alumni_registrations').select('status, employment_status')
    if (data && data.length > 0) {
      stats.value.total = data.length
      stats.value.pending = data.filter((r) => r.status === 'pending').length
      stats.value.approved = data.filter((r) => r.status === 'approved').length
      stats.value.declined = data.filter((r) => r.status === 'declined').length
      const employed = data.filter((r) => ['employed_full_time', 'employed_part_time', 'self_employed'].includes(r.employment_status)).length
      stats.value.employmentRate = Math.round((employed / data.length) * 100 * 10) / 10
    }
  } catch {
    // defaults to 0
  }
})
</script>

<style scoped>
.admin-dashboard {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.header-row h1 {
  margin: 0 0 0.5rem;
  color: #1b5e20;
  font-size: 1.7rem;
}

.subtitle {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.25rem;
}

.stat-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.25rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  border: 1px solid #e2ece3;
}

.stat-icon {
  font-size: 2rem;
  width: 48px;
  height: 48px;
  border-radius: 10px;
  background: #eef7ee;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-val {
  font-size: 1.6rem;
  font-weight: 800;
  color: #1b5e20;
}

.stat-lbl {
  font-size: 0.8rem;
  color: #666;
  font-weight: 500;
}

.quick-links {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}

.action-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.75rem;
  text-decoration: none;
  border: 1px solid #d7ecd8;
  box-shadow: 0 2px 8px rgba(27, 94, 32, 0.04);
  transition: all 0.15s ease;
}

.action-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(27, 94, 32, 0.1);
  border-color: #2e7d32;
}

.action-card h3 {
  margin: 0 0 0.5rem;
  color: #1b5e20;
  font-size: 1.15rem;
}

.action-card p {
  margin: 0;
  color: #666;
  font-size: 0.88rem;
  line-height: 1.5;
}

@media (max-width: 900px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .quick-links {
    grid-template-columns: 1fr;
  }
}
</style>
