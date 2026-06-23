import { Request, Response, NextFunction } from 'express';
import { config } from '../config';

export function errorHandler(err: Error, _req: Request, res: Response, _next: NextFunction) {
  console.error('[Error]', err.message);
  res.status(500).json({
    success: false,
    error: config.nodeEnv === 'production' ? 'Internal server error' : err.message,
  });
}

export function notFound(_req: Request, res: Response) {
  res.status(404).json({ success: false, error: 'Route not found' });
}
