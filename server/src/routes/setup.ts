import { Router, Request, Response } from 'express';
import getSupabase from '../config/supabase';

const router = Router();

router.get('/check', async (_req: Request, res: Response) => {
  try {
    const sb = getSupabase();
    const tables = ['users', 'courses', 'lessons', 'exercises', 'quizzes', 'enrollments', 'student_grades', 'notifications', 'chat_messages', 'documents', 'video_scripts'];
    const results: Record<string, string> = {};

    for (const table of tables) {
      const { data, error } = await sb.from(table).select('count', { count: 'exact', head: true });
      results[table] = error ? `❌ ${error.message}` : `✓ ${data ?? 0} lignes`;
    }

    res.json({ success: true, database: 'ok', tables: results });
  } catch (err) {
    res.status(500).json({ success: false, error: (err as Error).message });
  }
});

export default router;
