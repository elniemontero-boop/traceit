<template>
  <div class="announcements-page">
    <div class="header">
      <h1>University & Alumni Announcements</h1>
      <p>Stay informed about campus events, homecoming activities, and career opportunities.</p>
    </div>

    <div v-if="loading" class="loading-state">Loading announcements…</div>

    <div v-else-if="announcements.length === 0" class="empty-state">
      <p>No announcements published yet.</p>
    </div>

    <div v-else class="announcements-list">
      <div
        v-for="item in announcements"
        :key="item.id"
        class="announcement-card"
        :class="{ pinned: item.is_pinned }"
      >
        <div class="card-header">
          <span class="category-badge">{{ item.category }}</span>
          <span v-if="item.is_pinned" class="pinned-tag">📌 Pinned</span>
          <span class="date">{{ formatDate(item.created_at) }}</span>
        </div>
        <h2 class="title">{{ item.title }}</h2>
        <p class="content">{{ item.content }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import type { Announcement } from '@/types/database'

const loading = ref(true)
const announcements = ref<Announcement[]>([])

onMounted(async () => {
  try {
    const { data } = await supabase
      .from('announcements')
      .select('*')
      .order('created_at', { ascending: false })

    if (data) {
      announcements.value = data as Announcement[]
    }
  } catch {
    announcements.value = []
  } finally {
    loading.value = false
  }
})

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}
</script>

<style scoped>
.announcements-page {
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

.empty-state {
  background: #ffffff;
  padding: 2.5rem;
  border-radius: 12px;
  text-align: center;
  color: #777;
  border: 1px solid #e2ece3;
  font-style: italic;
}

.announcements-list {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.announcement-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
  border: 1px solid #e2ece3;
}

.announcement-card.pinned {
  border-left: 5px solid #2e7d32;
  background: #fafefb;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}

.category-badge {
  background: #eef7ee;
  color: #2e7d32;
  font-size: 0.75rem;
  font-weight: 700;
  padding: 0.25rem 0.6rem;
  border-radius: 4px;
  text-transform: uppercase;
}

.pinned-tag {
  font-size: 0.78rem;
  color: #2e7d32;
  font-weight: 600;
}

.date {
  font-size: 0.8rem;
  color: #888;
  margin-left: auto;
}

.title {
  margin: 0 0 0.6rem;
  color: #1b5e20;
  font-size: 1.2rem;
}

.content {
  margin: 0;
  color: #4a4a4a;
  font-size: 0.92rem;
  line-height: 1.6;
}
</style>
