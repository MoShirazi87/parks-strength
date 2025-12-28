-- Parks Strength Database Schema
-- Initial migration for full MVP

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS & AUTH
-- ============================================

-- Users table (extends Supabase auth.users)
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  first_name TEXT,
  last_name TEXT,
  display_name TEXT,
  avatar_url TEXT,
  date_of_birth DATE,
  experience_level TEXT CHECK (experience_level IN ('beginner', 'intermediate', 'advanced')),
  goals TEXT[] DEFAULT '{}',
  exercise_preferences TEXT[] DEFAULT '{}',
  injuries TEXT[] DEFAULT '{}',
  training_location TEXT CHECK (training_location IN ('full_gym', 'home_gym', 'minimal')),
  preferred_days TEXT[] DEFAULT '{}',
  preferred_time TEXT,
  reminder_time TIME,
  units_preference TEXT DEFAULT 'imperial' CHECK (units_preference IN ('imperial', 'metric')),
  onboarding_completed BOOLEAN DEFAULT false,
  points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_active_at TIMESTAMPTZ
);

-- User streaks
CREATE TABLE user_streaks (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_workout_date DATE,
  streak_updated_at TIMESTAMPTZ
);

-- Equipment catalog
CREATE TABLE equipment (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  category TEXT CHECK (category IN ('bars_weights', 'machines', 'benches', 'accessories')),
  icon_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User equipment (many-to-many)
CREATE TABLE user_equipment (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  equipment_id UUID REFERENCES equipment(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, equipment_id)
);

-- ============================================
-- PROGRAMS & WORKOUTS
-- ============================================

-- Programs
CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  description TEXT,
  short_description TEXT,
  thumbnail_url TEXT,
  hero_image_url TEXT,
  accent_color TEXT,
  duration_weeks INTEGER DEFAULT 8,
  days_per_week INTEGER DEFAULT 4,
  difficulty TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  focus_areas TEXT[] DEFAULT '{}',
  equipment_required UUID[] DEFAULT '{}',
  goals TEXT[] DEFAULT '{}',
  is_published BOOLEAN DEFAULT false,
  is_premium BOOLEAN DEFAULT false,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Program weeks
CREATE TABLE program_weeks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  week_number INTEGER NOT NULL,
  name TEXT,
  description TEXT,
  is_deload BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workouts
CREATE TABLE workouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  week_id UUID REFERENCES program_weeks(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  day_of_week TEXT CHECK (day_of_week IN ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')),
  day_number INTEGER,
  estimated_duration_minutes INTEGER DEFAULT 45,
  is_intro BOOLEAN DEFAULT false,
  coach_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workout sections
CREATE TABLE workout_sections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  section_type TEXT NOT NULL CHECK (section_type IN ('training', 'warmup', 'stretching', 'cooldown')),
  order_index INTEGER NOT NULL,
  is_collapsed_by_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- EXERCISES
-- ============================================

-- Exercise library
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  description TEXT,
  instructions TEXT[] DEFAULT '{}',
  cues TEXT[] DEFAULT '{}',
  common_mistakes TEXT[] DEFAULT '{}',
  primary_muscles TEXT[] DEFAULT '{}',
  secondary_muscles TEXT[] DEFAULT '{}',
  equipment_required UUID[] DEFAULT '{}',
  difficulty TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  movement_pattern TEXT CHECK (movement_pattern IN ('push', 'pull', 'hinge', 'squat', 'carry', 'core', 'isolation')),
  exercise_type TEXT CHECK (exercise_type IN ('strength', 'warmup', 'stretch', 'cardio')),
  video_url TEXT,
  video_url_alt TEXT,
  thumbnail_url TEXT,
  is_bilateral BOOLEAN DEFAULT true,
  is_published BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workout exercises (exercises assigned to workouts)
CREATE TABLE workout_exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
  section_id UUID REFERENCES workout_sections(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  letter_designation TEXT, -- A, B, C, D for training section
  sets INTEGER,
  reps INTEGER,
  time_seconds INTEGER,
  is_per_side BOOLEAN DEFAULT false,
  rest_seconds INTEGER,
  notes TEXT,
  weight_suggestion DECIMAL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- USER PROGRAM ENROLLMENT
-- ============================================

CREATE TABLE user_program_enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'abandoned')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  current_week INTEGER DEFAULT 1,
  current_day INTEGER DEFAULT 1,
  scheduled_days TEXT[] DEFAULT '{}',
  reminder_time TIME,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, program_id)
);

-- ============================================
-- WORKOUT LOGGING
-- ============================================

-- Workout logs
CREATE TABLE workout_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  workout_id UUID REFERENCES workouts(id) ON DELETE SET NULL,
  enrollment_id UUID REFERENCES user_program_enrollments(id) ON DELETE SET NULL,
  custom_workout_name TEXT,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  duration_seconds INTEGER,
  total_volume DECIMAL,
  total_sets INTEGER,
  total_reps INTEGER,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  notes TEXT,
  points_earned INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exercise logs within a workout
CREATE TABLE exercise_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_log_id UUID REFERENCES workout_logs(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
  order_completed INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Set logs within an exercise
CREATE TABLE set_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  exercise_log_id UUID REFERENCES exercise_logs(id) ON DELETE CASCADE,
  set_number INTEGER NOT NULL,
  reps_completed INTEGER,
  weight DECIMAL,
  weight_unit TEXT DEFAULT 'lbs' CHECK (weight_unit IN ('lbs', 'kg')),
  time_seconds INTEGER,
  rpe INTEGER CHECK (rpe >= 1 AND rpe <= 10),
  is_warmup_set BOOLEAN DEFAULT false,
  is_pr BOOLEAN DEFAULT false,
  notes TEXT,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Personal records
CREATE TABLE personal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
  rep_range INTEGER NOT NULL,
  weight DECIMAL NOT NULL,
  weight_unit TEXT DEFAULT 'lbs' CHECK (weight_unit IN ('lbs', 'kg')),
  estimated_1rm DECIMAL,
  achieved_at TIMESTAMPTZ DEFAULT NOW(),
  set_log_id UUID REFERENCES set_logs(id) ON DELETE SET NULL,
  UNIQUE(user_id, exercise_id, rep_range)
);

-- ============================================
-- BODY TRACKING
-- ============================================

-- Bodyweight logs
CREATE TABLE bodyweight_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  weight DECIMAL NOT NULL,
  weight_unit TEXT DEFAULT 'lbs' CHECK (weight_unit IN ('lbs', 'kg')),
  logged_at DATE DEFAULT CURRENT_DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Body measurements
CREATE TABLE body_measurements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  measurement_type TEXT NOT NULL CHECK (measurement_type IN ('chest', 'waist', 'hips', 'arm_l', 'arm_r', 'thigh_l', 'thigh_r', 'neck', 'calf_l', 'calf_r')),
  value DECIMAL NOT NULL,
  unit TEXT DEFAULT 'in' CHECK (unit IN ('in', 'cm')),
  logged_at DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- COMMUNITY
-- ============================================

-- Community posts
CREATE TABLE community_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  author_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT,
  post_type TEXT DEFAULT 'text' CHECK (post_type IN ('text', 'workout_share', 'image', 'video')),
  media_urls TEXT[] DEFAULT '{}',
  workout_log_id UUID REFERENCES workout_logs(id) ON DELETE SET NULL,
  is_pinned BOOLEAN DEFAULT false,
  is_coach_post BOOLEAN DEFAULT false,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Post likes
CREATE TABLE post_likes (
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (post_id, user_id)
);

-- Post comments
CREATE TABLE post_comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES post_comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tribe messages (group chat)
CREATE TABLE tribe_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  media_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- GAMIFICATION
-- ============================================

-- Badges
CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  icon_name TEXT,
  category TEXT CHECK (category IN ('consistency', 'volume', 'milestones', 'prs', 'community')),
  requirement_type TEXT,
  requirement_value INTEGER,
  points_awarded INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User badges
CREATE TABLE user_badges (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  badge_id UUID REFERENCES badges(id) ON DELETE CASCADE,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, badge_id)
);

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

-- Users
CREATE INDEX idx_users_email ON users(email);

-- Programs
CREATE INDEX idx_programs_slug ON programs(slug);
CREATE INDEX idx_programs_published ON programs(is_published);

-- Workouts
CREATE INDEX idx_workouts_program ON workouts(program_id);
CREATE INDEX idx_workouts_week ON workouts(week_id);

-- Exercises
CREATE INDEX idx_exercises_slug ON exercises(slug);
CREATE INDEX idx_exercises_published ON exercises(is_published);

-- Workout exercises
CREATE INDEX idx_workout_exercises_workout ON workout_exercises(workout_id);
CREATE INDEX idx_workout_exercises_section ON workout_exercises(section_id);

-- Workout logs
CREATE INDEX idx_workout_logs_user ON workout_logs(user_id);
CREATE INDEX idx_workout_logs_date ON workout_logs(completed_at);

-- Personal records
CREATE INDEX idx_personal_records_user ON personal_records(user_id);
CREATE INDEX idx_personal_records_exercise ON personal_records(exercise_id);

-- Community
CREATE INDEX idx_posts_author ON community_posts(author_id);
CREATE INDEX idx_posts_created ON community_posts(created_at);
CREATE INDEX idx_tribe_messages_created ON tribe_messages(created_at);

-- ============================================
-- TRIGGERS
-- ============================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_programs_updated_at
  BEFORE UPDATE ON programs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at
  BEFORE UPDATE ON workouts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
  BEFORE UPDATE ON community_posts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-create user profile after auth signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO users (id, email, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    NOW()
  );
  
  INSERT INTO user_streaks (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ language 'plpgsql' SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

