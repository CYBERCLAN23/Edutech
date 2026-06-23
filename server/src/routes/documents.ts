import { Router, Request, Response } from 'express';
import { authMiddleware } from '../middleware/auth';
import * as db from '../services/db';

const router = Router();

// GET /api/documents
router.get('/', authMiddleware, async (req: Request, res: Response) => {
  try {
    const category = req.query.category as string | undefined;
    const docs = await db.getDocuments(req.user!.userId, category);
    res.json({ success: true, data: docs });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// POST /api/documents
router.post('/', authMiddleware, async (req: Request, res: Response) => {
  try {
    const { name, category, file_url, size } = req.body;
    if (!name || !category || !file_url) {
      return res.status(400).json({ success: false, error: 'Missing required fields' });
    }
    const doc = await db.createDocument({
      user_id: req.user!.userId,
      name,
      category,
      file_url,
      size: size || 0,
    });
    res.status(201).json({ success: true, data: doc });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
