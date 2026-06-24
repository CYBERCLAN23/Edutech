import { useEffect, useState } from 'react';
import { Trash2, Search } from 'lucide-react';
import { api } from '../lib/api';
import type { AdminUser } from '../lib/types';

const roleColors: Record<string, string> = {
  student: 'bg-green-50 text-green-700 border-green-200',
  teacher: 'bg-indigo-50 text-indigo-700 border-indigo-200',
  admin: 'bg-amber-50 text-amber-700 border-amber-200',
};
const roleLabels: Record<string, string> = {
  student: 'Élève', teacher: 'Professeur', admin: 'Admin',
};

export default function UsersPage() {
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [filter, setFilter] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const load = async () => {
    setLoading(true); setError('');
    try { setUsers(await api.getUsers()); }
    catch (err: any) { setError(err.message); }
    finally { setLoading(false); }
  };

  useEffect(() => { load(); }, []);

  const handleDelete = async (id: string, name: string) => {
    if (!confirm(`Supprimer l'utilisateur "${name}" ? Cette action est irréversible.`)) return;
    try {
      await api.deleteUser(id);
      setUsers(prev => prev.filter(u => u.id !== id));
    } catch (err: any) { alert(err.message); }
  };

  const filtered = users
    .filter(u => !filter || u.role === filter)
    .filter(u => !search || u.name.toLowerCase().includes(search.toLowerCase()) || u.email.toLowerCase().includes(search.toLowerCase()));

  const counts = {
    all: users.length,
    student: users.filter(u => u.role === 'student').length,
    teacher: users.filter(u => u.role === 'teacher').length,
    admin: users.filter(u => u.role === 'admin').length,
  };

  const filters = [
    { key: null, label: 'Tous', count: counts.all },
    { key: 'student', label: 'Élèves', count: counts.student },
    { key: 'teacher', label: 'Professeurs', count: counts.teacher },
    { key: 'admin', label: 'Admins', count: counts.admin },
  ];

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Utilisateurs</h1>
          <p className="text-gray-500 mt-1">{users.length} inscrits sur la plateforme</p>
        </div>
      </div>

      <div className="flex flex-wrap gap-2 mb-6">
        {filters.map(f => (
          <button
            key={f.key ?? 'all'}
            onClick={() => setFilter(f.key)}
            className={`px-4 py-2 rounded-xl text-sm font-medium border transition-all ${
              filter === f.key ? 'bg-[#4F46E5] text-white border-[#4F46E5]' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-300'
            }`}
          >
            {f.label} ({f.count})
          </button>
        ))}
      </div>

      <div className="relative mb-6">
        <Search size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
        <input
          type="text" placeholder="Rechercher par nom ou email..." value={search} onChange={e => setSearch(e.target.value)}
          className="w-full pl-11 pr-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
        />
      </div>

      {loading ? (
        <div className="flex justify-center py-20"><div className="animate-spin w-8 h-8 border-4 border-[#4F46E5] border-t-transparent rounded-full" /></div>
      ) : error ? (
        <div className="text-center py-20"><p className="text-red-500 mb-4">{error}</p><button onClick={load} className="px-6 py-2 bg-[#4F46E5] text-white rounded-xl">Réessayer</button></div>
      ) : (
        <div className="space-y-2">
          {filtered.map(u => (
            <div key={u.id} className="bg-white rounded-xl p-4 border border-gray-100 hover:shadow-sm transition-shadow flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-[#4F46E5] flex items-center justify-center text-white text-sm font-bold shrink-0">
                {u.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-[#0D1B2A] truncate">{u.name}</p>
                <p className="text-xs text-gray-400 truncate">{u.email}{u.class_name ? ` · ${u.class_name}` : ''}</p>
              </div>
              <span className={`px-3 py-1 rounded-lg text-xs font-medium border ${roleColors[u.role] || ''}`}>
                {roleLabels[u.role] || u.role}
              </span>
              <button
                onClick={() => handleDelete(u.id, u.name)}
                className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-all"
              >
                <Trash2 size={16} />
              </button>
            </div>
          ))}
          {filtered.length === 0 && <p className="text-center py-10 text-gray-400">Aucun utilisateur trouvé</p>}
        </div>
      )}
    </div>
  );
}
