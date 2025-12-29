-- Parks Strength Extended Seed Data
-- 50+ exercises covering all 7 movement patterns
-- 10 complete workouts with RAMP warm-ups

-- ============================================
-- EXTENDED EXERCISE LIBRARY (50+ exercises)
-- ============================================

-- SQUAT PATTERN EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Box Squat', 'box-squat', 'Squat to a box, controlling depth and teaching proper hip mechanics', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'strength', 'beginner'),
  ('Goblet Squat', 'goblet-squat', 'Front-loaded squat holding a dumbbell or kettlebell at chest', ARRAY['quads', 'glutes'], ARRAY['core', 'upper_back'], 'squat', 'strength', 'beginner'),
  ('Front Squat', 'front-squat', 'Barbell squat with bar racked on front shoulders', ARRAY['quads', 'glutes'], ARRAY['core', 'upper_back'], 'squat', 'strength', 'advanced'),
  ('Bulgarian Split Squat', 'bulgarian-split-squat', 'Single-leg squat with rear foot elevated', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'strength', 'intermediate'),
  ('Zercher Squat', 'zercher-squat', 'Squat with barbell held in the crook of elbows', ARRAY['quads', 'glutes'], ARRAY['core', 'biceps'], 'squat', 'strength', 'advanced'),
  ('Pause Squat', 'pause-squat', 'Squat with 2-3 second pause at bottom position', ARRAY['quads', 'glutes'], ARRAY['core'], 'squat', 'strength', 'intermediate'),
  ('Tempo Squat', 'tempo-squat', 'Squat with controlled eccentric (3-4 seconds down)', ARRAY['quads', 'glutes'], ARRAY['core'], 'squat', 'strength', 'intermediate'),
  ('Hack Squat', 'hack-squat', 'Machine squat with back supported at an angle', ARRAY['quads'], ARRAY['glutes'], 'squat', 'strength', 'beginner'),
  ('Sissy Squat', 'sissy-squat', 'Quad-dominant squat with knees traveling forward', ARRAY['quads'], ARRAY['core'], 'squat', 'strength', 'advanced')
ON CONFLICT (slug) DO NOTHING;

-- HINGE PATTERN EXERCISES  
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Romanian Deadlift', 'romanian-deadlift', 'Hip hinge with slight knee bend, barbell slides down thighs', ARRAY['hamstrings', 'glutes'], ARRAY['lower_back', 'core'], 'hinge', 'strength', 'intermediate'),
  ('Trap Bar Deadlift', 'trap-bar-deadlift', 'Deadlift using hex bar with neutral grip', ARRAY['quads', 'glutes', 'hamstrings'], ARRAY['back', 'core'], 'hinge', 'strength', 'intermediate'),
  ('Sumo Deadlift', 'sumo-deadlift', 'Wide stance deadlift with hands inside knees', ARRAY['glutes', 'quads'], ARRAY['hamstrings', 'back'], 'hinge', 'strength', 'intermediate'),
  ('Good Morning', 'good-morning', 'Barbell on back, hip hinge with minimal knee bend', ARRAY['hamstrings', 'lower_back'], ARRAY['glutes', 'core'], 'hinge', 'strength', 'intermediate'),
  ('Hip Thrust', 'hip-thrust', 'Glute bridge with back on bench, barbell on hips', ARRAY['glutes'], ARRAY['hamstrings', 'core'], 'hinge', 'strength', 'beginner'),
  ('Single-Leg RDL', 'single-leg-rdl', 'Romanian deadlift on one leg for balance and stability', ARRAY['hamstrings', 'glutes'], ARRAY['core'], 'hinge', 'strength', 'advanced'),
  ('Kettlebell Swing', 'kettlebell-swing', 'Explosive hip hinge swinging kettlebell to shoulder height', ARRAY['glutes', 'hamstrings'], ARRAY['core', 'shoulders'], 'hinge', 'power', 'intermediate'),
  ('Cable Pull-Through', 'cable-pull-through', 'Hip hinge pulling cable between legs', ARRAY['glutes', 'hamstrings'], ARRAY['core'], 'hinge', 'strength', 'beginner'),
  ('Glute Bridge', 'glute-bridge', 'Hip extension lying on back with feet planted', ARRAY['glutes'], ARRAY['hamstrings', 'core'], 'hinge', 'strength', 'beginner'),
  ('Nordic Curl', 'nordic-curl', 'Eccentric hamstring exercise kneeling with ankles anchored', ARRAY['hamstrings'], ARRAY['core'], 'hinge', 'strength', 'advanced')
ON CONFLICT (slug) DO NOTHING;

-- PUSH PATTERN EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Incline Barbell Press', 'incline-barbell-press', 'Bench press on incline targeting upper chest', ARRAY['chest', 'front_delts'], ARRAY['triceps'], 'push', 'strength', 'intermediate'),
  ('Incline Dumbbell Press', 'incline-dumbbell-press', 'Incline press with dumbbells for greater ROM', ARRAY['chest', 'front_delts'], ARRAY['triceps'], 'push', 'strength', 'intermediate'),
  ('Dumbbell Bench Press', 'dumbbell-bench-press', 'Flat bench press with dumbbells', ARRAY['chest'], ARRAY['triceps', 'front_delts'], 'push', 'strength', 'beginner'),
  ('Dips', 'dips', 'Bodyweight pressing movement on parallel bars', ARRAY['chest', 'triceps'], ARRAY['front_delts'], 'push', 'strength', 'intermediate'),
  ('Push-ups', 'push-ups', 'Classic bodyweight pushing exercise', ARRAY['chest'], ARRAY['triceps', 'front_delts', 'core'], 'push', 'strength', 'beginner'),
  ('Close-Grip Bench Press', 'close-grip-bench-press', 'Bench press with narrow grip targeting triceps', ARRAY['triceps'], ARRAY['chest', 'front_delts'], 'push', 'strength', 'intermediate'),
  ('Landmine Press', 'landmine-press', 'Pressing movement using barbell in landmine', ARRAY['shoulders', 'chest'], ARRAY['triceps', 'core'], 'push', 'strength', 'beginner'),
  ('Arnold Press', 'arnold-press', 'Dumbbell press with rotation through the movement', ARRAY['shoulders'], ARRAY['triceps'], 'push', 'strength', 'intermediate'),
  ('Pike Push-ups', 'pike-push-ups', 'Push-up variation targeting shoulders', ARRAY['shoulders'], ARRAY['triceps'], 'push', 'strength', 'intermediate'),
  ('Floor Press', 'floor-press', 'Bench press performed lying on floor', ARRAY['chest', 'triceps'], ARRAY['front_delts'], 'push', 'strength', 'intermediate')
ON CONFLICT (slug) DO NOTHING;

-- PULL PATTERN EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Lat Pulldown', 'lat-pulldown', 'Cable pulling movement targeting lats', ARRAY['lats'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'beginner'),
  ('Seated Cable Row', 'seated-cable-row', 'Horizontal pulling on cable machine', ARRAY['back', 'lats'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'beginner'),
  ('Dumbbell Row', 'dumbbell-row', 'Single-arm rowing movement with dumbbell', ARRAY['lats', 'back'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'beginner'),
  ('Pendlay Row', 'pendlay-row', 'Strict barbell row from floor each rep', ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'intermediate'),
  ('Face Pulls', 'face-pulls', 'Cable pull to face targeting rear delts', ARRAY['rear_delts'], ARRAY['upper_back', 'rotator_cuff'], 'pull', 'strength', 'beginner'),
  ('Chin-ups', 'chin-ups', 'Pull-up with supinated (underhand) grip', ARRAY['lats', 'biceps'], ARRAY['core'], 'pull', 'strength', 'intermediate'),
  ('T-Bar Row', 't-bar-row', 'Rowing with landmine or T-bar machine', ARRAY['back', 'lats'], ARRAY['biceps'], 'pull', 'strength', 'intermediate'),
  ('Meadows Row', 'meadows-row', 'Single-arm landmine row variation', ARRAY['lats'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'intermediate'),
  ('Inverted Row', 'inverted-row', 'Bodyweight horizontal row using bar or rings', ARRAY['back'], ARRAY['biceps', 'core'], 'pull', 'strength', 'beginner'),
  ('Straight-Arm Pulldown', 'straight-arm-pulldown', 'Lat isolation with arms straight', ARRAY['lats'], ARRAY['core'], 'pull', 'strength', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- CARRY PATTERN EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Farmers Walk', 'farmers-walk', 'Walking while carrying heavy weights in each hand', ARRAY['grip', 'core'], ARRAY['traps', 'legs'], 'carry', 'strength', 'beginner'),
  ('Suitcase Carry', 'suitcase-carry', 'Single-arm carry challenging lateral stability', ARRAY['obliques', 'grip'], ARRAY['core', 'traps'], 'carry', 'strength', 'intermediate'),
  ('Overhead Carry', 'overhead-carry', 'Walking with weight pressed overhead', ARRAY['shoulders', 'core'], ARRAY['traps'], 'carry', 'strength', 'intermediate'),
  ('Rack Carry', 'rack-carry', 'Carrying kettlebells in rack position', ARRAY['core', 'shoulders'], ARRAY['grip'], 'carry', 'strength', 'intermediate'),
  ('Zercher Carry', 'zercher-carry', 'Carrying barbell in crook of elbows', ARRAY['core', 'biceps'], ARRAY['upper_back'], 'carry', 'strength', 'advanced'),
  ('Sandbag Carry', 'sandbag-carry', 'Carrying awkward sandbag load', ARRAY['core', 'grip'], ARRAY['full_body'], 'carry', 'strength', 'intermediate')
ON CONFLICT (slug) DO NOTHING;

-- ROTATION PATTERN EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Pallof Press', 'pallof-press', 'Anti-rotation exercise pressing cable away from body', ARRAY['core', 'obliques'], ARRAY[], 'rotation', 'strength', 'beginner'),
  ('Cable Woodchop', 'cable-woodchop', 'Rotational cable movement high to low', ARRAY['obliques', 'core'], ARRAY['shoulders'], 'rotation', 'strength', 'intermediate'),
  ('Medicine Ball Rotational Throw', 'med-ball-rotational-throw', 'Explosive rotational throw against wall', ARRAY['obliques', 'core'], ARRAY['shoulders', 'hips'], 'rotation', 'power', 'intermediate'),
  ('Russian Twist', 'russian-twist', 'Seated rotation holding weight', ARRAY['obliques'], ARRAY['core'], 'rotation', 'strength', 'beginner'),
  ('Landmine Rotation', 'landmine-rotation', 'Rotational movement with barbell in landmine', ARRAY['obliques', 'core'], ARRAY['shoulders'], 'rotation', 'strength', 'intermediate'),
  ('Dead Bug', 'dead-bug', 'Anti-extension core exercise lying on back', ARRAY['core'], ARRAY['hip_flexors'], 'rotation', 'strength', 'beginner'),
  ('Bird Dog', 'bird-dog', 'Anti-rotation exercise on hands and knees', ARRAY['core'], ARRAY['glutes', 'shoulders'], 'rotation', 'strength', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- LOCOMOTION PATTERN EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Sled Push', 'sled-push', 'Pushing weighted sled for distance', ARRAY['quads', 'glutes'], ARRAY['core', 'calves'], 'locomotion', 'conditioning', 'intermediate'),
  ('Sled Pull', 'sled-pull', 'Pulling weighted sled walking backwards', ARRAY['hamstrings', 'glutes'], ARRAY['core', 'grip'], 'locomotion', 'conditioning', 'intermediate'),
  ('Bear Crawl', 'bear-crawl', 'Crawling on hands and feet', ARRAY['core', 'shoulders'], ARRAY['quads', 'hip_flexors'], 'locomotion', 'conditioning', 'beginner'),
  ('Box Jumps', 'box-jumps', 'Explosive jump onto elevated box', ARRAY['quads', 'glutes'], ARRAY['calves', 'core'], 'locomotion', 'power', 'intermediate'),
  ('Broad Jump', 'broad-jump', 'Horizontal jump for distance', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'locomotion', 'power', 'intermediate'),
  ('Battle Ropes', 'battle-ropes', 'Alternating or simultaneous rope waves', ARRAY['shoulders', 'core'], ARRAY['grip', 'back'], 'locomotion', 'conditioning', 'beginner'),
  ('Jump Rope', 'jump-rope', 'Classic cardiovascular exercise', ARRAY['calves'], ARRAY['shoulders', 'core'], 'locomotion', 'conditioning', 'beginner'),
  ('Prowler Push', 'prowler-push', 'Pushing prowler sled at various heights', ARRAY['full_body'], ARRAY[], 'locomotion', 'conditioning', 'intermediate')
ON CONFLICT (slug) DO NOTHING;

-- ISOLATION EXERCISES
INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Hammer Curl', 'hammer-curl', 'Bicep curl with neutral grip', ARRAY['biceps', 'brachialis'], ARRAY['forearms'], 'isolation', 'strength', 'beginner'),
  ('Preacher Curl', 'preacher-curl', 'Bicep curl with arms on angled pad', ARRAY['biceps'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Skull Crushers', 'skull-crushers', 'Tricep extension lying on bench', ARRAY['triceps'], ARRAY[], 'isolation', 'strength', 'intermediate'),
  ('Overhead Tricep Extension', 'overhead-tricep-extension', 'Tricep extension with weight overhead', ARRAY['triceps'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Lateral Raise', 'lateral-raise', 'Dumbbell raise to the side for medial delts', ARRAY['shoulders'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Front Raise', 'front-raise', 'Dumbbell raise to the front', ARRAY['front_delts'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Rear Delt Fly', 'rear-delt-fly', 'Reverse fly for posterior deltoids', ARRAY['rear_delts'], ARRAY['upper_back'], 'isolation', 'strength', 'beginner'),
  ('Leg Extension', 'leg-extension', 'Machine exercise isolating quadriceps', ARRAY['quads'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Leg Curl', 'leg-curl', 'Machine exercise isolating hamstrings', ARRAY['hamstrings'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Calf Raise', 'calf-raise', 'Standing or seated calf raise', ARRAY['calves'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Cable Fly', 'cable-fly', 'Cable crossover for chest isolation', ARRAY['chest'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Concentration Curl', 'concentration-curl', 'Single-arm bicep curl with elbow braced', ARRAY['biceps'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Wrist Curl', 'wrist-curl', 'Forearm flexor exercise', ARRAY['forearms'], ARRAY[], 'isolation', 'strength', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- ADDITIONAL WARMUP/MOBILITY EXERCISES
-- ============================================

INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('World''s Greatest Stretch', 'worlds-greatest-stretch', 'Dynamic stretch hitting hip flexors, hamstrings, thoracic spine', ARRAY['hips', 'thoracic'], ARRAY['hamstrings'], 'core', 'warmup', 'beginner'),
  ('90/90 Hip Stretch', '90-90-hip-stretch', 'Hip mobility in 90 degree position', ARRAY['hips'], ARRAY['glutes'], 'core', 'warmup', 'beginner'),
  ('Thoracic Rotation', 'thoracic-rotation', 'Rotational stretch for upper back', ARRAY['thoracic'], ARRAY['core'], 'rotation', 'warmup', 'beginner'),
  ('Shoulder Dislocates', 'shoulder-dislocates', 'Band or stick pass-through for shoulder mobility', ARRAY['shoulders'], ARRAY['chest'], 'push', 'warmup', 'beginner'),
  ('Band Pull-Aparts', 'band-pull-aparts', 'Horizontal band pull for rear delts and posture', ARRAY['rear_delts'], ARRAY['upper_back'], 'pull', 'warmup', 'beginner'),
  ('Glute Activation', 'glute-activation', 'Mini-band walks and glute bridges', ARRAY['glutes'], ARRAY[], 'hinge', 'warmup', 'beginner'),
  ('Ankle Mobility', 'ankle-mobility', 'Wall ankle stretch and circles', ARRAY['calves'], ARRAY['ankles'], 'squat', 'warmup', 'beginner'),
  ('Pogo Hops', 'pogo-hops', 'Light bouncing to potentiate CNS', ARRAY['calves'], ARRAY[], 'locomotion', 'warmup', 'beginner'),
  ('High Knees', 'high-knees', 'Running in place with high knee drive', ARRAY['hip_flexors'], ARRAY['core', 'calves'], 'locomotion', 'warmup', 'beginner'),
  ('Butt Kicks', 'butt-kicks', 'Running in place kicking heels to glutes', ARRAY['hamstrings'], ARRAY['quads'], 'locomotion', 'warmup', 'beginner'),
  ('Inchworm', 'inchworm', 'Walk hands out to plank, walk feet to hands', ARRAY['hamstrings', 'core'], ARRAY['shoulders'], 'hinge', 'warmup', 'beginner'),
  ('Spiderman Lunge', 'spiderman-lunge', 'Deep lunge with elbow to floor', ARRAY['hips'], ARRAY['groin', 'thoracic'], 'squat', 'warmup', 'beginner')
ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- CREATE ADDITIONAL PROGRAMS
-- ============================================

-- Program: TITAN (4-day Upper/Lower)
INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'TITAN',
  'titan',
  'A 12-week strength program built on the principles of progressive overload and periodization. Train 4 days per week with an upper/lower split designed to maximize strength gains.',
  'Elite 12-week upper/lower strength program',
  12, 4, 'intermediate',
  ARRAY['strength', 'muscle_building'],
  ARRAY['build_strength', 'increase_muscle', 'progressive_overload'],
  true, true, '#F97316'
) ON CONFLICT (slug) DO NOTHING;

-- Program: FORGE (3-day Full Body)
INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'FORGE',
  'forge',
  'Perfect for busy schedules - 3 full-body sessions per week that hit all major movement patterns. Designed for efficient, effective training.',
  '3-day full body strength program',
  8, 3, 'beginner',
  ARRAY['strength', 'functional'],
  ARRAY['build_strength', 'improve_fitness', 'time_efficient'],
  true, false, '#EC4899'
) ON CONFLICT (slug) DO NOTHING;

-- Program: NOMAD (Minimal Equipment)
INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'NOMAD',
  'nomad',
  'Train anywhere with minimal equipment. This program uses dumbbells, bands, and bodyweight to deliver serious results.',
  'Minimal equipment training program',
  6, 4, 'beginner',
  ARRAY['functional', 'conditioning'],
  ARRAY['functional_strength', 'body_composition', 'flexibility'],
  true, false, '#3B82F6'
) ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- CREATE 10 COMPLETE WORKOUTS
-- ============================================

DO $$
DECLARE
  v_foundation_id UUID;
  v_titan_id UUID;
  v_forge_id UUID;
  v_week_id UUID;
  v_workout_id UUID;
  v_warmup_section_id UUID;
  v_training_section_id UUID;
  v_cooldown_section_id UUID;
BEGIN
  -- Get program IDs
  SELECT id INTO v_foundation_id FROM programs WHERE slug = 'foundation-strength';
  SELECT id INTO v_titan_id FROM programs WHERE slug = 'titan';
  SELECT id INTO v_forge_id FROM programs WHERE slug = 'forge';

  -- ============================================
  -- WORKOUT 1: Push Day (Compound)
  -- ============================================
  
  -- Create week for TITAN if not exists
  INSERT INTO program_weeks (program_id, week_number, name, description)
  VALUES (v_titan_id, 1, 'Foundation Week', 'Establish baseline strength')
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_week_id;
  
  IF v_week_id IS NULL THEN
    SELECT id INTO v_week_id FROM program_weeks WHERE program_id = v_titan_id AND week_number = 1;
  END IF;
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_titan_id, v_week_id, 'Push Day', 'Upper body pushing: chest, shoulders, triceps', 'mon', 1, 55)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    -- Warmup section
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'RAMP Warm-up', 'warmup', 0)
    RETURNING id INTO v_warmup_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
    SELECT v_workout_id, v_warmup_section_id, id, 0, 60 FROM exercises WHERE slug = 'arm-circles';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
    SELECT v_workout_id, v_warmup_section_id, id, 1, 60 FROM exercises WHERE slug = 'shoulder-dislocates';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 2, 15 FROM exercises WHERE slug = 'band-pull-aparts';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 3, 10 FROM exercises WHERE slug = 'push-ups';
    
    -- Training section
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 1)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 6, 180 FROM exercises WHERE slug = 'barbell-bench-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 4, 8, 120 FROM exercises WHERE slug = 'overhead-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 10, 90 FROM exercises WHERE slug = 'incline-dumbbell-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 10, 90 FROM exercises WHERE slug = 'dips';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 15, 60 FROM exercises WHERE slug = 'tricep-pushdown';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 3, 15, 60 FROM exercises WHERE slug = 'lateral-raise';
  END IF;

  -- ============================================
  -- WORKOUT 2: Pull Day (Compound)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_titan_id, v_week_id, 'Pull Day', 'Upper body pulling: back, biceps, rear delts', 'tue', 2, 55)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'RAMP Warm-up', 'warmup', 0)
    RETURNING id INTO v_warmup_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
    SELECT v_workout_id, v_warmup_section_id, id, 0, 60 FROM exercises WHERE slug = 'arm-circles';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 1, 15 FROM exercises WHERE slug = 'band-pull-aparts';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 2, 10 FROM exercises WHERE slug = 'inverted-row';
    
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 1)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 6, 180 FROM exercises WHERE slug = 'pull-ups';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 4, 8, 120 FROM exercises WHERE slug = 'barbell-row';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 10, 90 FROM exercises WHERE slug = 'seated-cable-row';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 15, 60 FROM exercises WHERE slug = 'face-pulls';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 12, 60 FROM exercises WHERE slug = 'dumbbell-curl';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 3, 12, 60 FROM exercises WHERE slug = 'hammer-curl';
  END IF;

  -- ============================================
  -- WORKOUT 3: Leg Day (Compound)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_titan_id, v_week_id, 'Leg Day', 'Lower body: quads, hamstrings, glutes', 'thu', 3, 60)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'RAMP Warm-up', 'warmup', 0)
    RETURNING id INTO v_warmup_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
    SELECT v_workout_id, v_warmup_section_id, id, 0, 60 FROM exercises WHERE slug = 'hip-circles';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
    SELECT v_workout_id, v_warmup_section_id, id, 1, 60 FROM exercises WHERE slug = 'leg-swings';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 2, 10 FROM exercises WHERE slug = 'goblet-squat';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 3, 10 FROM exercises WHERE slug = 'glute-bridge';
    
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 1)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 5, 180 FROM exercises WHERE slug = 'barbell-squat';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 4, 6, 180 FROM exercises WHERE slug = 'romanian-deadlift';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 10, 90 FROM exercises WHERE slug = 'bulgarian-split-squat';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 12, 90 FROM exercises WHERE slug = 'hip-thrust';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 15, 60 FROM exercises WHERE slug = 'leg-curl';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 4, 15, 60 FROM exercises WHERE slug = 'calf-raise';
  END IF;

  -- ============================================
  -- WORKOUT 4: Upper Body A (Horizontal)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_titan_id, v_week_id, 'Upper Body A', 'Horizontal push/pull focus', 'fri', 4, 50)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 8, 120 FROM exercises WHERE slug = 'dumbbell-bench-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 4, 8, 120 FROM exercises WHERE slug = 'dumbbell-row';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 12, 90 FROM exercises WHERE slug = 'cable-fly';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 12, 90 FROM exercises WHERE slug = 'face-pulls';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 12, 60 FROM exercises WHERE slug = 'skull-crushers';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 3, 12, 60 FROM exercises WHERE slug = 'preacher-curl';
  END IF;

  -- ============================================
  -- WORKOUT 5: Lower Body A (Squat-dominant)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_foundation_id, (SELECT id FROM program_weeks WHERE program_id = v_foundation_id LIMIT 1), 'Lower Body A', 'Squat-dominant lower body', 'wed', 2, 55)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 6, 180 FROM exercises WHERE slug = 'front-squat';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 3, 10, 90 FROM exercises WHERE slug = 'goblet-squat';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 10, 90 FROM exercises WHERE slug = 'dumbbell-lunges';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 15, 60 FROM exercises WHERE slug = 'leg-extension';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 4, 15, 60 FROM exercises WHERE slug = 'calf-raise';
  END IF;

  -- ============================================
  -- WORKOUT 6: Lower Body B (Hinge-dominant)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_foundation_id, (SELECT id FROM program_weeks WHERE program_id = v_foundation_id LIMIT 1), 'Lower Body B', 'Hinge-dominant lower body', 'sat', 4, 55)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 5, 180 FROM exercises WHERE slug = 'conventional-deadlift';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 3, 10, 90 FROM exercises WHERE slug = 'romanian-deadlift';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 12, 90 FROM exercises WHERE slug = 'hip-thrust';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 12, 60 FROM exercises WHERE slug = 'leg-curl';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 10, 90 FROM exercises WHERE slug = 'good-morning';
  END IF;

  -- ============================================
  -- WORKOUT 7: Chest & Triceps (Isolation Focus)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_forge_id, NULL, 'Chest & Triceps', 'Isolation focus: chest and tricep accessories', NULL, NULL, 45)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 10, 90 FROM exercises WHERE slug = 'incline-dumbbell-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 3, 12, 60 FROM exercises WHERE slug = 'cable-fly';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 15, 60 FROM exercises WHERE slug = 'push-ups';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 12, 60 FROM exercises WHERE slug = 'close-grip-bench-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 15, 60 FROM exercises WHERE slug = 'tricep-pushdown';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 3, 12, 60 FROM exercises WHERE slug = 'overhead-tricep-extension';
  END IF;

  -- ============================================
  -- WORKOUT 8: Back & Biceps (Isolation Focus)
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_forge_id, NULL, 'Back & Biceps', 'Isolation focus: back and bicep accessories', NULL, NULL, 45)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 10, 90 FROM exercises WHERE slug = 'lat-pulldown';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 4, 10, 90 FROM exercises WHERE slug = 'seated-cable-row';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 12, 60 FROM exercises WHERE slug = 'straight-arm-pulldown';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 15, 60 FROM exercises WHERE slug = 'rear-delt-fly';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 12, 60 FROM exercises WHERE slug = 'dumbbell-curl';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 3, 12, 60 FROM exercises WHERE slug = 'concentration-curl';
  END IF;

  -- ============================================
  -- WORKOUT 9: Legs Isolation
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_forge_id, NULL, 'Legs Isolation', 'Leg extensions, curls, and calf work', NULL, NULL, 40)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 0)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 4, 15, 60 FROM exercises WHERE slug = 'leg-extension';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 4, 15, 60 FROM exercises WHERE slug = 'leg-curl';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 15, 60 FROM exercises WHERE slug = 'hip-thrust';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 4, 15, 60 FROM exercises WHERE slug = 'calf-raise';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 12, 60 FROM exercises WHERE slug = 'glute-bridge';
  END IF;

  -- ============================================
  -- WORKOUT 10: Full Body Functional
  -- ============================================
  
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_forge_id, NULL, 'Full Body Functional', 'Complete functional workout hitting all patterns', NULL, NULL, 50)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_workout_id;
  
  IF v_workout_id IS NOT NULL THEN
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'RAMP Warm-up', 'warmup', 0)
    RETURNING id INTO v_warmup_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
    SELECT v_workout_id, v_warmup_section_id, id, 0, 120 FROM exercises WHERE slug = 'jump-rope';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 1, 5 FROM exercises WHERE slug = 'worlds-greatest-stretch';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, reps)
    SELECT v_workout_id, v_warmup_section_id, id, 2, 10 FROM exercises WHERE slug = 'goblet-squat';
    
    INSERT INTO workout_sections (workout_id, name, section_type, order_index)
    VALUES (v_workout_id, 'Training', 'training', 1)
    RETURNING id INTO v_training_section_id;
    
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 0, 'A', 3, 8, 120 FROM exercises WHERE slug = 'trap-bar-deadlift';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 1, 'B', 3, 10, 90 FROM exercises WHERE slug = 'dumbbell-bench-press';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 2, 'C', 3, 10, 90 FROM exercises WHERE slug = 'dumbbell-row';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 3, 'D', 3, 10, 90 FROM exercises WHERE slug = 'goblet-squat';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 4, 'E', 3, 30, 60 FROM exercises WHERE slug = 'farmers-walk';
    INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
    SELECT v_workout_id, v_training_section_id, id, 5, 'F', 3, 30, 60 FROM exercises WHERE slug = 'plank';
  END IF;

END $$;

-- ============================================
-- ADDITIONAL BADGES
-- ============================================

INSERT INTO badges (name, description, category, requirement_type, requirement_value, points_awarded) VALUES
  ('Movement Master', 'Complete workouts using all 7 movement patterns', 'milestones', 'movement_patterns', 7, 100),
  ('Functional Athlete', 'Complete 10 functional workouts', 'milestones', 'workouts_completed', 10, 100),
  ('Iron Will', 'Complete a workout at RPE 9+', 'milestones', 'high_rpe_workout', 1, 50),
  ('Progressive Beast', 'Increase weight on any exercise 5 times', 'prs', 'weight_increases', 5, 75),
  ('Carry King', 'Complete 20 carry exercises', 'milestones', 'carry_exercises', 20, 50)
ON CONFLICT DO NOTHING;

