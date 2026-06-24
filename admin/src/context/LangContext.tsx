import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { fr, en } from './translations';

type Lang = 'fr' | 'en';

interface LangCtx {
  lang: Lang;
  t: typeof fr;
  toggle: () => void;
}

const LangContext = createContext<LangCtx>({ lang: 'fr', t: fr, toggle: () => {} });

export function LangProvider({ children }: { children: ReactNode }) {
  const [lang, setLang] = useState<Lang>(() => {
    const stored = localStorage.getItem('admin_lang');
    return stored === 'en' ? 'en' : 'fr';
  });

  useEffect(() => {
    localStorage.setItem('admin_lang', lang);
  }, [lang]);

  const t = lang === 'fr' ? fr : en;
  const toggle = () => setLang(l => (l === 'fr' ? 'en' : 'fr'));

  return <LangContext.Provider value={{ lang, t, toggle }}>{children}</LangContext.Provider>;
}

export const useLang = () => useContext(LangContext);
