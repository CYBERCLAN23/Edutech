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
        <h1 className="text-2xl font-bold text-primary dark:text-dark-text">{sm.title}</h1>
        <p className="text-on-surface-variant dark:text-dark-text-secondary mt-1">{sm.subtitle}</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="glass-card dark:bg-dark-surface rounded-2xl p-6">
          <h2 className="text-lg font-semibold text-on-surface dark:text-dark-text mb-1">{sm.server}</h2>
          <p className="text-sm text-on-surface-variant dark:text-dark-text-secondary mb-6">{sm.serverDesc}</p>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 rounded-xl bg-surface-container dark:bg-dark-container">
              <div className="flex items-center gap-3">
                <Server size={18} className="text-outline dark:text-dark-text-muted" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-dark-text">{sm.status}</p>
                  <p className="text-xs text-on-surface-variant dark:text-dark-text-secondary">{sm.statusDetail}</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-tertiary" />
                <span className="text-sm text-tertiary font-medium">{sm.online}</span>
              </div>
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl bg-surface-container dark:bg-dark-container">
              <div className="flex items-center gap-3">
                <Shield size={18} className="text-outline dark:text-dark-text-muted" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-dark-text">{sm.apiVersion}</p>
                  <p className="text-xs text-on-surface-variant dark:text-dark-text-secondary">{sm.apiVersionDesc}</p>
                </div>
              </div>
              <span className="text-sm text-on-surface dark:text-dark-text">v1.0.0</span>
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl bg-surface-container dark:bg-dark-container">
              <div className="flex items-center gap-3">
                <Globe size={18} className="text-outline dark:text-dark-text-muted" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-dark-text">{sm.env}</p>
                  <p className="text-xs text-on-surface-variant dark:text-dark-text-secondary">{sm.envDesc}</p>
                </div>
              </div>
              <span className="px-3 py-1 bg-amber-50 text-amber-700 border border-amber-200 rounded-lg text-xs font-medium">Development</span>
            </div>
          </div>
        </div>

        <div className="glass-card dark:bg-dark-surface rounded-2xl p-6">
          <h2 className="text-lg font-semibold text-on-surface dark:text-dark-text mb-1">{sm.prefs}</h2>
          <p className="text-sm text-on-surface-variant dark:text-dark-text-secondary mb-6">{sm.prefsDesc}</p>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-surface-container dark:hover:bg-dark-container transition-colors">
              <div className="flex items-center gap-3">
                {theme === 'dark' ? <Moon size={18} className="text-outline dark:text-dark-text-muted" /> : <Sun size={18} className="text-outline dark:text-dark-text-muted" />}
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-dark-text">{sm.darkMode}</p>
                  <p className="text-xs text-on-surface-variant dark:text-dark-text-secondary">{sm.darkModeDesc}</p>
                </div>
              </div>
              <ToggleSwitch checked={theme === 'dark'} onChange={toggleTheme} />
            </div>
            <div className="flex items-center justify-between p-3 rounded-xl hover:bg-surface-container dark:hover:bg-dark-container transition-colors">
              <div className="flex items-center gap-3">
                <Globe size={18} className="text-outline dark:text-dark-text-muted" />
                <div>
                  <p className="text-sm font-medium text-on-surface dark:text-dark-text">{t.language}</p>
                  <p className="text-xs text-on-surface-variant dark:text-dark-text-secondary">{sm.languageDesc}</p>
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
      className={`relative w-11 h-6 rounded-full transition-colors ${checked ? 'bg-primary' : 'bg-outline-variant dark:bg-dark-border'}`}
    >
      <div className={`absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform ${checked ? 'translate-x-5' : ''}`} />
    </button>
  );
}
