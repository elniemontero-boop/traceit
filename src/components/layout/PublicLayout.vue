<template>
  <div class="public-layout">
    <PublicNavbar />
    <main class="public-content">
      <router-view />
    </main>
    <footer class="public-footer">
      <p>&copy; {{ currentYear }} TraceIt — Romblon State University Alumni Tracer</p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import PublicNavbar from './PublicNavbar.vue'

const currentYear = new Date().getFullYear()
</script>

<style scoped>
.public-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f5faf5;
}

.public-content {
  flex: 1;
}

.public-footer {
  background-color: #1b5e20;
  color: #e8f5e9;
  text-align: center;
  padding: 1rem;
  font-size: 0.85rem;
}
</style>