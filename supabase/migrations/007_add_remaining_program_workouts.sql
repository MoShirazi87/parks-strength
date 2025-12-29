-- Add workouts for Hypertrophy Max and Functional Athlete programs
-- Also add program weeks for proper structure

-- Program week for Hypertrophy Max (a0000002)
INSERT INTO program_weeks (id, program_id, week_number, name, focus, deload)
VALUES 
  ('c0000100-0000-0000-0000-000000000001', 'a0000002-0000-0000-0000-000000000001', 1, 'Week 1', 'Volume Building', false)
ON CONFLICT (id) DO NOTHING;

-- Program week for Functional Athlete (a0000003)
INSERT INTO program_weeks (id, program_id, week_number, name, focus, deload)
VALUES 
  ('c0000200-0000-0000-0000-000000000001', 'a0000003-0000-0000-0000-000000000001', 1, 'Week 1', 'Movement Patterns', false)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- HYPERTROPHY MAX WORKOUTS
-- =====================================================

-- Hypertrophy Chest & Triceps
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000100-0000-0000-0000-000000000001', 'a0000002-0000-0000-0000-000000000001', 'c0000100-0000-0000-0000-000000000001', 
   'Hypertrophy Chest & Triceps', 'hypertrophy-chest-triceps', 
   'High volume chest and triceps workout for maximum muscle growth.', 
   1, 1, 55, 'intermediate', ARRAY['barbell', 'dumbbells', 'cables'], 
   'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800')
ON CONFLICT (id) DO NOTHING;

-- Hypertrophy Back & Biceps
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000100-0000-0000-0000-000000000002', 'a0000002-0000-0000-0000-000000000001', 'c0000100-0000-0000-0000-000000000001', 
   'Hypertrophy Back & Biceps', 'hypertrophy-back-biceps', 
   'High volume back and biceps for width and thickness.', 
   2, 2, 55, 'intermediate', ARRAY['barbell', 'dumbbells', 'cables', 'pull-up bar'], 
   'https://images.unsplash.com/photo-1605296867424-35fc25c9212a?w=800')
ON CONFLICT (id) DO NOTHING;

-- Hypertrophy Legs
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000100-0000-0000-0000-000000000003', 'a0000002-0000-0000-0000-000000000001', 'c0000100-0000-0000-0000-000000000001', 
   'Hypertrophy Legs', 'hypertrophy-legs', 
   'Complete leg development with quads, hamstrings, and calves.', 
   4, 3, 60, 'intermediate', ARRAY['barbell', 'dumbbells', 'leg press'], 
   'https://images.unsplash.com/photo-1434608519344-49d77a699e1d?w=800')
ON CONFLICT (id) DO NOTHING;

-- Hypertrophy Shoulders & Arms
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000100-0000-0000-0000-000000000004', 'a0000002-0000-0000-0000-000000000001', 'c0000100-0000-0000-0000-000000000001', 
   'Hypertrophy Shoulders & Arms', 'hypertrophy-shoulders-arms', 
   'Build boulder shoulders and sleeve-busting arms.', 
   5, 4, 50, 'intermediate', ARRAY['dumbbells', 'cables', 'ez-bar'], 
   'https://images.unsplash.com/photo-1581009146145-b5ef050c149a?w=800')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- FUNCTIONAL ATHLETE WORKOUTS
-- =====================================================

-- Functional Full Body Power
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000200-0000-0000-0000-000000000001', 'a0000003-0000-0000-0000-000000000001', 'c0000200-0000-0000-0000-000000000001', 
   'Full Body Power', 'full-body-power', 
   'Explosive full body workout for athletic performance.', 
   1, 1, 45, 'intermediate', ARRAY['barbell', 'kettlebell', 'medicine ball'], 
   'https://images.unsplash.com/photo-1517963879433-6ad2b056d712?w=800')
ON CONFLICT (id) DO NOTHING;

-- Functional Core & Conditioning
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000200-0000-0000-0000-000000000002', 'a0000003-0000-0000-0000-000000000001', 'c0000200-0000-0000-0000-000000000001', 
   'Core & Conditioning', 'core-conditioning', 
   'Build a bulletproof core and improve conditioning.', 
   3, 2, 40, 'intermediate', ARRAY['bodyweight', 'medicine ball'], 
   'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800')
ON CONFLICT (id) DO NOTHING;

-- Functional Strength & Mobility
INSERT INTO workouts (id, program_id, week_id, name, slug, description, day_of_week, workout_order, duration_minutes, difficulty, equipment_needed, thumbnail_url)
VALUES 
  ('b0000200-0000-0000-0000-000000000003', 'a0000003-0000-0000-0000-000000000001', 'c0000200-0000-0000-0000-000000000001', 
   'Strength & Mobility', 'strength-mobility', 
   'Combine strength training with mobility work.', 
   5, 3, 50, 'intermediate', ARRAY['barbell', 'dumbbells', 'bands'], 
   'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- WORKOUT SECTIONS AND EXERCISES
-- =====================================================

-- Hypertrophy Chest & Triceps - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000001', 'b0000100-0000-0000-0000-000000000001', 'Chest', 'main', 1, 'Focus on the squeeze at the top')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000001', 'd0000100-0000-0000-0000-000000000001', 'e0000001-0000-0000-0000-000000000001', 1, 4, 10, 90, 'Controlled tempo'),
  ('f0000100-0000-0000-0000-000000000002', 'd0000100-0000-0000-0000-000000000001', 'e0000001-0000-0000-0000-000000000002', 2, 4, 12, 75, 'Full stretch at bottom'),
  ('f0000100-0000-0000-0000-000000000003', 'd0000100-0000-0000-0000-000000000001', 'e0000001-0000-0000-0000-000000000003', 3, 3, 15, 60, 'Squeeze at top')
ON CONFLICT (id) DO NOTHING;

-- Triceps Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000002', 'b0000100-0000-0000-0000-000000000001', 'Triceps', 'main', 2, 'Finish strong')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000004', 'd0000100-0000-0000-0000-000000000002', 'e0000007-0000-0000-0000-000000000001', 1, 4, 12, 60, 'Keep elbows tight'),
  ('f0000100-0000-0000-0000-000000000005', 'd0000100-0000-0000-0000-000000000002', 'e0000007-0000-0000-0000-000000000002', 2, 3, 12, 60, 'Full stretch')
ON CONFLICT (id) DO NOTHING;

-- Hypertrophy Back & Biceps - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000003', 'b0000100-0000-0000-0000-000000000002', 'Back', 'main', 1, 'Pull with your elbows')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000006', 'd0000100-0000-0000-0000-000000000003', 'e0000002-0000-0000-0000-000000000001', 1, 4, 8, 90, 'Chest to bar'),
  ('f0000100-0000-0000-0000-000000000007', 'd0000100-0000-0000-0000-000000000003', 'e0000002-0000-0000-0000-000000000003', 2, 4, 10, 75, 'Full stretch'),
  ('f0000100-0000-0000-0000-000000000008', 'd0000100-0000-0000-0000-000000000003', 'e0000002-0000-0000-0000-000000000004', 3, 3, 12, 60, 'Squeeze shoulder blades')
ON CONFLICT (id) DO NOTHING;

-- Biceps Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000004', 'b0000100-0000-0000-0000-000000000002', 'Biceps', 'main', 2, 'Slow negatives')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000009', 'd0000100-0000-0000-0000-000000000004', 'e0000006-0000-0000-0000-000000000001', 1, 3, 10, 60, 'Keep elbows pinned'),
  ('f0000100-0000-0000-0000-000000000010', 'd0000100-0000-0000-0000-000000000004', 'e0000006-0000-0000-0000-000000000002', 2, 3, 12, 60, 'Alternate arms')
ON CONFLICT (id) DO NOTHING;

-- Hypertrophy Legs - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000005', 'b0000100-0000-0000-0000-000000000003', 'Quads & Glutes', 'main', 1, 'Go deep, own the weight')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000011', 'd0000100-0000-0000-0000-000000000005', 'e0000004-0000-0000-0000-000000000001', 1, 4, 8, 120, 'Below parallel'),
  ('f0000100-0000-0000-0000-000000000012', 'd0000100-0000-0000-0000-000000000005', 'e0000004-0000-0000-0000-000000000003', 2, 4, 12, 90, 'Controlled descent'),
  ('f0000100-0000-0000-0000-000000000013', 'd0000100-0000-0000-0000-000000000005', 'e0000004-0000-0000-0000-000000000004', 3, 3, 12, 60, 'Each leg')
ON CONFLICT (id) DO NOTHING;

-- Hamstrings Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000006', 'b0000100-0000-0000-0000-000000000003', 'Hamstrings', 'main', 2, 'Feel the stretch')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000014', 'd0000100-0000-0000-0000-000000000006', 'e0000005-0000-0000-0000-000000000001', 1, 4, 10, 90, 'Hips back'),
  ('f0000100-0000-0000-0000-000000000015', 'd0000100-0000-0000-0000-000000000006', 'e0000005-0000-0000-0000-000000000003', 2, 3, 12, 60, 'Full ROM')
ON CONFLICT (id) DO NOTHING;

-- Hypertrophy Shoulders & Arms - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000100-0000-0000-0000-000000000007', 'b0000100-0000-0000-0000-000000000004', 'Shoulders', 'main', 1, 'Controlled movements')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000100-0000-0000-0000-000000000016', 'd0000100-0000-0000-0000-000000000007', 'e0000003-0000-0000-0000-000000000002', 1, 4, 10, 75, 'Full ROM'),
  ('f0000100-0000-0000-0000-000000000017', 'd0000100-0000-0000-0000-000000000007', 'e0000003-0000-0000-0000-000000000003', 2, 4, 15, 45, 'Keep arms straight'),
  ('f0000100-0000-0000-0000-000000000018', 'd0000100-0000-0000-0000-000000000007', 'e0000003-0000-0000-0000-000000000004', 3, 3, 15, 45, 'Squeeze at peak')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- FUNCTIONAL ATHLETE WORKOUT EXERCISES
-- =====================================================

-- Full Body Power - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000200-0000-0000-0000-000000000001', 'b0000200-0000-0000-0000-000000000001', 'Power Movements', 'main', 1, 'Explosive but controlled')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000200-0000-0000-0000-000000000001', 'd0000200-0000-0000-0000-000000000001', 'e0000005-0000-0000-0000-000000000002', 1, 5, 5, 120, 'Speed on the way up'),
  ('f0000200-0000-0000-0000-000000000002', 'd0000200-0000-0000-0000-000000000001', 'e0000004-0000-0000-0000-000000000001', 2, 4, 6, 90, 'Explode up'),
  ('f0000200-0000-0000-0000-000000000003', 'd0000200-0000-0000-0000-000000000001', 'e0000002-0000-0000-0000-000000000001', 3, 4, 8, 75, 'Explosive pull'),
  ('f0000200-0000-0000-0000-000000000004', 'd0000200-0000-0000-0000-000000000001', 'e0000003-0000-0000-0000-000000000001', 4, 4, 6, 75, 'Drive through feet')
ON CONFLICT (id) DO NOTHING;

-- Core & Conditioning - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000200-0000-0000-0000-000000000002', 'b0000200-0000-0000-0000-000000000002', 'Core Circuit', 'main', 1, 'Minimal rest between exercises')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000200-0000-0000-0000-000000000005', 'd0000200-0000-0000-0000-000000000002', 'e0000008-0000-0000-0000-000000000001', 1, 3, 60, 45, '60 second hold'),
  ('f0000200-0000-0000-0000-000000000006', 'd0000200-0000-0000-0000-000000000002', 'e0000008-0000-0000-0000-000000000003', 2, 3, 10, 30, 'Each side'),
  ('f0000200-0000-0000-0000-000000000007', 'd0000200-0000-0000-0000-000000000002', 'e0000008-0000-0000-0000-000000000002', 3, 3, 12, 45, 'Each side'),
  ('f0000200-0000-0000-0000-000000000008', 'd0000200-0000-0000-0000-000000000002', 'e0000008-0000-0000-0000-000000000004', 4, 3, 12, 60, 'Controlled')
ON CONFLICT (id) DO NOTHING;

-- Strength & Mobility - Main Section
INSERT INTO workout_sections (id, workout_id, name, section_type, section_order, notes)
VALUES 
  ('d0000200-0000-0000-0000-000000000003', 'b0000200-0000-0000-0000-000000000003', 'Strength Work', 'main', 1, 'Quality over quantity')
ON CONFLICT (id) DO NOTHING;

INSERT INTO workout_exercises (id, section_id, exercise_id, exercise_order, sets, reps, rest_seconds, notes)
VALUES 
  ('f0000200-0000-0000-0000-000000000009', 'd0000200-0000-0000-0000-000000000003', 'e0000004-0000-0000-0000-000000000002', 1, 4, 8, 90, 'Deep goblet squat'),
  ('f0000200-0000-0000-0000-000000000010', 'd0000200-0000-0000-0000-000000000003', 'e0000005-0000-0000-0000-000000000001', 2, 4, 8, 90, 'Slow eccentric'),
  ('f0000200-0000-0000-0000-000000000011', 'd0000200-0000-0000-0000-000000000003', 'e0000002-0000-0000-0000-000000000002', 3, 3, 8, 75, 'Full range'),
  ('f0000200-0000-0000-0000-000000000012', 'd0000200-0000-0000-0000-000000000003', 'e0000001-0000-0000-0000-000000000004', 4, 3, 15, 45, 'Perfect form')
ON CONFLICT (id) DO NOTHING;

