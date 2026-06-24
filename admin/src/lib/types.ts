export interface DashboardStats {
  totalUsers: number;
  totalStudents: number;
  totalTeachers: number;
  totalAdmins: number;
  totalCourses: number;
  totalActivities: number;
  totalChatMessages: number;
  averageGrade: number;
  lastWeek: string;
}

export interface AdminUser {
  id: string;
  email: string;
  name: string;
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
  users?: { name: string; email: string };
}

export interface ClassStats {
  className: string;
  studentCount: number;
  averageGrade: number;
}

export interface AdminActivity {
  id: string;
  type: string;
  subject_name: string;
  title: string;
  score: number;
  total: number;
  created_at: string;
  users?: { name: string; class_name: string };
}
