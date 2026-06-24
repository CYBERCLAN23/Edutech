import express from 'express';
import cors from 'cors';
import { config } from './config';
import { errorHandler, notFound } from './middleware/error';
import { securityHeaders } from './middleware/security';
import { generalLimiter, authLimiter, aiLimiter } from './middleware/rateLimit';
import { stripSensitiveHeaders, validateEnv } from './middleware/validate';
import authRoutes from './routes/auth';
import courseRoutes from './routes/courses';
import studentRoutes from './routes/students';
import aiRoutes from './routes/ai';
import documentRoutes from './routes/documents';
import notificationRoutes from './routes/notifications';
import videoRoutes from './routes/video';
import contentRoutes from './routes/content';
import uploadRoutes from './routes/upload';
import adminRoutes from './routes/admin';
import renderRoutes from './routes/render';
import setupRoutes from './routes/setup';

validateEnv();

const app = express();

app.use(securityHeaders);
app.use(stripSensitiveHeaders);

const corsOrigins = config.nodeEnv === 'production'
  ? ['https://edutech-production-4e49.up.railway.app', /\.vercel\.app$/]
  : '*';

app.use(cors({
  origin: corsOrigins,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  maxAge: 86400,
}));

app.use(generalLimiter);
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true, limit: '1mb' }));

app.use('/api/auth', authLimiter, authRoutes);
app.use('/api/ai', aiLimiter, aiRoutes);
app.use('/api/video', aiLimiter, videoRoutes);
app.use('/api/content', aiLimiter, contentRoutes);
app.use('/api/courses', courseRoutes);
app.use('/api/students', studentRoutes);
app.use('/api/documents', documentRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/render', aiLimiter, renderRoutes);
app.use('/api/setup', setupRoutes);

app.get('/api/health', (_req, res) => {
  res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});

app.use(notFound);
app.use(errorHandler);

app.listen(config.port, () => {
  console.log(`EduCam AI server running on port ${config.port}`);
  console.log(`Environment: ${config.nodeEnv}`);
  console.log('✓ Helmet CSP actif');
  console.log('✓ Rate limiting actif');
  console.log('✓ CORS restreint');
  console.log('✓ Validation des entrées active');
});

export default app;
