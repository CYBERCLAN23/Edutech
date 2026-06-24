import { useState } from 'react';
import { Shield, Server, Globe, Sun, Moon } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import { useLang } from '../context/LangContext';

export default function SettingsPage() {
  const { theme, toggle: toggleTheme } = useTheme();
  const { lang, t, toggle: toggleLang } = useLang();
  const sm = t.settings;

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-primary dark:text-white">{sm.title}</h1>
        <p className="text-on-surface-variant dark:text-white/60 mt-1">{sm.subtitle}</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="glass-card dark:bg-white/5 rounded-2xl p-6">
          <h2 className="text-lg font-semibold text-on-surface dark:text-white mb-1">{sm.server}</h2>
          <p className="text-sm text-on-surface-variant dark:text-white/60 mb-6">{sm.serverDesc}</p>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 rounded-xl bg-surface-container dark:bg-white/5">
              <div className="flex items-center gap-3">
                <Server size={18} className="text-outline dark:text-white/40" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-white">{sm.status}</p>
                  <p className="text-xs text-on-surface-variant dark:text-white/60">{sm.statusDetail}</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-tertiary" />
                <span className="text-sm text-tertiary font-medium">{sm.online}</span>
              </div>
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl bg-surface-container dark:bg-white/5">
              <div className="flex items-center gap-3">
                <Shield size={18} className="text-outline dark:text-white/40" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-white">{sm.apiVersion}</p>
                  <p className="text-xs text-on-surface-variant dark:text-white/60">{sm.apiVersionDesc}</p>
                </div>
              </div>
              <span className="text-sm text-on-surface dark:text-white">v1.0.0</span>
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl bg-surface-container dark:bg-white/5">
              <div className="flex items-center gap-3">
                <Globe size={18} className="text-outline dark:text-white/40" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-white">{sm.env}</p>
                  <p className="text-xs text-on-surface-variant dark:text-white/60">{sm.envDesc}</p>
                </div>
              </div>
              <span className="px-3 py-1 bg-amber-50 text-amber-700 border border-amber-200 rounded-lg text-xs font-medium">Development</span>
            </div>
          </div>
        </div>

        <div className="glass-card dark:bg-white/5 rounded-2xl p-6">
          <h2 className="text-lg font-semibold text-on-surface dark:text-white mb-1">{sm.prefs}</h2>
          <p className="text-sm text-on-surface-variant dark:text-white/60 mb-6">{sm.prefsDesc}</p>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-surface-container dark:hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                {theme === 'dark' ? <Moon size={18} className="text-outline dark:text-white/40" /> : <Sun size={18} className="text-outline dark:text-white/40" />}
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-white">{sm.darkMode}</p>
                  <p className="text-xs text-on-surface-variant dark:text-white/60">{sm.darkModeDesc}</p>
                </div>
              </div>
              <ToggleSwitch checked={theme === 'dark'} onChange={toggleTheme} />
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-surface-container dark:hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Globe size={18} className="text-outline dark:text-white/40" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-white">{t.language}</p>
                  <p className="text-xs text-on-surface-variant dark:text-white/60">{sm.languageDesc}</p>
                </div>
              </div>
              <button onClick={toggleLang}
                className="px-3 py-1.5 rounded-lg text-xs font-medium bg-primary text-white">
                {lang === 'fr' ? 'FR' : 'EN'}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function ToggleSwitch({ checked, onChange }: { checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <button
      onClick={() => onChange(!checked)}
      className={`relative w-11 h-6 rounded-full transition-colors ${checked ? 'bg-primary' : 'bg-outline-variant dark:bg-white/20'}`}
    >
      <div className={`absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform ${checked ? 'translate-x-5' : ''}`} />
    </button>
  );
}
