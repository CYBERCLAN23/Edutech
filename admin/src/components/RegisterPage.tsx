import { useState } from 'react';
import { api } from '../lib/api';
import { useLang } from '../context/LangContext';

interface Props {
  onLogin: (user: any) => void;
  onBack: () => void;
}

export default function RegisterPage({ onLogin, onBack }: Props) {
  const { t } = useLang();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const rm = t.register;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (code !== 'EDUCAM-ADMIN-2024') { setError(rm.codeError); return; }
    setLoading(true);
    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL || ''}/api/auth/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password, name, role: 'admin' }),
      });
      const data = await res.json();
      if (!data.success) throw new Error(data.error || rm.error);
      onLogin(data.data.user);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background dark:bg-dark-bg flex items-center justify-center p-4 transition-colors">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-primary rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg shadow-primary/20">
            <svg width="28" height="28" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
              <rect width="40" height="40" rx="10" fill="#00677f"/>
              <path d="M12 28V16l8-5 8 5v12H12z" stroke="#fff" strokeWidth="2" fill="none"/>
              <path d="M18 24v-4h4v4" stroke="#00d2ff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              <circle cx="20" cy="19" r="2" fill="#00d2ff"/>
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-primary dark:text-dark-text">{rm.title}</h1>
          <p className="text-on-surface-variant dark:text-dark-text-secondary mt-1">{rm.subtitle}</p>
        </div>
        <form onSubmit={handleSubmit} className="glass-card rounded-2xl p-8">
          <div className="mb-4">
            <label className="block text-sm font-medium text-on-surface dark:text-dark-text mb-2">{rm.name}</label>
            <input type="text" value={name} onChange={e => setName(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant dark:border-dark-border bg-white dark:bg-dark-surface focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all dark:text-dark-text"
              placeholder={rm.namePlaceholder} required />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-on-surface dark:text-dark-text mb-2">{rm.email}</label>
            <input type="email" value={email} onChange={e => setEmail(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant dark:border-dark-border bg-white dark:bg-dark-surface focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all dark:text-dark-text"
              placeholder={rm.emailPlaceholder} required />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-on-surface dark:text-dark-text mb-2">{rm.password}</label>
            <input type="password" value={password} onChange={e => setPassword(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant dark:border-dark-border bg-white dark:bg-dark-surface focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all dark:text-dark-text"
              placeholder={rm.passwordPlaceholder} required minLength={6} />
          </div>
          <div className="mb-6">
            <label className="block text-sm font-medium text-on-surface dark:text-dark-text mb-2">{rm.code}</label>
            <input type="password" value={code} onChange={e => setCode(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant dark:border-dark-border bg-white dark:bg-dark-surface focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all dark:text-dark-text"
              placeholder={rm.codePlaceholder} required />
          </div>
          {error && <p className="text-error text-sm mb-4">{error}</p>}
          <button type="submit" disabled={loading}
            className="w-full py-3 bg-primary text-white rounded-xl font-medium hover:brightness-110 transition-all disabled:opacity-50 soft-gradient mb-3">
            {loading ? rm.loading : rm.register}
          </button>
          <button type="button" onClick={onBack}
            className="w-full py-3 text-on-surface-variant dark:text-dark-text-secondary rounded-xl font-medium hover:bg-surface-container dark:hover:bg-dark-container transition-colors">
            {rm.backToLogin}
          </button>
        </form>
      </div>
    </div>
  );
}