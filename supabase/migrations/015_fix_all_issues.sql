-- Migration 015: Comprehensive Fix for All Issues
-- This migration fixes RLS policies, ensures tables exist, and populates data

-- ============================================
-- STEP 1: ENSURE USER TABLE HAS ALL COLUMNS
-- ============================================

-- Add all required columns to users table if they don't exist
DO $$ 
BEGIN
    -- Email column should exist from initial schema
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'email') THEN
        ALTER TABLE users ADD COLUMN email TEXT;
    END IF;
    
    -- Gamification columns
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'current_streak') THEN
        ALTER TABLE users ADD COLUMN current_streak INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'longest_streak') THEN
        ALTER TABLE users ADD COLUMN longest_streak INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'last_workout_date') THEN
        ALTER TABLE users ADD COLUMN last_workout_date DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'total_workouts') THEN
        ALTER TABLE users ADD COLUMN total_workouts INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'total_volume_lifted') THEN
        ALTER TABLE users ADD COLUMN total_volume_lifted DECIMAL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'points') THEN
        ALTER TABLE users ADD COLUMN points INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'onboarding_completed') THEN
        ALTER TABLE users ADD COLUMN onboarding_completed BOOLEAN DEFAULT false;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'streak_freezes_available') THEN
        ALTER TABLE users ADD COLUMN streak_freezes_available INTEGER DEFAULT 2;
    END IF;
END $$;

-- ============================================
-- STEP 2: FIX RLS POLICIES FOR USERS
-- ============================================

-- Enable RLS on users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable read for users" ON users;
DROP POLICY IF EXISTS "Enable update for users" ON users;
DROP POLICY IF EXISTS "allow_own_user_select" ON users;
DROP POLICY IF EXISTS "allow_own_user_update" ON users;
DROP POLICY IF EXISTS "allow_own_user_insert" ON users;

-- Create comprehensive policies
CREATE POLICY "users_select_own"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "users_insert_own"
  ON users FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "users_update_own"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================
-- STEP 3: FIX RLS POLICIES FOR PROGRAMS (PUBLIC READ)
-- ============================================

ALTER TABLE programs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Programs are viewable by everyone" ON programs;
DROP POLICY IF EXISTS "Public programs are viewable" ON programs;
DROP POLICY IF EXISTS "programs_public_read" ON programs;
DROP POLICY IF EXISTS "Anyone can view published programs" ON programs;

CREATE POLICY "programs_public_read"
  ON programs FOR SELECT
  TO authenticated
  USING (is_published = true);

-- ============================================
-- STEP 4: FIX RLS POLICIES FOR EXERCISES (PUBLIC READ)
-- ============================================

ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Exercises are viewable by everyone" ON exercises;
DROP POLICY IF EXISTS "exercises_public_read" ON exercises;
DROP POLICY IF EXISTS "Published exercises readable" ON exercises;
DROP POLICY IF EXISTS "Exercises readable by authenticated" ON exercises;

CREATE POLICY "exercises_public_read"
  ON exercises FOR SELECT
  TO authenticated
  USING (true);

-- ============================================
-- STEP 5: FIX RLS POLICIES FOR WORKOUTS (PUBLIC READ)
-- ============================================

ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Workouts are viewable by everyone" ON workouts;
DROP POLICY IF EXISTS "workouts_public_read" ON workouts;

CREATE POLICY "workouts_public_read"
  ON workouts FOR SELECT
  TO authenticated
  USING (true);

-- ============================================
-- STEP 6: FIX RLS FOR WORKOUT_SECTIONS (PUBLIC READ)
-- ============================================

ALTER TABLE workout_sections ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "workout_sections_public_read" ON workout_sections;
DROP POLICY IF EXISTS "Workout sections readable" ON workout_sections;
DROP POLICY IF EXISTS "Sections follow workout access" ON workout_sections;

CREATE POLICY "workout_sections_public_read"
  ON workout_sections FOR SELECT
  TO authenticated
  USING (true);

-- ============================================
-- STEP 7: FIX RLS FOR WORKOUT_EXERCISES (PUBLIC READ)
-- ============================================

ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "workout_exercises_public_read" ON workout_exercises;
DROP POLICY IF EXISTS "Workout exercises readable" ON workout_exercises;
DROP POLICY IF EXISTS "Workout exercises follow access" ON workout_exercises;

CREATE POLICY "workout_exercises_public_read"
  ON workout_exercises FOR SELECT
  TO authenticated
  USING (true);

-- ============================================
-- STEP 8: FIX RLS FOR PROGRAM_WEEKS (PUBLIC READ)
-- ============================================

ALTER TABLE program_weeks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "program_weeks_public_read" ON program_weeks;

CREATE POLICY "program_weeks_public_read"
  ON program_weeks FOR SELECT
  TO authenticated
  USING (true);

-- ============================================
-- STEP 9: FIX RLS FOR USER_PROGRAM_ENROLLMENTS
-- ============================================

ALTER TABLE user_program_enrollments ENABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "Users can view own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can create own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can update own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can delete own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "enrollments_select" ON user_program_enrollments;
DROP POLICY IF EXISTS "enrollments_insert" ON user_program_enrollments;
DROP POLICY IF EXISTS "enrollments_update" ON user_program_enrollments;
DROP POLICY IF EXISTS "enrollments_delete" ON user_program_enrollments;

CREATE POLICY "enrollments_select"
  ON user_program_enrollments FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "enrollments_insert"
  ON user_program_enrollments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "enrollments_update"
  ON user_program_enrollments FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "enrollments_delete"
  ON user_program_enrollments FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- STEP 10: FIX RLS FOR WORKOUT_LOGS
-- ============================================

ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "workout_logs_select" ON workout_logs;
DROP POLICY IF EXISTS "workout_logs_insert" ON workout_logs;
DROP POLICY IF EXISTS "workout_logs_update" ON workout_logs;
DROP POLICY IF EXISTS "Users can view own workout logs" ON workout_logs;
DROP POLICY IF EXISTS "Users can insert own workout logs" ON workout_logs;
DROP POLICY IF EXISTS "Users can update own workout logs" ON workout_logs;

CREATE POLICY "workout_logs_select"
  ON workout_logs FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "workout_logs_insert"
  ON workout_logs FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "workout_logs_update"
  ON workout_logs FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- STEP 11: FIX RLS FOR EXERCISE_LOGS
-- ============================================

ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "exercise_logs_select" ON exercise_logs;
DROP POLICY IF EXISTS "exercise_logs_insert" ON exercise_logs;
DROP POLICY IF EXISTS "exercise_logs_update" ON exercise_logs;
DROP POLICY IF EXISTS "Users can view own exercise logs" ON exercise_logs;
DROP POLICY IF EXISTS "Users can insert own exercise logs" ON exercise_logs;
DROP POLICY IF EXISTS "Users can update own exercise logs" ON exercise_logs;

CREATE POLICY "exercise_logs_select"
  ON exercise_logs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM workout_logs wl 
      WHERE wl.id = workout_log_id 
      AND wl.user_id = auth.uid()
    )
  );

CREATE POLICY "exercise_logs_insert"
  ON exercise_logs FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM workout_logs wl 
      WHERE wl.id = workout_log_id 
      AND wl.user_id = auth.uid()
    )
  );

CREATE POLICY "exercise_logs_update"
  ON exercise_logs FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM workout_logs wl 
      WHERE wl.id = workout_log_id 
      AND wl.user_id = auth.uid()
    )
  );

-- ============================================
-- STEP 12: FIX RLS FOR SET_LOGS
-- ============================================

ALTER TABLE set_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "set_logs_select" ON set_logs;
DROP POLICY IF EXISTS "set_logs_insert" ON set_logs;
DROP POLICY IF EXISTS "set_logs_update" ON set_logs;
DROP POLICY IF EXISTS "Users can view own set logs" ON set_logs;
DROP POLICY IF EXISTS "Users can insert own set logs" ON set_logs;
DROP POLICY IF EXISTS "Users can update own set logs" ON set_logs;

CREATE POLICY "set_logs_select"
  ON set_logs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM exercise_logs el
      JOIN workout_logs wl ON el.workout_log_id = wl.id
      WHERE el.id = exercise_log_id 
      AND wl.user_id = auth.uid()
    )
  );

CREATE POLICY "set_logs_insert"
  ON set_logs FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM exercise_logs el
      JOIN workout_logs wl ON el.workout_log_id = wl.id
      WHERE el.id = exercise_log_id 
      AND wl.user_id = auth.uid()
    )
  );

CREATE POLICY "set_logs_update"
  ON set_logs FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM exercise_logs el
      JOIN workout_logs wl ON el.workout_log_id = wl.id
      WHERE el.id = exercise_log_id 
      AND wl.user_id = auth.uid()
    )
  );

-- ============================================
-- STEP 13: FIX RLS FOR PERSONAL_RECORDS
-- ============================================

ALTER TABLE personal_records ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "personal_records_select" ON personal_records;
DROP POLICY IF EXISTS "personal_records_insert" ON personal_records;
DROP POLICY IF EXISTS "personal_records_update" ON personal_records;

CREATE POLICY "personal_records_select"
  ON personal_records FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "personal_records_insert"
  ON personal_records FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "personal_records_update"
  ON personal_records FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- STEP 14: CREATE USER ON SIGNUP (TRIGGER)
-- ============================================

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- STEP 15: INSERT SAMPLE PROGRAMS IF EMPTY
-- ============================================

-- Only insert if programs table is empty
INSERT INTO programs (id, name, slug, short_description, description, thumbnail_url, duration_weeks, days_per_week, difficulty, tags, goals, is_published, accent_color)
SELECT * FROM (VALUES
  (gen_random_uuid(), 'Foundation Strength', 'foundation-strength', 'Build a solid strength foundation', 'An 8-week program designed to build foundational strength through compound movements and progressive overload.', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800', 8, 4, 'beginner', ARRAY['strength', 'full body']::text[], ARRAY['build_strength', 'improve_form']::text[], true, '#6366F1'),
  (gen_random_uuid(), 'Hypertrophy Max', 'hypertrophy-max', 'Maximum muscle growth', 'A 12-week hypertrophy program focused on muscle growth through high volume training.', 'https://images.unsplash.com/photo-1581009146145-b5ef050c149c?w=800', 12, 5, 'intermediate', ARRAY['hypertrophy', 'bodybuilding']::text[], ARRAY['build_muscle', 'aesthetics']::text[], true, '#EC4899'),
  (gen_random_uuid(), 'Functional Athlete', 'functional-athlete', 'Train like an athlete', 'A 6-week program combining strength, power, and conditioning for athletic performance.', 'https://images.unsplash.com/photo-1599058917765-a780eda07a3e?w=800', 6, 4, 'intermediate', ARRAY['functional', 'athletic']::text[], ARRAY['athletic_performance', 'conditioning']::text[], true, '#22C55E')
) AS t(id, name, slug, short_description, description, thumbnail_url, duration_weeks, days_per_week, difficulty, tags, goals, is_published, accent_color)
WHERE NOT EXISTS (SELECT 1 FROM programs LIMIT 1);

-- ============================================
-- STEP 16: INSERT SAMPLE EXERCISES IF EMPTY
-- ============================================

-- Only insert if exercises table is empty
INSERT INTO exercises (id, name, slug, description, instructions, video_url, thumbnail_url, movement_pattern, primary_muscles, secondary_muscles, equipment_required, difficulty, is_compound, is_published)
SELECT * FROM (VALUES
  (gen_random_uuid(), 'Barbell Back Squat', 'barbell-back-squat', 'The king of leg exercises', ARRAY['Position the bar on your upper back', 'Feet shoulder-width apart', 'Descend until thighs are parallel', 'Drive through heels to stand']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Squat.gif', 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400', 'squat', ARRAY['quadriceps', 'glutes']::text[], ARRAY['hamstrings', 'core']::text[], ARRAY['barbell', 'squat rack']::text[], 'intermediate', true, true),
  (gen_random_uuid(), 'Barbell Bench Press', 'barbell-bench-press', 'The classic chest builder', ARRAY['Lie flat on bench', 'Grip bar slightly wider than shoulders', 'Lower bar to mid-chest', 'Press up explosively']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bench-Press.gif', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400', 'push', ARRAY['chest', 'triceps']::text[], ARRAY['shoulders', 'core']::text[], ARRAY['barbell', 'bench']::text[], 'intermediate', true, true),
  (gen_random_uuid(), 'Barbell Deadlift', 'barbell-deadlift', 'The ultimate full body exercise', ARRAY['Stand with feet hip-width apart', 'Grip bar outside knees', 'Keep back flat, chest up', 'Drive through heels, extend hips']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Deadlift.gif', 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=400', 'hinge', ARRAY['hamstrings', 'glutes', 'back']::text[], ARRAY['core', 'forearms']::text[], ARRAY['barbell']::text[], 'intermediate', true, true),
  (gen_random_uuid(), 'Pull-up', 'pull-up', 'Classic back builder', ARRAY['Grip bar slightly wider than shoulders', 'Hang with arms fully extended', 'Pull chest to bar', 'Lower with control']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pull-up.gif', 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=400', 'pull', ARRAY['lats', 'biceps']::text[], ARRAY['forearms', 'core']::text[], ARRAY['pull-up bar']::text[], 'intermediate', true, true),
  (gen_random_uuid(), 'Overhead Press', 'overhead-press', 'Build strong shoulders', ARRAY['Stand with feet shoulder-width', 'Grip bar at shoulders', 'Press overhead to lockout', 'Lower with control']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Overhead-Press.gif', 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400', 'push', ARRAY['shoulders', 'triceps']::text[], ARRAY['core', 'upper chest']::text[], ARRAY['barbell']::text[], 'intermediate', true, true),
  (gen_random_uuid(), 'Dumbbell Curl', 'dumbbell-curl', 'Classic bicep isolation', ARRAY['Stand holding dumbbells at sides', 'Curl weights to shoulders', 'Squeeze at top', 'Lower with control']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Curl.gif', 'https://images.unsplash.com/photo-1581009146145-b5ef050c149c?w=400', 'pull', ARRAY['biceps']::text[], ARRAY['forearms']::text[], ARRAY['dumbbells']::text[], 'beginner', false, true),
  (gen_random_uuid(), 'Tricep Pushdown', 'tricep-pushdown', 'Isolate your triceps', ARRAY['Stand at cable machine', 'Grip bar at chest height', 'Push down until arms straight', 'Squeeze triceps at bottom']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Triceps-Pushdown.gif', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400', 'push', ARRAY['triceps']::text[], ARRAY[]::text[], ARRAY['cable machine']::text[], 'beginner', false, true),
  (gen_random_uuid(), 'Lateral Raise', 'lateral-raise', 'Build wider shoulders', ARRAY['Stand holding dumbbells at sides', 'Raise arms out to sides', 'Stop at shoulder height', 'Lower with control']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Lateral-Raise.gif', 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400', 'push', ARRAY['shoulders']::text[], ARRAY[]::text[], ARRAY['dumbbells']::text[], 'beginner', false, true),
  (gen_random_uuid(), 'Leg Press', 'leg-press', 'Safe leg strength builder', ARRAY['Sit in leg press machine', 'Feet shoulder-width on platform', 'Lower until knees at 90 degrees', 'Press back to start']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Press.gif', 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400', 'squat', ARRAY['quadriceps', 'glutes']::text[], ARRAY['hamstrings']::text[], ARRAY['leg press machine']::text[], 'beginner', true, true),
  (gen_random_uuid(), 'Lat Pulldown', 'lat-pulldown', 'Build a wide back', ARRAY['Sit at lat pulldown machine', 'Grip bar wider than shoulders', 'Pull bar to upper chest', 'Squeeze lats, return with control']::text[], 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Lat-Pulldown.gif', 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=400', 'pull', ARRAY['lats']::text[], ARRAY['biceps', 'rear delts']::text[], ARRAY['cable machine']::text[], 'beginner', true, true)
) AS t(id, name, slug, description, instructions, video_url, thumbnail_url, movement_pattern, primary_muscles, secondary_muscles, equipment_required, difficulty, is_compound, is_published)
WHERE NOT EXISTS (SELECT 1 FROM exercises LIMIT 1);

-- ============================================
-- DONE
-- ============================================

