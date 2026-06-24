import { useEffect, useState } from 'react';
import { Trash2, Search, Pencil, UserPlus, GraduationCap, School } from 'lucide-react';
import { api } from '../lib/api';
import { useLang } from '../context/LangContext';
import type { AdminUser } from '../lib/types';
import UserFormModal from '../components/UserFormModal';
import ConfirmModal from '../components/ConfirmModal';

const roleColors: Record<string, string> = {
  student: 'bg-tertiary/10 text-tertiary border-tertiary/20',
  teacher: 'bg-secondary/10 text-secondary border-secondary/20',
  admin: 'bg-amber-50 text-amber-700 border-amber-200',
};

export default function UsersPage() {
  const { t } = useLang();
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [filter, setFilter] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [modal, setModal] = useState<{ mode: 'create-student' | 'create-teacher' | 'edit'; user?: AdminUser } | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<{ id: string; name: string } | null>(null);
  const [deleting, setDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState('');

  const load = async () => {
    setLoading(true); setError('');
    try { setUsers(await api.getUsers()); }
    catch (err: any) { setError(err.message); }
    finally { setLoading(false); }
  };

  useEffect(() => { load(); }, []);

  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true); setDeleteError('');
    try {
      await api.deleteUser(deleteTarget.id);
      setUsers(prev => prev.filter(u => u.id !== deleteTarget.id));
      setDeleteTarget(null);
    } catch (err: any) {
      setDeleteError(err.message);
    } finally {
      setDeleting(false);
    }
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

  const um = t.users;
  const roleLabels: Record<string, string> = {
    student: um.roleStudent, teacher: um.roleTeacher, admin: um.roleAdmin,
  };

  const filters = [
    { key: null, label: um.all, count: counts.all },
    { key: 'student', label: um.students, count: counts.student },
    { key: 'teacher', label: um.teachers, count: counts.teacher },
    { key: 'admin', label: um.admins, count: counts.admin },
  ];

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-primary dark:text-white">{um.title}</h1>
          <p className="text-on-surface-variant dark:text-white/60 mt-1">{users.length} {um.subtitle}</p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => setModal({ mode: 'create-teacher' })}
            className="flex items-center gap-2 px-4 py-2.5 bg-secondary/10 text-secondary border border-secondary/20 rounded-xl text-sm font-medium hover:bg-secondary/20 transition-all"
          >
            <School size={16} />
            {um.addTeacher}
          </button>
          <button
            onClick={() => setModal({ mode: 'create-student' })}
            className="flex items-center gap-2 px-4 py-2.5 bg-primary text-white rounded-xl text-sm font-medium hover:brightness-110 transition-all soft-gradient"
          >
            <UserPlus size={16} />
            {um.addStudent}
          </button>
        </div>
      </div>

      <div className="grid grid-cols-4 gap-4 mb-8">
        {filters.map(f => (
          <button key={f.key ?? 'all'} onClick={() => setFilter(f.key)}
            className={`text-left p-4 rounded-xl border transition-all glass-card dark:bg-white/5 ${
              filter === f.key ? 'bg-primary text-white border-primary' : 'text-on-surface dark:text-white border-outline-variant/20'
            }`}
          >
            <p className="text-2xl font-bold">{f.count}</p>
            <p className="text-sm opacity-70">{f.label}</p>
          </button>
        ))}
      </div>

      <div className="relative mb-6">
        <Search size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-outline" />
        <input
          type="text" placeholder={um.search} value={search} onChange={e => setSearch(e.target.value)}
          className="w-full pl-11 pr-4 py-3 bg-white dark:bg-white/5 border border-outline-variant dark:border-white/20 rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-sm dark:text-white"
        />
      </div>

      {loading ? (
        <div className="flex justify-center py-20"><div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" /></div>
      ) : error ? (
        <div className="text-center py-20"><p className="text-error mb-4">{error}</p><button onClick={load} className="px-6 py-2 bg-primary text-white rounded-xl soft-gradient">{um.retry}</button></div>
      ) : (
        <div className="space-y-2">
          {filtered.map(u => (
            <div key={u.id} className="glass-card dark:bg-white/5 rounded-xl p-4 border border-outline-variant/10 hover:shadow-sm transition-shadow flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-primary flex items-center justify-center text-white text-sm font-bold shrink-0">
                {u.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-on-surface dark:text-white truncate">{u.name}</p>
                <p className="text-xs text-on-surface-variant dark:text-white/60 truncate">{u.email}{u.class_name ? ` · ${u.class_name}` : ''}</p>
              </div>
              <span className={`px-3 py-1 rounded-lg text-xs font-medium border ${roleColors[u.role] || ''}`}>
                {roleLabels[u.role] || u.role}
              </span>
              <button
                onClick={() => setModal({ mode: 'edit', user: u })}
                className="p-2 text-outline dark:text-white/40 hover:text-primary hover:bg-primary/10 rounded-lg transition-all"
              >
                <Pencil size={16} />
              </button>
              <button
                onClick={() => setDeleteTarget({ id: u.id, name: u.name })}
                className="p-2 text-outline dark:text-white/40 hover:text-error hover:bg-error-container/20 rounded-lg transition-all"
              >
                <Trash2 size={16} />
              </button>
            </div>
          ))}
          {filtered.length === 0 && <p className="text-center py-10 text-on-surface-variant dark:text-white/40">{um.noResults}</p>}
        </div>
      )}

      {modal && (
        <UserFormModal
          mode={modal.mode}
          user={modal.user}
          onClose={() => setModal(null)}
          onSaved={() => { setModal(null); load(); }}
        />
      )}

      {deleteTarget && (
        <ConfirmModal
          title={`${um.delete} ${deleteTarget.name}`}
          message={`Êtes-vous sûr de vouloir supprimer "${deleteTarget.name}" ? Cette action est irréversible.`}
          confirmLabel={um.delete}
          danger
          loading={deleting}
          error={deleteError}
          onConfirm={handleDelete}
          onCancel={() => { setDeleteTarget(null); setDeleteError(''); }}
        />
      )}
    </div>
  );
}
