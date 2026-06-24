import { useState, useCallback, useRef } from 'react';
import { X, Copy, Check, RefreshCw } from 'lucide-react';
import { api } from '../lib/api';
import type { AdminUser } from '../lib/types';

interface Props {
  mode: 'create-student' | 'create-teacher' | 'edit';
  user?: AdminUser;
  onClose: () => void;
  onSaved: () => void;
}

function generateEmail(name: string): string {
  return name
    .toLowerCase()
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s.-]/g, '')
    .trim().replace(/\s+/g, '.')
    .replace(/\.+/g, '.')
    .replace(/^\.|\.$/g, '')
    .slice(0, 40) + '@educam.cm';
}

function generatePassword(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
  let pwd = '';
  for (let i = 0; i < 10; i++) pwd += chars[Math.floor(Math.random() * chars.length)];
  return pwd;
}

export default function UserFormModal({ mode, user, onClose, onSaved }: Props) {
  const isEdit = mode === 'edit';
  const isTeacher = mode === 'create-teacher';
  const [name, setName] = useState(user?.name || '');
  const [email, setEmail] = useState(user?.email || '');
  const [password, setPassword] = useState(isEdit ? '' : generatePassword());
  const [class_name, setClass_name] = useState(user?.class_name || '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [result, setResult] = useState<{ name: string; email: string; password: string } | null>(null);
  const [copied, setCopied] = useState(false);

  const emailRef = useRef<HTMLInputElement>(null);

  const role = isEdit ? (user?.role || 'student') : isTeacher ? 'teacher' : 'student';

  const title = isEdit ? 'Modifier l\'utilisateur'
    : isTeacher ? 'Ajouter un professeur'
    : 'Ajouter un élève';

  const nameChanged = useCallback((val: string) => {
    setName(val);
    if (!isEdit && !user?.email && emailRef.current) {
      const auto = generateEmail(val);
      setEmail(auto);
    }
  }, [isEdit, user]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError('');
    try {
      if (isEdit && user) {
        await api.updateUser(user.id, { name, class_name: class_name || null });
        onSaved();
      } else {
        const body: any = { name, role };
        if (email) body.email = email;
        if (password) body.password = password;
        if (class_name) body.class_name = class_name;
        const res = await api.createUser(body);
        setResult({
          name: res.user.name,
          email: res.user.email,
          password: res.generatedPassword || password,
        });
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  const handleCopy = async () => {
    if (!result) return;
    const text = `Identifiants ${result.name}\nEmail: ${result.email}\nMot de passe: ${result.password}`;
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch { /* fallback */ }
  };

  if (result) {
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
        <div className="bg-white rounded-2xl w-full max-w-md p-6 mx-4 shadow-2xl">
          <div className="w-14 h-14 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-4">
            <Check size={28} className="text-green-600" />
          </div>
          <h2 className="text-xl font-bold text-center text-[#0D1B2A] mb-1">Compte créé avec succès !</h2>
          <p className="text-center text-gray-500 text-sm mb-6">Remettez ces identifiants au professeur.</p>

          <div className="bg-gray-50 rounded-xl p-4 space-y-3 mb-6 border border-gray-200">
            <div>
              <p className="text-xs text-gray-400 uppercase tracking-wide font-medium">Nom</p>
              <p className="text-sm font-medium text-[#0D1B2A] mt-0.5">{result.name}</p>
            </div>
            <div>
              <p className="text-xs text-gray-400 uppercase tracking-wide font-medium">Email</p>
              <p className="text-sm font-medium text-[#0D1B2A] mt-0.5 font-mono">{result.email}</p>
            </div>
            <div>
              <p className="text-xs text-gray-400 uppercase tracking-wide font-medium">Mot de passe</p>
              <p className="text-sm font-medium text-[#0D1B2A] mt-0.5 font-mono tracking-wider">{result.password}</p>
            </div>
          </div>

          <div className="flex gap-3">
            <button onClick={handleCopy}
              className="flex-1 flex items-center justify-center gap-2 px-4 py-3 bg-[#4F46E5] text-white rounded-xl text-sm font-medium hover:bg-[#4338CA] transition-all">
              {copied ? <><Check size={16} /> Copié !</> : <><Copy size={16} /> Copier les identifiants</>}
            </button>
            <button onClick={onClose}
              className="px-4 py-3 border border-gray-200 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-50 transition-all">
              Fermer
            </button>
          </div>
        </div>
      </div>
    );
  }

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
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Rôle</label>
            <div className="px-4 py-3 bg-gray-50 rounded-xl text-sm text-gray-500 border border-gray-200">
              {role === 'teacher' ? 'Professeur' : role === 'student' ? 'Élève' : 'Admin'}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Nom complet *</label>
            <input type="text" required value={name}
              onChange={e => nameChanged(e.target.value)}
              className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
              placeholder="Ex: Jean Dupont" autoFocus />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Email {isTeacher ? '(généré automatiquement)' : '*'}</label>
            <input type="email" ref={emailRef}
              value={email} required
              onChange={e => setEmail(e.target.value)}
              className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm font-mono" />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Mot de passe {isTeacher ? '(généré automatiquement)' : '*'}
            </label>
            <div className="flex gap-2">
              <input type="text" required value={password} minLength={6}
                onChange={e => setPassword(e.target.value)}
                className="flex-1 px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm font-mono tracking-wider" />
              <button type="button" onClick={() => setPassword(generatePassword())}
                className="px-3 py-3 border border-gray-200 rounded-xl text-gray-400 hover:text-[#4F46E5] hover:border-[#4F46E5] transition-all"
                title="Générer un nouveau mot de passe">
                <RefreshCw size={18} />
              </button>
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Classe</label>
            <input type="text" value={class_name}
              onChange={e => setClass_name(e.target.value)}
              className="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:border-[#4F46E5] focus:ring-2 focus:ring-[#4F46E5]/20 outline-none text-sm"
              placeholder={role === 'student' ? 'Ex: Terminale C' : 'Laisser vide'} />
          </div>

          {error && <p className="text-red-500 text-sm">{error}</p>}

          <div className="flex gap-3 pt-2">
            <button type="button" onClick={onClose}
              className="flex-1 px-4 py-3 border border-gray-200 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-50 transition-all">
              Annuler
            </button>
            <button type="submit" disabled={saving}
              className="flex-1 px-4 py-3 bg-[#4F46E5] text-white rounded-xl text-sm font-medium hover:bg-[#4338CA] disabled:opacity-50 transition-all">
              {saving ? 'Création...' : isEdit ? 'Enregistrer' : 'Créer le compte'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
