export type UserRole = 'student' | 'teacher' | 'admin';

export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  class_name?: string;
  avatar_url?: string;
  created_at: string;
}

export interface Course {
  id: string;
  teacher_id: string;
  subject_name: string;
  class_name: string;
  icon: string;
  color: string;
  total_lessons: number;
  completed_lessons: number;
  created_at: string;
}

export interface Lesson {
  id: string;
  course_id: string;
  title: string;
  description: string;
  type: 'video' | 'pdf';
  url?: string;
  order: number;
  created_at: string;
}

export interface Exercise {
  id: string;
  course_id: string;
  title: string;
  instructions: string;
  created_at: string;
}

export interface ExerciseQuestion {
  id: string;
  exercise_id: string;
  text: string;
  points: number;
}

export interface Quiz {
  id: string;
  course_id: string;
  title: string;
  time_limit_minutes: number;
  created_at: string;
}

export interface QuizQuestion {
  id: string;
  quiz_id: string;
  text: string;
  options: string[];
  correct_index: number;
}

export interface ExamPaper {
  id: string;
  course_id: string;
  title: string;
  year: string;
  description?: string;
  pdf_url?: string;
  created_at: string;
}

export interface Document {
  id: string;
  user_id: string;
  name: string;
  category: 'Cours' | 'Exercices' | 'Notes';
  file_url: string;
  size: number;
  created_at: string;
}

export interface StudentGrade {
  id: string;
  student_id: string;
  course_id: string;
  subject_name: string;
  average: number;
  recent_scores: number[];
  exercises_completed: number;
  exercises_assigned: number;
  quizzes_completed: number;
  quizzes_assigned: number;
  last_active: string;
}

export interface StudentActivity {
  id: string;
  student_id: string;
  type: 'exercice' | 'quiz' | 'cours';
  subject_name: string;
  title: string;
  score: number;
  total: number;
  created_at: string;
}

export interface Notification {
  id: string;
  user_id: string;
  type: string;
  title: string;
  message: string;
  read: boolean;
  created_at: string;
}

export interface ChatMessage {
  id: string;
  user_id: string;
  content: string;
  is_ai: boolean;
  created_at: string;
}

export interface AiRecommendation {
  id: string;
  type: 'remedial_test' | 'more_exercises' | 'learning_approach' | 'quiz';
  title: string;
  description: string;
  topic: string;
  urgency: number;
  action_label: string;
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

// OpenRouter types
export interface OpenRouterRequest {
  model?: string;
  messages: { role: 'system' | 'user' | 'assistant'; content: string }[];
  temperature?: number;
  max_tokens?: number;
}

export interface OpenRouterResponse {
  id: string;
  choices: {
    message: { role: string; content: string };
    finish_reason: string;
  }[];
  usage: { prompt_tokens: number; completion_tokens: number; total_tokens: number };
}

// JWT payload
export interface JwtPayload {
  userId: string;
  email: string;
  role: UserRole;
}
