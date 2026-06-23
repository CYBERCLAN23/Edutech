-- ============================================
-- EduCam AI - Supabase Database Migration
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===================== USERS =====================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'teacher', 'admin')),
  class_name VARCHAR(100),
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== COURSES =====================
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject_name VARCHAR(255) NOT NULL,
  class_name VARCHAR(100) NOT NULL,
  icon VARCHAR(50) DEFAULT 'menu_book',
  color VARCHAR(20) DEFAULT '#4F46E5',
  total_lessons INT DEFAULT 20,
  completed_lessons INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== LESSONS =====================
CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT '',
  type VARCHAR(10) NOT NULL CHECK (type IN ('video', 'pdf')),
  url TEXT,
  "order" INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lessons_course ON lessons(course_id);

-- ===================== EXERCISES =====================
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  instructions TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_exercises_course ON exercises(course_id);

CREATE TABLE exercise_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  points INT DEFAULT 5
);

CREATE INDEX idx_exercise_questions ON exercise_questions(exercise_id);

-- ===================== QUIZZES =====================
CREATE TABLE quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  time_limit_minutes INT DEFAULT 15,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_quizzes_course ON quizzes(course_id);

CREATE TABLE quiz_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  options JSONB NOT NULL DEFAULT '[]',
  correct_index INT NOT NULL
);

CREATE INDEX idx_quiz_questions ON quiz_questions(quiz_id);

-- ===================== EXAM PAPERS =====================
CREATE TABLE exam_papers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  year VARCHAR(10) NOT NULL,
  description TEXT,
  pdf_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_exam_papers_course ON exam_papers(course_id);

-- ===================== DOCUMENTS =====================
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(20) NOT NULL CHECK (category IN ('Cours', 'Exercices', 'Notes')),
  file_url TEXT NOT NULL,
  size BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_documents_user ON documents(user_id);

-- ===================== STUDENT GRADES =====================
CREATE TABLE student_grades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  subject_name VARCHAR(255) NOT NULL,
  average DECIMAL(4,1) DEFAULT 0,
  recent_scores JSONB DEFAULT '[]',
  exercises_completed INT DEFAULT 0,
  exercises_assigned INT DEFAULT 0,
  quizzes_completed INT DEFAULT 0,
  quizzes_assigned INT DEFAULT 0,
  last_active TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, course_id)
);

CREATE INDEX idx_grades_student ON student_grades(student_id);

-- ===================== STUDENT ACTIVITIES =====================
CREATE TABLE student_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(20) NOT NULL CHECK (type IN ('exercice', 'quiz', 'cours')),
  subject_name VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  score DECIMAL(5,1) DEFAULT 0,
  total DECIMAL(5,1) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_activities_student ON student_activities(student_id);

-- ===================== NOTIFICATIONS =====================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, read) WHERE read = FALSE;

-- ===================== CHAT MESSAGES =====================
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_ai BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_chat_user ON chat_messages(user_id);

-- ===================== ENROLLMENTS =====================
CREATE TABLE enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  progress DECIMAL(5,2) DEFAULT 0,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, course_id)
);

CREATE INDEX idx_enrollments_student ON enrollments(student_id);

-- ================ ROW LEVEL SECURITY ================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercise_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_papers ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can read own data" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Teachers can read students" ON users FOR SELECT USING (
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'teacher')
);

-- Courses: teachers manage own, students read enrolled
CREATE POLICY "Teachers manage own courses" ON courses
  FOR ALL USING (teacher_id = auth.uid());

CREATE POLICY "Students read enrolled courses" ON courses
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM enrollments WHERE course_id = id AND student_id = auth.uid())
  );

-- Lessons/Exercises/Quizzes/Exams: read by enrolled students
CREATE POLICY "Course content readable by enrolled" ON lessons
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM enrollments WHERE course_id = lessons.course_id AND student_id = auth.uid())
    OR EXISTS (SELECT 1 FROM courses WHERE id = lessons.course_id AND teacher_id = auth.uid())
  );

-- Documents: user manages own
CREATE POLICY "Users manage own documents" ON documents
  FOR ALL USING (user_id = auth.uid());

-- Notifications: user manages own
CREATE POLICY "Users manage own notifications" ON notifications
  FOR ALL USING (user_id = auth.uid());

-- ================ SEED DATA ================
-- Seed users
INSERT INTO users (id, email, name, role, class_name) VALUES
  ('00000000-0000-0000-0000-000000000001', 'nkwi@educam.cm', 'M. Nkwi', 'teacher', NULL),
  ('00000000-0000-0000-0000-000000000002', 'eyanga@educam.cm', 'Mme Eyanga', 'teacher', NULL),
  ('00000000-0000-0000-0000-000000000003', 'samuel@educam.cm', 'Samuel Mbarga', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000004', 'alice@educam.cm', 'Alice Ngo', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000005', 'paul@educam.cm', 'Paul Biya Jr', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000006', 'marie@educam.cm', 'Marie Eyanga', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000007', 'jean@educam.cm', 'Jean-Pierre Essono', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000008', 'esther@educam.cm', 'Esther Bikoe', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000009', 'christine@educam.cm', 'Christine Awono', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000010', 'luc@educam.cm', 'Luc Mbede', 'student', 'Terminale C'),
  ('00000000-0000-0000-0000-000000000011', 'felicien@educam.cm', 'Felicien Nkoulou', 'student', 'Terminale D'),
  ('00000000-0000-0000-0000-000000000012', 'beatrice@educam.cm', 'Beatrice Mbele', 'student', 'Terminale D'),
  ('00000000-0000-0000-0000-000000000013', 'david@educam.cm', 'David Nkengue', 'student', 'Terminale D'),
  ('00000000-0000-0000-0000-000000000014', 'sophie@educam.cm', 'Sophie Ekwalla', 'student', 'Terminale D'),
  ('00000000-0000-0000-0000-000000000015', 'pierre@educam.cm', 'Pierre Mvogo', 'student', 'Premiere C'),
  ('00000000-0000-0000-0000-000000000016', 'julienne@educam.cm', 'Julienne Mbarga', 'student', 'Premiere C'),
  ('00000000-0000-0000-0000-000000000017', 'rene@educam.cm', 'Rene Onguene', 'student', 'Premiere C'),
  ('00000000-0000-0000-0000-000000000018', 'colette@educam.cm', 'Colette Abena', 'student', 'Premiere C'),
  ('00000000-0000-0000-0000-000000000019', 'blaise@educam.cm', 'Blaise Ndi', 'student', 'Seconde C'),
  ('00000000-0000-0000-0000-000000000020', 'florence@educam.cm', 'Florence Atangana', 'student', 'Seconde C'),
  ('00000000-0000-0000-0000-000000000021', 'henri@educam.cm', 'Henri Njock', 'student', 'Seconde C'),
  ('00000000-0000-0000-0000-000000000022', 'georgette@educam.cm', 'Georgette Mboe', 'student', 'Seconde C');

-- Seed courses
INSERT INTO courses (id, teacher_id, subject_name, class_name, icon, color, completed_lessons) VALUES
  ('c0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Mathematiques', 'Terminale C', 'functions', '#6366F1', 18),
  ('c0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 'Mathematiques', 'Terminale D', 'functions', '#6366F1', 18),
  ('c0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 'Physique', 'Premiere C', 'science', '#06B6D4', 10),
  ('c0000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000002', 'SVT', 'Seconde C', 'biotech', '#10B981', 14);

-- Seed enrollments (Terminale C students in Mathematiques)
INSERT INTO enrollments (student_id, course_id) VALUES
  ('00000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000008', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000001');

-- Seed student grades
INSERT INTO student_grades (student_id, course_id, subject_name, average, recent_scores, exercises_completed, exercises_assigned, quizzes_completed, quizzes_assigned) VALUES
  ('00000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 14.5, '[12,16,11,14,18]', 12, 15, 8, 10),
  ('00000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 16.0, '[15,17,14,16,19]', 14, 15, 9, 10),
  ('00000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 12.0, '[10,13,9,14,11]', 10, 15, 6, 10),
  ('00000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 17.5, '[18,16,19,17,20]', 15, 15, 10, 10),
  ('00000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 9.5, '[8,11,7,10,9]', 6, 15, 4, 10),
  ('00000000-0000-0000-0000-000000000008', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 8.0, '[6,9,7,8,10]', 5, 15, 3, 10),
  ('00000000-0000-0000-0000-000000000009', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 13.0, '[11,14,12,13,15]', 11, 15, 7, 10),
  ('00000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000001', 'Mathematiques', 10.5, '[9,12,8,11,10]', 8, 15, 5, 10);

-- Seed notifications
INSERT INTO notifications (user_id, type, title, message) VALUES
  ('00000000-0000-0000-0000-000000000003', 'new_exam', 'Nouveau sujet d''annales', 'M. Nkwi a publie un sujet d''annales BAC 2024 en Mathematiques'),
  ('00000000-0000-0000-0000-000000000003', 'new_lesson', 'Nouveau cours disponible', 'Mme Eyanga a ajoute un cours sur la genetique en SVT'),
  ('00000000-0000-0000-0000-000000000003', 'quiz_grade', 'Quiz note', 'Tu as obtenu 14/20 au quiz sur les fractions algebriques');

-- ===================== VIDEO SCRIPTS =====================
CREATE TABLE video_scripts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  subject VARCHAR(100) NOT NULL,
  class_name VARCHAR(100) NOT NULL,
  script JSONB NOT NULL,
  duration_seconds INT DEFAULT 0,
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'script_ready', 'published')),
  video_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== AI CONTENT CACHE =====================
CREATE TABLE ai_content_cache (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('lesson', 'exercise', 'quiz', 'correction')),
  topic VARCHAR(255) NOT NULL,
  subject VARCHAR(100) NOT NULL,
  content JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE video_scripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_content_cache ENABLE ROW LEVEL SECURITY;

-- RLS policies for video_scripts
CREATE POLICY "Teachers can manage their video scripts"
  ON video_scripts FOR ALL
  USING (teacher_id = auth.uid())
  WITH CHECK (teacher_id = auth.uid());

-- RLS policies for ai_content_cache
CREATE POLICY "Users can manage their content cache"
  ON ai_content_cache FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
