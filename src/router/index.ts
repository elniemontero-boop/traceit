import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

import PublicLayout from '@/components/layout/PublicLayout.vue'
import AuthenticatedLayout from '@/components/layout/AuthenticatedLayout.vue'

import HomeView from '@/views/public/HomeView.vue'
import AboutView from '@/views/public/AboutView.vue'
import ContactView from '@/views/public/ContactView.vue'
import LoginView from '@/views/public/LoginView.vue'
import RegisterView from '@/views/public/RegisterView.vue'

import AlumniDashboardView from '@/views/alumni/AlumniDashboardView.vue'
import RegistrationFormView from '@/views/alumni/RegistrationFormView.vue'
import RegistrationSubmittedView from '@/views/alumni/RegistrationSubmittedView.vue'
import ProfileView from '@/views/alumni/ProfileView.vue'
import AlumniAnnouncementsView from '@/views/alumni/AnnouncementsView.vue'

import AdminDashboardView from '@/views/admin/AdminDashboardView.vue'
import AdminAlumniListView from '@/views/admin/AdminAlumniListView.vue'
import AdminReviewView from '@/views/admin/AdminReviewView.vue'
import AdminReportsView from '@/views/admin/AdminReportsView.vue'
import AdminAnnouncementsView from '@/views/admin/AnnouncementsView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: PublicLayout,
      children: [
        {
          path: '',
          name: 'home',
          component: HomeView,
          meta: { title: 'TraceIt — Alumni Tracer' },
        },
        {
          path: 'about',
          name: 'about',
          component: AboutView,
          meta: { title: 'About — TraceIt' },
        },
        {
          path: 'contact',
          name: 'contact',
          component: ContactView,
          meta: { title: 'Contact — TraceIt' },
        },
      ],
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { title: 'Log In — TraceIt' },
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterView,
      meta: { title: 'Register — TraceIt' },
    },
    {
      path: '/',
      component: AuthenticatedLayout,
      meta: { requiresAuth: true },
      children: [
        {
          path: 'dashboard',
          name: 'alumni-dashboard',
          component: AlumniDashboardView,
          meta: { title: 'Dashboard — TraceIt' },
        },
        {
          path: 'registration-form',
          name: 'registration-form',
          component: RegistrationFormView,
          meta: { title: 'Alumni Registration — TraceIt' },
        },
        {
          path: 'registration-submitted',
          name: 'registration-submitted',
          component: RegistrationSubmittedView,
          meta: { title: 'Registration Submitted — TraceIt' },
        },
        {
          path: 'profile',
          name: 'profile',
          component: ProfileView,
          meta: { title: 'My Profile — TraceIt' },
        },
        {
          path: 'announcements',
          name: 'announcements',
          component: AlumniAnnouncementsView,
          meta: { title: 'Announcements — TraceIt' },
        },
        {
          path: 'admin',
          name: 'admin-dashboard',
          component: AdminDashboardView,
          meta: { requiresAdmin: true, title: 'Admin Dashboard — TraceIt' },
        },
        {
          path: 'admin/alumni',
          name: 'admin-alumni',
          component: AdminAlumniListView,
          meta: { requiresAdmin: true, title: 'Alumni Directory — TraceIt' },
        },
        {
          path: 'admin/review/:id',
          name: 'admin-review',
          component: AdminReviewView,
          props: true,
          meta: { requiresAdmin: true, title: 'Review Registration — TraceIt' },
        },
        {
          path: 'admin/reports',
          name: 'admin-reports',
          component: AdminReportsView,
          meta: { requiresAdmin: true, title: 'Reports & Analytics — TraceIt' },
        },
        {
          path: 'admin/announcements',
          name: 'admin-announcements',
          component: AdminAnnouncementsView,
          meta: { requiresAdmin: true, title: 'Manage Announcements — TraceIt' },
        },
      ],
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: '/',
    },
  ],
})

router.beforeEach(async (to) => {
  const authStore = useAuthStore()
  if (!authStore.initialized) {
    await authStore.init()
  }

  if (to.meta.requiresAuth && !authStore.isLoggedIn) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }

  if (to.meta.requiresAdmin && !authStore.isAdmin) {
    return { name: 'alumni-dashboard' }
  }

  if (to.meta.requiresAuth && authStore.isAlumni && !authStore.isApprovedAlumni) {
    const approval = authStore.approvalStatus || 'pending'
    await authStore.signOut()
    return { name: 'login', query: { approval } }
  }

  if (to.meta.title) {
    document.title = String(to.meta.title)
  }
})

export default router
