import type { DashboardStats, AdminUser, AdminCourse, AdminActivity, ClassStats } from './types';

const API_URL = import.meta.env.VITE_API_URL || '';
const BASE = `${API_URL}/api/admin`;
const AUTH = `${API_URL}/api/auth`;

async function fetchJSON<T>(url: string, options?: RequestInit): Promise<T> {
  const token = localStorage.getItem('admin_token');
  const headers: Record<string, string> = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;

  const res = await fetch(url, { ...options, headers });
  if (!res.ok) throw new Error(`HTTP ${res.status}: ${res.statusText}`);
  const text = await res.text();
  if (!text) throw new Error('Réponse vide du serveur');
  try {
    const data = JSON.parse(text);
    if (!data.success) throw new Error(data.error || 'Erreur inconnue');
    return data.data;
  } catch (e) {
    if (e instanceof SyntaxError) throw new Error('Réponse invalide du serveur');
    throw e;
  }
}

export const api = {
  login: async (email: string, password: string) => {
    const res = await fetch(`${AUTH}/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}: ${res.statusText}`);
    const text = await res.text();
    if (!text) throw new Error('Réponse vide du serveur');
    const data = JSON.parse(text);
    if (!data.success) throw new Error(data.error || 'Échec de connexion');
    if (data.data.user.role !== 'admin') throw new Error('Accès réservé aux administrateurs');
    localStorage.setItem('admin_token', data.data.token);
    return data.data;
  },

  logout: () => {
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_user');
  },

  getDashboard: () => fetchJSON<DashboardStats>(`${BASE}/dashboard`),
  getUsers: (role?: string) => fetchJSON<AdminUser[]>(`${BASE}/users${role ? `?role=${role}` : ''}`),
  deleteUser: async (id: string) => { await fetchJSON(`${BASE}/users/${id}`); },
  getCourses: () => fetchJSON<{ courses: AdminCourse[]; grouped: Record<string, AdminCourse[]> }>(`${BASE}/courses`),
  getActivities: (limit = 20) => fetchJSON<AdminActivity[]>(`${BASE}/activities?limit=${limit}`),
  getClassStats: () => fetchJSON<ClassStats[]>(`${BASE}/stats/classes`),
};
