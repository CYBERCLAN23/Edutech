import { Router, Request, Response } from 'express';
import { authMiddleware, requireRole } from '../middleware/auth';
import getSupabase from '../config/supabase';

const router = Router();
const sb = getSupabase();

const allAdmin = [authMiddleware, requireRole('admin')];

// GET /api/admin/dashboard — platform-wide stats
router.get('/dashboard', ...allAdmin, async (_req: Request, res: Response) => {
  try {
    const [usersRes, coursesRes, gradesRes, activitiesRes, chatRes] = await Promise.all([
      sb.from('users').select('role', { count: 'exact', head: false }),
      sb.from('courses').select('id', { count: 'exact', head: false }),
      sb.from('student_grades').select('average'),
      sb.from('student_activities').select('created_at', { count: 'exact', head: false }).gte('created_at', new Date(Date.now() - 7 * 86400000).toISOString()),
      sb.from('chat_messages').select('id', { count: 'exact', head: false }),
    ]);

    const users = usersRes.data || [];
    const totals = {
      totalUsers: users.length,
      totalStudents: users.filter((u: any) => u.role === 'student').length,
      totalTeachers: users.filter((u: any) => u.role === 'teacher').length,
      totalAdmins: users.filter((u: any) => u.role === 'admin').length,
    };

    const grades = (gradesRes.data || []) as { average: number }[];
    const avgGrade = grades.length > 0
      ? Math.round((grades.reduce((s, g) => s + g.average, 0) / grades.length) * 10) / 10
      : 0;

    res.json({
      success: true,
      data: {
        ...totals,
        totalCourses: coursesRes.count || 0,
        totalActivities: activitiesRes.count || 0,
        totalChatMessages: chatRes.count || 0,
        averageGrade: avgGrade,
        lastWeek: new Date().toISOString(),
      },
    });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/admin/users — list all users with optional role filter
router.get('/users', ...allAdmin, async (req: Request, res: Response) => {
  try {
    const role = req.query.role as string | undefined;
    let query = sb.from('users').select('*').order('created_at', { ascending: false });
    if (role) query = query.eq('role', role);
    const { data, error } = await query;
    if (error) throw new Error(error.message);
    res.json({ success: true, data: data || [] });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// DELETE /api/admin/users/:id — delete a user
router.delete('/users/:id', ...allAdmin, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { error } = await sb.from('users').delete().eq('id', id);
    if (error) throw new Error(error.message);
    res.json({ success: true, data: { id } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/admin/courses — all courses grouped by class
router.get('/courses', ...allAdmin, async (_req: Request, res: Response) => {
  try {
    const { data, error } = await sb
      .from('courses')
      .select('*, users!teacher_id(name, email)')
      .order('class_name', { ascending: true });
    if (error) throw new Error(error.message);

    const grouped: Record<string, any[]> = {};
    for (const course of data || []) {
      const cls = course.class_name || 'Non assignée';
      if (!grouped[cls]) grouped[cls] = [];
      grouped[cls].push(course);
    }

    res.json({ success: true, data: { courses: data || [], grouped } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/admin/activities — recent platform activity
router.get('/activities', ...allAdmin, async (req: Request, res: Response) => {
  try {
    const limit = parseInt(req.query.limit as string) || 20;
    const { data, error } = await sb
      .from('student_activities')
      .select('*, users!inner(name, class_name)')
      .order('created_at', { ascending: false })
      .limit(limit);
    if (error) throw new Error(error.message);
    res.json({ success: true, data: data || [] });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/admin/stats/classes — per-class performance
router.get('/stats/classes', ...allAdmin, async (_req: Request, res: Response) => {
  try {
    const { data: users, error: uErr } = await sb
      .from('users')
      .select('id, class_name')
      .eq('role', 'student');

    if (uErr) throw new Error(uErr.message);

    const classIds = [...new Set((users || []).map((u: any) => u.class_name).filter(Boolean))] as string[];
    const classStats: any[] = [];

    for (const className of classIds) {
      const studentIds = (users || []).filter((u: any) => u.class_name === className).map((u: any) => u.id);

      let avg = 0;
      if (studentIds.length > 0) {
        const { data: grades } = await sb
          .from('student_grades')
          .select('average')
          .in('student_id', studentIds);

        const avgs = (grades || []).map((g: any) => g.average).filter(Boolean);
        avg = avgs.length > 0 ? Math.round((avgs.reduce((a: number, b: number) => a + b, 0) / avgs.length) * 10) / 10 : 0;
      }

      classStats.push({
        className,
        studentCount: studentIds.length,
        averageGrade: avg,
      });
    }

    res.json({ success: true, data: classStats });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
