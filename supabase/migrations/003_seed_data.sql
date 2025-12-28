-- Parks Strength Seed Data
-- Initial data for MVP

-- ============================================
-- EQUIPMENT
-- ============================================

INSERT INTO equipment (name, category, icon_name) VALUES
  ('Barbell', 'bars_weights', 'barbell'),
  ('Dumbbells', 'bars_weights', 'dumbbell'),
  ('Kettlebells', 'bars_weights', 'kettlebell'),
  ('EZ Curl Bar', 'bars_weights', 'ez_curl'),
  ('Trap Bar', 'bars_weights', 'trap_bar'),
  ('Cable Machine', 'machines', 'cable'),
  ('Leg Press', 'machines', 'leg_press'),
  ('Lat Pulldown', 'machines', 'lat_pulldown'),
  ('Leg Curl/Extension', 'machines', 'leg_machine'),
  ('Smith Machine', 'machines', 'smith'),
  ('Flat Bench', 'benches', 'bench'),
  ('Adjustable Bench', 'benches', 'adj_bench'),
  ('Squat Rack', 'benches', 'squat_rack'),
  ('Pull-up Bar', 'benches', 'pullup_bar'),
  ('Dip Station', 'benches', 'dip_station'),
  ('Resistance Bands', 'accessories', 'bands'),
  ('Battle Ropes', 'accessories', 'ropes'),
  ('Jump Ropes', 'accessories', 'jump_rope'),
  ('Medicine Ball', 'accessories', 'med_ball'),
  ('Foam Roller', 'accessories', 'foam_roller'),
  ('Stability Ball', 'accessories', 'stability_ball'),
  ('TRX/Suspension', 'accessories', 'trx'),
  ('Plyo Box', 'accessories', 'plyo_box'),
  ('Ab Wheel', 'accessories', 'ab_wheel');

-- ============================================
-- SAMPLE EXERCISES
-- ============================================

INSERT INTO exercises (name, slug, description, primary_muscles, secondary_muscles, movement_pattern, exercise_type, difficulty) VALUES
  ('Barbell Bench Press', 'barbell-bench-press', 'Classic chest exercise using a barbell', ARRAY['chest'], ARRAY['triceps', 'front_delts'], 'push', 'strength', 'intermediate'),
  ('Barbell Squat', 'barbell-squat', 'Compound lower body exercise', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'strength', 'intermediate'),
  ('Conventional Deadlift', 'conventional-deadlift', 'Full body pulling movement', ARRAY['back', 'hamstrings'], ARRAY['glutes', 'core', 'forearms'], 'hinge', 'strength', 'intermediate'),
  ('Pull-ups', 'pull-ups', 'Bodyweight pulling exercise', ARRAY['lats', 'biceps'], ARRAY['rear_delts', 'core'], 'pull', 'strength', 'intermediate'),
  ('Overhead Press', 'overhead-press', 'Vertical pressing movement', ARRAY['shoulders'], ARRAY['triceps', 'core'], 'push', 'strength', 'intermediate'),
  ('Barbell Row', 'barbell-row', 'Horizontal pulling for back development', ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'strength', 'intermediate'),
  ('Dumbbell Lunges', 'dumbbell-lunges', 'Unilateral lower body exercise', ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'strength', 'beginner'),
  ('Dumbbell Curl', 'dumbbell-curl', 'Isolation exercise for biceps', ARRAY['biceps'], ARRAY['forearms'], 'isolation', 'strength', 'beginner'),
  ('Tricep Pushdown', 'tricep-pushdown', 'Cable exercise for triceps', ARRAY['triceps'], ARRAY[], 'isolation', 'strength', 'beginner'),
  ('Plank', 'plank', 'Isometric core exercise', ARRAY['core'], ARRAY['shoulders'], 'core', 'strength', 'beginner'),
  ('Neck Roll', 'neck-roll', 'Warmup movement for neck mobility', ARRAY['neck'], ARRAY[], 'core', 'warmup', 'beginner'),
  ('Arm Circles', 'arm-circles', 'Dynamic warmup for shoulders', ARRAY['shoulders'], ARRAY[], 'push', 'warmup', 'beginner'),
  ('Hip Circles', 'hip-circles', 'Dynamic warmup for hips', ARRAY['hips'], ARRAY['glutes'], 'hinge', 'warmup', 'beginner'),
  ('Leg Swings', 'leg-swings', 'Dynamic warmup for legs', ARRAY['hamstrings', 'hip_flexors'], ARRAY[], 'hinge', 'warmup', 'beginner'),
  ('Cat-Cow Stretch', 'cat-cow', 'Spinal mobility stretch', ARRAY['back', 'core'], ARRAY[], 'core', 'stretch', 'beginner');

-- ============================================
-- SAMPLE PROGRAM: FOUNDATION STRENGTH
-- ============================================

INSERT INTO programs (
  name, slug, description, short_description, 
  duration_weeks, days_per_week, difficulty,
  focus_areas, goals, is_published, is_premium, accent_color
) VALUES (
  'Foundation Strength',
  'foundation-strength',
  'Build a solid foundation of functional strength with this comprehensive 8-week program. Perfect for those ready to take their training seriously and develop lasting strength.',
  'Build foundational strength with proper movement patterns',
  8, 4, 'intermediate',
  ARRAY['strength', 'functional'],
  ARRAY['build_strength', 'improve_mobility', 'functional_movement'],
  true, false, '#F97316'
);

-- Get the program ID
DO $$
DECLARE
  v_program_id UUID;
  v_week1_id UUID;
  v_workout1_id UUID;
  v_training_section_id UUID;
  v_warmup_section_id UUID;
BEGIN
  SELECT id INTO v_program_id FROM programs WHERE slug = 'foundation-strength';

  -- Create Week 1
  INSERT INTO program_weeks (program_id, week_number, name, description)
  VALUES (v_program_id, 1, 'Movement Foundations', 'Focus on form and movement quality')
  RETURNING id INTO v_week1_id;

  -- Create Push Day workout
  INSERT INTO workouts (program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes)
  VALUES (v_program_id, v_week1_id, 'Push Day', 'Upper body pushing focus: chest, shoulders, triceps', 'mon', 1, 50)
  RETURNING id INTO v_workout1_id;

  -- Create sections
  INSERT INTO workout_sections (workout_id, name, section_type, order_index)
  VALUES (v_workout1_id, 'Warm-up', 'warmup', 0)
  RETURNING id INTO v_warmup_section_id;

  INSERT INTO workout_sections (workout_id, name, section_type, order_index)
  VALUES (v_workout1_id, 'Training', 'training', 1)
  RETURNING id INTO v_training_section_id;

  -- Add warmup exercises
  INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
  SELECT v_workout1_id, v_warmup_section_id, id, 0, 30
  FROM exercises WHERE slug = 'arm-circles';

  INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, time_seconds)
  SELECT v_workout1_id, v_warmup_section_id, id, 1, 30
  FROM exercises WHERE slug = 'neck-roll';

  -- Add training exercises
  INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
  SELECT v_workout1_id, v_training_section_id, id, 0, 'A', 4, 8, 120
  FROM exercises WHERE slug = 'barbell-bench-press';

  INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
  SELECT v_workout1_id, v_training_section_id, id, 1, 'B', 3, 10, 90
  FROM exercises WHERE slug = 'overhead-press';

  INSERT INTO workout_exercises (workout_id, section_id, exercise_id, order_index, letter_designation, sets, reps, rest_seconds)
  SELECT v_workout1_id, v_training_section_id, id, 2, 'C', 3, 12, 60
  FROM exercises WHERE slug = 'tricep-pushdown';

END $$;

-- ============================================
-- BADGES
-- ============================================

INSERT INTO badges (name, description, category, requirement_type, requirement_value, points_awarded) VALUES
  ('First Workout', 'Complete your first workout', 'milestones', 'workouts_completed', 1, 50),
  ('Week Warrior', 'Complete 7 workouts in a week', 'consistency', 'weekly_workouts', 7, 100),
  ('Streak Starter', 'Achieve a 3-day streak', 'consistency', 'streak_days', 3, 25),
  ('Week Streak', 'Achieve a 7-day streak', 'consistency', 'streak_days', 7, 75),
  ('Month Streak', 'Achieve a 30-day streak', 'consistency', 'streak_days', 30, 250),
  ('PR Hunter', 'Set your first personal record', 'prs', 'total_prs', 1, 50),
  ('PR Machine', 'Set 10 personal records', 'prs', 'total_prs', 10, 150),
  ('Volume King', 'Lift 100,000 lbs total volume', 'volume', 'total_volume', 100000, 100),
  ('Community Member', 'Make your first community post', 'community', 'posts_created', 1, 25),
  ('Program Finisher', 'Complete a full program', 'milestones', 'programs_completed', 1, 200);

