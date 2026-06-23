import { Router, Request, Response } from 'express';
import { authMiddleware, requireRole } from '../middleware/auth';
import * as db from '../services/db';

const router = Router();

// GET /api/students — list students (teacher)
router.get('/', authMiddleware, requireRole('teacher'), async (req: Request, res: Response) => {
  try {
    const className = req.query.class as string | undefined;
    const students = await db.getUsersByRole('student', className);
    res.json({ success: true, data: students });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/students/:id/grades
router.get('/:id/grades', authMiddleware, async (req: Request, res: Response) => {
  try {
    const courseId = req.query.courseId as string;
    if (!courseId) {
      return res.status(400).json({ success: false, error: 'courseId required' });
    }
    const grade = await db.getStudentGrade(req.params.id, courseId);
    res.json({ success: true, data: grade });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/students/:id/activities
router.get('/:id/activities', authMiddleware, async (req: Request, res: Response) => {
  try {
    const activities = await db.getStudentActivities(req.params.id);
    res.json({ success: true, data: activities });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/students/:id/recommendations (AI-powered)
router.get('/:id/recommendations', authMiddleware, requireRole('teacher'), async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const courseId = req.query.courseId as string;
    if (!courseId) {
      return res.status(400).json({ success: false, error: 'courseId required' });
    }

    const grade = await db.getStudentGrade(id, courseId);
    if (!grade) {
      return res.json({ success: true, data: [] });
    }

    const student = await db.getUserById(id);
    const recommendations = [];

    const avg = grade.average;
    const scores = (grade.recent_scores || []) as number[];
    const trend = scores.length >= 2 ? scores[scores.length - 1] - scores[0] : 0;

    if (avg < 12) {
      if (avg < 10) {
        recommendations.push({
          type: 'remedial_test',
          title: 'Test de rattrapage recommande',
          description: `${student?.name || "L'eleve"} a une moyenne de ${avg}/20 en ${grade.subject_name}. Un test cible sur les fondamentaux est recommande.`,
          topic: grade.subject_name,
          urgency: avg < 8 ? 3 : 2,
          action_label: 'Creer un test',
        });
        recommendations.push({
          type: 'more_exercises',
          title: 'Exercices supplementaires',
          description: `Seulement ${grade.exercises_completed}/${grade.exercises_assigned} exercices completes. Renforcer par des exercices cibles.`,
          topic: grade.subject_name,
          urgency: 2,
          action_label: 'Ajouter des exercices',
        });
        recommendations.push({
          type: 'learning_approach',
          title: 'Changer d\'approche pedagogique',
          description: `${student?.name || "L'eleve"} a des difficultes durables. Envisager des supports visuels ou du tutorat par les pairs.`,
          topic: grade.subject_name,
          urgency: 2,
          action_label: 'Voir les options',
        });
        recommendations.push({
          type: 'quiz',
          title: 'Quiz automatique genere',
          description: `Un quiz adaptatif sur ${grade.subject_name} pour evaluer les lacunes specifiques.`,
          topic: grade.subject_name,
          urgency: 1,
          action_label: 'Generer un quiz',
        });
      } else if (avg < 12 && trend <= 0) {
        recommendations.push({
          type: 'more_exercises',
          title: 'Exercices de consolidation',
          description: `${student?.name || "L'eleve"} stagne en ${grade.subject_name}. Des exercices progressifs aideraient.`,
          topic: grade.subject_name,
          urgency: 1,
          action_label: 'Ajouter des exercices',
        });
      }
    }

    res.json({ success: true, data: recommendations });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// PUT /api/students/grades — upsert grade
router.put('/grades', authMiddleware, requireRole('teacher'), async (req: Request, res: Response) => {
  try {
    const grade = await db.upsertStudentGrade(req.body);
    res.json({ success: true, data: grade });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
