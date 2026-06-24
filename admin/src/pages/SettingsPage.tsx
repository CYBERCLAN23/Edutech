import { useState } from 'react';
import { Shield, Server, Globe, Sun, Moon } from 'lucide-react';

export default function SettingsPage() {
  const [darkMode, setDarkMode] = useState(false);
  const [notifications, setNotifications] = useState(true);

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-[#0D1B2A]">Système</h1>
        <p className="text-gray-500 mt-1">Configuration de la plateforme</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
          <h2 className="text-lg font-semibold text-[#0D1B2A] mb-1">Serveur</h2>
          <p className="text-sm text-gray-400 mb-6">État et version du serveur</p>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 rounded-xl bg-gray-50">
              <div className="flex items-center gap-3">
                <Server size={18} className="text-gray-500" />
                <div>
                  <p className="text-sm font-medium text-[#0D1B2A]">Statut</p>
                  <p className="text-xs text-gray-400">API Express + Supabase</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-green-500" />
                <span className="text-sm text-green-600 font-medium">En ligne</span>
              </div>
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl bg-gray-50">
              <div className="flex items-center gap-3">
                <Shield size={18} className="text-gray-500" />
                <div>
                  <p className="text-sm font-medium text-[#0D1B2A]">Version API</p>
                  <p className="text-xs text-gray-400">Dernier déploiement</p>
                </div>
              </div>
              <span className="text-sm text-gray-600">v1.0.0</span>
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl bg-gray-50">
              <div className="flex items-center gap-3">
                <Globe size={18} className="text-gray-500" />
                <div>
                  <p className="text-sm font-medium text-[#0D1B2A]">Environnement</p>
                  <p className="text-xs text-gray-400">Mode de déploiement</p>
                </div>
              </div>
              <span className="px-3 py-1 bg-amber-50 text-amber-700 border border-amber-200 rounded-lg text-xs font-medium">Development</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
          <h2 className="text-lg font-semibold text-[#0D1B2A] mb-1">Préférences</h2>
          <p className="text-sm text-gray-400 mb-6">Paramètres de l'interface</p>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-gray-50 transition-colors">
              <div className="flex items-center gap-3">
                <Bell size={18} className="text-gray-500" />
                <div>
                  <p className="text-sm font-medium text-[#0D1B2A]">Notifications</p>
                  <p className="text-xs text-gray-400">Alertes et mises à jour</p>
                </div>
              </div>
              <ToggleSwitch checked={notifications} onChange={setNotifications} />
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-gray-50 transition-colors">
              <div className="flex items-center gap-3">
                {darkMode ? <Moon size={18} className="text-gray-500" /> : <Sun size={18} className="text-gray-500" />}
                <div>
                  <p className="text-sm font-medium text-[#0D1B2A]">Mode sombre</p>
                  <p className="text-xs text-gray-400">Thème de l'interface</p>
                </div>
              </div>
              <ToggleSwitch checked={darkMode} onChange={setDarkMode} />
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-gray-50 transition-colors">
              <div className="flex items-center gap-3">
                <Globe size={18} className="text-gray-500" />
                <div>
                  <p className="text-sm font-medium text-[#0D1B2A]">Langue</p>
                  <p className="text-xs text-gray-400">Langue de l'interface</p>
                </div>
              </div>
              <span className="text-sm font-medium text-[#0D1B2A]">Français</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function Bell({ size }: { size: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9" /><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0" />
    </svg>
  );
}

function ToggleSwitch({ checked, onChange }: { checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <button
      onClick={() => onChange(!checked)}
      className={`relative w-11 h-6 rounded-full transition-colors ${checked ? 'bg-[#4F46E5]' : 'bg-gray-300'}`}
    >
      <div className={`absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform ${checked ? 'translate-x-5' : ''}`} />
    </button>
  );
}
