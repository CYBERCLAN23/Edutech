import { Router, Request, Response } from 'express';
import { authMiddleware, requireRole } from '../middleware/auth';
import * as db from '../services/db';

const router = Router();

// GET /api/courses — teacher's courses
router.get('/', authMiddleware, async (req: Request, res: Response) => {
  try {
    const user = req.user!;
    if (user.role === 'teacher') {
      const courses = await db.getCoursesByTeacher(user.userId);
      return res.json({ success: true, data: courses });
    }
    if (user.role === 'student') {
      const courses = await db.getCoursesByStudent(user.userId);
      return res.json({ success: true, data: courses });
    }
    res.json({ success: true, data: [] });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// POST /api/courses
router.post('/', authMiddleware, requireRole('teacher'), async (req: Request, res: Response) => {
  try {
    const course = await db.createCourse({
      ...req.body,
      teacher_id: req.user!.userId,
    });
    res.status(201).json({ success: true, data: course });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/courses/:courseId/lessons
router.get('/:courseId/lessons', authMiddleware, async (req: Request, res: Response) => {
  try {
    const lessons = await db.getLessons(req.params.courseId);
    res.json({ success: true, data: lessons });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/courses/:courseId/exercises
router.get('/:courseId/exercises', authMiddleware, async (req: Request, res: Response) => {
  try {
    const exercises = await db.getExercises(req.params.courseId);
    res.json({ success: true, data: exercises });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/courses/:courseId/quizzes
router.get('/:courseId/quizzes', authMiddleware, async (req: Request, res: Response) => {
  try {
    const quizzes = await db.getQuizzes(req.params.courseId);
    res.json({ success: true, data: quizzes });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/courses/:courseId/exams
router.get('/:courseId/exams', authMiddleware, async (req: Request, res: Response) => {
  try {
    const exams = await db.getExamPapers(req.params.courseId);
    res.json({ success: true, data: exams });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
