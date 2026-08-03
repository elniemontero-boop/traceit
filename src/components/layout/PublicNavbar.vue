<template>
  <header class="public-navbar">
    <div class="nav-container">
      <router-link to="/" class="brand">
        <img src="@/assets/logo.png" alt="RSU Logo" class="brand-logo" />
        <span class="brand-text">TraceIt</span>
      </router-link>

      <button
        class="mobile-toggle"
        @click="mobileMenuOpen = !mobileMenuOpen"
        aria-label="Toggle menu"
      >
        <span>{{ mobileMenuOpen ? '✕' : '☰' }}</span>
      </button>

      <div class="nav-content" :class="{ 'is-open': mobileMenuOpen }">
        <nav class="nav-links">
          <router-link to="/" class="nav-item" @click="mobileMenuOpen = false">Home</router-link>
          <router-link to="/about" class="nav-item" @click="mobileMenuOpen = false">About</router-link>
          <router-link to="/contact" class="nav-item" @click="mobileMenuOpen = false">Contact</router-link>
        </nav>

        <div class="nav-auth">
          <template v-if="authStore.isLoggedIn">
            <router-link
              :to="authStore.isAdmin ? '/admin' : '/dashboard'"
              class="btn-dashboard"
              @click="mobileMenuOpen = false"
            >
              Dashboard
            </router-link>
          </template>
          <template v-else>
            <router-link to="/login" class="btn-login" @click="mobileMenuOpen = false">Log In</router-link>
            <router-link to="/register" class="btn-register" @click="mobileMenuOpen = false">Register</router-link>
          </template>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const mobileMenuOpen = ref(false)
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
  position: relative;
}

.brand {
  display: flex;
  align-items: center;
  gap: 0.6rem;
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

.mobile-toggle {
  display: none;
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #1b5e20;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
}

.nav-content {
  display: flex;
  align-items: center;
  gap: 2.5rem;
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

@media (max-width: 768px) {
  .mobile-toggle {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 44px;
    min-height: 44px;
  }

  .nav-content {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: #ffffff;
    flex-direction: column;
    align-items: stretch;
    padding: 1.25rem 1.5rem;
    gap: 1.25rem;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    border-bottom: 1px solid #e2ece3;
    z-index: 100;
  }

  .nav-content.is-open {
    display: flex;
  }

  .nav-links {
    flex-direction: column;
    gap: 0.25rem;
  }

  .nav-item {
    padding: 0.65rem 0.5rem;
    font-size: 1rem;
  }

  .nav-auth {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
    padding-top: 0.75rem;
    border-top: 1px solid #f0f0f0;
  }

  .btn-login,
  .btn-register,
  .btn-dashboard {
    text-align: center;
    width: 100%;
    padding: 0.75rem 1rem;
    font-size: 0.95rem;
  }
}
</style>
