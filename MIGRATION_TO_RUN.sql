-- =====================================================
-- COMPLETE FIX: ALL RLS POLICIES IN ONE PLACE
-- This fixes enrollment, workouts, exercises - everything
-- =====================================================

-- =====================================================
-- 0. USERS TABLE & USER EQUIPMENT
-- =====================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'users'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON users', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "users_read_own" ON users FOR SELECT TO authenticated USING (auth.uid() = id);
CREATE POLICY "users_update_own" ON users FOR UPDATE TO authenticated USING (auth.uid() = id);
CREATE POLICY "users_insert_own" ON users FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

-- User Equipment
ALTER TABLE user_equipment ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'user_equipment'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON user_equipment', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "user_equipment_select" ON user_equipment FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "user_equipment_insert" ON user_equipment FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "user_equipment_delete" ON user_equipment FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- =====================================================
-- 1. ENROLLMENT TABLE
-- =====================================================
ALTER TABLE user_program_enrollments ENABLE ROW LEVEL SECURITY;

-- Drop all enrollment policies dynamically
DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'user_program_enrollments'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON user_program_enrollments', r.policyname);
  END LOOP;
END $$;

-- Add unique constraint if missing
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_program_enrollments_user_program_unique') THEN
    ALTER TABLE user_program_enrollments ADD CONSTRAINT user_program_enrollments_user_program_unique UNIQUE (user_id, program_id);
  END IF;
END $$;

-- Create enrollment policies
CREATE POLICY "enroll_select" ON user_program_enrollments FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "enroll_insert" ON user_program_enrollments FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "enroll_update" ON user_program_enrollments FOR UPDATE TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "enroll_delete" ON user_program_enrollments FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- =====================================================
-- 2. PROGRAMS TABLE
-- =====================================================
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'programs'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON programs', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "programs_read" ON programs FOR SELECT TO authenticated USING (is_published = true);

-- =====================================================
-- 3. WORKOUTS TABLE
-- =====================================================
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'workouts'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON workouts', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "workouts_read" ON workouts FOR SELECT TO authenticated USING (true);

-- =====================================================
-- 4. WORKOUT_SECTIONS TABLE
-- =====================================================
ALTER TABLE workout_sections ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'workout_sections'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON workout_sections', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "sections_read" ON workout_sections FOR SELECT TO authenticated USING (true);

-- =====================================================
-- 5. WORKOUT_EXERCISES TABLE
-- =====================================================
ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'workout_exercises'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON workout_exercises', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "exercises_read" ON workout_exercises FOR SELECT TO authenticated USING (true);

-- =====================================================
-- 6. EXERCISES TABLE
-- =====================================================
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'exercises'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON exercises', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "exercises_read" ON exercises FOR SELECT TO authenticated USING (true);

-- =====================================================
-- 7. WORKOUT_LOGS TABLE (for logging sets)
-- =====================================================
ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'workout_logs'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON workout_logs', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "logs_select" ON workout_logs FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "logs_insert" ON workout_logs FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "logs_update" ON workout_logs FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- =====================================================
-- 8. EXERCISE_LOGS TABLE
-- =====================================================
ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'exercise_logs'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON exercise_logs', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "exlogs_select" ON exercise_logs FOR SELECT TO authenticated USING (true);
CREATE POLICY "exlogs_insert" ON exercise_logs FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "exlogs_update" ON exercise_logs FOR UPDATE TO authenticated USING (true);

-- =====================================================
-- 9. SET_LOGS TABLE
-- =====================================================
ALTER TABLE set_logs ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE tablename = 'set_logs'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON set_logs', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "setlogs_select" ON set_logs FOR SELECT TO authenticated USING (true);
CREATE POLICY "setlogs_insert" ON set_logs FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "setlogs_update" ON set_logs FOR UPDATE TO authenticated USING (true);

-- =====================================================
-- VERIFY ALL POLICIES
-- =====================================================
SELECT 'All RLS Policies:' as status;
SELECT tablename, policyname, cmd 
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename IN (
  'users', 
  'user_equipment',
  'user_program_enrollments', 
  'programs', 
  'workouts', 
  'workout_sections', 
  'workout_exercises', 
  'exercises', 
  'workout_logs', 
  'exercise_logs', 
  'set_logs'
)
ORDER BY tablename, policyname;
