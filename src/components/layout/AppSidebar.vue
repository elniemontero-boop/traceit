<template>
  <aside class="sidebar">
    <div class="sidebar-header">
      <router-link to="/" class="brand" @click="$emit('close-mobile')">
        <img src="@/assets/logo.png" alt="RSU Logo" class="brand-logo" />
        <div class="brand-titles">
          <span class="app-title">TraceIt</span>
          <span class="app-subtitle">RSU Alumni Portal</span>
        </div>
      </router-link>
      <button class="mobile-close-btn" @click="$emit('close-mobile')">✕</button>
    </div>

    <div class="user-badge" v-if="authStore.user">
      <div class="user-avatar">{{ avatarInitial }}</div>
      <div class="user-info">
        <span class="user-name">{{ userName }}</span>
        <span class="user-role">{{ authStore.isAdmin ? 'Administrator' : 'Alumni' }}</span>
      </div>
    </div>

    <nav class="sidebar-nav">
      <!-- Alumni Nav -->
      <template v-if="!authStore.isAdmin">
        <div class="nav-group-title">MAIN MENU</div>
        <router-link to="/dashboard" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">📊</span> Dashboard
        </router-link>
        <router-link to="/registration-form" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">📋</span> Tracer Form
        </router-link>
        <router-link to="/profile" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">👤</span> My Profile
        </router-link>
        <router-link to="/announcements" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">📢</span> Announcements
        </router-link>
      </template>

      <!-- Admin Nav -->
      <template v-else>
        <div class="nav-group-title">ADMINISTRATION</div>
        <router-link to="/admin" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">📈</span> Admin Overview
        </router-link>
        <router-link to="/admin/alumni" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">👥</span> Alumni Directory
        </router-link>
        <router-link to="/admin/reports" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">📊</span> Reports & Analytics
        </router-link>
        <router-link to="/admin/announcements" class="nav-item" @click="$emit('close-mobile')">
          <span class="icon">📢</span> Manage News
        </router-link>
      </template>
    </nav>

    <div class="sidebar-footer">
      <button @click="handleLogout" class="btn-logout">
        <span class="icon">🚪</span> Log Out
      </button>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

defineEmits(['close-mobile'])

const authStore = useAuthStore()
const router = useRouter()

const userName = computed(() => {
  return authStore.user?.user_metadata?.full_name || authStore.user?.email || 'User'
})

const avatarInitial = computed(() => {
  return userName.value.charAt(0).toUpperCase()
})

async function handleLogout() {
  await authStore.signOut()
  router.push('/login')
}
</script>

<style scoped>
.sidebar {
  width: 260px;
  background-color: #1b5e20;
  color: #ffffff;
  display: flex;
  flex-direction: column;
  height: 100vh;
  position: sticky;
  top: 0;
  box-shadow: 3px 0 10px rgba(0, 0, 0, 0.05);
  z-index: 90;
  transition: transform 0.3s ease;
}

.sidebar-header {
  padding: 1.5rem 1.25rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.12);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  text-decoration: none;
  color: #ffffff;
}

.brand-logo {
  height: 42px;
  width: auto;
  object-fit: contain;
}

.brand-titles {
  display: flex;
  flex-direction: column;
}

.app-title {
  font-weight: 800;
  font-size: 1.25rem;
  letter-spacing: 0.5px;
}

.app-subtitle {
  font-size: 0.72rem;
  color: #a5d6a7;
}

.mobile-close-btn {
  display: none;
  background: none;
  border: none;
  color: #ffffff;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0.2rem 0.5rem;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1.2rem 1.25rem;
  background-color: rgba(0, 0, 0, 0.15);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #81c784;
  color: #1b5e20;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1rem;
}

.user-info {
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.user-name {
  font-size: 0.88rem;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.user-role {
  font-size: 0.72rem;
  color: #c8e6c9;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.sidebar-nav {
  flex: 1;
  padding: 1.25rem 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  overflow-y: auto;
}

.nav-group-title {
  font-size: 0.68rem;
  font-weight: 700;
  color: #a5d6a7;
  padding: 0.5rem 0.75rem 0.25rem;
  letter-spacing: 1px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.65rem 0.85rem;
  border-radius: 8px;
  color: #e8f5e9;
  text-decoration: none;
  font-size: 0.9rem;
  font-weight: 500;
  transition: all 0.15s ease;
}

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.15);
}

.nav-item.router-link-active {
  background-color: #ffffff;
  color: #1b5e20;
  font-weight: 700;
}

.icon {
  font-size: 1.1rem;
}

.sidebar-footer {
  padding: 1rem 1.25rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.btn-logout {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.6rem 1rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: #ffffff;
  font-weight: 600;
  font-size: 0.88rem;
  cursor: pointer;
  transition: background 0.15s ease;
}

.btn-logout:hover {
  background: rgba(239, 68, 68, 0.8);
  border-color: transparent;
}

@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    width: 280px;
    max-width: 85vw;
    transform: translateX(-100%);
    box-shadow: 4px 0 20px rgba(0, 0, 0, 0.2);
  }

  .sidebar.is-mobile-open {
    transform: translateX(0);
  }

  .mobile-close-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 40px;
    min-height: 40px;
  }

  .nav-item {
    padding: 0.75rem 1rem;
    font-size: 0.95rem;
  }
}
</style>
