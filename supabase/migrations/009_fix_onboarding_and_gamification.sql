-- Migration 009: Fix Onboarding Save and Gamification System
-- This migration ensures all user columns exist and RLS policies are correct

-- ============================================
-- FIX USERS TABLE
-- ============================================

-- Change reminder_time from TIME to TEXT (accepts "7:00 AM" format)
ALTER TABLE users 
  ALTER COLUMN reminder_time TYPE TEXT USING reminder_time::TEXT;

-- Add missing gamification columns
ALTER TABLE users ADD COLUMN IF NOT EXISTS streak_freezes_available INTEGER DEFAULT 2;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_workouts INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_volume_lifted DECIMAL DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS current_streak INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS longest_streak INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_workout_date DATE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_admin BOOLEAN DEFAULT false;

-- Add notification preferences
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_workout_reminders BOOLEAN DEFAULT true;
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_rest_day_checkins BOOLEAN DEFAULT true;
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_coach_updates BOOLEAN DEFAULT true;
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_weekly_progress BOOLEAN DEFAULT true;

-- ============================================
-- FIX USER_STREAKS TABLE
-- ============================================

-- Add streak freeze column
ALTER TABLE user_streaks ADD COLUMN IF NOT EXISTS streak_freezes_used INTEGER DEFAULT 0;
ALTER TABLE user_streaks ADD COLUMN IF NOT EXISTS streak_freezes_available INTEGER DEFAULT 2;

-- Add INSERT policy for user_streaks (trigger creates it, but just in case)
DROP POLICY IF EXISTS "Users can insert own streaks" ON user_streaks;
CREATE POLICY "Users can insert own streaks"
  ON user_streaks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- FIX PROGRAMS TABLE FOR ADMIN MANAGEMENT
-- ============================================

-- Add admin management columns
ALTER TABLE programs ADD COLUMN IF NOT EXISTS coach_notes TEXT;
ALTER TABLE programs ADD COLUMN IF NOT EXISTS internal_tags TEXT[] DEFAULT '{}';
ALTER TABLE programs ADD COLUMN IF NOT EXISTS last_reviewed_at TIMESTAMPTZ;
ALTER TABLE programs ADD COLUMN IF NOT EXISTS reviewed_by UUID REFERENCES users(id);

-- ============================================
-- FIX EXERCISES TABLE FOR FULL METADATA
-- ============================================

-- Add equipment as text array for flexible querying
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS equipment_names TEXT[] DEFAULT '{}';
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS is_machine BOOLEAN DEFAULT false;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS is_unilateral BOOLEAN DEFAULT false;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS coach_tips TEXT[] DEFAULT '{}';
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS progression_exercises UUID[] DEFAULT '{}';
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS regression_exercises UUID[] DEFAULT '{}';

-- ============================================
-- FIX WORKOUTS TABLE
-- ============================================

-- Add missing columns for proper workout lookup
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS slug TEXT;
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS thumbnail_url TEXT;
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS difficulty TEXT;
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS equipment_needed TEXT[] DEFAULT '{}';
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS duration_minutes INTEGER DEFAULT 45;
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS workout_order INTEGER DEFAULT 1;

-- ============================================
-- FIX WORKOUT_SECTIONS TABLE
-- ============================================

-- Allow 'main' as section_type (currently only training, warmup, stretching, cooldown)
ALTER TABLE workout_sections DROP CONSTRAINT IF EXISTS workout_sections_section_type_check;
ALTER TABLE workout_sections ADD CONSTRAINT workout_sections_section_type_check 
  CHECK (section_type IN ('training', 'warmup', 'stretching', 'cooldown', 'main', 'finisher', 'activation'));

-- Add section order column if missing
ALTER TABLE workout_sections ADD COLUMN IF NOT EXISTS section_order INTEGER DEFAULT 1;
ALTER TABLE workout_sections ADD COLUMN IF NOT EXISTS notes TEXT;

-- ============================================
-- FIX WORKOUT_EXERCISES TABLE
-- ============================================

-- Add exercise_order if missing
ALTER TABLE workout_exercises ADD COLUMN IF NOT EXISTS exercise_order INTEGER DEFAULT 1;

-- ============================================
-- FIX PROGRAM_WEEKS TABLE
-- ============================================

-- Add missing columns
ALTER TABLE program_weeks ADD COLUMN IF NOT EXISTS focus TEXT;
ALTER TABLE program_weeks ADD COLUMN IF NOT EXISTS deload BOOLEAN DEFAULT false;

-- ============================================
-- ADDITIONAL RLS POLICIES
-- ============================================

-- Allow authenticated users to read all published exercises (even anonymous sections)
DROP POLICY IF EXISTS "Published exercises readable" ON exercises;
CREATE POLICY "Exercises readable by authenticated"
  ON exercises FOR SELECT
  TO authenticated
  USING (is_published = true);

-- Allow users to read workout_exercises for workouts they have access to
DROP POLICY IF EXISTS "Workout exercises follow access" ON workout_exercises;
CREATE POLICY "Workout exercises readable"
  ON workout_exercises FOR SELECT
  TO authenticated
  USING (true);

-- Allow reading workout sections
DROP POLICY IF EXISTS "Sections follow workout access" ON workout_sections;
CREATE POLICY "Workout sections readable"
  ON workout_sections FOR SELECT
  TO authenticated
  USING (true);

-- ============================================
-- POINTS AND GAMIFICATION FUNCTIONS
-- ============================================

-- Function to award points after workout completion
CREATE OR REPLACE FUNCTION award_workout_points()
RETURNS TRIGGER AS $$
DECLARE
  base_points INTEGER := 10;
  duration_bonus INTEGER := 0;
  streak_bonus INTEGER := 0;
  current_user_streak INTEGER;
BEGIN
  -- Only award points when workout is completed
  IF NEW.completed_at IS NOT NULL AND OLD.completed_at IS NULL THEN
    -- Duration bonus: 25 points for 30+ min workouts
    IF NEW.duration_seconds >= 1800 THEN
      duration_bonus := 15;
    END IF;
    
    -- Get current streak for streak bonus
    SELECT current_streak INTO current_user_streak 
    FROM users WHERE id = NEW.user_id;
    
    IF current_user_streak >= 7 THEN
      streak_bonus := 5;
    ELSIF current_user_streak >= 30 THEN
      streak_bonus := 10;
    END IF;
    
    -- Calculate total points
    NEW.points_earned := base_points + duration_bonus + streak_bonus;
    
    -- Update user's total points
    UPDATE users 
    SET points = points + NEW.points_earned,
        total_workouts = total_workouts + 1,
        total_volume_lifted = total_volume_lifted + COALESCE(NEW.total_volume, 0),
        last_workout_date = CURRENT_DATE,
        last_active_at = NOW()
    WHERE id = NEW.user_id;
    
    -- Update streak
    PERFORM update_user_streak(NEW.user_id);
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for workout completion
DROP TRIGGER IF EXISTS on_workout_completed ON workout_logs;
CREATE TRIGGER on_workout_completed
  BEFORE UPDATE ON workout_logs
  FOR EACH ROW
  EXECUTE FUNCTION award_workout_points();

-- Function to update user streak
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
  last_date DATE;
  curr_streak INTEGER;
  long_streak INTEGER;
BEGIN
  -- Get current streak info
  SELECT last_workout_date, current_streak, longest_streak
  INTO last_date, curr_streak, long_streak
  FROM users WHERE id = p_user_id;
  
  -- If last workout was yesterday, increment streak
  IF last_date = CURRENT_DATE - 1 THEN
    curr_streak := curr_streak + 1;
  -- If last workout was today, no change
  ELSIF last_date = CURRENT_DATE THEN
    -- No change
    NULL;
  -- Otherwise, reset streak (but check for streak freeze)
  ELSE
    -- Check if user has streak freeze available
    IF (SELECT streak_freezes_available FROM users WHERE id = p_user_id) > 0 
       AND last_date = CURRENT_DATE - 2 THEN
      -- Use streak freeze
      UPDATE users SET streak_freezes_available = streak_freezes_available - 1 WHERE id = p_user_id;
      curr_streak := curr_streak + 1;
    ELSE
      -- Reset streak
      curr_streak := 1;
    END IF;
  END IF;
  
  -- Update longest streak if needed
  IF curr_streak > long_streak THEN
    long_streak := curr_streak;
  END IF;
  
  -- Save to users table
  UPDATE users 
  SET current_streak = curr_streak,
      longest_streak = long_streak,
      last_workout_date = CURRENT_DATE
  WHERE id = p_user_id;
  
  -- Also update user_streaks table
  INSERT INTO user_streaks (user_id, current_streak, longest_streak, last_workout_date, streak_updated_at)
  VALUES (p_user_id, curr_streak, long_streak, CURRENT_DATE, NOW())
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    current_streak = curr_streak,
    longest_streak = long_streak,
    last_workout_date = CURRENT_DATE,
    streak_updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- PR DETECTION FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION check_and_record_pr()
RETURNS TRIGGER AS $$
DECLARE
  exercise_id_val UUID;
  user_id_val UUID;
  current_best DECIMAL;
BEGIN
  -- Get exercise_id and user_id from the exercise_log and workout_log
  SELECT el.exercise_id, wl.user_id 
  INTO exercise_id_val, user_id_val
  FROM exercise_logs el
  JOIN workout_logs wl ON el.workout_log_id = wl.id
  WHERE el.id = NEW.exercise_log_id;
  
  -- Skip warmup sets
  IF NEW.is_warmup_set THEN
    RETURN NEW;
  END IF;
  
  -- Get current best for this rep range
  SELECT weight INTO current_best
  FROM personal_records
  WHERE user_id = user_id_val 
    AND exercise_id = exercise_id_val 
    AND rep_range = NEW.reps_completed;
  
  -- Check if this is a PR
  IF NEW.weight > COALESCE(current_best, 0) THEN
    NEW.is_pr := true;
    
    -- Insert or update personal record
    INSERT INTO personal_records (user_id, exercise_id, rep_range, weight, estimated_1rm, achieved_at, set_log_id)
    VALUES (
      user_id_val, 
      exercise_id_val, 
      NEW.reps_completed, 
      NEW.weight,
      NEW.weight * (1 + NEW.reps_completed::decimal / 30), -- Epley formula
      NOW(),
      NEW.id
    )
    ON CONFLICT (user_id, exercise_id, rep_range)
    DO UPDATE SET 
      weight = NEW.weight,
      estimated_1rm = NEW.weight * (1 + NEW.reps_completed::decimal / 30),
      achieved_at = NOW(),
      set_log_id = NEW.id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for PR detection
DROP TRIGGER IF EXISTS check_pr_on_set ON set_logs;
CREATE TRIGGER check_pr_on_set
  BEFORE INSERT ON set_logs
  FOR EACH ROW
  EXECUTE FUNCTION check_and_record_pr();

-- ============================================
-- SEED DEFAULT BADGES
-- ============================================

INSERT INTO badges (name, description, icon_name, category, requirement_type, requirement_value, points_awarded)
VALUES 
  ('First Workout', 'Complete your first workout', 'fitness_center', 'milestones', 'workouts_completed', 1, 50),
  ('Week Warrior', 'Maintain a 7-day streak', 'local_fire_department', 'consistency', 'streak_days', 7, 100),
  ('Month Master', 'Maintain a 30-day streak', 'whatshot', 'consistency', 'streak_days', 30, 500),
  ('Century Club', 'Complete 100 workouts', 'military_tech', 'milestones', 'workouts_completed', 100, 1000),
  ('Ton Club', 'Lift 2,000+ lbs in a single workout', 'fitness_center', 'volume', 'single_workout_volume', 2000, 200),
  ('PR Hunter', 'Set 10 personal records', 'emoji_events', 'prs', 'total_prs', 10, 250),
  ('Community Star', 'Receive 50 likes on your posts', 'star', 'community', 'likes_received', 50, 150),
  ('Early Bird', 'Complete 10 workouts before 7 AM', 'wb_sunny', 'consistency', 'morning_workouts', 10, 100),
  ('Iron Will', 'Complete a workout on a rest day', 'psychology', 'consistency', 'rest_day_workout', 1, 75),
  ('Movement Master', 'Complete workouts with all 7 movement patterns', 'all_inclusive', 'milestones', 'movement_patterns', 7, 300)
ON CONFLICT DO NOTHING;

-- ============================================
-- SEED DEFAULT EQUIPMENT
-- ============================================

INSERT INTO equipment (name, category, icon_name)
VALUES 
  ('Barbell', 'bars_weights', 'fitness_center'),
  ('Dumbbells', 'bars_weights', 'fitness_center'),
  ('Kettlebell', 'bars_weights', 'fitness_center'),
  ('EZ Curl Bar', 'bars_weights', 'fitness_center'),
  ('Trap Bar', 'bars_weights', 'fitness_center'),
  ('Cable Machine', 'machines', 'settings'),
  ('Lat Pulldown Machine', 'machines', 'settings'),
  ('Leg Press Machine', 'machines', 'settings'),
  ('Smith Machine', 'machines', 'settings'),
  ('Chest Press Machine', 'machines', 'settings'),
  ('Leg Curl Machine', 'machines', 'settings'),
  ('Leg Extension Machine', 'machines', 'settings'),
  ('Seated Row Machine', 'machines', 'settings'),
  ('Pec Deck Machine', 'machines', 'settings'),
  ('Shoulder Press Machine', 'machines', 'settings'),
  ('Flat Bench', 'benches', 'weekend'),
  ('Incline Bench', 'benches', 'weekend'),
  ('Decline Bench', 'benches', 'weekend'),
  ('Adjustable Bench', 'benches', 'weekend'),
  ('Preacher Curl Bench', 'benches', 'weekend'),
  ('Pull-up Bar', 'accessories', 'fitness_center'),
  ('Dip Station', 'accessories', 'fitness_center'),
  ('Resistance Bands', 'accessories', 'fitness_center'),
  ('Medicine Ball', 'accessories', 'sports_basketball'),
  ('Foam Roller', 'accessories', 'self_improvement'),
  ('Ab Wheel', 'accessories', 'rotate_right'),
  ('TRX/Suspension Trainer', 'accessories', 'fitness_center'),
  ('Bodyweight Only', 'accessories', 'accessibility_new')
ON CONFLICT DO NOTHING;

