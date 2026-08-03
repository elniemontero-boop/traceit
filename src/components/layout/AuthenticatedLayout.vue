<template>
  <div class="auth-layout">
    <div class="mobile-header">
      <button class="mobile-menu-btn" @click="sidebarOpen = !sidebarOpen" aria-label="Toggle navigation menu">
        ☰
      </button>
      <div class="mobile-brand">
        <img src="@/assets/logo.png" alt="RSU Logo" class="mobile-logo" />
        <span class="mobile-title">TraceIt</span>
      </div>
    </div>

    <div
      class="sidebar-overlay"
      v-if="sidebarOpen"
      @click="sidebarOpen = false"
    ></div>

    <AppSidebar
      :class="{ 'is-mobile-open': sidebarOpen }"
      @close-mobile="sidebarOpen = false"
    />

    <main class="auth-content">
      <header class="top-bar">
        <div class="page-title">
          <h2>{{ currentTitle }}</h2>
        </div>
      </header>
      <div class="content-body">
        <router-view />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import AppSidebar from './AppSidebar.vue'

const route = useRoute()
const sidebarOpen = ref(false)

const currentTitle = computed(() => {
  return (route.meta.title as string)?.split('—')[0]?.trim() || 'TraceIt Portal'
})
</script>

<style scoped>
.auth-layout {
  display: flex;
  min-height: 100vh;
  background-color: #f4f7f4;
  position: relative;
}

.mobile-header {
  display: none;
  background-color: #1b5e20;
  color: #ffffff;
  padding: 0.75rem 1rem;
  align-items: center;
  gap: 1rem;
  position: sticky;
  top: 0;
  z-index: 80;
}

.mobile-menu-btn {
  background: rgba(255, 255, 255, 0.15);
  border: none;
  color: #ffffff;
  font-size: 1.4rem;
  padding: 0.3rem 0.6rem;
  border-radius: 6px;
  cursor: pointer;
}

.mobile-brand {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.mobile-logo {
  height: 32px;
  width: auto;
  object-fit: contain;
}

.mobile-title {
  font-weight: 700;
  font-size: 1.15rem;
}

.sidebar-overlay {
  display: none;
  position: fixed;
  inset: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 85;
}

.auth-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.top-bar {
  background-color: #ffffff;
  border-bottom: 1px solid #e2ece3;
  padding: 1.25rem 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
}

.page-title h2 {
  margin: 0;
  font-size: 1.35rem;
  font-weight: 700;
  color: #1b5e20;
}

.content-body {
  flex: 1;
  padding: 2rem;
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .auth-layout {
    flex-direction: column;
  }

  .mobile-header {
    display: flex;
  }

  .mobile-menu-btn {
    min-width: 44px;
    min-height: 44px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .sidebar-overlay {
    display: block;
  }

  .top-bar {
    padding: 0.85rem 1rem;
  }

  .page-title h2 {
    font-size: 1.15rem;
  }

  .content-body {
    padding: 1rem 0.85rem;
  }
}
</style>
