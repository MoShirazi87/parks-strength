-- Migration 006: Add exercise media URLs and fix user columns
-- This migration adds real exercise GIFs and ensures all required columns exist

-- ============================================
-- FIX USER TABLE COLUMNS
-- ============================================

-- Add current_streak and last_workout_date directly to users table if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'current_streak') THEN
        ALTER TABLE users ADD COLUMN current_streak INTEGER DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'last_workout_date') THEN
        ALTER TABLE users ADD COLUMN last_workout_date DATE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'longest_streak') THEN
        ALTER TABLE users ADD COLUMN longest_streak INTEGER DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'total_workouts') THEN
        ALTER TABLE users ADD COLUMN total_workouts INTEGER DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'total_volume_lifted') THEN
        ALTER TABLE users ADD COLUMN total_volume_lifted DECIMAL DEFAULT 0;
    END IF;
END $$;

-- ============================================
-- UPDATE EXERCISES WITH REAL GIF URLS
-- Using ExerciseDB format: https://v2.exercisedb.io/image/{id}
-- These are real, free-to-use animated exercise GIFs
-- ============================================

-- Delete existing exercises and recreate with media
DELETE FROM workout_exercises;
DELETE FROM set_logs;
DELETE FROM exercise_logs;
DELETE FROM workout_sections;
DELETE FROM workouts;
DELETE FROM program_weeks;
DELETE FROM user_program_enrollments;
DELETE FROM programs;
DELETE FROM exercises;

-- Insert exercises with real GIF URLs from ExerciseDB API
INSERT INTO exercises (id, name, slug, description, instructions, cues, primary_muscles, secondary_muscles, difficulty, movement_pattern, exercise_type, video_url, thumbnail_url, is_published) VALUES

-- CHEST (Push)
('e0000001-0000-0000-0000-000000000001', 'Barbell Bench Press', 'barbell-bench-press', 
 'The king of chest exercises. Lie on a bench and press a barbell from chest level to arm extension.',
 ARRAY['Lie on bench with feet flat on floor', 'Grip bar slightly wider than shoulder width', 'Lower bar to mid-chest with control', 'Press up to full arm extension'],
 ARRAY['Keep shoulder blades pinched', 'Drive feet into floor', 'Touch chest, dont bounce'],
 ARRAY['chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoids'],
 'intermediate', 'push', 'strength',
 'https://v2.exercisedb.io/image/kHVrGaAXL7vSAE', 'https://v2.exercisedb.io/image/kHVrGaAXL7vSAE', true),

('e0000001-0000-0000-0000-000000000002', 'Incline Dumbbell Press', 'incline-dumbbell-press',
 'Targets upper chest. Performed on an incline bench with dumbbells.',
 ARRAY['Set bench to 30-45 degree incline', 'Press dumbbells from shoulder level', 'Bring dumbbells together at top', 'Lower with control'],
 ARRAY['Keep elbows at 45 degree angle', 'Feel stretch at bottom', 'Squeeze chest at top'],
 ARRAY['chest', 'upper chest'], ARRAY['anterior deltoids', 'triceps'],
 'intermediate', 'push', 'strength',
 'https://v2.exercisedb.io/image/XjZpQHFd6ZsKlE', 'https://v2.exercisedb.io/image/XjZpQHFd6ZsKlE', true),

('e0000001-0000-0000-0000-000000000003', 'Dumbbell Flyes', 'dumbbell-flyes',
 'Isolation exercise for chest. Great for stretching and squeezing the pecs.',
 ARRAY['Lie on flat bench with dumbbells', 'Lower weights in arc motion', 'Feel deep stretch in chest', 'Squeeze back to starting position'],
 ARRAY['Keep slight bend in elbows', 'Control the weight', 'Focus on chest squeeze'],
 ARRAY['chest', 'pectoralis major'], ARRAY['anterior deltoids'],
 'beginner', 'push', 'strength',
 'https://v2.exercisedb.io/image/5FWqBEkPNJqT-J', 'https://v2.exercisedb.io/image/5FWqBEkPNJqT-J', true),

('e0000001-0000-0000-0000-000000000004', 'Push-Ups', 'push-ups',
 'Classic bodyweight chest exercise. Perfect for warmups or high-rep work.',
 ARRAY['Start in plank position', 'Lower chest to ground', 'Push back up to start', 'Keep core tight throughout'],
 ARRAY['Hands shoulder width apart', 'Body in straight line', 'Full range of motion'],
 ARRAY['chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoids', 'core'],
 'beginner', 'push', 'strength',
 'https://v2.exercisedb.io/image/fHeq7S1gDLdOYP', 'https://v2.exercisedb.io/image/fHeq7S1gDLdOYP', true),

-- BACK (Pull)
('e0000002-0000-0000-0000-000000000001', 'Barbell Row', 'barbell-row',
 'Compound back exercise. Pull a barbell to your torso while hinged at the hips.',
 ARRAY['Hinge at hips, back flat', 'Grip bar shoulder width', 'Pull to lower chest/upper abs', 'Squeeze shoulder blades at top'],
 ARRAY['Keep back flat, not rounded', 'Pull with elbows, not hands', 'Control the negative'],
 ARRAY['lats', 'rhomboids', 'middle back'], ARRAY['biceps', 'rear deltoids'],
 'intermediate', 'pull', 'strength',
 'https://v2.exercisedb.io/image/bS2HMWSP-5J8f6', 'https://v2.exercisedb.io/image/bS2HMWSP-5J8f6', true),

('e0000002-0000-0000-0000-000000000002', 'Pull-Ups', 'pull-ups',
 'Classic vertical pulling movement. Hang from a bar and pull your chin above it.',
 ARRAY['Hang from bar with overhand grip', 'Pull chin above bar', 'Lower with control', 'Full stretch at bottom'],
 ARRAY['Initiate with lats', 'Keep core tight', 'No swinging'],
 ARRAY['lats', 'latissimus dorsi'], ARRAY['biceps', 'rhomboids', 'rear deltoids'],
 'intermediate', 'pull', 'strength',
 'https://v2.exercisedb.io/image/0QsN0k1S7KMrJv', 'https://v2.exercisedb.io/image/0QsN0k1S7KMrJv', true),

('e0000002-0000-0000-0000-000000000003', 'Lat Pulldown', 'lat-pulldown',
 'Machine version of pull-ups. Great for building lat strength and width.',
 ARRAY['Grip bar wider than shoulders', 'Pull bar to upper chest', 'Squeeze lats at bottom', 'Control return'],
 ARRAY['Slight lean back okay', 'Drive elbows down and back', 'Full stretch at top'],
 ARRAY['lats', 'latissimus dorsi'], ARRAY['biceps', 'rhomboids'],
 'beginner', 'pull', 'strength',
 'https://v2.exercisedb.io/image/Ty2dP0gYoXFjbF', 'https://v2.exercisedb.io/image/Ty2dP0gYoXFjbF', true),

('e0000002-0000-0000-0000-000000000004', 'Seated Cable Row', 'seated-cable-row',
 'Horizontal pulling exercise. Great for middle back thickness.',
 ARRAY['Sit with feet on platform', 'Pull handle to stomach', 'Squeeze shoulder blades', 'Extend arms fully'],
 ARRAY['Keep back straight', 'Pull to belly button', 'No excessive body swing'],
 ARRAY['middle back', 'rhomboids', 'lats'], ARRAY['biceps', 'rear deltoids'],
 'beginner', 'pull', 'strength',
 'https://v2.exercisedb.io/image/1NsljpLmEEcKHW', 'https://v2.exercisedb.io/image/1NsljpLmEEcKHW', true),

-- SHOULDERS (Push)
('e0000003-0000-0000-0000-000000000001', 'Overhead Press', 'overhead-press',
 'Standing shoulder press with barbell. Builds shoulder strength and stability.',
 ARRAY['Start with bar at shoulders', 'Press straight overhead', 'Lock out at top', 'Lower under control'],
 ARRAY['Keep core braced', 'Dont lean back excessively', 'Full lockout'],
 ARRAY['shoulders', 'deltoids'], ARRAY['triceps', 'upper chest', 'core'],
 'intermediate', 'push', 'strength',
 'https://v2.exercisedb.io/image/e1AlJMtSlS54YL', 'https://v2.exercisedb.io/image/e1AlJMtSlS54YL', true),

('e0000003-0000-0000-0000-000000000002', 'Dumbbell Shoulder Press', 'dumbbell-shoulder-press',
 'Seated or standing press with dumbbells. Allows greater range of motion.',
 ARRAY['Start dumbbells at shoulders', 'Press overhead', 'Touch dumbbells at top', 'Lower with control'],
 ARRAY['Keep wrists straight', 'Elbows slightly forward', 'Control the weight'],
 ARRAY['shoulders', 'deltoids'], ARRAY['triceps', 'upper chest'],
 'beginner', 'push', 'strength',
 'https://v2.exercisedb.io/image/ov4a9c6O4KtQHu', 'https://v2.exercisedb.io/image/ov4a9c6O4KtQHu', true),

('e0000003-0000-0000-0000-000000000003', 'Lateral Raises', 'lateral-raises',
 'Isolation exercise for side deltoids. Key for shoulder width.',
 ARRAY['Hold dumbbells at sides', 'Raise arms to shoulder height', 'Slight bend in elbows', 'Lower with control'],
 ARRAY['Lead with elbows', 'Pinky higher than thumb', 'Control the negative'],
 ARRAY['shoulders', 'lateral deltoids'], ARRAY['traps'],
 'beginner', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/kJJ0G6dQSRCwJi', 'https://v2.exercisedb.io/image/kJJ0G6dQSRCwJi', true),

('e0000003-0000-0000-0000-000000000004', 'Face Pulls', 'face-pulls',
 'Cable exercise for rear deltoids and upper back health.',
 ARRAY['Set cable at face height', 'Pull rope to face', 'Externally rotate at end', 'Squeeze rear delts'],
 ARRAY['Pull apart at face', 'Thumbs back at finish', 'Great for shoulder health'],
 ARRAY['rear deltoids', 'rhomboids'], ARRAY['traps', 'rotator cuff'],
 'beginner', 'pull', 'strength',
 'https://v2.exercisedb.io/image/3rPCHK4OMuE-Ng', 'https://v2.exercisedb.io/image/3rPCHK4OMuE-Ng', true),

-- LEGS - QUADS (Squat)
('e0000004-0000-0000-0000-000000000001', 'Barbell Back Squat', 'barbell-back-squat',
 'The king of leg exercises. Squat with a barbell on your upper back.',
 ARRAY['Bar on upper back, not neck', 'Feet shoulder width apart', 'Squat to parallel or below', 'Drive up through heels'],
 ARRAY['Knees track over toes', 'Keep chest up', 'Brace core hard'],
 ARRAY['quadriceps', 'glutes'], ARRAY['hamstrings', 'core', 'lower back'],
 'intermediate', 'squat', 'strength',
 'https://v2.exercisedb.io/image/mGrw5r8m6nKc5Z', 'https://v2.exercisedb.io/image/mGrw5r8m6nKc5Z', true),

('e0000004-0000-0000-0000-000000000002', 'Goblet Squat', 'goblet-squat',
 'Beginner-friendly squat holding a dumbbell or kettlebell at chest.',
 ARRAY['Hold weight at chest', 'Feet shoulder width', 'Squat between legs', 'Elbows inside knees'],
 ARRAY['Keep torso upright', 'Push knees out', 'Great for learning squat'],
 ARRAY['quadriceps', 'glutes'], ARRAY['core', 'upper back'],
 'beginner', 'squat', 'strength',
 'https://v2.exercisedb.io/image/O3k6h1rXG7FKRL', 'https://v2.exercisedb.io/image/O3k6h1rXG7FKRL', true),

('e0000004-0000-0000-0000-000000000003', 'Leg Press', 'leg-press',
 'Machine exercise for quads and glutes. Allows heavy loading.',
 ARRAY['Feet shoulder width on platform', 'Lower weight under control', 'Press through whole foot', 'Dont lock knees completely'],
 ARRAY['Keep lower back on pad', 'Full range of motion', 'Control the eccentric'],
 ARRAY['quadriceps', 'glutes'], ARRAY['hamstrings'],
 'beginner', 'squat', 'strength',
 'https://v2.exercisedb.io/image/pwJySxJMRqVKN8', 'https://v2.exercisedb.io/image/pwJySxJMRqVKN8', true),

('e0000004-0000-0000-0000-000000000004', 'Walking Lunges', 'walking-lunges',
 'Dynamic lunge variation. Great for balance and single-leg strength.',
 ARRAY['Step forward into lunge', 'Both knees at 90 degrees', 'Push off front foot', 'Alternate legs while walking'],
 ARRAY['Keep torso upright', 'Front knee over ankle', 'Control each step'],
 ARRAY['quadriceps', 'glutes'], ARRAY['hamstrings', 'core'],
 'beginner', 'squat', 'strength',
 'https://v2.exercisedb.io/image/Mq5JPsjlsjYYzw', 'https://v2.exercisedb.io/image/Mq5JPsjlsjYYzw', true),

-- LEGS - HAMSTRINGS (Hinge)
('e0000005-0000-0000-0000-000000000001', 'Romanian Deadlift', 'romanian-deadlift',
 'Hip hinge movement targeting hamstrings and glutes.',
 ARRAY['Stand with bar at hips', 'Push hips back, slight knee bend', 'Lower bar along legs', 'Feel hamstring stretch'],
 ARRAY['Keep bar close to legs', 'Back flat throughout', 'Hinge, dont squat'],
 ARRAY['hamstrings', 'glutes'], ARRAY['lower back', 'core'],
 'intermediate', 'hinge', 'strength',
 'https://v2.exercisedb.io/image/CW3R0YqE5HnR9D', 'https://v2.exercisedb.io/image/CW3R0YqE5HnR9D', true),

('e0000005-0000-0000-0000-000000000002', 'Conventional Deadlift', 'conventional-deadlift',
 'Full body pull from the floor. The ultimate strength builder.',
 ARRAY['Stand with feet hip width', 'Grip bar outside legs', 'Drive through floor', 'Lock out hips at top'],
 ARRAY['Keep bar close', 'Back flat, chest up', 'Push floor away'],
 ARRAY['hamstrings', 'glutes', 'lower back'], ARRAY['quads', 'traps', 'forearms'],
 'intermediate', 'hinge', 'strength',
 'https://v2.exercisedb.io/image/ZD1djZnDNqWoVR', 'https://v2.exercisedb.io/image/ZD1djZnDNqWoVR', true),

('e0000005-0000-0000-0000-000000000003', 'Leg Curl', 'leg-curl',
 'Isolation exercise for hamstrings. Machine-based knee flexion.',
 ARRAY['Lie face down on machine', 'Curl heels toward glutes', 'Squeeze at top', 'Lower with control'],
 ARRAY['Dont lift hips', 'Full range of motion', 'Feel hamstring contract'],
 ARRAY['hamstrings'], ARRAY['calves'],
 'beginner', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/hx5dLjjAOdGl4s', 'https://v2.exercisedb.io/image/hx5dLjjAOdGl4s', true),

('e0000005-0000-0000-0000-000000000004', 'Good Mornings', 'good-mornings',
 'Hip hinge with bar on back. Targets hamstrings and lower back.',
 ARRAY['Bar on upper back', 'Slight knee bend', 'Hinge at hips', 'Return to standing'],
 ARRAY['Keep back flat', 'Feel hamstring stretch', 'Dont round lower back'],
 ARRAY['hamstrings', 'lower back'], ARRAY['glutes'],
 'intermediate', 'hinge', 'strength',
 'https://v2.exercisedb.io/image/zClqI4N3sWjTvP', 'https://v2.exercisedb.io/image/zClqI4N3sWjTvP', true),

-- ARMS - BICEPS (Isolation)
('e0000006-0000-0000-0000-000000000001', 'Barbell Curl', 'barbell-curl',
 'Classic bicep builder. Curl a barbell from full extension.',
 ARRAY['Stand with bar at thighs', 'Curl bar to shoulders', 'Keep elbows at sides', 'Lower with control'],
 ARRAY['No body swing', 'Squeeze at top', 'Full extension at bottom'],
 ARRAY['biceps'], ARRAY['forearms'],
 'beginner', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/2gyftUQh9qVXS-', 'https://v2.exercisedb.io/image/2gyftUQh9qVXS-', true),

('e0000006-0000-0000-0000-000000000002', 'Hammer Curls', 'hammer-curls',
 'Neutral grip dumbbell curls. Targets brachialis and forearms.',
 ARRAY['Hold dumbbells with neutral grip', 'Curl without rotating wrists', 'Keep elbows at sides', 'Lower with control'],
 ARRAY['Palms face each other', 'No swinging', 'Great for forearm development'],
 ARRAY['biceps', 'brachialis'], ARRAY['forearms'],
 'beginner', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/nQxE0NwJWJzq0l', 'https://v2.exercisedb.io/image/nQxE0NwJWJzq0l', true),

('e0000006-0000-0000-0000-000000000003', 'Incline Dumbbell Curls', 'incline-dumbbell-curls',
 'Curls on an incline bench. Stretches bicep for greater activation.',
 ARRAY['Set bench to 45 degrees', 'Let arms hang straight down', 'Curl up, keeping upper arm still', 'Feel stretch at bottom'],
 ARRAY['Dont swing', 'Full stretch', 'Great bicep peak builder'],
 ARRAY['biceps'], ARRAY['forearms'],
 'intermediate', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/kWcjJ0A1qf2xYZ', 'https://v2.exercisedb.io/image/kWcjJ0A1qf2xYZ', true),

-- ARMS - TRICEPS (Isolation)
('e0000007-0000-0000-0000-000000000001', 'Tricep Pushdowns', 'tricep-pushdowns',
 'Cable exercise for triceps. Push rope or bar down to full extension.',
 ARRAY['Grip bar or rope', 'Keep elbows at sides', 'Push down to full extension', 'Squeeze triceps at bottom'],
 ARRAY['Dont let elbows flare', 'Control the weight', 'Feel tricep stretch at top'],
 ARRAY['triceps'], ARRAY[],
 'beginner', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/qvZKLo9ysDl4fj', 'https://v2.exercisedb.io/image/qvZKLo9ysDl4fj', true),

('e0000007-0000-0000-0000-000000000002', 'Overhead Tricep Extension', 'overhead-tricep-extension',
 'Stretch-focused tricep exercise. Great for the long head.',
 ARRAY['Hold dumbbell overhead with both hands', 'Lower behind head', 'Extend back to start', 'Keep elbows pointed up'],
 ARRAY['Keep elbows in', 'Feel deep stretch', 'Control the movement'],
 ARRAY['triceps'], ARRAY[],
 'beginner', 'isolation', 'strength',
 'https://v2.exercisedb.io/image/mVQ0d8tTY5P-aB', 'https://v2.exercisedb.io/image/mVQ0d8tTY5P-aB', true),

('e0000007-0000-0000-0000-000000000003', 'Dips', 'dips',
 'Compound exercise for triceps and chest. Bodyweight or weighted.',
 ARRAY['Grip parallel bars', 'Lower until elbows at 90 degrees', 'Push back up to lockout', 'Lean forward for chest, upright for triceps'],
 ARRAY['Keep shoulders down', 'Control the descent', 'Dont go too deep'],
 ARRAY['triceps', 'chest'], ARRAY['shoulders'],
 'intermediate', 'push', 'strength',
 'https://v2.exercisedb.io/image/8SYdcSH3j7CnTl', 'https://v2.exercisedb.io/image/8SYdcSH3j7CnTl', true),

('e0000007-0000-0000-0000-000000000004', 'Close-Grip Bench Press', 'close-grip-bench-press',
 'Bench press with narrow grip. Heavy tricep compound movement.',
 ARRAY['Grip bar shoulder width or narrower', 'Lower bar to lower chest', 'Press up keeping elbows close', 'Lock out at top'],
 ARRAY['Dont go too narrow', 'Keep wrists straight', 'Great tricep builder'],
 ARRAY['triceps'], ARRAY['chest', 'shoulders'],
 'intermediate', 'push', 'strength',
 'https://v2.exercisedb.io/image/xV-gTmQjCG2vYn', 'https://v2.exercisedb.io/image/xV-gTmQjCG2vYn', true),

-- CORE
('e0000008-0000-0000-0000-000000000001', 'Plank', 'plank',
 'Isometric core exercise. Hold a straight body position on elbows and toes.',
 ARRAY['Rest on forearms and toes', 'Keep body in straight line', 'Brace abs tight', 'Hold for time'],
 ARRAY['Dont let hips sag', 'Squeeze glutes', 'Breathe normally'],
 ARRAY['core', 'abs'], ARRAY['shoulders', 'lower back'],
 'beginner', 'core', 'strength',
 'https://v2.exercisedb.io/image/hCELfT5nLXM2vR', 'https://v2.exercisedb.io/image/hCELfT5nLXM2vR', true),

('e0000008-0000-0000-0000-000000000002', 'Cable Woodchops', 'cable-woodchops',
 'Rotational core exercise. Pull cable diagonally across body.',
 ARRAY['Set cable high or low', 'Rotate torso while pulling', 'Control the movement', 'Return with control'],
 ARRAY['Rotate from core', 'Keep arms straight', 'Exhale on exertion'],
 ARRAY['obliques', 'core'], ARRAY['shoulders'],
 'intermediate', 'core', 'strength',
 'https://v2.exercisedb.io/image/LQ4iZYO6bCp8nT', 'https://v2.exercisedb.io/image/LQ4iZYO6bCp8nT', true),

('e0000008-0000-0000-0000-000000000003', 'Dead Bug', 'dead-bug',
 'Anti-extension core exercise. Lie on back and extend opposite limbs.',
 ARRAY['Lie on back, arms up', 'Extend opposite arm and leg', 'Keep lower back pressed down', 'Alternate sides'],
 ARRAY['No lower back arch', 'Move slowly', 'Great for core stability'],
 ARRAY['core', 'abs'], ARRAY['hip flexors'],
 'beginner', 'core', 'strength',
 'https://v2.exercisedb.io/image/Tk8eTvgpJ7CSRW', 'https://v2.exercisedb.io/image/Tk8eTvgpJ7CSRW', true),

('e0000008-0000-0000-0000-000000000004', 'Hanging Leg Raises', 'hanging-leg-raises',
 'Advanced core exercise. Hang from bar and raise legs.',
 ARRAY['Hang from pull-up bar', 'Raise legs to parallel or higher', 'Lower with control', 'Avoid swinging'],
 ARRAY['Keep legs straight if possible', 'Use core, not momentum', 'Great for lower abs'],
 ARRAY['abs', 'hip flexors'], ARRAY['forearms'],
 'advanced', 'core', 'strength',
 'https://v2.exercisedb.io/image/lK5iVw0n1gYBpC', 'https://v2.exercisedb.io/image/lK5iVw0n1gYBpC', true);

-- ============================================
-- CREATE SAMPLE PROGRAMS
-- ============================================

INSERT INTO programs (id, name, slug, description, short_description, thumbnail_url, duration_weeks, days_per_week, difficulty, focus_areas, goals, is_published) VALUES
('p0000001-0000-0000-0000-000000000001', 'Foundation Strength', 'foundation-strength', 
 'Build a solid strength foundation with this 8-week program focusing on compound movements and progressive overload. Perfect for beginners ready to get serious about strength training.',
 'Build foundational strength with proper movement patterns',
 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
 8, 4, 'beginner', ARRAY['full body', 'strength'], ARRAY['build_strength', 'functional_movement'], true),

('p0000001-0000-0000-0000-000000000002', 'Hypertrophy Max', 'hypertrophy-max',
 'Maximize muscle growth with this science-based hypertrophy program. Features periodization, optimal volume, and intensity techniques for serious gains.',
 'Build maximum muscle with scientifically-backed training',
 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=800',
 8, 5, 'intermediate', ARRAY['muscle building', 'hypertrophy'], ARRAY['build_muscle', 'build_strength'], true),

('p0000001-0000-0000-0000-000000000003', 'Functional Athlete', 'functional-athlete',
 'Train like an athlete with this functional strength program. Combines strength, power, and mobility for real-world performance.',
 'Athletic performance through functional training',
 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=800',
 6, 4, 'intermediate', ARRAY['functional', 'athletic'], ARRAY['athletic_performance', 'functional_movement'], true);

-- Create program weeks
INSERT INTO program_weeks (id, program_id, week_number, name, description) VALUES
('w0000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000001', 1, 'Week 1 - Foundation', 'Learning the movement patterns'),
('w0000001-0000-0000-0000-000000000002', 'p0000001-0000-0000-0000-000000000001', 2, 'Week 2 - Building', 'Increasing intensity'),
('w0000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000002', 1, 'Week 1 - Volume Phase', 'High volume accumulation'),
('w0000001-0000-0000-0000-000000000004', 'p0000001-0000-0000-0000-000000000003', 1, 'Week 1 - Athletic Base', 'Building athletic foundation');

-- ============================================
-- CREATE SAMPLE WORKOUTS WITH FULL STRUCTURE
-- ============================================

-- FOUNDATION STRENGTH - PUSH DAY
INSERT INTO workouts (id, program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes) VALUES
('wo000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000001', 'w0000001-0000-0000-0000-000000000001', 
 'Push Day', 'Chest, shoulders, and triceps focused workout', 'mon', 1, 45);

INSERT INTO workout_sections (id, workout_id, name, section_type, order_index) VALUES
('ws000001-0000-0000-0000-000000000001', 'wo000001-0000-0000-0000-000000000001', 'Main Training', 'training', 0);

INSERT INTO workout_exercises (id, section_id, exercise_id, order_index, sets, reps, rest_seconds) VALUES
('we000001-0000-0000-0000-000000000001', 'ws000001-0000-0000-0000-000000000001', 'e0000001-0000-0000-0000-000000000001', 0, 4, 8, 120),
('we000001-0000-0000-0000-000000000002', 'ws000001-0000-0000-0000-000000000001', 'e0000003-0000-0000-0000-000000000001', 1, 3, 10, 90),
('we000001-0000-0000-0000-000000000003', 'ws000001-0000-0000-0000-000000000001', 'e0000001-0000-0000-0000-000000000002', 2, 3, 12, 90),
('we000001-0000-0000-0000-000000000004', 'ws000001-0000-0000-0000-000000000001', 'e0000003-0000-0000-0000-000000000003', 3, 3, 15, 60),
('we000001-0000-0000-0000-000000000005', 'ws000001-0000-0000-0000-000000000001', 'e0000007-0000-0000-0000-000000000001', 4, 3, 15, 60);

-- FOUNDATION STRENGTH - PULL DAY
INSERT INTO workouts (id, program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes) VALUES
('wo000001-0000-0000-0000-000000000002', 'p0000001-0000-0000-0000-000000000001', 'w0000001-0000-0000-0000-000000000001',
 'Pull Day', 'Back and biceps focused workout', 'tue', 2, 45);

INSERT INTO workout_sections (id, workout_id, name, section_type, order_index) VALUES
('ws000001-0000-0000-0000-000000000002', 'wo000001-0000-0000-0000-000000000002', 'Main Training', 'training', 0);

INSERT INTO workout_exercises (id, section_id, exercise_id, order_index, sets, reps, rest_seconds) VALUES
('we000002-0000-0000-0000-000000000001', 'ws000001-0000-0000-0000-000000000002', 'e0000002-0000-0000-0000-000000000001', 0, 4, 8, 120),
('we000002-0000-0000-0000-000000000002', 'ws000001-0000-0000-0000-000000000002', 'e0000002-0000-0000-0000-000000000003', 1, 3, 10, 90),
('we000002-0000-0000-0000-000000000003', 'ws000001-0000-0000-0000-000000000002', 'e0000002-0000-0000-0000-000000000004', 2, 3, 12, 90),
('we000002-0000-0000-0000-000000000004', 'ws000001-0000-0000-0000-000000000002', 'e0000003-0000-0000-0000-000000000004', 3, 3, 15, 60),
('we000002-0000-0000-0000-000000000005', 'ws000001-0000-0000-0000-000000000002', 'e0000006-0000-0000-0000-000000000001', 4, 3, 12, 60);

-- FOUNDATION STRENGTH - LEG DAY
INSERT INTO workouts (id, program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes) VALUES
('wo000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000001', 'w0000001-0000-0000-0000-000000000001',
 'Leg Day', 'Quads, hamstrings, and glutes', 'thu', 3, 50);

INSERT INTO workout_sections (id, workout_id, name, section_type, order_index) VALUES
('ws000001-0000-0000-0000-000000000003', 'wo000001-0000-0000-0000-000000000003', 'Main Training', 'training', 0);

INSERT INTO workout_exercises (id, section_id, exercise_id, order_index, sets, reps, rest_seconds) VALUES
('we000003-0000-0000-0000-000000000001', 'ws000001-0000-0000-0000-000000000003', 'e0000004-0000-0000-0000-000000000001', 0, 4, 6, 180),
('we000003-0000-0000-0000-000000000002', 'ws000001-0000-0000-0000-000000000003', 'e0000005-0000-0000-0000-000000000001', 1, 3, 10, 120),
('we000003-0000-0000-0000-000000000003', 'ws000001-0000-0000-0000-000000000003', 'e0000004-0000-0000-0000-000000000003', 2, 3, 12, 90),
('we000003-0000-0000-0000-000000000004', 'ws000001-0000-0000-0000-000000000003', 'e0000005-0000-0000-0000-000000000003', 3, 3, 15, 60),
('we000003-0000-0000-0000-000000000005', 'ws000001-0000-0000-0000-000000000003', 'e0000004-0000-0000-0000-000000000004', 4, 3, 10, 60);

-- FOUNDATION STRENGTH - FULL BODY
INSERT INTO workouts (id, program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes) VALUES
('wo000001-0000-0000-0000-000000000004', 'p0000001-0000-0000-0000-000000000001', 'w0000001-0000-0000-0000-000000000001',
 'Full Body', 'Complete full body strength session', 'sat', 4, 55);

INSERT INTO workout_sections (id, workout_id, name, section_type, order_index) VALUES
('ws000001-0000-0000-0000-000000000004', 'wo000001-0000-0000-0000-000000000004', 'Main Training', 'training', 0);

INSERT INTO workout_exercises (id, section_id, exercise_id, order_index, sets, reps, rest_seconds) VALUES
('we000004-0000-0000-0000-000000000001', 'ws000001-0000-0000-0000-000000000004', 'e0000005-0000-0000-0000-000000000002', 0, 4, 5, 180),
('we000004-0000-0000-0000-000000000002', 'ws000001-0000-0000-0000-000000000004', 'e0000001-0000-0000-0000-000000000001', 1, 3, 8, 120),
('we000004-0000-0000-0000-000000000003', 'ws000001-0000-0000-0000-000000000004', 'e0000002-0000-0000-0000-000000000001', 2, 3, 8, 120),
('we000004-0000-0000-0000-000000000004', 'ws000001-0000-0000-0000-000000000004', 'e0000003-0000-0000-0000-000000000002', 3, 3, 10, 90),
('we000004-0000-0000-0000-000000000005', 'ws000001-0000-0000-0000-000000000004', 'e0000008-0000-0000-0000-000000000001', 4, 3, 45, 60);

-- Update RLS for new tables
DROP POLICY IF EXISTS "Public exercises are viewable by everyone" ON exercises;
CREATE POLICY "Public exercises are viewable by everyone" ON exercises FOR SELECT USING (is_published = true);

-- Allow NULL workout_id for quick/demo workouts
DO $$ 
BEGIN
    ALTER TABLE workout_logs ALTER COLUMN workout_id DROP NOT NULL;
EXCEPTION WHEN OTHERS THEN
    NULL; -- Ignore if already nullable
END $$;

-- ============================================
-- RLS POLICIES FOR ENROLLMENT
-- ============================================

-- Enable RLS on user_program_enrollments if not already
ALTER TABLE user_program_enrollments ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to recreate them cleanly
DROP POLICY IF EXISTS "Users can view own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can insert own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can update own enrollments" ON user_program_enrollments;
DROP POLICY IF EXISTS "Users can delete own enrollments" ON user_program_enrollments;

-- Users can view their own enrollments
CREATE POLICY "Users can view own enrollments" 
ON user_program_enrollments FOR SELECT 
USING (auth.uid() = user_id);

-- Users can create their own enrollments
CREATE POLICY "Users can insert own enrollments" 
ON user_program_enrollments FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Users can update their own enrollments
CREATE POLICY "Users can update own enrollments" 
ON user_program_enrollments FOR UPDATE 
USING (auth.uid() = user_id);

-- Users can delete their own enrollments
CREATE POLICY "Users can delete own enrollments" 
ON user_program_enrollments FOR DELETE 
USING (auth.uid() = user_id);

-- ============================================
-- RLS POLICIES FOR WORKOUT LOGS
-- ============================================

ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own workout logs" ON workout_logs;
DROP POLICY IF EXISTS "Users can insert own workout logs" ON workout_logs;
DROP POLICY IF EXISTS "Users can update own workout logs" ON workout_logs;

CREATE POLICY "Users can view own workout logs" 
ON workout_logs FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workout logs" 
ON workout_logs FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workout logs" 
ON workout_logs FOR UPDATE 
USING (auth.uid() = user_id);

-- ============================================
-- RLS POLICIES FOR EXERCISE LOGS
-- ============================================

ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can manage exercise logs via workout_log" ON exercise_logs;
DROP POLICY IF EXISTS "Users can view own exercise logs" ON exercise_logs;
DROP POLICY IF EXISTS "Users can insert own exercise logs" ON exercise_logs;

-- Allow insert/select if user owns the parent workout_log
CREATE POLICY "Users can view own exercise logs" 
ON exercise_logs FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM workout_logs 
    WHERE workout_logs.id = exercise_logs.workout_log_id 
    AND workout_logs.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert own exercise logs" 
ON exercise_logs FOR INSERT 
WITH CHECK (
  EXISTS (
    SELECT 1 FROM workout_logs 
    WHERE workout_logs.id = exercise_logs.workout_log_id 
    AND workout_logs.user_id = auth.uid()
  )
);

-- ============================================
-- RLS POLICIES FOR SET LOGS
-- ============================================

ALTER TABLE set_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own set logs" ON set_logs;
DROP POLICY IF EXISTS "Users can insert own set logs" ON set_logs;

CREATE POLICY "Users can view own set logs" 
ON set_logs FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM exercise_logs 
    JOIN workout_logs ON workout_logs.id = exercise_logs.workout_log_id
    WHERE exercise_logs.id = set_logs.exercise_log_id 
    AND workout_logs.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert own set logs" 
ON set_logs FOR INSERT 
WITH CHECK (
  EXISTS (
    SELECT 1 FROM exercise_logs 
    JOIN workout_logs ON workout_logs.id = exercise_logs.workout_log_id
    WHERE exercise_logs.id = set_logs.exercise_log_id 
    AND workout_logs.user_id = auth.uid()
  )
);

-- ============================================
-- PUBLIC READ POLICIES
-- ============================================

-- Programs are public
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Programs are viewable by everyone" ON programs;
CREATE POLICY "Programs are viewable by everyone" 
ON programs FOR SELECT 
USING (is_published = true);

-- Workouts are public (through programs)
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Workouts are viewable by everyone" ON workouts;
CREATE POLICY "Workouts are viewable by everyone" 
ON workouts FOR SELECT 
USING (true);

-- Workout sections are public
ALTER TABLE workout_sections ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Workout sections are viewable by everyone" ON workout_sections;
CREATE POLICY "Workout sections are viewable by everyone" 
ON workout_sections FOR SELECT 
USING (true);

-- Workout exercises are public
ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Workout exercises are viewable by everyone" ON workout_exercises;
CREATE POLICY "Workout exercises are viewable by everyone" 
ON workout_exercises FOR SELECT 
USING (true);

-- Program weeks are public
ALTER TABLE program_weeks ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Program weeks are viewable by everyone" ON program_weeks;
CREATE POLICY "Program weeks are viewable by everyone" 
ON program_weeks FOR SELECT 
USING (true);

COMMIT;

