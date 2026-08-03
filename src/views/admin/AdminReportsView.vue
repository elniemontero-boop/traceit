<template>
  <div class="reports-page">
    <div class="header">
      <h1>Alumni Reports & Analytics</h1>
      <p>Employment metrics, campus breakdowns, and tracer study insights.</p>
    </div>

    <div v-if="loading" class="loading-text">Loading report data…</div>

    <div v-else-if="totalCount === 0" class="empty-state">
      <div class="empty-box">
        <span class="icon">📊</span>
        <h3>No Alumni Registration Data Yet</h3>
        <p>Analytics and graphs will automatically populate here as alumni complete the tracer registration study.</p>
      </div>
    </div>

    <div v-else class="reports-grid">
      <!-- Employment Status Breakdown -->
      <div class="report-card">
        <h3>Employment Status Breakdown</h3>
        <div class="bar-chart">
          <div v-for="(item, key) in employmentStats" :key="key" class="bar-row">
            <span class="bar-lbl">{{ formatStatusLabel(key) }}</span>
            <div class="bar-track">
              <div class="bar-fill" :style="{ width: item.percent + '%' }"></div>
            </div>
            <span class="bar-val">{{ item.percent }}% ({{ item.count }})</span>
          </div>
        </div>
      </div>

      <!-- Total Summary Card -->
      <div class="report-card">
        <h3>Submissions Summary</h3>
        <div class="summary-box">
          <div class="stat-big">
            <span class="num">{{ totalCount }}</span>
            <span class="lbl">Total Tracer Submissions</span>
          </div>
          <div class="stat-big">
            <span class="num">{{ overallEmploymentRate }}%</span>
            <span class="lbl">Overall Employment Rate</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const loading = ref(true)
const registrations = ref<any[]>([])

onMounted(async () => {
  try {
    const { data } = await supabase.from('alumni_registrations').select('*')
    if (data) {
      registrations.value = data
    }
  } catch {
    registrations.value = []
  } finally {
    loading.value = false
  }
})

const totalCount = computed(() => registrations.value.length)

const overallEmploymentRate = computed(() => {
  if (totalCount.value === 0) return 0
  const employed = registrations.value.filter((r) =>
    ['employed_full_time', 'employed_part_time', 'self_employed'].includes(r.employment_status)
  ).length
  return Math.round((employed / totalCount.value) * 100 * 10) / 10
})

const employmentStats = computed(() => {
  if (totalCount.value === 0) return {}
  const statusCounts: Record<string, number> = {
    employed_full_time: 0,
    employed_part_time: 0,
    self_employed: 0,
    further_studies: 0,
    unemployed: 0,
  }

  registrations.value.forEach((r) => {
    const key = r.employment_status
    if (typeof statusCounts[key] === 'number') {
      statusCounts[key] = (statusCounts[key] || 0) + 1
    }
  })

  const result: Record<string, { count: number; percent: number }> = {}
  Object.keys(statusCounts).forEach((key) => {
    const count = statusCounts[key] ?? 0
    const percent = Math.round((count / totalCount.value) * 100 * 10) / 10
    result[key] = { count, percent }
  })

  return result
})

function formatStatusLabel(key: string) {
  const map: Record<string, string> = {
    employed_full_time: 'Employed (Full-Time)',
    employed_part_time: 'Employed (Part-Time)',
    self_employed: 'Self-Employed / Business',
    further_studies: 'Further Studies',
    unemployed: 'Unemployed',
  }
  return map[key] || key
}
</script>

<style scoped>
.reports-page {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.header h1 {
  margin: 0 0 0.5rem;
  color: #1b5e20;
  font-size: 1.6rem;
}

.header p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
}

.loading-text {
  color: #666;
  font-style: italic;
}

.empty-state {
  display: flex;
  justify-content: center;
  padding: 3rem 0;
}

.empty-box {
  background: #ffffff;
  border-radius: 12px;
  padding: 3rem 2rem;
  max-width: 480px;
  text-align: center;
  border: 1px solid #d7ecd8;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.empty-box .icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 0.5rem;
}

.empty-box h3 {
  margin: 0 0 0.5rem;
  color: #1b5e20;
}

.empty-box p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
  line-height: 1.5;
}

.reports-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
}

.report-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.75rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  border: 1px solid #e2ece3;
}

.report-card h3 {
  margin: 0 0 1.5rem;
  color: #1b5e20;
  font-size: 1.1rem;
}

.bar-chart {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.bar-row {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.85rem;
}

.bar-lbl {
  width: 170px;
  color: #444;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.bar-track {
  flex: 1;
  height: 12px;
  background: #eef7ee;
  border-radius: 6px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: #2e7d32;
  border-radius: 6px;
  transition: width 0.4s ease;
}

.bar-val {
  width: 90px;
  font-weight: 700;
  color: #2e2e2e;
  text-align: right;
}

.summary-box {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.stat-big {
  background: #f5faf5;
  padding: 1.25rem;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-big .num {
  font-size: 2.2rem;
  font-weight: 800;
  color: #1b5e20;
}

.stat-big .lbl {
  font-size: 0.85rem;
  color: #666;
  margin-top: 0.25rem;
}

@media (max-width: 900px) {
  .reports-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 560px) {
  .report-card {
    padding: 1.25rem;
  }
  .bar-row {
    flex-wrap: wrap;
    gap: 0.35rem 0.75rem;
  }
  .bar-lbl {
    width: 100%;
  }
  .bar-track {
    flex: 1;
  }
  .bar-val {
    width: auto;
    font-size: 0.82rem;
  }
}
</style>
