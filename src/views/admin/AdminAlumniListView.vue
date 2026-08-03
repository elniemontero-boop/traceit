<template>
  <div class="alumni-list-page">
    <div class="header">
      <h1>Alumni Directory</h1>
      <p>Search, filter, and review submitted alumni tracer registrations.</p>
    </div>

    <!-- Filter Controls -->
    <div class="controls-bar">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search by name, email, or degree…"
        class="search-input"
      />

      <select v-model="statusFilter" class="filter-select">
        <option value="">All Statuses</option>
        <option value="pending">Pending</option>
        <option value="approved">Approved</option>
        <option value="declined">Declined</option>
      </select>
    </div>

    <!-- Table View (Desktop & Tablet) -->
    <div class="table-container desktop-only">
      <table class="data-table">
        <thead>
          <tr>
            <th>Full Name</th>
            <th>Email</th>
            <th>Degree</th>
            <th>Graduated</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="filteredList.length === 0">
            <td colspan="6" class="empty-cell">No alumni registrations found.</td>
          </tr>
          <tr v-for="item in filteredList" :key="item.id">
            <td class="name-cell">{{ item.full_name }}</td>
            <td>{{ item.email_address }}</td>
            <td>{{ item.degree_completed }}</td>
            <td>{{ item.year_graduated }}</td>
            <td>
              <span class="status-tag" :class="`status-${item.status}`">
                {{ item.status }}
              </span>
            </td>
            <td>
              <router-link :to="`/admin/review/${item.id}`" class="btn-review">
                Review →
              </router-link>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Mobile Card View -->
    <div class="mobile-cards-list mobile-only">
      <div v-if="filteredList.length === 0" class="empty-card">
        No alumni registrations found.
      </div>
      <div v-for="item in filteredList" :key="'card-' + item.id" class="alumni-card">
        <div class="card-top">
          <div class="card-name-group">
            <h4 class="card-name">{{ item.full_name }}</h4>
            <span class="card-email">{{ item.email_address }}</span>
          </div>
          <span class="status-tag" :class="`status-${item.status}`">
            {{ item.status }}
          </span>
        </div>
        <div class="card-details">
          <div class="detail-row">
            <span class="detail-label">Degree</span>
            <span class="detail-val">{{ item.degree_completed }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Year Graduated</span>
            <span class="detail-val">{{ item.year_graduated }}</span>
          </div>
        </div>
        <router-link :to="`/admin/review/${item.id}`" class="btn-review-card">
          Review Submission →
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

interface Registrant {
  id: string
  full_name: string
  email_address: string
  degree_completed: string
  year_graduated: number
  status: 'pending' | 'approved' | 'declined'
}

const searchQuery = ref('')
const statusFilter = ref('')
const registrations = ref<Registrant[]>([])

onMounted(async () => {
  try {
    const { data } = await supabase
      .from('alumni_registrations')
      .select('id, full_name, email_address, degree_completed, year_graduated, status')
      .order('created_at', { ascending: false })
      
    if (data) {
      registrations.value = data as Registrant[]
    }
  } catch {
    registrations.value = []
  }
})

const filteredList = computed(() => {
  return registrations.value.filter((item) => {
    const matchesSearch =
      !searchQuery.value ||
      item.full_name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      item.email_address.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      item.degree_completed.toLowerCase().includes(searchQuery.value.toLowerCase())

    const matchesStatus = !statusFilter.value || item.status === statusFilter.value

    return matchesSearch && matchesStatus
  })
})
</script>

<style scoped>
.alumni-list-page {
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

.controls-bar {
  display: flex;
  gap: 1rem;
}

.search-input {
  flex: 1;
  padding: 0.65rem 1rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  outline: none;
}

.filter-select {
  padding: 0.65rem 1rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.9rem;
  outline: none;
  background: #fff;
}

.table-container {
  background: #ffffff;
  border-radius: 12px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  border: 1px solid #e2ece3;
}

@media (max-width: 640px) {
  .controls-bar {
    flex-direction: column;
  }
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
  font-size: 0.9rem;
}

.data-table th {
  background: #f5faf5;
  color: #1b5e20;
  padding: 0.85rem 1rem;
  font-weight: 700;
  border-bottom: 1px solid #e2ece3;
}

.data-table td {
  padding: 0.85rem 1rem;
  border-bottom: 1px solid #e2ece3;
  color: #333;
}

.name-cell {
  font-weight: 600;
}

.status-tag {
  padding: 0.25rem 0.6rem;
  border-radius: 4px;
  font-size: 0.78rem;
  font-weight: 700;
  text-transform: capitalize;
}

.status-pending {
  background: #fff8e1;
  color: #f57f17;
}

.status-approved {
  background: #e8f5e9;
  color: #2e7d32;
}

.status-declined {
  background: #ffebee;
  color: #c62828;
}

.btn-review {
  color: #2e7d32;
  font-weight: 700;
  text-decoration: none;
  font-size: 0.85rem;
}

.empty-cell {
  text-align: center;
  color: #777;
  padding: 2.5rem !important;
  font-style: italic;
}

.mobile-only {
  display: none;
}

@media (max-width: 640px) {
  .desktop-only {
    display: none;
  }
  .mobile-only {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }
}

.empty-card {
  background: #ffffff;
  padding: 2rem;
  border-radius: 12px;
  text-align: center;
  color: #777;
  border: 1px solid #e2ece3;
  font-style: italic;
}

.alumni-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.25rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  border: 1px solid #e2ece3;
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 0.5rem;
}

.card-name {
  margin: 0 0 0.15rem;
  font-size: 1rem;
  color: #1b5e20;
}

.card-email {
  font-size: 0.82rem;
  color: #666;
  word-break: break-all;
}

.card-details {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  padding: 0.65rem 0;
  border-top: 1px solid #f0f0f0;
  border-bottom: 1px solid #f0f0f0;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.85rem;
}

.detail-label {
  color: #666;
}

.detail-val {
  font-weight: 600;
  color: #333;
  text-align: right;
}

.btn-review-card {
  display: block;
  text-align: center;
  background-color: #eef7ee;
  color: #2e7d32;
  font-weight: 700;
  padding: 0.65rem;
  border-radius: 8px;
  text-decoration: none;
  font-size: 0.9rem;
}
</style>
