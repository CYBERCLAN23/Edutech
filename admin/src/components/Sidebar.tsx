import { LayoutDashboard, Users, BookOpen, Settings, LogOut, School } from 'lucide-react';

const navItems = [
  { id: 'dashboard', label: 'Tableau de bord', icon: LayoutDashboard },
  { id: 'users', label: 'Utilisateurs', icon: Users },
  { id: 'courses', label: 'Cours', icon: BookOpen },
  { id: 'settings', label: 'Système', icon: Settings },
];

interface Props {
  active: string;
  onNavigate: (id: string) => void;
  onLogout: () => void;
  user: { name: string; email: string } | null;
}

export default function Sidebar({ active, onNavigate, onLogout, user }: Props) {
  return (
    <aside className="w-72 bg-surface-container-low min-h-screen flex flex-col shadow-xl">
      <div className="p-8 pb-4">
        <div className="flex items-center gap-3 mb-10">
          <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center shadow-lg shadow-primary/20">
            <School size={22} className="text-white" />
          </div>
          <span className="text-xl font-bold text-primary">EduCam AI</span>
        </div>

        <nav className="space-y-2">
          {navItems.map(({ id, label, icon: Icon }) => (
            <button
              key={id}
              onClick={() => onNavigate(id)}
              className={`w-full flex items-center gap-4 px-4 py-3 rounded-full text-sm font-medium transition-all ${
                active === id
                  ? 'bg-secondary-container text-on-primary-container font-bold'
                  : 'text-on-surface-variant hover:bg-surface-container-high hover:translate-x-1'
              }`}
            >
              <Icon size={20} />
              {label}
            </button>
          ))}
        </nav>
      </div>

      {user && (
        <div className="mt-auto p-6">
          <div className="flex items-center gap-3 p-3 bg-surface-container-lowest rounded-2xl">
            <div className="w-10 h-10 rounded-full bg-outline-variant flex items-center justify-center text-on-surface-variant font-bold text-sm shrink-0">
              {user.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()}
            </div>
            <div className="flex flex-col min-w-0">
              <span className="text-sm font-bold text-on-surface truncate">{user.name}</span>
              <span className="text-[10px] text-outline uppercase tracking-wider">Administrateur</span>
            </div>
          </div>
          <button
            onClick={onLogout}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-full text-sm font-medium text-on-surface-variant hover:bg-error-container/20 hover:text-error transition-all mt-3"
          >
            <LogOut size={18} />
            Déconnexion
          </button>
        </div>
      )}
    </aside>
  );
}
