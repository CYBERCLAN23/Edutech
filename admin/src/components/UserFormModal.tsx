import { useState } from 'react';
import { X } from 'lucide-react';
import { api } from '../lib/api';
import type { AdminUser } from '../lib/types';

interface Props {
  mode: 'create-student' | 'create-teacher' | 'edit';
  user?: AdminUser;
  onClose: () => void;
  onSaved: () => void;
}

export default function UserFormModal({ mode, user, onClose, onSaved }: Props) {
  const isEdit = mode === 'edit';
  const [email, setEmail] = useState(user?.email || '');
  const [password, setPassword] = useState('');
  const [name, setName] = useState(user?.name || '');
  const [class_name, setClass_name] = useState(user?.class_name || '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const role = isEdit ? (user?.role || 'student')
    : mode === 'create-teacher' ? 'teacher' : 'student';

  const title = isEdit ? 'Modifier l\'utilisateur'
    : mode === 'create-teacher' ? 'Ajouter un professeur'
    : 'Ajouter un élève';

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError('');
    try {
      if (isEdit && user) {
        await api.updateUser(user.id, { name, class_name: class_name || null });
      } else {
        await api.createUser({ email, password, name, role, class_name: class_name || undefined });
      }
      onSaved();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  const label = role === 'teacher' ? 'Professeur' : role === 'student' ? 'Élève' : 'Admin';

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-white rounded-2xl w-full max-w-md p-6 mx-4 shadow-2xl">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-lg font-bold text-[#0D1B2A]">{title}</h2>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-xl transition-colors">
            <X size={18} className="text-gray-400" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          {!isEdit && (
            <>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Rôle</label>
                <div className="px-4 py-3 bg-gray-50 rounded-xl text-sm text-gray-500 border border-gray-200">
                  {label}
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                <input
                  type="email" required value={email}
                  onChange={e => setEmail(e.target.value)}
                  className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
                  placeholder="email@exemple.com"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Mot de passe</label>
                <input
                  type="password" required value={password}
                  onChange={e => setPassword(e.target.value)}
                  className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
                  placeholder="Min. 6 caractères"
                  minLength={6}
                />
              </div>
            </>
          )}

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Nom complet</label>
            <input
              type="text" required value={name}
              onChange={e => setName(e.target.value)}
              className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
              placeholder="Nom et prénom"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Classe</label>
            <input
              type="text" value={class_name}
              onChange={e => setClass_name(e.target.value)}
              className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
              placeholder={role === 'student' ? 'Ex: Terminale C' : 'Laisser vide'}
            />
          </div>

          {error && <p className="text-red-500 text-sm">{error}</p>}

          <div className="flex gap-3 pt-2">
            <button type="button" onClick={onClose}
              className="flex-1 px-4 py-3 border border-gray-200 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-50 transition-all">
              Annuler
            </button>
            <button type="submit" disabled={saving}
              className="flex-1 px-4 py-3 bg-[#4F46E5] text-white rounded-xl text-sm font-medium hover:bg-[#4338CA] disabled:opacity-50 transition-all">
              {saving ? 'Enregistrement...' : isEdit ? 'Enregistrer' : 'Créer'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
