<template>
  <div class="auth-layout">
    <AppSidebar />
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
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import AppSidebar from './AppSidebar.vue'

const route = useRoute()

const currentTitle = computed(() => {
  return (route.meta.title as string)?.split('—')[0]?.trim() || 'TraceIt Portal'
})
</script>

<style scoped>
.auth-layout {
  display: flex;
  min-height: 100vh;
  background-color: #f4f7f4;
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
</style>
