-- ============================================
-- INTELLIGENT EXERCISE LIBRARY
-- Comprehensive exercises with full metadata for filtering
-- Each exercise includes: equipment, location, muscle groups, movement pattern
-- ============================================

-- First, add location_tags column if it doesn't exist
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS location_tags TEXT[] DEFAULT ARRAY[]::TEXT[];

-- ============================================
-- EQUIPMENT CATALOG
-- Standard equipment users can select
-- ============================================
TRUNCATE TABLE user_equipment CASCADE;
TRUNCATE TABLE equipment CASCADE;

INSERT INTO equipment (id, name, category, description, is_common) VALUES
-- Bars and Weights
('eq000001-0000-0000-0000-000000000001', 'barbell', 'bars_weights', 'Standard Olympic or standard barbell', true),
('eq000002-0000-0000-0000-000000000001', 'dumbbell', 'bars_weights', 'Pair of dumbbells (any weight)', true),
('eq000003-0000-0000-0000-000000000001', 'kettlebell', 'bars_weights', 'Russian kettlebell (any weight)', true),
('eq000004-0000-0000-0000-000000000001', 'ez-bar', 'bars_weights', 'EZ curl bar for bicep exercises', true),
('eq000005-0000-0000-0000-000000000001', 'trap-bar', 'bars_weights', 'Hex/trap bar for deadlifts', false),
-- Benches and Racks
('eq000006-0000-0000-0000-000000000001', 'bench', 'benches', 'Flat or adjustable weight bench', true),
('eq000007-0000-0000-0000-000000000001', 'squat-rack', 'benches', 'Squat rack or power cage', true),
-- Machines
('eq000008-0000-0000-0000-000000000001', 'cable', 'machines', 'Cable machine or pulley system', true),
('eq000009-0000-0000-0000-000000000001', 'machine', 'machines', 'General weight machines', true),
-- Accessories
('eq000010-0000-0000-0000-000000000001', 'pull-up bar', 'accessories', 'Pull-up bar (doorway or mounted)', true),
('eq000011-0000-0000-0000-000000000001', 'dip-station', 'accessories', 'Dip bars or parallettes', false),
('eq000012-0000-0000-0000-000000000001', 'resistance_band', 'accessories', 'Resistance bands', true),
('eq000013-0000-0000-0000-000000000001', 'ab-wheel', 'accessories', 'Ab roller wheel', false),
('eq000014-0000-0000-0000-000000000001', 'plyo-box', 'accessories', 'Plyometric box for jumps', false),
-- Bodyweight (always available)
('eq000015-0000-0000-0000-000000000001', 'bodyweight', 'none', 'No equipment needed', true);

-- Clear existing exercises to repopulate with complete metadata
TRUNCATE TABLE workout_exercises CASCADE;
TRUNCATE TABLE exercises CASCADE;

-- ============================================
-- CHEST EXERCISES (Push Pattern)
-- ============================================
INSERT INTO exercises (id, name, slug, description, equipment_required, primary_muscles, secondary_muscles, movement_pattern, difficulty, video_url, location_tags, is_published, created_at) VALUES
-- Barbell exercises
('e1000001-0000-0000-0000-000000000001', 'Barbell Bench Press', 'barbell-bench-press', 
 'The king of chest exercises. Lie on a flat bench and press the barbell from chest to lockout.',
 ARRAY['barbell', 'bench'], ARRAY['chest'], ARRAY['triceps', 'shoulders'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif',
 ARRAY['gym'], true, NOW()),

('e1000002-0000-0000-0000-000000000001', 'Incline Barbell Press', 'incline-barbell-press',
 'Targets upper chest. Set bench to 30-45 degree incline.',
 ARRAY['barbell', 'bench'], ARRAY['chest'], ARRAY['shoulders', 'triceps'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/incline-barbell-bench-press.gif',
 ARRAY['gym'], true, NOW()),

-- Dumbbell exercises
('e1000003-0000-0000-0000-000000000001', 'Dumbbell Bench Press', 'dumbbell-bench-press',
 'Greater range of motion than barbell. Each arm works independently.',
 ARRAY['dumbbell', 'bench'], ARRAY['chest'], ARRAY['triceps', 'shoulders'], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/dumbbell-bench-press.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e1000004-0000-0000-0000-000000000001', 'Incline Dumbbell Press', 'incline-dumbbell-press',
 'Excellent for upper chest development with full range of motion.',
 ARRAY['dumbbell', 'bench'], ARRAY['chest'], ARRAY['shoulders', 'triceps'], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-press.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e1000005-0000-0000-0000-000000000001', 'Dumbbell Chest Fly', 'dumbbell-chest-fly',
 'Isolation exercise for chest. Keep slight bend in elbows throughout.',
 ARRAY['dumbbell', 'bench'], ARRAY['chest'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-chest-fly.gif',
 ARRAY['gym', 'home'], true, NOW()),

-- Bodyweight exercises
('e1000006-0000-0000-0000-000000000001', 'Push-Up', 'push-up',
 'Classic bodyweight chest exercise. Keep core tight, lower chest to floor.',
 ARRAY['bodyweight'], ARRAY['chest'], ARRAY['triceps', 'shoulders', 'core'], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e1000007-0000-0000-0000-000000000001', 'Diamond Push-Up', 'diamond-push-up',
 'Hands form a diamond shape. Emphasizes triceps and inner chest.',
 ARRAY['bodyweight'], ARRAY['chest', 'triceps'], ARRAY['shoulders'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/diamond-push-up.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e1000008-0000-0000-0000-000000000001', 'Decline Push-Up', 'decline-push-up',
 'Feet elevated on bench or step. Targets upper chest.',
 ARRAY['bodyweight'], ARRAY['chest'], ARRAY['shoulders', 'triceps'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
 ARRAY['gym', 'home'], true, NOW()),

-- Cable/Machine exercises
('e1000009-0000-0000-0000-000000000001', 'Cable Fly', 'cable-fly',
 'Constant tension throughout the movement. Great for chest isolation.',
 ARRAY['cable'], ARRAY['chest'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-cable-fly.gif',
 ARRAY['gym'], true, NOW()),

('e1000010-0000-0000-0000-000000000001', 'Chest Dips', 'chest-dips',
 'Lean forward to emphasize chest. Excellent compound movement.',
 ARRAY['bodyweight', 'dip-station'], ARRAY['chest'], ARRAY['triceps', 'shoulders'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/chest-dips.gif',
 ARRAY['gym', 'home'], true, NOW()),

-- ============================================
-- BACK EXERCISES (Pull Pattern)
-- ============================================
('e2000001-0000-0000-0000-000000000001', 'Barbell Bent Over Row', 'barbell-bent-over-row',
 'Hinge at hips, pull bar to lower chest. Keep back flat.',
 ARRAY['barbell'], ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif',
 ARRAY['gym'], true, NOW()),

('e2000002-0000-0000-0000-000000000001', 'Pull-Up', 'pull-up',
 'King of back exercises. Pull chin over bar with wide grip.',
 ARRAY['bodyweight', 'pull-up bar'], ARRAY['back'], ARRAY['biceps'], 'pull', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e2000003-0000-0000-0000-000000000001', 'Chin-Up', 'chin-up',
 'Underhand grip pull-up. More biceps involvement.',
 ARRAY['bodyweight', 'pull-up bar'], ARRAY['back', 'biceps'], ARRAY[]::TEXT[], 'pull', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/chin-up.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e2000004-0000-0000-0000-000000000001', 'Dumbbell Row', 'dumbbell-row',
 'Single-arm row on bench. Great for lat development.',
 ARRAY['dumbbell', 'bench'], ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/single-arm-dumbbell-row.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e2000005-0000-0000-0000-000000000001', 'Lat Pulldown', 'lat-pulldown',
 'Cable machine exercise. Pull bar to upper chest.',
 ARRAY['cable', 'machine'], ARRAY['back'], ARRAY['biceps'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/lat-pulldown.gif',
 ARRAY['gym'], true, NOW()),

('e2000006-0000-0000-0000-000000000001', 'Seated Cable Row', 'seated-cable-row',
 'Pull handle to lower chest. Keep back straight.',
 ARRAY['cable', 'machine'], ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
 ARRAY['gym'], true, NOW()),

('e2000007-0000-0000-0000-000000000001', 'T-Bar Row', 't-bar-row',
 'Barbell landmine row. Great for middle back thickness.',
 ARRAY['barbell'], ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/t-bar-row.gif',
 ARRAY['gym'], true, NOW()),

('e2000008-0000-0000-0000-000000000001', 'Inverted Row', 'inverted-row',
 'Bodyweight row using low bar or rings. Scalable by foot position.',
 ARRAY['bodyweight'], ARRAY['back'], ARRAY['biceps', 'rear_delts'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2023/03/inverted-row.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e2000009-0000-0000-0000-000000000001', 'Face Pull', 'face-pull',
 'Cable exercise for rear delts and upper back. Essential for shoulder health.',
 ARRAY['cable'], ARRAY['rear_delts', 'back'], ARRAY['rotator_cuff'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/face-pull.gif',
 ARRAY['gym'], true, NOW()),

-- ============================================
-- SHOULDER EXERCISES (Push/Rotation)
-- ============================================
('e3000001-0000-0000-0000-000000000001', 'Barbell Overhead Press', 'barbell-overhead-press',
 'The king of shoulder exercises. Press bar from shoulders to overhead.',
 ARRAY['barbell'], ARRAY['shoulders'], ARRAY['triceps', 'core'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
 ARRAY['gym'], true, NOW()),

('e3000002-0000-0000-0000-000000000001', 'Dumbbell Shoulder Press', 'dumbbell-shoulder-press',
 'Seated or standing dumbbell press. Full range of motion.',
 ARRAY['dumbbell'], ARRAY['shoulders'], ARRAY['triceps'], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shoulder-press.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e3000003-0000-0000-0000-000000000001', 'Arnold Press', 'arnold-press',
 'Rotating dumbbell press. Hits all three delt heads.',
 ARRAY['dumbbell'], ARRAY['shoulders'], ARRAY['triceps'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/arnold-press.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e3000004-0000-0000-0000-000000000001', 'Lateral Raise', 'lateral-raise',
 'Isolation for side delts. Lift dumbbells out to sides.',
 ARRAY['dumbbell'], ARRAY['shoulders'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e3000005-0000-0000-0000-000000000001', 'Front Raise', 'front-raise',
 'Lift dumbbells to front. Targets front delts.',
 ARRAY['dumbbell'], ARRAY['shoulders'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-front-raise.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e3000006-0000-0000-0000-000000000001', 'Rear Delt Fly', 'rear-delt-fly',
 'Bent over dumbbell fly. Essential for balanced shoulders.',
 ARRAY['dumbbell'], ARRAY['rear_delts', 'shoulders'], ARRAY['back'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/dumbbell-rear-delt-fly.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e3000007-0000-0000-0000-000000000001', 'Pike Push-Up', 'pike-push-up',
 'Bodyweight shoulder press alternative. Hips high, press head toward floor.',
 ARRAY['bodyweight'], ARRAY['shoulders'], ARRAY['triceps'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e3000008-0000-0000-0000-000000000001', 'Landmine Press', 'landmine-press',
 'Angled press using barbell in corner. Shoulder-friendly pressing.',
 ARRAY['barbell'], ARRAY['shoulders'], ARRAY['chest', 'triceps'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/landmine-press.gif',
 ARRAY['gym'], true, NOW()),

-- ============================================
-- LEG EXERCISES - QUADS (Squat Pattern)
-- ============================================
('e4000001-0000-0000-0000-000000000001', 'Barbell Back Squat', 'barbell-back-squat',
 'The king of leg exercises. Bar on upper back, squat to depth.',
 ARRAY['barbell', 'squat-rack'], ARRAY['quads', 'glutes'], ARRAY['hamstrings', 'core'], 'squat', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
 ARRAY['gym'], true, NOW()),

('e4000002-0000-0000-0000-000000000001', 'Front Squat', 'front-squat',
 'Bar on front shoulders. More quad dominant than back squat.',
 ARRAY['barbell', 'squat-rack'], ARRAY['quads'], ARRAY['core', 'glutes'], 'squat', 'advanced',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/front-squat-form.gif',
 ARRAY['gym'], true, NOW()),

('e4000003-0000-0000-0000-000000000001', 'Goblet Squat', 'goblet-squat',
 'Hold dumbbell or kettlebell at chest. Great for beginners.',
 ARRAY['dumbbell', 'kettlebell'], ARRAY['quads', 'glutes'], ARRAY['core'], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/goblet-squat.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e4000004-0000-0000-0000-000000000001', 'Leg Press', 'leg-press',
 'Machine exercise. Push weight away with legs.',
 ARRAY['machine'], ARRAY['quads', 'glutes'], ARRAY['hamstrings'], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/leg-press.gif',
 ARRAY['gym'], true, NOW()),

('e4000005-0000-0000-0000-000000000001', 'Bulgarian Split Squat', 'bulgarian-split-squat',
 'Rear foot elevated. Unilateral leg exercise.',
 ARRAY['dumbbell', 'bodyweight'], ARRAY['quads', 'glutes'], ARRAY['hamstrings'], 'squat', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/bulgarian-split-squat.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e4000006-0000-0000-0000-000000000001', 'Walking Lunge', 'walking-lunge',
 'Step forward into lunge, repeat. Great for leg strength and balance.',
 ARRAY['dumbbell', 'bodyweight'], ARRAY['quads', 'glutes'], ARRAY['hamstrings'], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e4000007-0000-0000-0000-000000000001', 'Leg Extension', 'leg-extension',
 'Machine isolation for quads. Extend legs against resistance.',
 ARRAY['machine'], ARRAY['quads'], ARRAY[]::TEXT[], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/leg-extension-machine.gif',
 ARRAY['gym'], true, NOW()),

('e4000008-0000-0000-0000-000000000001', 'Bodyweight Squat', 'bodyweight-squat',
 'No equipment needed. Perfect for beginners and warm-ups.',
 ARRAY['bodyweight'], ARRAY['quads', 'glutes'], ARRAY['core'], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/goblet-squat.gif',
 ARRAY['gym', 'home'], true, NOW()),

-- ============================================
-- LEG EXERCISES - HAMSTRINGS/GLUTES (Hinge Pattern)
-- ============================================
('e5000001-0000-0000-0000-000000000001', 'Conventional Deadlift', 'conventional-deadlift',
 'The ultimate posterior chain exercise. Lift bar from floor to lockout.',
 ARRAY['barbell'], ARRAY['hamstrings', 'glutes', 'back'], ARRAY['core'], 'hinge', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-deadlift.gif',
 ARRAY['gym'], true, NOW()),

('e5000002-0000-0000-0000-000000000001', 'Romanian Deadlift', 'romanian-deadlift',
 'Hinge at hips with slight knee bend. Targets hamstrings and glutes.',
 ARRAY['barbell', 'dumbbell'], ARRAY['hamstrings', 'glutes'], ARRAY['back'], 'hinge', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-romanian-deadlift.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e5000003-0000-0000-0000-000000000001', 'Trap Bar Deadlift', 'trap-bar-deadlift',
 'Safer for lower back. Handles at sides for neutral grip.',
 ARRAY['trap-bar'], ARRAY['quads', 'hamstrings', 'glutes'], ARRAY['back'], 'hinge', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/trap-bar-deadlift.gif',
 ARRAY['gym'], true, NOW()),

('e5000004-0000-0000-0000-000000000001', 'Hip Thrust', 'hip-thrust',
 'Best glute exercise. Drive hips up with weight on lap.',
 ARRAY['barbell', 'bench'], ARRAY['glutes'], ARRAY['hamstrings'], 'hinge', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/barbell-hip-thrust.gif',
 ARRAY['gym'], true, NOW()),

('e5000005-0000-0000-0000-000000000001', 'Glute Bridge', 'glute-bridge',
 'Bodyweight hip thrust. Lie on back, drive hips up.',
 ARRAY['bodyweight'], ARRAY['glutes'], ARRAY['hamstrings'], 'hinge', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/glute-bridge.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e5000006-0000-0000-0000-000000000001', 'Lying Leg Curl', 'lying-leg-curl',
 'Machine isolation for hamstrings. Curl weight toward glutes.',
 ARRAY['machine'], ARRAY['hamstrings'], ARRAY[]::TEXT[], 'hinge', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/lying-leg-curl-machine.gif',
 ARRAY['gym'], true, NOW()),

('e5000007-0000-0000-0000-000000000001', 'Good Morning', 'good-morning',
 'Bar on back, hinge at hips. Stretch hamstrings and glutes.',
 ARRAY['barbell'], ARRAY['hamstrings', 'glutes'], ARRAY['back'], 'hinge', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/good-morning-exercise.gif',
 ARRAY['gym'], true, NOW()),

('e5000008-0000-0000-0000-000000000001', 'Kettlebell Swing', 'kettlebell-swing',
 'Explosive hip hinge. Power comes from hips, not arms.',
 ARRAY['kettlebell'], ARRAY['glutes', 'hamstrings'], ARRAY['back', 'core'], 'hinge', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/russian-kettlebell-swing.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e5000009-0000-0000-0000-000000000001', 'Cable Pull Through', 'cable-pull-through',
 'Cable hinge movement. Great for learning hip hinge pattern.',
 ARRAY['cable'], ARRAY['glutes', 'hamstrings'], ARRAY[]::TEXT[], 'hinge', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/cable-pull-through.gif',
 ARRAY['gym'], true, NOW()),

-- ============================================
-- CALVES
-- ============================================
('e5100001-0000-0000-0000-000000000001', 'Standing Calf Raise', 'standing-calf-raise',
 'Rise up on toes with weight. Targets gastrocnemius.',
 ARRAY['machine', 'dumbbell'], ARRAY['calves'], ARRAY[]::TEXT[], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-calf-raise-machine.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e5100002-0000-0000-0000-000000000001', 'Seated Calf Raise', 'seated-calf-raise',
 'Seated version. Targets soleus muscle.',
 ARRAY['machine'], ARRAY['calves'], ARRAY[]::TEXT[], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/seated-calf-raise.gif',
 ARRAY['gym'], true, NOW()),

-- ============================================
-- BICEPS
-- ============================================
('e6000001-0000-0000-0000-000000000001', 'Barbell Curl', 'barbell-curl',
 'Classic biceps exercise. Curl bar from thighs to shoulders.',
 ARRAY['barbell'], ARRAY['biceps'], ARRAY[]::TEXT[], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-curl.gif',
 ARRAY['gym'], true, NOW()),

('e6000002-0000-0000-0000-000000000001', 'Dumbbell Bicep Curl', 'dumbbell-bicep-curl',
 'Alternating or simultaneous dumbbell curls.',
 ARRAY['dumbbell'], ARRAY['biceps'], ARRAY[]::TEXT[], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-bicep-curl.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e6000003-0000-0000-0000-000000000001', 'Hammer Curl', 'hammer-curl',
 'Neutral grip curl. Hits brachialis and forearms.',
 ARRAY['dumbbell'], ARRAY['biceps'], ARRAY['forearms'], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/hammer-curl.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e6000004-0000-0000-0000-000000000001', 'Preacher Curl', 'preacher-curl',
 'Curl on angled pad. Isolates biceps, no momentum.',
 ARRAY['dumbbell', 'barbell', 'ez-bar'], ARRAY['biceps'], ARRAY[]::TEXT[], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/preacher-curl.gif',
 ARRAY['gym'], true, NOW()),

('e6000005-0000-0000-0000-000000000001', 'Cable Curl', 'cable-curl',
 'Constant tension biceps curl using cables.',
 ARRAY['cable'], ARRAY['biceps'], ARRAY[]::TEXT[], 'pull', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/cable-bicep-curl.gif',
 ARRAY['gym'], true, NOW()),

-- ============================================
-- TRICEPS
-- ============================================
('e7000001-0000-0000-0000-000000000001', 'Tricep Pushdown', 'tricep-pushdown',
 'Cable pushdown with straight bar or rope.',
 ARRAY['cable'], ARRAY['triceps'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif',
 ARRAY['gym'], true, NOW()),

('e7000002-0000-0000-0000-000000000001', 'Rope Pushdown', 'rope-pushdown',
 'Pushdown with rope attachment. Spread rope at bottom.',
 ARRAY['cable'], ARRAY['triceps'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/rope-pushdown.gif',
 ARRAY['gym'], true, NOW()),

('e7000003-0000-0000-0000-000000000001', 'Skull Crusher', 'skull-crusher',
 'Lying tricep extension. Lower weight to forehead.',
 ARRAY['barbell', 'dumbbell', 'ez-bar'], ARRAY['triceps'], ARRAY[]::TEXT[], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/skull-crusher.gif',
 ARRAY['gym'], true, NOW()),

('e7000004-0000-0000-0000-000000000001', 'Close Grip Bench Press', 'close-grip-bench-press',
 'Narrow grip bench press. Emphasizes triceps.',
 ARRAY['barbell', 'bench'], ARRAY['triceps'], ARRAY['chest', 'shoulders'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/close-grip-bench-press.gif',
 ARRAY['gym'], true, NOW()),

('e7000005-0000-0000-0000-000000000001', 'Tricep Dip', 'tricep-dip',
 'Bodyweight dip. Keep torso upright for triceps focus.',
 ARRAY['bodyweight', 'dip-station'], ARRAY['triceps'], ARRAY['chest', 'shoulders'], 'push', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e7000006-0000-0000-0000-000000000001', 'Overhead Tricep Extension', 'overhead-tricep-extension',
 'Dumbbell or cable overhead extension. Stretches long head.',
 ARRAY['dumbbell', 'cable'], ARRAY['triceps'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/cable-overhead-tricep-extension.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e7000007-0000-0000-0000-000000000001', 'Tricep Kickback', 'tricep-kickback',
 'Bent over dumbbell kickback. Full extension at top.',
 ARRAY['dumbbell'], ARRAY['triceps'], ARRAY[]::TEXT[], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-kickback.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e7000008-0000-0000-0000-000000000001', 'Bench Dip', 'bench-dip',
 'Hands on bench, dip down. Easier than parallel bar dips.',
 ARRAY['bodyweight', 'bench'], ARRAY['triceps'], ARRAY['chest', 'shoulders'], 'push', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/bench-dip.gif',
 ARRAY['gym', 'home'], true, NOW()),

-- ============================================
-- CORE EXERCISES (Rotation / Anti-Rotation)
-- ============================================
('e8000001-0000-0000-0000-000000000001', 'Plank', 'plank',
 'Isometric core hold. Keep body in straight line.',
 ARRAY['bodyweight'], ARRAY['core', 'abs'], ARRAY['shoulders'], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/plank.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000002-0000-0000-0000-000000000001', 'Side Plank', 'side-plank',
 'Lateral core exercise. Hold on one forearm.',
 ARRAY['bodyweight'], ARRAY['obliques', 'core'], ARRAY[]::TEXT[], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/side-plank.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000003-0000-0000-0000-000000000001', 'Hanging Leg Raise', 'hanging-leg-raise',
 'Hang from bar, raise legs. Advanced core exercise.',
 ARRAY['bodyweight', 'pull-up bar'], ARRAY['abs', 'core'], ARRAY['hip_flexors'], 'rotation', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/hanging-leg-raises.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000004-0000-0000-0000-000000000001', 'Russian Twist', 'russian-twist',
 'Seated twist with weight. Targets obliques.',
 ARRAY['bodyweight', 'dumbbell'], ARRAY['obliques', 'core'], ARRAY[]::TEXT[], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/russian-twist.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000005-0000-0000-0000-000000000001', 'Bicycle Crunch', 'bicycle-crunch',
 'Alternating elbow to knee crunch. Great for abs and obliques.',
 ARRAY['bodyweight'], ARRAY['abs', 'obliques'], ARRAY[]::TEXT[], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/bicycle-crunch.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000006-0000-0000-0000-000000000001', 'Mountain Climbers', 'mountain-climbers',
 'Dynamic plank with alternating knee drives. Cardio and core.',
 ARRAY['bodyweight'], ARRAY['core', 'abs'], ARRAY['shoulders', 'hip_flexors'], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/mountain-climber.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000007-0000-0000-0000-000000000001', 'Dead Bug', 'dead-bug',
 'Lie on back, alternate arm and leg extension. Core stability.',
 ARRAY['bodyweight'], ARRAY['core', 'abs'], ARRAY[]::TEXT[], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/dead-bug.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000008-0000-0000-0000-000000000001', 'Bird Dog', 'bird-dog',
 'Opposite arm and leg extension on all fours. Core and balance.',
 ARRAY['bodyweight'], ARRAY['core'], ARRAY['glutes', 'back'], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/bird-dog.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000009-0000-0000-0000-000000000001', 'Cable Wood Chop', 'cable-wood-chop',
 'Rotational cable exercise. Mimics chopping motion.',
 ARRAY['cable'], ARRAY['obliques', 'core'], ARRAY['shoulders'], 'rotation', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/cable-wood-chop.gif',
 ARRAY['gym'], true, NOW()),

('e8000010-0000-0000-0000-000000000001', 'Pallof Press', 'pallof-press',
 'Anti-rotation cable press. Hold against rotational force.',
 ARRAY['cable', 'resistance_band'], ARRAY['core', 'obliques'], ARRAY[]::TEXT[], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/pallof-press.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000011-0000-0000-0000-000000000001', 'Ab Wheel Rollout', 'ab-wheel-rollout',
 'Roll wheel forward, extend body. Advanced core exercise.',
 ARRAY['ab-wheel'], ARRAY['abs', 'core'], ARRAY['shoulders'], 'rotation', 'advanced',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/ab-wheel-rollout.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e8000012-0000-0000-0000-000000000001', 'Crunch', 'crunch',
 'Basic ab crunch. Curl shoulders toward hips.',
 ARRAY['bodyweight'], ARRAY['abs'], ARRAY[]::TEXT[], 'rotation', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/crunch.gif',
 ARRAY['gym', 'home'], true, NOW()),

-- ============================================
-- FUNCTIONAL/COMPOUND (Carry/Locomotion)
-- ============================================
('e9000001-0000-0000-0000-000000000001', 'Farmers Walk', 'farmers-walk',
 'Carry heavy weights at sides. Walk for distance or time.',
 ARRAY['dumbbell', 'kettlebell'], ARRAY['core', 'forearms'], ARRAY['traps', 'glutes'], 'carry', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/farmers-walk.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e9000002-0000-0000-0000-000000000001', 'Burpees', 'burpees',
 'Full body explosive exercise. Squat, jump back, push-up, jump up.',
 ARRAY['bodyweight'], ARRAY['full_body'], ARRAY['core', 'chest', 'quads'], 'locomotion', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/burpees.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e9000003-0000-0000-0000-000000000001', 'Box Jump', 'box-jump',
 'Explosive jump onto box. Build power and athleticism.',
 ARRAY['plyo-box'], ARRAY['quads', 'glutes'], ARRAY['calves'], 'locomotion', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/box-jump.gif',
 ARRAY['gym'], true, NOW()),

('e9000004-0000-0000-0000-000000000001', 'Jump Squat', 'jump-squat',
 'Squat down and explode up. Plyometric leg exercise.',
 ARRAY['bodyweight'], ARRAY['quads', 'glutes'], ARRAY['calves'], 'locomotion', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/jump-squat.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e9000005-0000-0000-0000-000000000001', 'Dumbbell Thruster', 'dumbbell-thruster',
 'Front squat to overhead press in one motion. Full body power.',
 ARRAY['dumbbell'], ARRAY['quads', 'shoulders'], ARRAY['core', 'triceps'], 'squat', 'intermediate',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-thruster.gif',
 ARRAY['gym', 'home'], true, NOW()),

('e9000006-0000-0000-0000-000000000001', 'Step-Up', 'step-up',
 'Step onto elevated surface with weight. Unilateral leg work.',
 ARRAY['dumbbell', 'bodyweight'], ARRAY['quads', 'glutes'], ARRAY['hamstrings'], 'squat', 'beginner',
 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-step-up.gif',
 ARRAY['gym', 'home'], true, NOW());

-- ============================================
-- CREATE INDEX FOR FASTER FILTERING
-- ============================================
CREATE INDEX IF NOT EXISTS idx_exercises_equipment ON exercises USING GIN (equipment_required);
CREATE INDEX IF NOT EXISTS idx_exercises_muscles ON exercises USING GIN (primary_muscles);
CREATE INDEX IF NOT EXISTS idx_exercises_movement ON exercises (movement_pattern);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON exercises (difficulty);
CREATE INDEX IF NOT EXISTS idx_exercises_location ON exercises USING GIN (location_tags);

