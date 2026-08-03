<template>
  <div class="auth-page">
    <div class="auth-card">
      <img src="@/assets/logo.png" alt="RSU Logo" class="auth-logo" />
      <h1 class="brand">TraceIt</h1>
      <p class="subtitle">Alumni Tracer System</p>

      <div v-if="cooldownRemaining > 0" class="cooldown-box">
        <p class="cooldown-title">🔒 Account Temporarily Locked</p>
        <p class="cooldown-text">
          Too many incorrect attempts (3/3). Please wait <strong>{{ cooldownRemaining }}s</strong> before trying again.
        </p>
      </div>

      <form @submit.prevent="handleLogin" class="auth-form">
        <label class="field">
          <span>Email</span>
          <input
            v-model="email"
            type="email"
            required
            placeholder="you@example.com"
            :disabled="loading || cooldownRemaining > 0"
          />
        </label>

        <label class="field">
          <span>Password</span>
          <input
            v-model="password"
            type="password"
            required
            placeholder="••••••••"
            :disabled="loading || cooldownRemaining > 0"
          />
        </label>

        <p v-if="errorMessage && cooldownRemaining === 0" class="error-text">{{ errorMessage }}</p>

        <button type="submit" class="btn-primary" :disabled="loading || cooldownRemaining > 0">
          <span v-if="cooldownRemaining > 0">Locked ({{ cooldownRemaining }}s)</span>
          <span v-else-if="loading">Signing in…</span>
          <span v-else>Log In</span>
        </button>
      </form>

      <p class="switch-auth">
        Don't have an account?
        <router-link to="/register">Register here</router-link>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')

const MAX_ATTEMPTS = 3
const COOLDOWN_DURATION = 30 // seconds
const STORAGE_KEY_LOCKOUT = 'traceit_login_lockout_until'
const STORAGE_KEY_ATTEMPTS = 'traceit_login_failed_attempts'

const failedAttempts = ref(0)
const cooldownRemaining = ref(0)
let timer: ReturnType<typeof setInterval> | null = null

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

function checkLockout(): boolean {
  const storedLockout = localStorage.getItem(STORAGE_KEY_LOCKOUT)
  if (storedLockout) {
    const lockoutUntil = parseInt(storedLockout, 10)
    const now = Date.now()
    if (lockoutUntil > now) {
      startCooldown(Math.ceil((lockoutUntil - now) / 1000))
      return true
    } else {
      localStorage.removeItem(STORAGE_KEY_LOCKOUT)
      localStorage.removeItem(STORAGE_KEY_ATTEMPTS)
      failedAttempts.value = 0
    }
  }

  const storedAttempts = localStorage.getItem(STORAGE_KEY_ATTEMPTS)
  if (storedAttempts) {
    failedAttempts.value = parseInt(storedAttempts, 10) || 0
  }
  return false
}

function startCooldown(seconds: number) {
  cooldownRemaining.value = seconds
  if (timer) clearInterval(timer)

  timer = setInterval(() => {
    cooldownRemaining.value--
    if (cooldownRemaining.value <= 0) {
      if (timer) clearInterval(timer)
      timer = null
      cooldownRemaining.value = 0
      failedAttempts.value = 0
      localStorage.removeItem(STORAGE_KEY_LOCKOUT)
      localStorage.removeItem(STORAGE_KEY_ATTEMPTS)
      errorMessage.value = ''
    }
  }, 1000)
}

onMounted(() => {
  checkLockout()
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

async function handleLogin() {
  if (cooldownRemaining.value > 0) return

  loading.value = true
  errorMessage.value = ''

  const { error } = await supabase.auth.signInWithPassword({
    email: email.value,
    password: password.value,
  })

  if (error) {
    loading.value = false
    failedAttempts.value += 1
    localStorage.setItem(STORAGE_KEY_ATTEMPTS, failedAttempts.value.toString())

    if (failedAttempts.value >= MAX_ATTEMPTS) {
      const lockoutUntil = Date.now() + COOLDOWN_DURATION * 1000
      localStorage.setItem(STORAGE_KEY_LOCKOUT, lockoutUntil.toString())
      startCooldown(COOLDOWN_DURATION)
    } else {
      const remaining = MAX_ATTEMPTS - failedAttempts.value
      errorMessage.value = `${error.message || 'Invalid credentials.'} (Attempt ${failedAttempts.value}/${MAX_ATTEMPTS} — ${remaining} remaining before lock)`
    }
    return
  }

  failedAttempts.value = 0
  localStorage.removeItem(STORAGE_KEY_LOCKOUT)
  localStorage.removeItem(STORAGE_KEY_ATTEMPTS)

  await authStore.fetchRole()

  const redirect = (route.query.redirect as string) || '/'
  router.push(redirect)
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(15, 45, 18, 0.78), rgba(27, 94, 32, 0.85)),
    url('@/assets/bg.jpg') center/cover no-repeat;
  padding: 2rem 1rem;
}

.auth-card {
  width: 100%;
  max-width: 420px;
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  padding: 2.5rem 2rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.4);
}

.auth-logo {
  height: 64px;
  width: auto;
  margin: 0 auto 0.75rem;
  display: block;
  object-fit: contain;
}

.brand {
  color: #1b5e20;
  font-size: 1.8rem;
  font-weight: 700;
  text-align: center;
  margin: 0;
}

.subtitle {
  text-align: center;
  color: #4caf50;
  font-size: 0.9rem;
  margin-top: 0.25rem;
  margin-bottom: 2rem;
}

.cooldown-box {
  background-color: #fff3e0;
  border: 1px solid #ffe0b2;
  border-radius: 8px;
  padding: 1rem;
  margin-bottom: 1.25rem;
  text-align: center;
}

.cooldown-title {
  color: #e65100;
  font-weight: 700;
  margin: 0 0 0.25rem;
  font-size: 0.95rem;
}

.cooldown-text {
  color: #bf360c;
  font-size: 0.85rem;
  margin: 0;
  line-height: 1.4;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  font-size: 0.9rem;
  color: #2e2e2e;
}

.field input {
  padding: 0.65rem 0.8rem;
  border: 1px solid #bcdec0;
  border-radius: 8px;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.15s ease;
}

.field input:focus {
  border-color: #2e7d32;
}

.field input:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
}

.error-text {
  color: #c62828;
  font-size: 0.85rem;
  margin: 0;
}

.btn-primary {
  background-color: #2e7d32;
  color: #ffffff;
  border: none;
  padding: 0.75rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.btn-primary:hover:not(:disabled) {
  background-color: #1b5e20;
}

.btn-primary:disabled {
  background-color: #a5d6a7;
  cursor: not-allowed;
}

.switch-auth {
  text-align: center;
  font-size: 0.85rem;
  margin-top: 1.5rem;
  color: #555;
}

.switch-auth a {
  color: #2e7d32;
  font-weight: 600;
  text-decoration: none;
}

.switch-auth a:hover {
  text-decoration: underline;
}
</style>