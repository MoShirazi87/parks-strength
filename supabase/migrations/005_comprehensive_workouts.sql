-- Parks Strength Comprehensive Workout Data
-- V2 MVP: Full exercise library and sample workouts
-- Run this AFTER 003_seed_data.sql

-- ============================================
-- ADDITIONAL EXERCISES - Complete Library
-- ============================================

-- CHEST EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty, video_url, thumbnail_url) VALUES
  ('Incline Dumbbell Press', 'incline-dumbbell-press', 'Upper chest focused pressing movement', ARRAY['chest'], ARRAY['triceps', 'front_delts'], 'push', 'strength', 'intermediate', 'https://api.exercisedb.io/image/incline-dumbbell-press', 'https://images.pexels.com/photos/3837757/pexels-photo-3837757.jpeg?w=300'),
  ('Dumbbell Flyes', 'dumbbell-flyes', 'Chest isolation stretch and squeeze', ARRAY['chest'], ARRAY['front_delts'], 'isolation', 'strength', 'beginner', NULL, NULL),
  ('Cable Crossover', 'cable-crossover', 'Chest isolation with constant tension', ARRAY['chest'], ARRAY[], 'isolation', 'strength', 'intermediate', NULL, NULL),
  ('Push-ups', 'push-ups', 'Bodyweight chest and tricep exercise', ARRAY['chest'], ARRAY['triceps', 'core', 'front_delts'], 'push', 'strength', 'beginner', NULL, NULL),
  ('Dips', 'dips', 'Compound pressing for chest and triceps', ARRAY['chest', 'triceps'], ARRAY['front_delts'], 'push', 'strength', 'intermediate', NULL, NULL)
ON CONFLICT (slug) DO NOTHING;

-- BACK EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Lat Pulldown', 'lat-pulldown', 'Machine vertical pulling for lats', ARRAY['lats'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'beginner'),
  ('Seated Cable Row', 'seated-cable-row', 'Horizontal pulling for mid-back', ARRAY['back', 'lats'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'beginner'),
  ('T-Bar Row', 't-bar-row', 'Compound rowing variation', ARRAY['back'], ARRAY['biceps', 'rear_delts', 'core'], 'pull', 'strength', 'intermediate'),
  ('Dumbbell Row', 'dumbbell-row', 'Unilateral back rowing', ARRAY['lats', 'back'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'beginner'),
  ('Face Pulls', 'face-pulls', 'Rear delt and upper back isolation', ARRAY['rear_delts', 'upper_back'], ARRAY['biceps'], 'pull', 'strength', 'beginner'),
  ('Straight Arm Pulldown', 'straight-arm-pulldown', 'Lat isolation movement', ARRAY['lats'], ARRAY['core'], 'isolation', 'strength', 'intermediate')
ON CONFLICT (slug) DO NOTHING;

-- SHOULDER EXERCISES  
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Dumbbell Shoulder Press', 'dumbbell-shoulder-press', 'Seated or standing shoulder pressing', ARRAY['shoulders', 'front_delts'], ARRAY['triceps'], 'push', 'strength', 'beginner'),
  ('Lateral Raise', 'lateral-raise', 'Side delt isolation', ARRAY['side_delts'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Front Raise', 'front-raise', 'Front delt isolation', ARRAY['front_delts'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Rear Delt Flyes', 'rear-delt-flyes', 'Rear delt isolation', ARRAY['rear_delts'], ARRAY['upper_back'], 'isolation', 'strength', 'beginner'),
  ('Arnold Press', 'arnold-press', 'Rotational shoulder press variation', ARRAY['shoulders'], ARRAY['triceps', 'front_delts'], 'push', 'strength', 'intermediate'),
  ('Upright Row', 'upright-row', 'Compound shoulder and trap movement', ARRAY['shoulders', 'traps'], ARRAY['biceps'], 'pull', 'strength', 'intermediate')
ON CONFLICT (slug) DO NOTHING;

-- LEG EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Leg Press', 'leg-press', 'Machine compound leg exercise', ARRAY['quads', 'glutes'], ARRAY['hamstrings'], 'squat', 'strength', 'beginner'),
  ('Romanian Deadlift', 'romanian-deadlift', 'Hamstring focused hip hinge', ARRAY['hamstrings', 'glutes'], ARRAY['back', 'core'], 'hinge', 'strength', 'intermediate'),
  ('Leg Extension', 'leg-extension', 'Quad isolation machine', ARRAY['quads'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Leg Curl', 'leg-curl', 'Hamstring isolation machine', ARRAY['hamstrings'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Bulgarian Split Squat', 'bulgarian-split-squat', 'Unilateral quad and glute focus', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'strength', 'intermediate'),
  ('Hip Thrust', 'hip-thrust', 'Glute focused hip extension', ARRAY['glutes'], ARRAY['hamstrings', 'core'], 'hinge', 'strength', 'intermediate'),
  ('Calf Raises', 'calf-raises', 'Calf isolation standing or seated', ARRAY['calves'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Goblet Squat', 'goblet-squat', 'Front loaded squat pattern', ARRAY['quads', 'glutes'], ARRAY['core', 'upper_back'], 'squat', 'strength', 'beginner'),
  ('Walking Lunges', 'walking-lunges', 'Dynamic unilateral leg movement', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'strength', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- ARM EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Barbell Curl', 'barbell-curl', 'Bicep mass builder', ARRAY['biceps'], ARRAY['forearms'], 'isolation', 'strength', 'beginner'),
  ('Hammer Curl', 'hammer-curl', 'Neutral grip bicep curl', ARRAY['biceps', 'brachialis'], ARRAY['forearms'], 'isolation', 'strength', 'beginner'),
  ('Preacher Curl', 'preacher-curl', 'Strict bicep isolation', ARRAY['biceps'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Incline Curl', 'incline-curl', 'Stretched bicep position', ARRAY['biceps'], ARRAY[], 'isolation', 'strength', 'intermediate'),
  ('Skull Crushers', 'skull-crushers', 'Lying tricep extension', ARRAY['triceps'], ARRAY[], 'isolation', 'strength', 'intermediate'),
  ('Overhead Tricep Extension', 'overhead-tricep-extension', 'Tricep long head focus', ARRAY['triceps'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Close Grip Bench Press', 'close-grip-bench-press', 'Tricep focused pressing', ARRAY['triceps'], ARRAY['chest', 'front_delts'], 'push', 'strength', 'intermediate'),
  ('Rope Pushdown', 'rope-pushdown', 'Tricep cable isolation', ARRAY['triceps'], ARRAY[], 'isolation', 'strength', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- CORE EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Hanging Leg Raise', 'hanging-leg-raise', 'Lower ab focused movement', ARRAY['core', 'hip_flexors'], ARRAY['obliques'], 'core', 'strength', 'intermediate'),
  ('Cable Woodchop', 'cable-woodchop', 'Rotational core strength', ARRAY['obliques', 'core'], ARRAY[], 'rotation', 'strength', 'intermediate'),
  ('Ab Wheel Rollout', 'ab-wheel-rollout', 'Anti-extension core training', ARRAY['core'], ARRAY['lats', 'shoulders'], 'core', 'strength', 'intermediate'),
  ('Dead Bug', 'dead-bug', 'Core stability and coordination', ARRAY['core'], ARRAY['hip_flexors'], 'core', 'strength', 'beginner'),
  ('Pallof Press', 'pallof-press', 'Anti-rotation core stability', ARRAY['core', 'obliques'], ARRAY[], 'core', 'strength', 'beginner'),
  ('Russian Twist', 'russian-twist', 'Rotational core exercise', ARRAY['obliques'], ARRAY['core'], 'rotation', 'strength', 'beginner'),
  ('Side Plank', 'side-plank', 'Oblique and lateral core stability', ARRAY['obliques', 'core'], ARRAY['shoulders'], 'core', 'strength', 'beginner'),
  ('Bicycle Crunch', 'bicycle-crunch', 'Dynamic ab and oblique exercise', ARRAY['core', 'obliques'], ARRAY[], 'core', 'strength', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- WARMUP/MOBILITY EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('World''s Greatest Stretch', 'worlds-greatest-stretch', 'Full body mobility flow', ARRAY['hip_flexors', 'hamstrings', 'thoracic'], ARRAY['glutes', 'shoulders'], 'hinge', 'warmup', 'beginner'),
  ('Shoulder Dislocates', 'shoulder-dislocates', 'Shoulder mobility with band or stick', ARRAY['shoulders'], ARRAY['chest'], 'push', 'warmup', 'beginner'),
  ('Band Pull-Aparts', 'band-pull-aparts', 'Rear delt and upper back activation', ARRAY['rear_delts', 'upper_back'], ARRAY[], 'pull', 'warmup', 'beginner'),
  ('Glute Bridges', 'glute-bridges', 'Glute activation and hip extension', ARRAY['glutes'], ARRAY['hamstrings', 'core'], 'hinge', 'warmup', 'beginner'),
  ('Bird Dogs', 'bird-dogs', 'Core stability and coordination', ARRAY['core'], ARRAY['glutes', 'shoulders'], 'core', 'warmup', 'beginner'),
  ('Inchworms', 'inchworms', 'Hamstring and full body mobility', ARRAY['hamstrings', 'core'], ARRAY['shoulders', 'chest'], 'hinge', 'warmup', 'beginner'),
  ('High Knees', 'high-knees', 'Dynamic warmup for lower body', ARRAY['hip_flexors', 'quads'], ARRAY['calves', 'core'], 'locomotion', 'warmup', 'beginner'),
  ('Butt Kicks', 'butt-kicks', 'Dynamic hamstring warmup', ARRAY['hamstrings'], ARRAY['calves'], 'locomotion', 'warmup', 'beginner'),
  ('Bodyweight Squat', 'bodyweight-squat', 'Squat pattern warmup', ARRAY['quads', 'glutes'], ARRAY['core', 'hamstrings'], 'squat', 'warmup', 'beginner'),
  ('Thoracic Rotations', 'thoracic-rotations', 'Upper back mobility', ARRAY['thoracic', 'core'], ARRAY[], 'rotation', 'warmup', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- ADDITIONAL PROGRAMS
-- ============================================

-- TITAN: 4-Day Upper/Lower Split
INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'TITAN',
  'titan',
  'The ultimate strength building program. 4 days per week Upper/Lower split designed for maximum strength and muscle gains.',
  '4-Day Upper/Lower Strength',
  12, 4, 'intermediate',
  ARRAY['strength', 'hypertrophy'],
  ARRAY['build_strength', 'build_muscle', 'progressive_overload'],
  true, false, '#F97316'
) ON CONFLICT (slug) DO NOTHING;

-- FORGE: 3-Day Full Body
INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'FORGE',
  'forge',
  'Efficient full body training 3 days per week. Perfect for busy schedules while still making serious gains.',
  '3-Day Full Body',
  8, 3, 'beginner',
  ARRAY['strength', 'full_body'],
  ARRAY['build_strength', 'time_efficient', 'functional_movement'],
  true, false, '#EC4899'
) ON CONFLICT (slug) DO NOTHING;

-- NOMAD: Minimal Equipment
INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'NOMAD',
  'nomad',
  'Train anywhere with minimal equipment. This program requires only dumbbells and a pull-up bar for a complete workout.',
  'Minimal Equipment Training',
  6, 4, 'beginner',
  ARRAY['functional', 'minimal_equipment'],
  ARRAY['train_anywhere', 'functional_movement', 'body_recomp'],
  true, false, '#3B82F6'
) ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- CREATE WORKOUTS FOR TITAN PROGRAM
-- ============================================

DO $$
DECLARE
  v_program_id UUID;
  v_week_id UUID;
  v_workout_id UUID;
  v_section_id UUID;
  v_exercise_id UUID;
  i INT;
BEGIN
  -- Get TITAN program ID
  SELECT id INTO v_program_id FROM programs WHERE slug = 'titan';
  
  IF v_program_id IS NULL THEN
    RAISE NOTICE 'TITAN program not found, skipping workout creation';
    RETURN;
  END IF;
  
  -- Create weeks
  FOR i IN 1..4 LOOP
    INSERT INTO program_weeks (program_id, week_number, name, description)
    VALUES (
      v_program_id, 
      i, 
      CASE 
        WHEN i = 1 THEN 'Foundation Phase'
        WHEN i = 2 THEN 'Building Phase'
        WHEN i = 3 THEN 'Intensification'
        ELSE 'Deload'
      END,
      CASE 
        WHEN i = 1 THEN 'Focus on form and establish baseline weights'
        WHEN i = 2 THEN 'Progressive overload begins'
        WHEN i = 3 THEN 'Push intensity with controlled volume'
        ELSE 'Recovery week - reduce volume and intensity'
      END
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO v_week_id;
    
    IF v_week_id IS NULL THEN
      SELECT id INTO v_week_id FROM program_weeks 
      WHERE program_id = v_program_id AND week_number = i;
    END IF;
    
    -- UPPER A - Push Focus (Monday)
    INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
    VALUES (v_program_id, v_week_id, 'Upper A - Push Focus', 'Chest, shoulders, triceps with some pulling', 'mon', 1, 55)
    ON CONFLICT DO NOTHING
    RETURNING id INTO v_workout_id;
    
    IF v_workout_id IS NOT NULL THEN
      -- Warmup section
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Warm-up', 'warmup', 0)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'arm-circles';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 30);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'band-pull-aparts';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 15);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'push-ups';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 10);
      END IF;
      
      -- Training section
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Training', 'training', 1)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'barbell-bench-press';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds, notes)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 4, 6, 180, 'Heavy compound - progressive overload focus');
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'overhead-press';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 4, 8, 120);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'incline-dumbbell-press';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 10, 90);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'lateral-raise';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 15, 60);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'tricep-pushdown';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 3, 12, 60);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'face-pulls';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 5, 'F', 3, 15, 60);
      END IF;
    END IF;
    
    -- LOWER A - Squat Focus (Tuesday)
    INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
    VALUES (v_program_id, v_week_id, 'Lower A - Squat Focus', 'Quad dominant with accessory hamstring and glute work', 'tue', 2, 60)
    ON CONFLICT DO NOTHING
    RETURNING id INTO v_workout_id;
    
    IF v_workout_id IS NOT NULL THEN
      -- Warmup
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Warm-up', 'warmup', 0)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'hip-circles';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 30);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'glute-bridges';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 15);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'bodyweight-squat';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 15);
      END IF;
      
      -- Training
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Training', 'training', 1)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'barbell-squat';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds, notes)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 4, 6, 180, 'Main lift - depth to parallel or below');
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'leg-press';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 3, 12, 90);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'romanian-deadlift';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 10, 90);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'leg-curl';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 12, 60);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'calf-raises';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 4, 15, 60);
      END IF;
    END IF;
    
    -- UPPER B - Pull Focus (Thursday)
    INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
    VALUES (v_program_id, v_week_id, 'Upper B - Pull Focus', 'Back, biceps, rear delts with some pressing', 'thu', 4, 55)
    ON CONFLICT DO NOTHING
    RETURNING id INTO v_workout_id;
    
    IF v_workout_id IS NOT NULL THEN
      -- Warmup
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Warm-up', 'warmup', 0)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'shoulder-dislocates';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 10);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'band-pull-aparts';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 15);
      END IF;
      
      -- Training
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Training', 'training', 1)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'pull-ups';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds, notes)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 4, 8, 120, 'Add weight when bodyweight becomes easy');
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'barbell-row';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 4, 8, 120);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'seated-cable-row';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 12, 90);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'rear-delt-flyes';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 15, 60);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'barbell-curl';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 3, 10, 60);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'hammer-curl';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 5, 'F', 3, 12, 60);
      END IF;
    END IF;
    
    -- LOWER B - Hinge Focus (Friday)
    INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
    VALUES (v_program_id, v_week_id, 'Lower B - Hinge Focus', 'Deadlift and hamstring dominant with unilateral work', 'fri', 5, 60)
    ON CONFLICT DO NOTHING
    RETURNING id INTO v_workout_id;
    
    IF v_workout_id IS NOT NULL THEN
      -- Warmup
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Warm-up', 'warmup', 0)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'worlds-greatest-stretch';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 5);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'glute-bridges';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 15);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'bird-dogs';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 10);
      END IF;
      
      -- Training
      INSERT INTO workout_sections (workout_id, name, section_type, order_index)
      VALUES (v_workout_id, 'Training', 'training', 1)
      RETURNING id INTO v_section_id;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'conventional-deadlift';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds, notes)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 4, 5, 180, 'Main lift - maintain neutral spine');
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'hip-thrust';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 3, 12, 90);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'bulgarian-split-squat';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds, notes)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 10, 90, 'Each leg');
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'leg-curl';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 12, 60);
      END IF;
      
      SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'plank';
      IF v_exercise_id IS NOT NULL THEN
        INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, time_seconds, rest_seconds)
        VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 3, 45, 60);
      END IF;
    END IF;
    
  END LOOP;
END $$;

-- ============================================
-- CREATE WORKOUTS FOR FORGE PROGRAM (3-Day Full Body)
-- ============================================

DO $$
DECLARE
  v_program_id UUID;
  v_week_id UUID;
  v_workout_id UUID;
  v_section_id UUID;
  v_exercise_id UUID;
BEGIN
  SELECT id INTO v_program_id FROM programs WHERE slug = 'forge';
  
  IF v_program_id IS NULL THEN
    RAISE NOTICE 'FORGE program not found, skipping';
    RETURN;
  END IF;
  
  -- Create Week 1
  INSERT INTO program_weeks (program_id, week_number, name, description)
  VALUES (v_program_id, 1, 'Getting Started', 'Learn the movements and establish baseline')
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_week_id;
  
  IF v_week_id IS NULL THEN
    SELECT id INTO v_week_id FROM program_weeks WHERE program_id = v_program_id AND week_number = 1;
  END IF;
  
  -- Full Body A (Monday)
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_program_id, v_week_id, 'Full Body A', 'Squat pattern focus with balanced upper body', 'mon', 1, 50)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_section_id;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'goblet-squat';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 4, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'dumbbell-row';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'dumbbell-shoulder-press';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'romanian-deadlift';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'plank';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, time_seconds, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 3, 30, 60);
    END IF;
  END IF;
  
  -- Full Body B (Wednesday)
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_program_id, v_week_id, 'Full Body B', 'Hinge pattern focus with pushing emphasis', 'wed', 3, 50)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_section_id;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'romanian-deadlift';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 4, 8, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'incline-dumbbell-press';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'lat-pulldown';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'walking-lunges';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 12, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'dumbbell-curl';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 2, 12, 60);
    END IF;
  END IF;
  
  -- Full Body C (Friday)
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_program_id, v_week_id, 'Full Body C', 'Unilateral focus with core emphasis', 'fri', 5, 50)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_section_id;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'bulgarian-split-squat';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 0, 'A', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'push-ups';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 1, 'B', 3, 15, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'dumbbell-row';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 2, 'C', 3, 10, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'hip-thrust';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 3, 'D', 3, 12, 90);
    END IF;
    
    SELECT id INTO v_exercise_id FROM exercises WHERE slug = 'dead-bug';
    IF v_exercise_id IS NOT NULL THEN
      INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
      VALUES (v_workout_id, v_section_id, v_exercise_id, 4, 'E', 3, 10, 60);
    END IF;
  END IF;
END $$;

-- ============================================
-- SAMPLE PERSONAL RECORDS TABLE DATA PREP
-- ============================================
-- These structures will allow the app to track PRs

-- Ensure we have the proper columns for PR tracking
ALTER TABLE exercise_logs ADD COLUMN IF NOT EXISTS best_set_weight DECIMAL(10, 2);
ALTER TABLE exercise_logs ADD COLUMN IF NOT EXISTS best_set_reps INT;
ALTER TABLE exercise_logs ADD COLUMN IF NOT EXISTS is_pr BOOLEAN DEFAULT false;

-- Add estimated 1RM column
ALTER TABLE exercise_logs ADD COLUMN IF NOT EXISTS estimated_1rm DECIMAL(10, 2);

COMMENT ON COLUMN exercise_logs.estimated_1rm IS 'Estimated 1 rep max using Brzycki formula: weight * (36 / (37 - reps))';

-- ============================================
-- Management App Preparation
-- ============================================

-- Add fields for content management
ALTER TABLE programs ADD COLUMN IF NOT EXISTS coach_notes TEXT;
ALTER TABLE programs ADD COLUMN IF NOT EXISTS internal_tags TEXT[];

ALTER TABLE exercises ADD COLUMN IF NOT EXISTS coach_tips TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS common_mistakes TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS progression_options TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS regression_options TEXT[];

ALTER TABLE workouts ADD COLUMN IF NOT EXISTS coach_notes TEXT;
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS intensity_level VARCHAR(20);
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS target_rpe INT;

-- Create content status tracking
CREATE TYPE content_status AS ENUM ('draft', 'review', 'published', 'archived');

ALTER TABLE programs ADD COLUMN IF NOT EXISTS content_status content_status DEFAULT 'published';
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS content_status content_status DEFAULT 'published';
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS content_status content_status DEFAULT 'published';

-- Create audit log for management
CREATE TABLE IF NOT EXISTS content_audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name VARCHAR(100) NOT NULL,
  record_id UUID NOT NULL,
  action VARCHAR(20) NOT NULL,
  changed_by UUID REFERENCES auth.users(id),
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  old_values JSONB,
  new_values JSONB
);

-- Index for audit queries
CREATE INDEX IF NOT EXISTS idx_audit_log_table ON content_audit_log(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_date ON content_audit_log(changed_at DESC);

-- Grant access for authenticated users (coaches/admins will have additional permissions)
ALTER TABLE content_audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view audit logs" ON content_audit_log
  FOR SELECT TO authenticated
  USING (true);

RAISE NOTICE 'Comprehensive workout data migration complete!';

