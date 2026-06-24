import { useState } from 'react';
import { api } from '../lib/api';
import { useLang } from '../context/LangContext';

interface Props {
  onLogin: (user: any) => void;
  onRegister?: () => void;
}

export default function LoginPage({ onLogin, onRegister }: Props) {
  const { t } = useLang();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const lm = t.login;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const data = await api.login(email, password);
      onLogin(data.user);
    } catch (err: any) {
      setError(lm.error);
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
          <h1 className="text-2xl font-bold text-primary dark:text-dark-text">{lm.title}</h1>
          <p className="text-on-surface-variant dark:text-dark-text-secondary mt-1">{lm.subtitle}</p>
        </div>
        <form onSubmit={handleSubmit} className="glass-card rounded-2xl p-8">
          <div className="mb-5">
            <label className="block text-sm font-medium text-on-surface dark:text-dark-text mb-2">{lm.email}</label>
            <input
              type="email" value={email} onChange={e => setEmail(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant dark:border-dark-border bg-white dark:bg-dark-surface focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all dark:text-dark-text"
              placeholder={lm.emailPlaceholder} required
            />
          </div>
          <div className="mb-6">
            <label className="block text-sm font-medium text-on-surface dark:text-dark-text mb-2">{lm.password}</label>
            <input
              type="password" value={password} onChange={e => setPassword(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant dark:border-dark-border bg-white dark:bg-dark-surface focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all dark:text-dark-text"
              placeholder={lm.passwordPlaceholder} required
            />
          </div>
          {error && <p className="text-error text-sm mb-4">{error}</p>}
          <button
            type="submit" disabled={loading}
            className="w-full py-3 bg-primary text-white rounded-xl font-medium hover:brightness-110 transition-all disabled:opacity-50 soft-gradient"
          >
            {loading ? lm.loading : lm.login}
          </button>
          {onRegister && (
            <p className="text-center mt-4 text-sm text-on-surface-variant dark:text-dark-text-secondary">
              {lm.noAccount}{' '}
              <button type="button" onClick={onRegister} className="text-primary font-medium hover:underline">
                {lm.createAccount}
              </button>
            </p>
          )}
        </form>
      </div>
    </div>
  );
}