import { Router, Request, Response } from 'express';
import { authMiddleware } from '../middleware/auth';
import * as db from '../services/db';
import { chatCompletion } from '../services/ai';

const router = Router();

// POST /api/ai/chat — send message, get AI reply (save both)
router.post('/chat', authMiddleware, async (req: Request, res: Response) => {
  try {
    const { message } = req.body;
    if (!message) {
      return res.status(400).json({ success: false, error: 'Message required' });
    }

    const userId = req.user!.userId;

    // Save user message
    await db.saveChatMessage({ user_id: userId, content: message, is_ai: false });

    // Get recent history for context
    const history = await db.getChatHistory(userId, 10);
    const contextMessages = history.map((m: any) => ({
      role: (m.is_ai ? 'assistant' : 'user') as 'system' | 'user' | 'assistant',
      content: m.content,
    }));

    const systemPrompt = `Tu es TutorBot, assistant educatif specialise dans le programme camerounais (Terminale C, D, Premiere C, Seconde C).
Tu aides les eleves avec leurs devoirs, exercices, et revisions.
Tu donnes des explications claires avec des exemples concrets.
Tu es encourageant et pedagogique. Reponds en francais.`;

    const aiReply = await chatCompletion([
      { role: 'system', content: systemPrompt },
      ...contextMessages,
      { role: 'user', content: message },
    ]);

    // Save AI reply
    await db.saveChatMessage({ user_id: userId, content: aiReply, is_ai: true });

    res.json({ success: true, data: { reply: aiReply } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/ai/history — chat history
router.get('/history', authMiddleware, async (req: Request, res: Response) => {
  try {
    const messages = await db.getChatHistory(req.user!.userId);
    res.json({ success: true, data: messages });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
