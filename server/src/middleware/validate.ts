import { Request, Response, NextFunction } from 'express';

const BLOCKED_HEADERS = ['x-forwarded-host', 'x-forwarded-proto', 'x-forwarded-for'];
const BLOCKED_PATTERNS = [
  /<script[\s>]/i,
  /javascript:/i,
  /onerror\s*=/i,
  /onload\s*=/i,
  /onclick\s*=/i,
  /alert\(/i,
  /prompt\(/i,
  /confirm\(/i,
  /--/,
  /;\s*$/,
];

export function sanitizeInput(value: string): string {
  return value
    .replace(/[<>]/g, '')
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;');
}

export function validateRequestBody(allowedKeys: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.body || typeof req.body !== 'object') {
      res.status(400).json({ success: false, error: 'Corps de requête invalide' });
      return;
    }

    for (const key of Object.keys(req.body)) {
      if (!allowedKeys.includes(key)) {
        res.status(400).json({ success: false, error: `Clé non autorisée: ${key}` });
        return;
      }

      const val = req.body[key];
      if (typeof val === 'string') {
        for (const pattern of BLOCKED_PATTERNS) {
          if (pattern.test(val)) {
            res.status(400).json({ success: false, error: 'Contenu non autorisé détecté' });
            return;
          }
        }
        req.body[key] = sanitizeInput(val);
      }
    }

    next();
  };
}

export function stripSensitiveHeaders(req: Request, _res: Response, next: NextFunction) {
  BLOCKED_HEADERS.forEach(h => delete req.headers[h]);
  next();
}

export function requireEnv(key: string): string {
  const val = process.env[key];
  if (!val) {
    throw new Error(`❌ Variable d'environnement manquante: ${key}`);
  }
  return val;
}

const REQUIRED_ENV = [
  'SUPABASE_URL',
  'SUPABASE_ANON_KEY',
  'SUPABASE_SERVICE_KEY',
  'JWT_SECRET',
  'OPENROUTER_API_KEY',
];

export function validateEnv() {
  const missing = REQUIRED_ENV.filter(k => !process.env[k]);
  if (missing.length > 0) {
    console.error(`❌ Variables d'environnement manquantes: ${missing.join(', ')}`);
    console.error('👉 Copiez .env.example vers .env et remplissez les valeurs');
    process.exit(1);
  }
  console.log('✓ Toutes les variables d\'environnement sont présentes');
}
