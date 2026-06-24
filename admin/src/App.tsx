import { useState, useEffect } from 'react';
import Sidebar from './components/Sidebar';
import LoginPage from './components/LoginPage';
import DashboardPage from './pages/DashboardPage';
import UsersPage from './pages/UsersPage';
import CoursesPage from './pages/CoursesPage';
import SettingsPage from './pages/SettingsPage';
import { api } from './lib/api';

const PAGES = ['dashboard', 'users', 'courses', 'settings'] as const;
type Page = (typeof PAGES)[number];

function App() {
  const [page, setPage] = useState<Page>('dashboard');
  const [user, setUser] = useState<{ name: string; email: string } | null>(() => {
    const stored = localStorage.getItem('admin_user');
    const token = localStorage.getItem('admin_token');
    if (stored && token) {
      try { return JSON.parse(stored); } catch { return null; }
    }
    return null;
  });

  useEffect(() => {
    if (user) localStorage.setItem('admin_user', JSON.stringify(user));
    else {
      localStorage.removeItem('admin_user');
      localStorage.removeItem('admin_token');
    }
  }, [user]);

  const handleLogout = () => {
    api.logout();
    setUser(null);
    setPage('dashboard');
  };

  if (!user) return <LoginPage onLogin={(u) => setUser(u)} />;

  const PageComponent = page === 'dashboard' ? DashboardPage
    : page === 'users' ? UsersPage
    : page === 'courses' ? CoursesPage
    : SettingsPage;

  return (
    <div className="flex min-h-screen bg-[#F8FAFC]">
      <Sidebar active={page} onNavigate={(id) => setPage(id as Page)} onLogout={handleLogout} user={user} />
      <main className="flex-1 p-8 overflow-auto">
        <PageComponent />
      </main>
    </div>
  );
}

export default App;
