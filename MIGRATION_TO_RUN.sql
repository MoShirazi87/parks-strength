-- Phase 2: Onboarding Flow Migration
-- Run this in Supabase SQL Editor

-- ============================================
-- 1. ADD MISSING COLUMNS TO USERS TABLE
-- ============================================

-- Add exercise_types column (separate from exercise_preferences)
ALTER TABLE users ADD COLUMN IF NOT EXISTS exercise_types TEXT[] DEFAULT '{}';

-- Add injury_notes column for detailed injury descriptions
ALTER TABLE users ADD COLUMN IF NOT EXISTS injury_notes TEXT;

-- Add notification_preferences as JSONB for flexible notification settings
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_preferences JSONB DEFAULT '{
  "workout_reminders": true,
  "rest_day_checkins": true,
  "coach_tips": true,
  "weekly_summary": true
}'::jsonb;

-- ============================================
-- 2. ADD is_home_friendly TO EQUIPMENT TABLE
-- ============================================

ALTER TABLE equipment ADD COLUMN IF NOT EXISTS is_home_friendly BOOLEAN DEFAULT false;

-- ============================================
-- 3. SEED EQUIPMENT CATALOG (12 items)
-- ============================================

-- First, clear existing equipment to avoid duplicates
DELETE FROM equipment WHERE name IN (
  'Barbell', 'Dumbbells', 'Kettlebells', 'Cable Machine', 
  'Resistance Bands', 'Pull-up Bar', 'Bench', 'Squat Rack',
  'Leg Press', 'Battle Ropes', 'Jump Rope', 'Medicine Ball'
);

-- Insert equipment catalog
INSERT INTO equipment (id, name, category, icon_name, is_home_friendly) VALUES
  (gen_random_uuid(), 'Barbell', 'bars_weights', 'barbell', false),
  (gen_random_uuid(), 'Dumbbells', 'bars_weights', 'dumbbell', true),
  (gen_random_uuid(), 'Kettlebells', 'bars_weights', 'kettlebell', true),
  (gen_random_uuid(), 'Cable Machine', 'machines', 'cable', false),
  (gen_random_uuid(), 'Resistance Bands', 'accessories', 'bands', true),
  (gen_random_uuid(), 'Pull-up Bar', 'accessories', 'pullup', true),
  (gen_random_uuid(), 'Bench', 'benches', 'bench', true),
  (gen_random_uuid(), 'Squat Rack', 'benches', 'rack', false),
  (gen_random_uuid(), 'Leg Press', 'machines', 'legpress', false),
  (gen_random_uuid(), 'Battle Ropes', 'accessories', 'ropes', false),
  (gen_random_uuid(), 'Jump Rope', 'accessories', 'jumprope', true),
  (gen_random_uuid(), 'Medicine Ball', 'accessories', 'medball', true);

-- ============================================
-- 4. RLS POLICIES FOR USER_EQUIPMENT
-- ============================================

-- Enable RLS on user_equipment if not already enabled
ALTER TABLE user_equipment ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "user_equipment_select" ON user_equipment;
DROP POLICY IF EXISTS "user_equipment_insert" ON user_equipment;
DROP POLICY IF EXISTS "user_equipment_delete" ON user_equipment;
DROP POLICY IF EXISTS "user_equipment_all" ON user_equipment;

-- Users can only see their own equipment
CREATE POLICY "user_equipment_select" ON user_equipment 
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- Users can only add equipment to their own profile
CREATE POLICY "user_equipment_insert" ON user_equipment 
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Users can only delete their own equipment
CREATE POLICY "user_equipment_delete" ON user_equipment 
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- 5. RLS POLICIES FOR EQUIPMENT (public read)
-- ============================================

-- Enable RLS on equipment
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "equipment_public_read" ON equipment;

-- Anyone authenticated can read equipment catalog
CREATE POLICY "equipment_public_read" ON equipment 
  FOR SELECT TO authenticated
  USING (true);

-- ============================================
-- 6. ENSURE USERS TABLE HAS PROPER RLS
-- ============================================

-- Enable RLS on users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to recreate cleanly
DROP POLICY IF EXISTS "users_select" ON users;
DROP POLICY IF EXISTS "users_insert" ON users;
DROP POLICY IF EXISTS "users_update" ON users;
DROP POLICY IF EXISTS "users_read_own" ON users;
DROP POLICY IF EXISTS "users_update_own" ON users;

-- Users can read their own profile
CREATE POLICY "users_read_own" ON users 
  FOR SELECT TO authenticated
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "users_update_own" ON users 
  FOR UPDATE TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================
-- VERIFICATION QUERY (run after migration)
-- ============================================
-- SELECT name, category, is_home_friendly FROM equipment ORDER BY name;
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users' AND column_name IN ('exercise_types', 'injury_notes', 'notification_preferences');
