<template>
  <header class="public-navbar">
    <div class="nav-container">
      <router-link to="/" class="brand">
        <img src="@/assets/logo.png" alt="RSU Logo" class="brand-logo" />
        <span class="brand-text">TraceIt</span>
      </router-link>

      <nav class="nav-links">
        <router-link to="/" class="nav-item">Home</router-link>
        <router-link to="/about" class="nav-item">About</router-link>
        <router-link to="/contact" class="nav-item">Contact</router-link>
      </nav>

      <div class="nav-auth">
        <template v-if="authStore.isLoggedIn">
          <router-link
            :to="authStore.isAdmin ? '/admin' : '/dashboard'"
            class="btn-dashboard"
          >
            Dashboard
          </router-link>
        </template>
        <template v-else>
          <router-link to="/login" class="btn-login">Log In</router-link>
          <router-link to="/register" class="btn-register">Register</router-link>
        </template>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
</script>

<style scoped>
.public-navbar {
  background-color: #ffffff;
  border-bottom: 1px solid #e2ece3;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0.85rem 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.brand {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
  font-weight: 700;
  font-size: 1.35rem;
  color: #1b5e20;
}

.brand-logo {
  height: 38px;
  width: auto;
  object-fit: contain;
}

.nav-links {
  display: flex;
  gap: 1.8rem;
}

.nav-item {
  text-decoration: none;
  color: #4a5568;
  font-weight: 500;
  font-size: 0.95rem;
  transition: color 0.15s ease;
}

.nav-item:hover,
.nav-item.router-link-active {
  color: #2e7d32;
  font-weight: 600;
}

.nav-auth {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.btn-login {
  text-decoration: none;
  color: #2e7d32;
  font-weight: 600;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-size: 0.9rem;
  transition: background 0.15s ease;
}

.btn-login:hover {
  background-color: #eef7ee;
}

.btn-register,
.btn-dashboard {
  text-decoration: none;
  background-color: #2e7d32;
  color: #ffffff;
  font-weight: 600;
  padding: 0.5rem 1.2rem;
  border-radius: 6px;
  font-size: 0.9rem;
  transition: background 0.15s ease;
}

.btn-register:hover,
.btn-dashboard:hover {
  background-color: #1b5e20;
}
</style>
