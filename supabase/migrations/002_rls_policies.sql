-- Parks Strength Row Level Security Policies
-- Secure access to all tables

-- ============================================
-- ENABLE RLS ON ALL TABLES
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE program_weeks ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_program_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE set_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE personal_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE bodyweight_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE body_measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE tribe_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ============================================
-- USERS
-- ============================================

-- Users can read their own profile
CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Users can view other users' basic info (for community)
CREATE POLICY "Users can view other users basic info"
  ON users FOR SELECT
  USING (auth.role() = 'authenticated');

-- User streaks - own data only
CREATE POLICY "Users can view own streaks"
  ON user_streaks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own streaks"
  ON user_streaks FOR UPDATE
  USING (auth.uid() = user_id);

-- ============================================
-- EQUIPMENT
-- ============================================

-- Everyone can read equipment catalog
CREATE POLICY "Equipment readable by all"
  ON equipment FOR SELECT
  USING (true);

-- User equipment - own data only
CREATE POLICY "Users can manage own equipment"
  ON user_equipment FOR ALL
  USING (auth.uid() = user_id);

-- ============================================
-- PROGRAMS (Public read, admin write)
-- ============================================

-- Anyone authenticated can read published programs
CREATE POLICY "Published programs readable by authenticated"
  ON programs FOR SELECT
  USING (is_published = true AND auth.role() = 'authenticated');

-- Program weeks follow program access
CREATE POLICY "Program weeks follow program access"
  ON program_weeks FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM programs WHERE programs.id = program_weeks.program_id AND is_published = true
  ));

-- ============================================
-- WORKOUTS
-- ============================================

-- Workouts readable if program is published
CREATE POLICY "Workouts follow program access"
  ON workouts FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM programs WHERE programs.id = workouts.program_id AND is_published = true
  ));

-- Workout sections follow workout access
CREATE POLICY "Sections follow workout access"
  ON workout_sections FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM workouts w
    JOIN programs p ON w.program_id = p.id
    WHERE w.id = workout_sections.workout_id AND p.is_published = true
  ));

-- ============================================
-- EXERCISES
-- ============================================

-- Published exercises readable by all authenticated
CREATE POLICY "Published exercises readable"
  ON exercises FOR SELECT
  USING (is_published = true AND auth.role() = 'authenticated');

-- Workout exercises follow workout access
CREATE POLICY "Workout exercises follow access"
  ON workout_exercises FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM workouts w
    JOIN programs p ON w.program_id = p.id
    WHERE w.id = workout_exercises.workout_id AND p.is_published = true
  ));

-- ============================================
-- USER PROGRAM ENROLLMENTS
-- ============================================

CREATE POLICY "Users can manage own enrollments"
  ON user_program_enrollments FOR ALL
  USING (auth.uid() = user_id);

-- ============================================
-- WORKOUT LOGGING
-- ============================================

-- Workout logs - own data only
CREATE POLICY "Users can manage own workout logs"
  ON workout_logs FOR ALL
  USING (auth.uid() = user_id);

-- Exercise logs - through workout logs
CREATE POLICY "Users can manage own exercise logs"
  ON exercise_logs FOR ALL
  USING (EXISTS (
    SELECT 1 FROM workout_logs WHERE workout_logs.id = exercise_logs.workout_log_id AND workout_logs.user_id = auth.uid()
  ));

-- Set logs - through exercise logs
CREATE POLICY "Users can manage own set logs"
  ON set_logs FOR ALL
  USING (EXISTS (
    SELECT 1 FROM exercise_logs el
    JOIN workout_logs wl ON el.workout_log_id = wl.id
    WHERE el.id = set_logs.exercise_log_id AND wl.user_id = auth.uid()
  ));

-- Personal records - own data only
CREATE POLICY "Users can manage own PRs"
  ON personal_records FOR ALL
  USING (auth.uid() = user_id);

-- ============================================
-- BODY TRACKING
-- ============================================

CREATE POLICY "Users can manage own bodyweight logs"
  ON bodyweight_logs FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own measurements"
  ON body_measurements FOR ALL
  USING (auth.uid() = user_id);

-- ============================================
-- COMMUNITY
-- ============================================

-- Posts - read all, write own
CREATE POLICY "All can read posts"
  ON community_posts FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can create posts"
  ON community_posts FOR INSERT
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update own posts"
  ON community_posts FOR UPDATE
  USING (auth.uid() = author_id);

CREATE POLICY "Users can delete own posts"
  ON community_posts FOR DELETE
  USING (auth.uid() = author_id);

-- Likes - manage own
CREATE POLICY "Users can manage own likes"
  ON post_likes FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "All can read likes"
  ON post_likes FOR SELECT
  USING (auth.role() = 'authenticated');

-- Comments - read all, write own
CREATE POLICY "All can read comments"
  ON post_comments FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can create comments"
  ON post_comments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments"
  ON post_comments FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments"
  ON post_comments FOR DELETE
  USING (auth.uid() = user_id);

-- Tribe messages
CREATE POLICY "All can read tribe messages"
  ON tribe_messages FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can send tribe messages"
  ON tribe_messages FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- GAMIFICATION
-- ============================================

-- Badges readable by all
CREATE POLICY "Badges readable by all"
  ON badges FOR SELECT
  USING (is_active = true);

-- User badges
CREATE POLICY "User badges readable by all"
  ON user_badges FOR SELECT
  USING (auth.role() = 'authenticated');

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

