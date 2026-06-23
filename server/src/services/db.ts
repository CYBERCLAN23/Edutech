import getSupabase from '../config/supabase';
import { User, StudentGrade, StudentActivity, Document, Notification, Course } from '../types';

const sb = new Proxy({} as ReturnType<typeof getSupabase>, {
  get(_, prop) {
    return getSupabase()[prop as keyof ReturnType<typeof getSupabase>];
  },
});

// ===================== USER SERVICE =====================
export async function createUser(user: Omit<User, 'id' | 'created_at'>): Promise<User> {
  const { data, error } = await sb
    .from('users')
    .insert(user)
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

export async function getUserById(id: string): Promise<User | null> {
  const { data, error } = await sb
    .from('users')
    .select()
    .eq('id', id)
    .single();
  if (error) return null;
  return data;
}

export async function getUsersByRole(role: string, className?: string): Promise<User[]> {
  let query = sb.from('users').select().eq('role', role);
  if (className) query = query.eq('class_name', className);
  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return data || [];
}

// ===================== COURSE SERVICE =====================
export async function getCoursesByTeacher(teacherId: string): Promise<Course[]> {
  const { data, error } = await sb
    .from('courses')
    .select()
    .eq('teacher_id', teacherId);
  if (error) throw new Error(error.message);
  return data || [];
}

export async function getCoursesByStudent(studentId: string): Promise<any[]> {
  const { data, error } = await sb
    .from('enrollments')
    .select('courses(*)')
    .eq('student_id', studentId);
  if (error) throw new Error(error.message);
  return (data || []).map((e: any) => e.courses).filter(Boolean);
}

export async function createCourse(course: Omit<Course, 'id' | 'created_at'>): Promise<Course> {
  const { data, error } = await sb
    .from('courses')
    .insert(course)
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ===================== CONTENT SERVICE (Lesson, Exercise, Quiz, Exam) =====================
export async function getLessons(courseId: string) {
  const { data, error } = await sb
    .from('lessons')
    .select()
    .eq('course_id', courseId)
    .order('order', { ascending: true });
  if (error) throw new Error(error.message);
  return data || [];
}

export async function getExercises(courseId: string) {
  const { data, error } = await sb
    .from('exercises')
    .select('*, exercise_questions(*)')
    .eq('course_id', courseId);
  if (error) throw new Error(error.message);
  return data || [];
}

export async function getQuizzes(courseId: string) {
  const { data, error } = await sb
    .from('quizzes')
    .select('*, quiz_questions(*)')
    .eq('course_id', courseId);
  if (error) throw new Error(error.message);
  return data || [];
}

export async function getExamPapers(courseId: string) {
  const { data, error } = await sb
    .from('exam_papers')
    .select()
    .eq('course_id', courseId)
    .order('year', { ascending: false });
  if (error) throw new Error(error.message);
  return data || [];
}

// ===================== STUDENT GRADE SERVICE =====================
export async function getStudentGrade(studentId: string, courseId: string): Promise<StudentGrade | null> {
  const { data, error } = await sb
    .from('student_grades')
    .select()
    .eq('student_id', studentId)
    .eq('course_id', courseId)
    .single();
  if (error) return null;
  return data;
}

export async function upsertStudentGrade(grade: Partial<StudentGrade> & { student_id: string; course_id: string }) {
  const { data, error } = await sb
    .from('student_grades')
    .upsert(grade, { onConflict: 'student_id,course_id' })
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ===================== ACTIVITY SERVICE =====================
export async function getStudentActivities(studentId: string, limit = 10): Promise<StudentActivity[]> {
  const { data, error } = await sb
    .from('student_activities')
    .select()
    .eq('student_id', studentId)
    .order('created_at', { ascending: false })
    .limit(limit);
  if (error) throw new Error(error.message);
  return data || [];
}

// ===================== DOCUMENT SERVICE =====================
export async function getDocuments(userId: string, category?: string): Promise<Document[]> {
  let query = sb.from('documents').select().eq('user_id', userId).order('created_at', { ascending: false });
  if (category) query = query.eq('category', category);
  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return data || [];
}

export async function createDocument(doc: Omit<Document, 'id' | 'created_at'>): Promise<Document> {
  const { data, error } = await sb
    .from('documents')
    .insert(doc)
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ===================== NOTIFICATION SERVICE =====================
export async function getNotifications(userId: string): Promise<Notification[]> {
  const { data, error } = await sb
    .from('notifications')
    .select()
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(20);
  if (error) throw new Error(error.message);
  return data || [];
}

export async function markNotificationRead(notificationId: string) {
  const { error } = await sb
    .from('notifications')
    .update({ read: true })
    .eq('id', notificationId);
  if (error) throw new Error(error.message);
}

export async function createNotification(notif: Omit<Notification, 'id' | 'read' | 'created_at'>) {
  const { data, error } = await sb
    .from('notifications')
    .insert(notif)
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ===================== CHAT SERVICE =====================
export async function getChatHistory(userId: string, limit = 50) {
  const { data, error } = await sb
    .from('chat_messages')
    .select()
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(limit);
  if (error) throw new Error(error.message);
  return (data || []).reverse();
}

export async function saveChatMessage(msg: { user_id: string; content: string; is_ai: boolean }) {
  const { data, error } = await sb
    .from('chat_messages')
    .insert(msg)
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}
