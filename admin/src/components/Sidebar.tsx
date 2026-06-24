import { LayoutDashboard, Users, BookOpen, Settings, LogOut, Sun, Moon, Languages } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import { useLang } from '../context/LangContext';

const navItems = [
  { id: 'dashboard', labelKey: 'dashboard', icon: LayoutDashboard },
  { id: 'users', labelKey: 'users', icon: Users },
  { id: 'courses', labelKey: 'courses', icon: BookOpen },
  { id: 'settings', labelKey: 'settings', icon: Settings },
] as const;

const eduCamLogoSvg = (
  <svg width="22" height="22" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="40" height="40" rx="10" fill="#00677f"/>
    <path d="M12 28V16l8-5 8 5v12H12z" stroke="#fff" strokeWidth="2" fill="none"/>
    <path d="M18 24v-4h4v4" stroke="#00d2ff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
    <circle cx="20" cy="19" r="2" fill="#00d2ff"/>
  </svg>
);

interface Props {
  active: string;
  onNavigate: (id: string) => void;
  onLogout: () => void;
  user: { name: string; email: string } | null;
}

export default function Sidebar({ active, onNavigate, onLogout, user }: Props) {
  const { theme, toggle: toggleTheme } = useTheme();
  const { lang, t, toggle: toggleLang } = useLang();

  return (
    <aside className="w-72 bg-surface-container-low dark:bg-[#0F172A] min-h-screen flex flex-col shadow-xl transition-colors">
      <div className="p-8 pb-4">
        <div className="flex items-center gap-3 mb-10">
          <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center shadow-lg shadow-primary/20">
            {eduCamLogoSvg}
          </div>
          <span className="text-xl font-bold text-primary dark:text-white">EduCam AI</span>
        </div>

        <nav className="space-y-2">
          {navItems.map(({ id, labelKey, icon: Icon }) => (
            <button
              key={id}
              onClick={() => onNavigate(id)}
              className={`w-full flex items-center gap-4 px-4 py-3 rounded-full text-sm font-medium transition-all ${
                active === id
                  ? 'bg-secondary-container text-on-primary-container font-bold dark:bg-secondary/20 dark:text-primary-light'
                  : 'text-on-surface-variant dark:text-white/60 hover:bg-surface-container-high dark:hover:bg-white/5 hover:translate-x-1'
              }`}
            >
              <Icon size={20} />
              {t.nav[labelKey]}
            </button>
          ))}
        </nav>
      </div>

      <div className="px-6 space-y-2">
        <div className="flex items-center gap-2 p-2 rounded-xl bg-surface-container dark:bg-white/5">
          <button
            onClick={toggleTheme}
            className="flex-1 flex items-center justify-center gap-2 py-2 rounded-lg text-xs font-medium transition-all"
          >
            <Sun size={14} className={theme === 'light' ? 'text-primary' : 'text-outline dark:text-white/40'} />
            <span className={theme === 'light' ? 'text-primary font-bold' : 'text-outline dark:text-white/40'}>{t.light}</span>
          </button>
          <button
            onClick={toggleLang}
            className="flex-1 flex items-center justify-center gap-2 py-2 rounded-lg text-xs font-medium transition-all"
          >
            <Languages size={14} className="text-outline dark:text-white/40" />
            <span className="text-outline dark:text-white/40">{lang === 'fr' ? 'FR' : 'EN'}</span>
          </button>
        </div>
      </div>

      {user && (
        <div className="mt-auto p-6">
          <div className="flex items-center gap-3 p-3 bg-surface-container-lowest dark:bg-white/5 rounded-2xl">
            <div className="w-10 h-10 rounded-full bg-outline-variant flex items-center justify-center text-on-surface-variant dark:text-white font-bold text-sm shrink-0">
              {user.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()}
            </div>
            <div className="flex flex-col min-w-0">
              <span className="text-sm font-bold text-on-surface dark:text-white truncate">{user.name}</span>
              <span className="text-[10px] text-outline dark:text-white/40 uppercase tracking-wider">{t.nav.admin}</span>
            </div>
          </div>
          <button
            onClick={onLogout}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-full text-sm font-medium text-on-surface-variant dark:text-white/60 hover:bg-error-container/20 hover:text-error transition-all mt-3"
          >
            <LogOut size={18} />
            {t.nav.logout}
          </button>
        </div>
      )}
    </aside>
  );
}
