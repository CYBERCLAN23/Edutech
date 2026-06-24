-- EduCam AI - Tables de base (à exécuter dans Supabase SQL Editor)

-- Enable UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===================== USERS =====================
CREATE TABLE IF NOT EXISTS users (
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
CREATE TABLE IF NOT EXISTS courses (
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

-- ===================== ENROLLMENTS =====================
CREATE TABLE IF NOT EXISTS enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  progress DECIMAL(5,2) DEFAULT 0,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, course_id)
);

-- ===================== STUDENT GRADES =====================
CREATE TABLE IF NOT EXISTS student_grades (
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

-- ===================== STUDENT ACTIVITIES =====================
CREATE TABLE IF NOT EXISTS student_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(20) NOT NULL CHECK (type IN ('exercice', 'quiz', 'cours')),
  subject_name VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  score DECIMAL(5,1) DEFAULT 0,
  total DECIMAL(5,1) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== NOTIFICATIONS =====================
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== CHAT MESSAGES =====================
CREATE TABLE IF NOT EXISTS chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_ai BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== DOCUMENTS =====================
CREATE TABLE IF NOT EXISTS documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(20) NOT NULL CHECK (category IN ('Cours', 'Exercices', 'Notes')),
  file_url TEXT NOT NULL,
  size BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===================== VIDEO SCRIPTS =====================
CREATE TABLE IF NOT EXISTS video_scripts (
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
CREATE TABLE IF NOT EXISTS ai_content_cache (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('lesson', 'exercise', 'quiz', 'correction')),
  topic VARCHAR(255) NOT NULL,
  subject VARCHAR(100) NOT NULL,
  content JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================ ROW LEVEL SECURITY ================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_scripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_content_cache ENABLE ROW LEVEL SECURITY;

-- Users policy
DROP POLICY IF EXISTS "Users can read own data" ON users;
CREATE POLICY "Users can read own data" ON users
  FOR SELECT USING (auth.uid() = id);

-- Courses: teachers manage own
DROP POLICY IF EXISTS "Teachers manage own courses" ON courses;
CREATE POLICY "Teachers manage own courses" ON courses
  FOR ALL USING (teacher_id = auth.uid());

-- Seed data
INSERT INTO users (id, email, name, role, class_name) VALUES
  ('00000000-0000-0000-0000-000000000001', 'nkwi@educam.cm', 'M. Nkwi', 'teacher', NULL),
  ('00000000-0000-0000-0000-000000000002', 'eyanga@educam.cm', 'Mme Eyanga', 'teacher', NULL),
  ('00000000-0000-0000-0000-000000000003', 'samuel@educam.cm', 'Samuel Mbarga', 'student', 'Terminale C')
ON CONFLICT (id) DO NOTHING;

INSERT INTO courses (id, teacher_id, subject_name, class_name, icon, color, completed_lessons) VALUES
  ('c0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Mathematiques', 'Terminale C', 'functions', '#6366F1', 18)
ON CONFLICT (id) DO NOTHING;

INSERT INTO enrollments (student_id, course_id) VALUES
  ('00000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000001')
ON CONFLICT (student_id, course_id) DO NOTHING;
