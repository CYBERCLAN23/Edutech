import { Router, Request, Response } from 'express';
import { authMiddleware, requireRole } from '../middleware/auth';
import { generateLesson, generateExercises, generateQuiz } from '../services/content';
import { storeLessonPlan } from '../services/notion';

const router = Router();

router.post('/generate-lesson', authMiddleware, requireRole('teacher', 'admin'), async (req: Request, res: Response) => {
  try {
    const { topic, subject, className } = req.body;
    if (!topic || !subject || !className) {
      return res.status(400).json({ success: false, error: 'topic, subject, and className required' });
    }

    const lesson = await generateLesson(topic, subject, className);

    await storeLessonPlan({
      title: lesson.title,
      subject,
      className,
      content: lesson.content,
      objectives: lesson.objectives,
    });

    res.json({ success: true, data: lesson });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.post('/generate-exercises', authMiddleware, requireRole('teacher', 'admin'), async (req: Request, res: Response) => {
  try {
    const { topic, subject, numQuestions } = req.body;
    if (!topic || !subject) {
      return res.status(400).json({ success: false, error: 'topic and subject required' });
    }

    const exercise = await generateExercises(topic, subject, numQuestions || 5);
    res.json({ success: true, data: exercise });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.post('/generate-quiz', authMiddleware, requireRole('teacher', 'admin'), async (req: Request, res: Response) => {
  try {
    const { topic, subject, numQuestions } = req.body;
    if (!topic || !subject) {
      return res.status(400).json({ success: false, error: 'topic and subject required' });
    }

    const quiz = await generateQuiz(topic, subject, numQuestions || 10);
    res.json({ success: true, data: quiz });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
