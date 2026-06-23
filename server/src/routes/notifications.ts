import { Router, Request, Response } from 'express';
import { authMiddleware } from '../middleware/auth';
import * as db from '../services/db';

const router = Router();

// GET /api/notifications
router.get('/', authMiddleware, async (req: Request, res: Response) => {
  try {
    const notifs = await db.getNotifications(req.user!.userId);
    res.json({ success: true, data: notifs });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// PUT /api/notifications/:id/read
router.put('/:id/read', authMiddleware, async (req: Request, res: Response) => {
  try {
    await db.markNotificationRead(req.params.id);
    res.json({ success: true, message: 'Marked as read' });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
