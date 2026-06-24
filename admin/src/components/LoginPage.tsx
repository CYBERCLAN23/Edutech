import { useState } from 'react';
import { api } from '../lib/api';

interface Props {
  onLogin: (user: any) => void;
  onRegister?: () => void;
}

export default function LoginPage({ onLogin, onRegister }: Props) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const data = await api.login(email, password);
      onLogin(data.user);
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
          <h1 className="text-2xl font-bold text-primary">EduCam AI</h1>
          <p className="text-on-surface-variant mt-1">Espace Administration</p>
        </div>
        <form onSubmit={handleSubmit} className="glass-card rounded-2xl p-8">
          <div className="mb-5">
            <label className="block text-sm font-medium text-on-surface mb-2">Email</label>
            <input
              type="email" value={email} onChange={e => setEmail(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant bg-white focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"
              placeholder="admin@educam.cm" required
            />
          </div>
          <div className="mb-6">
            <label className="block text-sm font-medium text-on-surface mb-2">Mot de passe</label>
            <input
              type="password" value={password} onChange={e => setPassword(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-outline-variant bg-white focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"
              placeholder="••••••••" required
            />
          </div>
          {error && <p className="text-error text-sm mb-4">{error}</p>}
          <button
            type="submit" disabled={loading}
            className="w-full py-3 bg-primary text-white rounded-xl font-medium hover:brightness-110 transition-all disabled:opacity-50 soft-gradient"
          >
            {loading ? 'Connexion...' : 'Se connecter'}
          </button>
          {onRegister && (
            <p className="text-center mt-4 text-sm text-on-surface-variant">
              Pas encore de compte ?{' '}
              <button type="button" onClick={onRegister} className="text-primary font-medium hover:underline">
                Créer un compte admin
              </button>
            </p>
          )}
        </form>
      </div>
    </div>
  );
}
