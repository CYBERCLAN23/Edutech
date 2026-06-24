export interface DashboardStats {
  totalUsers: number;
  totalStudents: number;
  totalTeachers: number;
  totalAdmins: number;
  totalCourses: number;
  totalChatMessages: number;
  totalActivities: number;
  averageGrade: number;
}

export interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: 'student' | 'teacher' | 'admin';
  class_name?: string;
  created_at: string;
}

export interface AdminCourse {
  id: string;
  subject_name: string;
  class_name: string;
  teacher_id: string;
  total_lessons: number;
  completed_lessons: number;
  users?: { name: string };
}

export interface AdminActivity {
  id: string;
  type: 'quiz' | 'exercice' | 'cours';
  title: string;
  subject_name: string;
  score: number;
  total: number;
  users?: { name: string };
  created_at: string;
}

export interface ClassStats {
  className: string;
  studentCount: number;
  averageGrade: number;
}
