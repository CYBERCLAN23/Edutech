import { useState } from 'react';
import { api } from '../lib/api';

interface Props {
  onLogin: (user: any) => void;
  onBack: () => void;
}

export default function RegisterPage({ onLogin, onBack }: Props) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (code !== 'EDUCAM-ADMIN-2024') { setError("Code d'inscription invalide"); return; }
    setLoading(true);
    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL || ''}/api/auth/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password, name, role: 'admin' }),
      });
      const data = await res.json();
      if (!data.success) throw new Error(data.error || 'Erreur');
      onLogin(data.data.user);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-primary rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg shadow-primary/20">
            <span className="text-white text-2xl font-bold">EA</span>
          </div>
          <h1 className="text-2xl font-bold text-primary">Créer un compte admin</h1>
          <p className="text-on-surface-variant mt-1">EduCam AI - Administration</p>
        </div>
        <form onSubmit={handleSubmit} className="glass-card rounded-2xl p-8">
          <div className="mb-4">
            <label className="block text-sm font-medium text-on-surface mb-2">Nom complet</label>
            <input type="text" value={name} onChange={e => setName(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant bg-white focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"
              placeholder="Admin EduCam" required />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-on-surface mb-2">Email</label>
            <input type="email" value={email} onChange={e => setEmail(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant bg-white focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"
              placeholder="admin@educam.cm" required />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-on-surface mb-2">Mot de passe</label>
            <input type="password" value={password} onChange={e => setPassword(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant bg-white focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"
              placeholder="••••••••" required minLength={6} />
          </div>
          <div className="mb-6">
            <label className="block text-sm font-medium text-on-surface mb-2">Code d'inscription</label>
            <input type="password" value={code} onChange={e => setCode(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant bg-white focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"
              placeholder="••••••••••••" required />
          </div>
          {error && <p className="text-error text-sm mb-4">{error}</p>}
          <button type="submit" disabled={loading}
            className="w-full py-3 bg-primary text-white rounded-xl font-medium hover:brightness-110 transition-all disabled:opacity-50 soft-gradient mb-3">
            {loading ? 'Création...' : 'Créer le compte'}
          </button>
          <button type="button" onClick={onBack}
            className="w-full py-3 text-on-surface-variant rounded-xl font-medium hover:bg-surface-container transition-colors">
            Déjà un compte ? Se connecter
          </button>
        </form>
      </div>
    </div>
  );
}
