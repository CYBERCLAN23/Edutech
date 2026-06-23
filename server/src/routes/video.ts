import { Router, Request, Response } from 'express';
import { authMiddleware, requireRole } from '../middleware/auth';
import { generateEducationalVideo, generateVideoScript } from '../services/video';
import { storeGeneratedVideo } from '../services/notion';

const router = Router();

router.post('/generate', authMiddleware, requireRole('teacher', 'admin'), async (req: Request, res: Response) => {
  try {
    const { topic, subject, className, duration } = req.body;
    if (!topic || !subject || !className) {
      return res.status(400).json({ success: false, error: 'topic, subject, and className required' });
    }

    const result = await generateEducationalVideo(topic, subject, className, duration || 'medium');

    await storeGeneratedVideo({
      title: result.script.title,
      subject,
      script: result.script.scenes.map((s) => s.narration).join('\n\n'),
    });

    res.json({ success: true, data: result });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.post('/script', authMiddleware, requireRole('teacher', 'admin'), async (req: Request, res: Response) => {
  try {
    const { topic, subject, className, duration } = req.body;
    if (!topic || !subject || !className) {
      return res.status(400).json({ success: false, error: 'topic, subject, and className required' });
    }

    const script = await generateVideoScript(topic, subject, className, duration || 'medium');
    res.json({ success: true, data: script });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
