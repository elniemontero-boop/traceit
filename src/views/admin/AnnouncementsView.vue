<template>
  <div class="admin-announcements">
    <div class="header">
      <div>
        <h1>Manage Announcements</h1>
        <p>Post and update news, events, and notices for alumni.</p>
      </div>
      <button @click="showForm = !showForm" class="btn-primary">
        {{ showForm ? 'Cancel' : '+ New Announcement' }}
      </button>
    </div>

    <!-- Create Form -->
    <div v-if="showForm" class="form-card">
      <h3>Create New Announcement</h3>
      <form @submit.prevent="handleCreate" class="form">
        <label class="field">
          <span>Title *</span>
          <input v-model="newTitle" type="text" required placeholder="e.g. Alumni Homecoming 2026 Registration" />
        </label>

        <label class="field">
          <span>Category</span>
          <select v-model="newCategory">
            <option value="General">General</option>
            <option value="Event">Event</option>
            <option value="Career">Career</option>
            <option value="Academic">Academic</option>
          </select>
        </label>

        <label class="field full-width">
          <span>Content / Message *</span>
          <textarea v-model="newContent" rows="3" required placeholder="Write announcement details here…"></textarea>
        </label>

        <label class="checkbox-field">
          <input v-model="newPinned" type="checkbox" />
          <span>Pin this announcement to top</span>
        </label>

        <button type="submit" class="btn-submit" :disabled="submitting">
          {{ submitting ? 'Publishing…' : 'Publish Announcement' }}
        </button>
      </form>
    </div>

    <!-- List -->
    <div v-if="announcements.length === 0" class="empty-state">
      No announcements published yet. Click "+ New Announcement" to post your first notice.
    </div>

    <div v-else class="announcements-list">
      <div v-for="item in announcements" :key="item.id" class="announcement-item">
        <div class="item-main">
          <div class="item-tags">
            <span class="category-tag">{{ item.category }}</span>
            <span v-if="item.is_pinned" class="pinned-tag">📌 Pinned</span>
            <span class="date">{{ formatDate(item.created_at) }}</span>
          </div>
          <h4>{{ item.title }}</h4>
          <p>{{ item.content }}</p>
        </div>
        <button @click="handleDelete(item.id)" class="btn-delete" title="Delete">
          🗑️
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import type { Announcement } from '@/types/database'

const showForm = ref(false)
const submitting = ref(false)
const newTitle = ref('')
const newCategory = ref('General')
const newContent = ref('')
const newPinned = ref(false)

const announcements = ref<Announcement[]>([])

onMounted(async () => {
  try {
    const { data } = await supabase.from('announcements').select('*').order('created_at', { ascending: false })
    if (data) {
      announcements.value = data as Announcement[]
    }
  } catch {
    announcements.value = []
  }
})

async function handleCreate() {
  submitting.value = true
  const item: Omit<Announcement, 'id'> = {
    title: newTitle.value,
    category: newCategory.value,
    content: newContent.value,
    is_pinned: newPinned.value,
    created_at: new Date().toISOString(),
  }

  try {
    const { data, error } = await supabase.from('announcements').insert([item]).select()
    if (!error && data && data.length > 0) {
      announcements.value.unshift(data[0] as Announcement)
    } else {
      announcements.value.unshift({ ...item, id: String(Date.now()) })
    }
  } catch {
    announcements.value.unshift({ ...item, id: String(Date.now()) })
  } finally {
    newTitle.value = ''
    newContent.value = ''
    newPinned.value = false
    showForm.value = false
    submitting.value = false
  }
}

async function handleDelete(id: string) {
  try {
    await supabase.from('announcements').delete().eq('id', id)
  } catch {
    // ignore
  }
  announcements.value = announcements.value.filter((a) => a.id !== id)
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}
</script>

<style scoped>
.admin-announcements {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
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

.btn-primary {
  background: #2e7d32;
  color: #fff;
  border: none;
  padding: 0.65rem 1.2rem;
  border-radius: 8px;
  font-weight: 700;
  cursor: pointer;
}

.form-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  border: 1px solid #d7ecd8;
}

.form-card h3 {
  margin: 0 0 1rem;
  color: #1b5e20;
  font-size: 1.1rem;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  font-size: 0.85rem;
}

.field input,
.field select,
.field textarea {
  padding: 0.6rem;
  border: 1px solid #bcdec0;
  border-radius: 6px;
  font-family: inherit;
}

.checkbox-field {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.88rem;
}

.btn-submit {
  background: #1b5e20;
  color: #fff;
  border: none;
  padding: 0.65rem;
  border-radius: 8px;
  font-weight: 700;
  cursor: pointer;
  align-self: flex-start;
}

.announcements-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.announcement-item {
  background: #ffffff;
  border-radius: 10px;
  padding: 1.25rem;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
  border: 1px solid #e2ece3;
}

.item-main {
  flex: 1;
}

.item-tags {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.5rem;
}

.category-tag {
  background: #eef7ee;
  color: #2e7d32;
  font-size: 0.72rem;
  font-weight: 700;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
}

.pinned-tag {
  font-size: 0.75rem;
  color: #2e7d32;
}

.date {
  font-size: 0.78rem;
  color: #888;
}

.item-main h4 {
  margin: 0 0 0.4rem;
  color: #1b5e20;
  font-size: 1.1rem;
}

.item-main p {
  margin: 0;
  color: #555;
  font-size: 0.88rem;
  line-height: 1.5;
}

.btn-delete {
  background: transparent;
  border: none;
  cursor: pointer;
  font-size: 1.1rem;
  padding: 0.25rem;
  opacity: 0.7;
}

.btn-delete:hover {
  opacity: 1;
}
</style>
