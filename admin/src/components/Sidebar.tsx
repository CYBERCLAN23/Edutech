import { LayoutDashboard, Users, BookOpen, Settings, LogOut } from 'lucide-react';

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
    <aside className="w-64 bg-[#0D1B2A] min-h-screen flex flex-col">
      <div className="p-6 border-b border-white/10">
        <h1 className="text-white text-xl font-bold tracking-tight">EduCam AI</h1>
        <p className="text-white/50 text-sm mt-1">Administration</p>
      </div>

      {user && (
        <div className="px-6 py-4 border-b border-white/10">
          <p className="text-white text-sm font-medium truncate">{user.name}</p>
          <p className="text-white/40 text-xs truncate">{user.email}</p>
        </div>
      )}

      <nav className="flex-1 p-4 space-y-1">
        {navItems.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => onNavigate(id)}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all ${
              active === id
                ? 'bg-[#4F46E5] text-white shadow-lg shadow-[#4F46E5]/25'
                : 'text-white/60 hover:text-white hover:bg-white/5'
            }`}
          >
            <Icon size={18} />
            {label}
          </button>
        ))}
      </nav>

      <div className="p-4 border-t border-white/10">
        <button
          onClick={onLogout}
          className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-red-400 hover:bg-red-500/10 transition-all"
        >
          <LogOut size={18} />
          Déconnexion
        </button>
      </div>
    </aside>
  );
}
