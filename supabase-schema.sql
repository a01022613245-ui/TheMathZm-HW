-- TheMathZm-OMR Supabase Schema
-- Run this in Supabase SQL Editor

-- 1. Teachers
CREATE TABLE IF NOT EXISTS omr_teachers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  login_id TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Classes
CREATE TABLE IF NOT EXISTS omr_classes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  teacher_id UUID NOT NULL REFERENCES omr_teachers(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Students
CREATE TABLE IF NOT EXISTS omr_students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  school TEXT,
  grade TEXT,
  login_id TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  class_id UUID NOT NULL REFERENCES omr_classes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Homeworks
CREATE TABLE IF NOT EXISTS omr_homeworks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  class_id UUID NOT NULL REFERENCES omr_classes(id) ON DELETE CASCADE,
  problems INT[] NOT NULL DEFAULT '{}',
  homework_date DATE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Submissions
CREATE TABLE IF NOT EXISTS omr_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES omr_students(id) ON DELETE CASCADE,
  homework_id UUID NOT NULL REFERENCES omr_homeworks(id) ON DELETE CASCADE,
  results JSONB NOT NULL DEFAULT '{}',
  correct_count INT NOT NULL DEFAULT 0,
  wrong_count INT NOT NULL DEFAULT 0,
  submitted_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(student_id, homework_id)
);

-- 6. Textbooks (반교재)
CREATE TABLE IF NOT EXISTS omr_textbooks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  class_id UUID NOT NULL REFERENCES omr_classes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 7. Homework Sections (과제 단원별 문제)
CREATE TABLE IF NOT EXISTS omr_homework_sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  homework_id UUID NOT NULL REFERENCES omr_homeworks(id) ON DELETE CASCADE,
  textbook_id UUID NOT NULL REFERENCES omr_textbooks(id) ON DELETE CASCADE,
  chapter_name TEXT NOT NULL,
  problems INT[] NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Add homework_date to existing omr_homeworks (safe if column already exists)
-- ALTER TABLE omr_homeworks ADD COLUMN IF NOT EXISTS homework_date DATE;

-- Disable RLS for now (using anon key)
ALTER TABLE omr_teachers DISABLE ROW LEVEL SECURITY;
ALTER TABLE omr_classes DISABLE ROW LEVEL SECURITY;
ALTER TABLE omr_students DISABLE ROW LEVEL SECURITY;
ALTER TABLE omr_homeworks DISABLE ROW LEVEL SECURITY;
ALTER TABLE omr_submissions DISABLE ROW LEVEL SECURITY;
ALTER TABLE omr_textbooks DISABLE ROW LEVEL SECURITY;
ALTER TABLE omr_homework_sections DISABLE ROW LEVEL SECURITY;
