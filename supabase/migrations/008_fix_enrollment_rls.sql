-- Fix RLS policies for user_program_enrollments table
-- Ensure users can insert, update, and delete their own enrollments

-- First, make sure RLS is enabled
ALTER TABLE user_program_enrollments ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies that might conflict
DROP POLICY IF EXISTS "Users can view their own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can insert their own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can update their own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can delete their own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "user_program_enrollments_select" ON user_program_enrollments;
DROP POLICY IF EXISTS "user_program_enrollments_insert" ON user_program_enrollments;
DROP POLICY IF EXISTS "user_program_enrollments_update" ON user_program_enrollments;
DROP POLICY IF EXISTS "user_program_enrollments_delete" ON user_program_enrollments;

-- Create comprehensive policies for user_program_enrollments
CREATE POLICY "Users can view their own enrollments"
ON user_program_enrollments FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own enrollments"
ON user_program_enrollments FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own enrollments"
ON user_program_enrollments FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own enrollments"
ON user_program_enrollments FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- Also ensure workout_logs has proper policies for the workout logging
ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can manage their own workout logs" ON workout_logs;
DROP POLICY IF EXISTS "workout_logs_select" ON workout_logs;
DROP POLICY IF EXISTS "workout_logs_insert" ON workout_logs;
DROP POLICY IF EXISTS "workout_logs_update" ON workout_logs;
DROP POLICY IF EXISTS "workout_logs_delete" ON workout_logs;

CREATE POLICY "Users can view their own workout logs"
ON workout_logs FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own workout logs"
ON workout_logs FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workout logs"
ON workout_logs FOR UPDATE
TO authenticated
USING (auth.uid() = user_id);

-- Ensure exercise_logs and set_logs have proper policies
ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "exercise_logs_select" ON exercise_logs;
DROP POLICY IF EXISTS "exercise_logs_insert" ON exercise_logs;
DROP POLICY IF EXISTS "exercise_logs_update" ON exercise_logs;

CREATE POLICY "Users can view their exercise logs"
ON exercise_logs FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM workout_logs wl 
    WHERE wl.id = exercise_logs.workout_log_id 
    AND wl.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert their exercise logs"
ON exercise_logs FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM workout_logs wl 
    WHERE wl.id = exercise_logs.workout_log_id 
    AND wl.user_id = auth.uid()
  )
);

ALTER TABLE set_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "set_logs_select" ON set_logs;
DROP POLICY IF EXISTS "set_logs_insert" ON set_logs;
DROP POLICY IF EXISTS "set_logs_update" ON set_logs;

CREATE POLICY "Users can view their set logs"
ON set_logs FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM exercise_logs el 
    JOIN workout_logs wl ON wl.id = el.workout_log_id 
    WHERE el.id = set_logs.exercise_log_id 
    AND wl.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert their set logs"
ON set_logs FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM exercise_logs el 
    JOIN workout_logs wl ON wl.id = el.workout_log_id 
    WHERE el.id = set_logs.exercise_log_id 
    AND wl.user_id = auth.uid()
  )
);

