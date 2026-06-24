import express from 'express';
import cors from 'cors';
import { config } from './config';
import { errorHandler, notFound } from './middleware/error';
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

const app = express();

app.use(cors({ origin: '*', credentials: true }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/courses', courseRoutes);
app.use('/api/students', studentRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/documents', documentRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/video', videoRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/admin', adminRoutes);

// Error handling
app.use(notFound);
app.use(errorHandler);

app.listen(config.port, () => {
  console.log(`EduCam AI server running on port ${config.port}`);
  console.log(`Environment: ${config.nodeEnv}`);
});

export default app;
