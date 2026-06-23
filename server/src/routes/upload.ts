import { Router, Request, Response } from 'express';
import multer from 'multer';
import { authMiddleware } from '../middleware/auth';
import { uploadFile, ensureBucket } from '../services/storage';
import { createDocument } from '../services/db';
import { config } from '../config';

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: config.upload.maxFileSize },
  fileFilter: (_req, file, cb) => {
    const allowed = [
      'image/jpeg', 'image/png', 'image/gif', 'image/webp',
      'application/pdf',
      'video/mp4', 'video/webm',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/plain',
    ];
    if (allowed.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error(`File type ${file.mimetype} not allowed`));
    }
  },
});

const router = Router();

router.post('/', authMiddleware, upload.single('file'), async (req: Request, res: Response) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, error: 'No file provided' });
    }

    const category = (req.body.category as string) || 'Notes';
    if (!['Cours', 'Exercices', 'Notes'].includes(category)) {
      return res.status(400).json({ success: false, error: 'Invalid category' });
    }

    await ensureBucket('documents');
    const { url, path } = await uploadFile('documents', req.file, req.user!.userId);

    const doc = await createDocument({
      user_id: req.user!.userId,
      name: req.file.originalname,
      category: category as 'Cours' | 'Exercices' | 'Notes',
      file_url: url,
      size: req.file.size,
    });

    res.status(201).json({ success: true, data: { ...doc, storagePath: path } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
