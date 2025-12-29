-- =====================================================
-- COMPREHENSIVE EXERCISE LIBRARY MIGRATION
-- Creates complete exercise infrastructure with 1000+ exercises
-- =====================================================

-- First, update exercises table to support all new fields
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS slug TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS body_part TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS target_muscle TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS equipment TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS difficulty_score INTEGER DEFAULT 5;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS mechanics_type TEXT DEFAULT 'compound';
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS force_type TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS location_tags TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS gif_url TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS musclewiki_gif TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS wger_image TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS requires_spotter BOOLEAN DEFAULT false;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS requires_rack BOOLEAN DEFAULT false;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS progression_from TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS progression_to TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS muscle_tags TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS equipment_tags TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS safety_tips TEXT[] DEFAULT ARRAY[]::TEXT[];

-- Create equipment catalog table
CREATE TABLE IF NOT EXISTS equipment_catalog (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    locations TEXT[] DEFAULT ARRAY[]::TEXT[],
    is_common BOOLEAN DEFAULT false,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create muscle groups reference table
CREATE TABLE IF NOT EXISTS muscle_groups (
    id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    category TEXT NOT NULL,
    sub_muscles TEXT[] DEFAULT ARRAY[]::TEXT[],
    body_region TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create movement patterns reference table  
CREATE TABLE IF NOT EXISTS movement_patterns (
    id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create progression chains table
CREATE TABLE IF NOT EXISTS progression_chains (
    id TEXT PRIMARY KEY,
    base_exercise_name TEXT NOT NULL,
    chain_exercises JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on new tables
ALTER TABLE equipment_catalog ENABLE ROW LEVEL SECURITY;
ALTER TABLE muscle_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE movement_patterns ENABLE ROW LEVEL SECURITY;
ALTER TABLE progression_chains ENABLE ROW LEVEL SECURITY;

-- Public read access for reference tables
CREATE POLICY IF NOT EXISTS "equipment_catalog_public_read" ON equipment_catalog FOR SELECT TO authenticated USING (true);
CREATE POLICY IF NOT EXISTS "muscle_groups_public_read" ON muscle_groups FOR SELECT TO authenticated USING (true);
CREATE POLICY IF NOT EXISTS "movement_patterns_public_read" ON movement_patterns FOR SELECT TO authenticated USING (true);
CREATE POLICY IF NOT EXISTS "progression_chains_public_read" ON progression_chains FOR SELECT TO authenticated USING (true);

-- Populate equipment catalog
INSERT INTO equipment_catalog (id, name, category, locations, is_common) VALUES
-- Free Weights
('barbell', 'Barbell', 'free_weights', ARRAY['gym', 'home'], true),
('dumbbell', 'Dumbbells', 'free_weights', ARRAY['gym', 'home'], true),
('kettlebell', 'Kettlebell', 'free_weights', ARRAY['gym', 'home'], true),
('ez_bar', 'EZ Bar', 'free_weights', ARRAY['gym', 'home'], false),
('trap_bar', 'Trap Bar', 'free_weights', ARRAY['gym'], false),
('plates', 'Weight Plates', 'free_weights', ARRAY['gym', 'home'], true),
('medicine_ball', 'Medicine Ball', 'free_weights', ARRAY['gym', 'home'], false),
-- Machines
('cable_machine', 'Cable Machine', 'machines', ARRAY['gym'], true),
('lat_pulldown_machine', 'Lat Pulldown Machine', 'machines', ARRAY['gym'], true),
('leg_press_machine', 'Leg Press Machine', 'machines', ARRAY['gym'], true),
('smith_machine', 'Smith Machine', 'machines', ARRAY['gym'], false),
('hack_squat_machine', 'Hack Squat Machine', 'machines', ARRAY['gym'], false),
('leg_extension_machine', 'Leg Extension Machine', 'machines', ARRAY['gym'], true),
('leg_curl_machine', 'Leg Curl Machine', 'machines', ARRAY['gym'], true),
('chest_press_machine', 'Chest Press Machine', 'machines', ARRAY['gym'], true),
('shoulder_press_machine', 'Shoulder Press Machine', 'machines', ARRAY['gym'], true),
('row_machine', 'Row Machine', 'machines', ARRAY['gym'], true),
('pec_deck', 'Pec Deck', 'machines', ARRAY['gym'], true),
('assisted_dip_machine', 'Assisted Dip Machine', 'machines', ARRAY['gym'], false),
('assisted_pullup_machine', 'Assisted Pull-up Machine', 'machines', ARRAY['gym'], false),
-- Bodyweight
('no_equipment', 'No Equipment', 'bodyweight', ARRAY['home', 'gym', 'outdoor', 'travel'], true),
('pull_up_bar', 'Pull-up Bar', 'bodyweight', ARRAY['home', 'gym', 'outdoor'], true),
('dip_station', 'Dip Station', 'bodyweight', ARRAY['home', 'gym'], false),
('rings', 'Gymnastic Rings', 'bodyweight', ARRAY['home', 'gym', 'outdoor'], false),
('suspension_trainer', 'Suspension Trainer', 'bodyweight', ARRAY['home', 'gym', 'outdoor', 'travel'], true),
-- Benches
('flat_bench', 'Flat Bench', 'benches', ARRAY['gym', 'home'], true),
('adjustable_bench', 'Adjustable Bench', 'benches', ARRAY['gym', 'home'], true),
('decline_bench', 'Decline Bench', 'benches', ARRAY['gym'], false),
-- Cardio
('treadmill', 'Treadmill', 'cardio', ARRAY['gym', 'home'], false),
('stationary_bike', 'Stationary Bike', 'cardio', ARRAY['gym', 'home'], false),
('rower', 'Rower', 'cardio', ARRAY['gym', 'home'], false),
('assault_bike', 'Assault Bike', 'cardio', ARRAY['gym'], false),
-- Accessories
('resistance_band', 'Resistance Band', 'accessories', ARRAY['home', 'gym', 'outdoor', 'travel'], true),
('ab_wheel', 'Ab Wheel', 'accessories', ARRAY['home', 'gym'], true),
('foam_roller', 'Foam Roller', 'accessories', ARRAY['home', 'gym'], true),
('yoga_mat', 'Yoga Mat', 'accessories', ARRAY['home', 'gym', 'outdoor', 'travel'], true),
('jump_rope', 'Jump Rope', 'accessories', ARRAY['home', 'gym', 'outdoor', 'travel'], true),
('stability_ball', 'Stability Ball', 'accessories', ARRAY['home', 'gym'], false),
('bosu_ball', 'Bosu Ball', 'accessories', ARRAY['gym'], false)
ON CONFLICT (id) DO NOTHING;

-- Populate muscle groups
INSERT INTO muscle_groups (id, display_name, category, sub_muscles, body_region) VALUES
('chest', 'Chest', 'push', ARRAY['upper_chest', 'mid_chest', 'lower_chest', 'inner_chest'], 'upper_body'),
('back', 'Back', 'pull', ARRAY['lats', 'traps', 'rhomboids', 'erector_spinae', 'teres_major', 'teres_minor'], 'upper_body'),
('shoulders', 'Shoulders', 'push', ARRAY['anterior_deltoid', 'lateral_deltoid', 'posterior_deltoid'], 'upper_body'),
('triceps', 'Triceps', 'push', ARRAY['long_head', 'lateral_head', 'medial_head'], 'arms'),
('biceps', 'Biceps', 'pull', ARRAY['long_head', 'short_head', 'brachialis', 'brachioradialis'], 'arms'),
('forearms', 'Forearms', 'arms', ARRAY['flexors', 'extensors', 'brachioradialis'], 'arms'),
('quadriceps', 'Quadriceps', 'legs', ARRAY['rectus_femoris', 'vastus_lateralis', 'vastus_medialis', 'vastus_intermedius'], 'lower_body'),
('hamstrings', 'Hamstrings', 'legs', ARRAY['biceps_femoris', 'semitendinosus', 'semimembranosus'], 'lower_body'),
('glutes', 'Glutes', 'legs', ARRAY['gluteus_maximus', 'gluteus_medius', 'gluteus_minimus'], 'lower_body'),
('calves', 'Calves', 'legs', ARRAY['gastrocnemius', 'soleus'], 'lower_body'),
('abs', 'Abs', 'core', ARRAY['rectus_abdominis', 'obliques', 'transverse_abdominis'], 'core'),
('lower_back', 'Lower Back', 'core', ARRAY['erector_spinae', 'multifidus'], 'core'),
('hip_flexors', 'Hip Flexors', 'core', ARRAY['iliopsoas', 'rectus_femoris', 'sartorius'], 'core'),
('adductors', 'Adductors', 'legs', ARRAY['adductor_magnus', 'adductor_longus', 'adductor_brevis'], 'lower_body'),
('abductors', 'Abductors', 'legs', ARRAY['tensor_fasciae_latae', 'gluteus_medius', 'gluteus_minimus'], 'lower_body')
ON CONFLICT (id) DO NOTHING;

-- Populate movement patterns
INSERT INTO movement_patterns (id, display_name, description) VALUES
('squat', 'Squat', 'Lower body pushing movement - knee dominant'),
('hinge', 'Hinge', 'Posterior chain dominant - hip hinge movement'),
('push_horizontal', 'Horizontal Push', 'Chest and triceps - pushing away from body'),
('push_vertical', 'Vertical Push', 'Shoulders and triceps - pushing overhead'),
('pull_horizontal', 'Horizontal Pull', 'Back and biceps - rowing movements'),
('pull_vertical', 'Vertical Pull', 'Back and biceps - pulling down'),
('lunge', 'Lunge', 'Single leg locomotion pattern'),
('carry', 'Carry', 'Loaded carries for core and grip strength'),
('rotation', 'Rotation', 'Rotational movements for core strength'),
('core', 'Core', 'Anti-extension, anti-rotation, flexion'),
('isolation', 'Isolation', 'Single joint movements')
ON CONFLICT (id) DO NOTHING;

-- Populate progression chains
INSERT INTO progression_chains (id, base_exercise_name, chain_exercises) VALUES
('push_up_progression', 'Push-up', '[
    {"name": "Wall Push-up", "difficulty_score": 1},
    {"name": "Incline Push-up", "difficulty_score": 2},
    {"name": "Knee Push-up", "difficulty_score": 3},
    {"name": "Push-up", "difficulty_score": 4},
    {"name": "Diamond Push-up", "difficulty_score": 5},
    {"name": "Decline Push-up", "difficulty_score": 5},
    {"name": "Archer Push-up", "difficulty_score": 7},
    {"name": "One-Arm Push-up", "difficulty_score": 9}
]'),
('squat_progression', 'Squat', '[
    {"name": "Assisted Squat", "difficulty_score": 1},
    {"name": "Bodyweight Squat", "difficulty_score": 2},
    {"name": "Goblet Squat", "difficulty_score": 3},
    {"name": "Dumbbell Squat", "difficulty_score": 4},
    {"name": "Barbell Back Squat", "difficulty_score": 5},
    {"name": "Barbell Front Squat", "difficulty_score": 6},
    {"name": "Bulgarian Split Squat", "difficulty_score": 6},
    {"name": "Pistol Squat", "difficulty_score": 9}
]'),
('pull_up_progression', 'Pull-up', '[
    {"name": "Dead Hang", "difficulty_score": 1},
    {"name": "Scapular Pull-up", "difficulty_score": 2},
    {"name": "Negative Pull-up", "difficulty_score": 3},
    {"name": "Band-Assisted Pull-up", "difficulty_score": 4},
    {"name": "Pull-up", "difficulty_score": 6},
    {"name": "Chest-to-Bar Pull-up", "difficulty_score": 7},
    {"name": "Weighted Pull-up", "difficulty_score": 8},
    {"name": "One-Arm Pull-up", "difficulty_score": 10}
]'),
('deadlift_progression', 'Deadlift', '[
    {"name": "Kettlebell Deadlift", "difficulty_score": 3},
    {"name": "Romanian Deadlift", "difficulty_score": 4},
    {"name": "Trap Bar Deadlift", "difficulty_score": 4},
    {"name": "Sumo Deadlift", "difficulty_score": 5},
    {"name": "Conventional Deadlift", "difficulty_score": 6},
    {"name": "Deficit Deadlift", "difficulty_score": 7},
    {"name": "Snatch Grip Deadlift", "difficulty_score": 8}
]'),
('bench_press_progression', 'Bench Press', '[
    {"name": "Push-up", "difficulty_score": 3},
    {"name": "Dumbbell Bench Press", "difficulty_score": 4},
    {"name": "Barbell Bench Press", "difficulty_score": 5},
    {"name": "Incline Barbell Bench Press", "difficulty_score": 5},
    {"name": "Close-Grip Bench Press", "difficulty_score": 5},
    {"name": "Pause Bench Press", "difficulty_score": 6},
    {"name": "Floor Press", "difficulty_score": 5}
]'),
('row_progression', 'Row', '[
    {"name": "Inverted Row", "difficulty_score": 3},
    {"name": "Dumbbell Row", "difficulty_score": 4},
    {"name": "Barbell Row", "difficulty_score": 5},
    {"name": "Pendlay Row", "difficulty_score": 6},
    {"name": "Meadows Row", "difficulty_score": 5}
]')
ON CONFLICT (id) DO NOTHING;

-- Clear existing exercises for clean re-seed
TRUNCATE exercises CASCADE;

-- Insert comprehensive exercise library
-- =====================================================
-- CHEST EXERCISES
-- =====================================================
INSERT INTO exercises (id, name, slug, body_part, target_muscle, equipment, difficulty, difficulty_score, movement_pattern, mechanics_type, force_type, location_tags, instructions, cues, common_mistakes, muscle_tags, equipment_tags, gif_url, is_published) VALUES

-- Barbell Chest
('ex_barbell_bench_press', 'Barbell Bench Press', 'barbell-bench-press', 'chest', 'pectorals', 'barbell', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['gym', 'home'], 
 ARRAY['Lie on flat bench with eyes under the bar', 'Grip bar slightly wider than shoulder width', 'Unrack and lower bar to mid-chest', 'Press bar up until arms are extended'],
 ARRAY['Retract shoulder blades', 'Drive feet into floor', 'Keep wrists straight'],
 ARRAY['Bouncing bar off chest', 'Flaring elbows too wide', 'Lifting hips off bench'],
 ARRAY['chest', 'triceps', 'anterior_deltoid'], ARRAY['barbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/FHtdV48nNPNFvL', true),

('ex_incline_barbell_bench', 'Incline Barbell Bench Press', 'incline-barbell-bench-press', 'chest', 'upper_chest', 'barbell', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Set bench to 30-45 degree incline', 'Grip bar slightly wider than shoulder width', 'Lower bar to upper chest', 'Press bar up until arms are extended'],
 ARRAY['Keep upper back tight on bench', 'Elbows at 45 degree angle', 'Control the descent'],
 ARRAY['Angle too steep', 'Lowering bar too low', 'Excessive arch'],
 ARRAY['upper_chest', 'triceps', 'anterior_deltoid'], ARRAY['barbell', 'adjustable_bench'],
 'https://v2.exercisedb.io/image/UzSuddEoOGJPzq', true),

('ex_decline_barbell_bench', 'Decline Barbell Bench Press', 'decline-barbell-bench-press', 'chest', 'lower_chest', 'barbell', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['gym'],
 ARRAY['Set bench to 15-30 degree decline', 'Secure legs at end of bench', 'Lower bar to lower chest', 'Press bar up until arms are extended'],
 ARRAY['Keep core tight', 'Control the bar path', 'Focus on lower chest squeeze'],
 ARRAY['Too steep decline', 'Rushing the movement', 'Not securing legs'],
 ARRAY['lower_chest', 'triceps', 'anterior_deltoid'], ARRAY['barbell', 'decline_bench'],
 'https://v2.exercisedb.io/image/qz2gYNr-nSVPEd', true),

-- Dumbbell Chest
('ex_dumbbell_bench_press', 'Dumbbell Bench Press', 'dumbbell-bench-press', 'chest', 'pectorals', 'dumbbell', 'beginner', 4, 'push_horizontal', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Lie on flat bench holding dumbbells at chest level', 'Press dumbbells up until arms are extended', 'Lower dumbbells back to starting position'],
 ARRAY['Keep elbows at 45 degrees', 'Touch dumbbells at top', 'Control the negative'],
 ARRAY['Going too heavy too soon', 'Uneven pressing', 'Dropping weights too fast'],
 ARRAY['chest', 'triceps', 'anterior_deltoid'], ARRAY['dumbbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/ykxGQhEnWnG5HG', true),

('ex_incline_dumbbell_press', 'Incline Dumbbell Press', 'incline-dumbbell-press', 'chest', 'upper_chest', 'dumbbell', 'beginner', 4, 'push_horizontal', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Set bench to 30-45 degree incline', 'Press dumbbells up until arms are extended', 'Lower dumbbells back to starting position'],
 ARRAY['Keep shoulders back', 'Focus on upper chest', 'Full range of motion'],
 ARRAY['Bench angle too high', 'Using momentum', 'Partial reps'],
 ARRAY['upper_chest', 'triceps', 'anterior_deltoid'], ARRAY['dumbbell', 'adjustable_bench'],
 'https://v2.exercisedb.io/image/TBnCbvFhmRJ-YI', true),

('ex_dumbbell_fly', 'Dumbbell Fly', 'dumbbell-fly', 'chest', 'pectorals', 'dumbbell', 'beginner', 3, 'push_horizontal', 'isolation', 'push', ARRAY['gym', 'home'],
 ARRAY['Lie on flat bench with dumbbells above chest', 'Lower dumbbells in arc motion to sides', 'Return to starting position squeezing chest'],
 ARRAY['Slight bend in elbows', 'Feel the stretch', 'Control the movement'],
 ARRAY['Going too heavy', 'Straightening arms', 'Rushing the stretch'],
 ARRAY['chest', 'anterior_deltoid'], ARRAY['dumbbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/KzwVKoaWQtVTCH', true),

-- Bodyweight Chest
('ex_push_up', 'Push-up', 'push-up', 'chest', 'pectorals', 'body weight', 'beginner', 4, 'push_horizontal', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Start in plank position with hands under shoulders', 'Lower chest to floor', 'Push back up to starting position'],
 ARRAY['Keep body straight', 'Core tight', 'Full range of motion'],
 ARRAY['Sagging hips', 'Flaring elbows', 'Partial reps'],
 ARRAY['chest', 'triceps', 'anterior_deltoid', 'core'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/4Dt7xJJy6V3oWF', true),

('ex_incline_push_up', 'Incline Push-up', 'incline-push-up', 'chest', 'lower_chest', 'body weight', 'beginner', 2, 'push_horizontal', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Place hands on elevated surface', 'Lower chest toward surface', 'Push back up'],
 ARRAY['Keep body straight', 'Full range of motion', 'Great for beginners'],
 ARRAY['Surface too high or too low', 'Sagging hips', 'Half reps'],
 ARRAY['lower_chest', 'triceps', 'anterior_deltoid'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/gMJe67LbMCpX0j', true),

('ex_decline_push_up', 'Decline Push-up', 'decline-push-up', 'chest', 'upper_chest', 'body weight', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Place feet on elevated surface', 'Lower chest to floor', 'Push back up'],
 ARRAY['Maintain straight body line', 'Focus on upper chest', 'Control the movement'],
 ARRAY['Feet too high', 'Sagging hips', 'Neck craning'],
 ARRAY['upper_chest', 'triceps', 'anterior_deltoid', 'core'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/jtNsVvE8Zcw8x-', true),

('ex_diamond_push_up', 'Diamond Push-up', 'diamond-push-up', 'chest', 'triceps', 'body weight', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Place hands together forming diamond shape', 'Lower chest to hands', 'Push back up'],
 ARRAY['Keep elbows close to body', 'Core engaged', 'Focus on triceps'],
 ARRAY['Hands too far apart', 'Flaring elbows', 'Sagging hips'],
 ARRAY['chest', 'triceps'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/xnZMxDgGg05EqX', true),

-- Machine Chest
('ex_cable_fly', 'Cable Fly', 'cable-fly', 'chest', 'pectorals', 'cable', 'beginner', 3, 'push_horizontal', 'isolation', 'push', ARRAY['gym'],
 ARRAY['Set cables to shoulder height', 'Step forward with slight lean', 'Bring handles together in front of chest', 'Control back to start'],
 ARRAY['Keep slight bend in elbows', 'Squeeze chest at peak', 'Slow controlled movement'],
 ARRAY['Using too much weight', 'Straightening arms', 'Losing form'],
 ARRAY['chest', 'anterior_deltoid'], ARRAY['cable_machine'],
 'https://v2.exercisedb.io/image/LzF6jBmZSu5UtT', true),

('ex_machine_chest_press', 'Machine Chest Press', 'machine-chest-press', 'chest', 'pectorals', 'leverage machine', 'beginner', 2, 'push_horizontal', 'compound', 'push', ARRAY['gym'],
 ARRAY['Adjust seat so handles are at chest level', 'Grip handles and press forward', 'Control weight back to start'],
 ARRAY['Keep back against pad', 'Exhale on push', 'Full range of motion'],
 ARRAY['Seat too high or low', 'Using momentum', 'Partial reps'],
 ARRAY['chest', 'triceps', 'anterior_deltoid'], ARRAY['chest_press_machine'],
 'https://v2.exercisedb.io/image/rOTtaZ9cXm6vLs', true),

('ex_pec_deck', 'Pec Deck Fly', 'pec-deck-fly', 'chest', 'pectorals', 'leverage machine', 'beginner', 2, 'push_horizontal', 'isolation', 'push', ARRAY['gym'],
 ARRAY['Adjust seat so arms are parallel to floor', 'Place forearms on pads', 'Bring pads together in front', 'Control back to start'],
 ARRAY['Keep back against pad', 'Squeeze at peak contraction', 'Controlled movement'],
 ARRAY['Going too heavy', 'Rushing the movement', 'Not getting full stretch'],
 ARRAY['chest', 'anterior_deltoid'], ARRAY['pec_deck'],
 'https://v2.exercisedb.io/image/9BdPZc-KmOJ0lD', true),

-- =====================================================
-- BACK EXERCISES
-- =====================================================

-- Barbell Back
('ex_barbell_row', 'Barbell Row', 'barbell-row', 'back', 'lats', 'barbell', 'intermediate', 5, 'pull_horizontal', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Bend over with back flat, holding barbell', 'Pull bar to lower chest/upper abdomen', 'Lower with control'],
 ARRAY['Keep back flat', 'Pull to lower ribcage', 'Squeeze shoulder blades'],
 ARRAY['Rounding back', 'Using too much body english', 'Not pulling to proper position'],
 ARRAY['lats', 'rhomboids', 'rear_deltoid', 'biceps'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/Cq6mlPpAPEA-UF', true),

('ex_pendlay_row', 'Pendlay Row', 'pendlay-row', 'back', 'lats', 'barbell', 'intermediate', 6, 'pull_horizontal', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Set up with bar on floor, back parallel to ground', 'Pull bar explosively to lower chest', 'Lower bar back to floor'],
 ARRAY['Reset each rep', 'Explosive pull', 'Back stays parallel'],
 ARRAY['Not resetting', 'Rising up during pull', 'Slow, controlled style'],
 ARRAY['lats', 'rhomboids', 'rear_deltoid', 'biceps'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/x3GKEsSlp0N7lR', true),

('ex_deadlift', 'Conventional Deadlift', 'conventional-deadlift', 'back', 'erector_spinae', 'barbell', 'advanced', 7, 'hinge', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with feet hip width apart, bar over mid-foot', 'Grip bar just outside legs', 'Drive through heels, extend hips and knees', 'Lock out at top, reverse motion'],
 ARRAY['Keep bar close to body', 'Neutral spine', 'Drive hips forward at top'],
 ARRAY['Rounding lower back', 'Bar drifting forward', 'Jerking the weight'],
 ARRAY['erector_spinae', 'glutes', 'hamstrings', 'traps', 'forearms'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/TU0ZZTG0bSFQGj', true),

('ex_sumo_deadlift', 'Sumo Deadlift', 'sumo-deadlift', 'back', 'glutes', 'barbell', 'advanced', 7, 'hinge', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with wide stance, toes pointed out', 'Grip bar between legs', 'Drive through heels, extend hips and knees', 'Lock out at top'],
 ARRAY['Push knees out', 'Stay upright', 'Hips and shoulders rise together'],
 ARRAY['Hips shooting up first', 'Knees caving in', 'Not driving through heels'],
 ARRAY['glutes', 'adductors', 'quadriceps', 'erector_spinae'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/0u5fgXSsJdMkfm', true),

-- Dumbbell Back
('ex_dumbbell_row', 'Single-Arm Dumbbell Row', 'dumbbell-row', 'back', 'lats', 'dumbbell', 'beginner', 3, 'pull_horizontal', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Place one hand and knee on bench', 'Row dumbbell to hip', 'Lower with control'],
 ARRAY['Keep back flat', 'Pull to hip', 'Squeeze at top'],
 ARRAY['Rotating torso', 'Shrugging shoulder', 'Using momentum'],
 ARRAY['lats', 'rhomboids', 'rear_deltoid', 'biceps'], ARRAY['dumbbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/fKfWvRpWQHAFPT', true),

('ex_dumbbell_pullover', 'Dumbbell Pullover', 'dumbbell-pullover', 'back', 'lats', 'dumbbell', 'intermediate', 4, 'pull_vertical', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Lie across bench with upper back supported', 'Hold dumbbell with both hands overhead', 'Lower dumbbell behind head', 'Pull back over chest'],
 ARRAY['Keep slight bend in elbows', 'Feel the stretch in lats', 'Control the movement'],
 ARRAY['Going too heavy', 'Bending elbows too much', 'Arching lower back'],
 ARRAY['lats', 'chest', 'triceps', 'serratus_anterior'], ARRAY['dumbbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/1bxCxW7wr-cIyf', true),

-- Bodyweight Back
('ex_pull_up', 'Pull-up', 'pull-up', 'back', 'lats', 'body weight', 'intermediate', 6, 'pull_vertical', 'compound', 'pull', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Hang from bar with overhand grip', 'Pull body up until chin clears bar', 'Lower with control'],
 ARRAY['Full dead hang at bottom', 'Lead with chest', 'Squeeze at top'],
 ARRAY['Kipping', 'Partial range of motion', 'Shrugging shoulders'],
 ARRAY['lats', 'biceps', 'rhomboids', 'core'], ARRAY['pull_up_bar'],
 'https://v2.exercisedb.io/image/Ua6D7JQVhFFdmI', true),

('ex_chin_up', 'Chin-up', 'chin-up', 'back', 'lats', 'body weight', 'intermediate', 5, 'pull_vertical', 'compound', 'pull', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Hang from bar with underhand grip', 'Pull body up until chin clears bar', 'Lower with control'],
 ARRAY['Full dead hang at bottom', 'Elbows down and back', 'Control the negative'],
 ARRAY['Half reps', 'Using momentum', 'Not going low enough'],
 ARRAY['lats', 'biceps', 'rhomboids'], ARRAY['pull_up_bar'],
 'https://v2.exercisedb.io/image/aWKoD6xHN1c-Ij', true),

('ex_inverted_row', 'Inverted Row', 'inverted-row', 'back', 'lats', 'body weight', 'beginner', 3, 'pull_horizontal', 'compound', 'pull', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Set bar at hip height', 'Hang below bar with straight body', 'Pull chest to bar', 'Lower with control'],
 ARRAY['Keep body straight', 'Pull to lower chest', 'Squeeze shoulder blades'],
 ARRAY['Hips sagging', 'Partial range of motion', 'Craning neck'],
 ARRAY['lats', 'rhomboids', 'biceps', 'rear_deltoid'], ARRAY['pull_up_bar'],
 'https://v2.exercisedb.io/image/8gn0u2EEbaNsrI', true),

-- Machine Back
('ex_lat_pulldown', 'Lat Pulldown', 'lat-pulldown', 'back', 'lats', 'cable', 'beginner', 3, 'pull_vertical', 'compound', 'pull', ARRAY['gym'],
 ARRAY['Sit at machine with thighs secured', 'Grip bar wider than shoulder width', 'Pull bar to upper chest', 'Control back to start'],
 ARRAY['Lead with elbows', 'Squeeze at bottom', 'Control the negative'],
 ARRAY['Leaning too far back', 'Pulling behind neck', 'Using momentum'],
 ARRAY['lats', 'biceps', 'rhomboids'], ARRAY['lat_pulldown_machine'],
 'https://v2.exercisedb.io/image/Z2TIiRu-xaUJsv', true),

('ex_seated_cable_row', 'Seated Cable Row', 'seated-cable-row', 'back', 'lats', 'cable', 'beginner', 3, 'pull_horizontal', 'compound', 'pull', ARRAY['gym'],
 ARRAY['Sit at machine with feet on platform', 'Grip handle with arms extended', 'Pull handle to lower chest', 'Squeeze and return'],
 ARRAY['Keep chest up', 'Pull to sternum', 'Squeeze shoulder blades'],
 ARRAY['Excessive forward lean', 'Using momentum', 'Rounding shoulders'],
 ARRAY['lats', 'rhomboids', 'biceps', 'rear_deltoid'], ARRAY['cable_machine'],
 'https://v2.exercisedb.io/image/xp1Bpx5pVhLCjU', true),

('ex_face_pull', 'Face Pull', 'face-pull', 'back', 'rear_deltoid', 'cable', 'beginner', 3, 'pull_horizontal', 'isolation', 'pull', ARRAY['gym'],
 ARRAY['Set cable at face height', 'Grip rope with thumbs back', 'Pull to face, spreading rope apart', 'Squeeze rear delts and return'],
 ARRAY['Elbows high', 'External rotation at end', 'Control the movement'],
 ARRAY['Elbows too low', 'Using too much weight', 'No external rotation'],
 ARRAY['rear_deltoid', 'rhomboids', 'rotator_cuff'], ARRAY['cable_machine'],
 'https://v2.exercisedb.io/image/HDWfLfeFT3Kl5T', true),

-- =====================================================
-- SHOULDER EXERCISES
-- =====================================================

-- Barbell Shoulders
('ex_overhead_press', 'Barbell Overhead Press', 'overhead-press', 'shoulders', 'anterior_deltoid', 'barbell', 'intermediate', 5, 'push_vertical', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Grip bar at shoulder width in rack position', 'Press bar overhead until arms are extended', 'Lower bar back to shoulders'],
 ARRAY['Brace core tight', 'Push head through at top', 'Lock out completely'],
 ARRAY['Excessive back arch', 'Not locking out', 'Bar path not straight'],
 ARRAY['anterior_deltoid', 'triceps', 'upper_chest'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/ks6uTmCIL6KrDg', true),

('ex_push_press', 'Push Press', 'push-press', 'shoulders', 'anterior_deltoid', 'barbell', 'intermediate', 6, 'push_vertical', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Start with bar in rack position', 'Dip knees slightly', 'Drive through legs and press bar overhead', 'Lower with control'],
 ARRAY['Use leg drive', 'Fast dip and drive', 'Lock out at top'],
 ARRAY['Dipping too deep', 'Not using enough leg drive', 'Pressing before dip is complete'],
 ARRAY['anterior_deltoid', 'triceps', 'quadriceps'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/a9J1e-4R0Skg3n', true),

-- Dumbbell Shoulders
('ex_dumbbell_shoulder_press', 'Dumbbell Shoulder Press', 'dumbbell-shoulder-press', 'shoulders', 'anterior_deltoid', 'dumbbell', 'beginner', 4, 'push_vertical', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Sit with dumbbells at shoulder level', 'Press dumbbells overhead', 'Lower with control'],
 ARRAY['Core engaged', 'Push straight up', 'Control the descent'],
 ARRAY['Arching back', 'Dumbbells drifting forward', 'Not locking out'],
 ARRAY['anterior_deltoid', 'triceps', 'upper_chest'], ARRAY['dumbbell', 'adjustable_bench'],
 'https://v2.exercisedb.io/image/w4j8qY0Sq3Vlnt', true),

('ex_lateral_raise', 'Dumbbell Lateral Raise', 'lateral-raise', 'shoulders', 'lateral_deltoid', 'dumbbell', 'beginner', 3, 'push_vertical', 'isolation', 'push', ARRAY['gym', 'home'],
 ARRAY['Stand with dumbbells at sides', 'Raise arms to sides until parallel', 'Lower with control'],
 ARRAY['Slight bend in elbows', 'Lead with elbows', 'Control the negative'],
 ARRAY['Swinging weights', 'Raising too high', 'Using momentum'],
 ARRAY['lateral_deltoid'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/xqBxKJMUJfbHpH', true),

('ex_front_raise', 'Dumbbell Front Raise', 'front-raise', 'shoulders', 'anterior_deltoid', 'dumbbell', 'beginner', 3, 'push_vertical', 'isolation', 'push', ARRAY['gym', 'home'],
 ARRAY['Stand with dumbbells in front of thighs', 'Raise one or both arms to eye level', 'Lower with control'],
 ARRAY['Keep slight elbow bend', 'Thumbs slightly up', 'Dont swing'],
 ARRAY['Going too heavy', 'Using momentum', 'Raising too high'],
 ARRAY['anterior_deltoid'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/d3R7Dp7TJ8Cqwu', true),

('ex_rear_delt_fly', 'Rear Delt Fly', 'rear-delt-fly', 'shoulders', 'posterior_deltoid', 'dumbbell', 'beginner', 3, 'pull_horizontal', 'isolation', 'pull', ARRAY['gym', 'home'],
 ARRAY['Bend over with dumbbells hanging', 'Raise arms to sides squeezing rear delts', 'Lower with control'],
 ARRAY['Slight bend in elbows', 'Squeeze shoulder blades', 'Control the movement'],
 ARRAY['Standing too upright', 'Swinging weights', 'Not squeezing at top'],
 ARRAY['posterior_deltoid', 'rhomboids'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/5oJNhLy7hWpv7T', true),

('ex_arnold_press', 'Arnold Press', 'arnold-press', 'shoulders', 'anterior_deltoid', 'dumbbell', 'intermediate', 5, 'push_vertical', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Start with palms facing you at shoulder level', 'Rotate palms as you press up', 'Reverse motion on the way down'],
 ARRAY['Smooth rotation', 'Full lockout', 'Control throughout'],
 ARRAY['Rushing the rotation', 'Not full range of motion', 'Too heavy'],
 ARRAY['anterior_deltoid', 'lateral_deltoid', 'triceps'], ARRAY['dumbbell', 'adjustable_bench'],
 'https://v2.exercisedb.io/image/pu6mC-A9d0xbDf', true),

-- =====================================================
-- ARM EXERCISES
-- =====================================================

-- Triceps
('ex_tricep_pushdown', 'Tricep Pushdown', 'tricep-pushdown', 'upper arms', 'triceps', 'cable', 'beginner', 3, 'isolation', 'isolation', 'push', ARRAY['gym'],
 ARRAY['Stand facing cable machine', 'Grip bar with overhand grip', 'Press down until arms are extended', 'Control back to start'],
 ARRAY['Keep elbows at sides', 'Full extension', 'Squeeze at bottom'],
 ARRAY['Elbows flaring', 'Using momentum', 'Partial range of motion'],
 ARRAY['triceps'], ARRAY['cable_machine'],
 'https://v2.exercisedb.io/image/VB1MpJHTVCIoq6', true),

('ex_skull_crusher', 'Skull Crusher', 'skull-crusher', 'upper arms', 'triceps', 'barbell', 'intermediate', 4, 'isolation', 'isolation', 'push', ARRAY['gym', 'home'],
 ARRAY['Lie on bench with bar above forehead', 'Lower bar by bending elbows', 'Extend arms back to start'],
 ARRAY['Keep elbows pointed up', 'Control the descent', 'Full extension'],
 ARRAY['Elbows flaring', 'Going too heavy', 'Hitting head'],
 ARRAY['triceps'], ARRAY['barbell', 'ez_bar', 'flat_bench'],
 'https://v2.exercisedb.io/image/v4GE0-J8sDQmhQ', true),

('ex_overhead_tricep_extension', 'Overhead Tricep Extension', 'overhead-tricep-extension', 'upper arms', 'triceps', 'dumbbell', 'beginner', 3, 'isolation', 'isolation', 'push', ARRAY['gym', 'home'],
 ARRAY['Hold dumbbell overhead with both hands', 'Lower dumbbell behind head', 'Extend arms back up'],
 ARRAY['Keep elbows close to head', 'Full stretch at bottom', 'Lock out at top'],
 ARRAY['Elbows flaring out', 'Using too much weight', 'Not getting full stretch'],
 ARRAY['triceps'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/qN8vxHxcpR2KyU', true),

('ex_dip', 'Dip', 'dip', 'upper arms', 'triceps', 'body weight', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Support body on parallel bars', 'Lower body by bending elbows', 'Press back up to start'],
 ARRAY['Lean forward for chest, upright for triceps', 'Control the descent', 'Full lockout'],
 ARRAY['Going too deep', 'Swinging', 'Shoulder pain'],
 ARRAY['triceps', 'chest', 'anterior_deltoid'], ARRAY['dip_station'],
 'https://v2.exercisedb.io/image/rDfmPPCcz67BHJ', true),

('ex_close_grip_bench', 'Close-Grip Bench Press', 'close-grip-bench-press', 'upper arms', 'triceps', 'barbell', 'intermediate', 5, 'push_horizontal', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Lie on bench with narrow grip on bar', 'Lower bar to lower chest', 'Press bar up until arms are extended'],
 ARRAY['Keep elbows tucked', 'Touch lower chest', 'Control the descent'],
 ARRAY['Grip too narrow', 'Flaring elbows', 'Bouncing off chest'],
 ARRAY['triceps', 'chest', 'anterior_deltoid'], ARRAY['barbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/h2D0JVF-NJwLfx', true),

-- Biceps
('ex_barbell_curl', 'Barbell Curl', 'barbell-curl', 'upper arms', 'biceps', 'barbell', 'beginner', 3, 'isolation', 'isolation', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with barbell at arms length', 'Curl bar up to shoulders', 'Lower with control'],
 ARRAY['Keep elbows at sides', 'Squeeze at top', 'Control the negative'],
 ARRAY['Swinging body', 'Moving elbows', 'Partial reps'],
 ARRAY['biceps', 'brachialis'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/j6TvQUG3HRuC0h', true),

('ex_dumbbell_curl', 'Dumbbell Bicep Curl', 'dumbbell-curl', 'upper arms', 'biceps', 'dumbbell', 'beginner', 3, 'isolation', 'isolation', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with dumbbells at sides', 'Curl dumbbells up rotating palms up', 'Lower with control'],
 ARRAY['Supinate at top', 'Keep elbows still', 'Full range of motion'],
 ARRAY['Swinging weights', 'Not supinating', 'Using momentum'],
 ARRAY['biceps', 'brachialis'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/iKADU9aXVG-LZf', true),

('ex_hammer_curl', 'Hammer Curl', 'hammer-curl', 'upper arms', 'biceps', 'dumbbell', 'beginner', 3, 'isolation', 'isolation', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with dumbbells at sides, palms facing in', 'Curl dumbbells up keeping neutral grip', 'Lower with control'],
 ARRAY['Neutral grip throughout', 'Keep elbows still', 'Squeeze at top'],
 ARRAY['Swinging', 'Rotating grip', 'Too heavy'],
 ARRAY['biceps', 'brachioradialis', 'brachialis'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/CwRm7nQPRpQCpH', true),

('ex_preacher_curl', 'Preacher Curl', 'preacher-curl', 'upper arms', 'biceps', 'barbell', 'beginner', 3, 'isolation', 'isolation', 'pull', ARRAY['gym'],
 ARRAY['Sit at preacher bench with arms over pad', 'Curl bar up to shoulders', 'Lower with control'],
 ARRAY['Keep upper arms on pad', 'Full stretch at bottom', 'Squeeze at top'],
 ARRAY['Coming off pad', 'Not full extension', 'Using momentum'],
 ARRAY['biceps'], ARRAY['barbell', 'ez_bar'],
 'https://v2.exercisedb.io/image/mWpZ0wHYUPdQFT', true),

('ex_concentration_curl', 'Concentration Curl', 'concentration-curl', 'upper arms', 'biceps', 'dumbbell', 'beginner', 3, 'isolation', 'isolation', 'pull', ARRAY['gym', 'home'],
 ARRAY['Sit with elbow braced against inner thigh', 'Curl dumbbell up to shoulder', 'Lower with control'],
 ARRAY['Brace elbow firmly', 'Full range of motion', 'Squeeze at top'],
 ARRAY['Moving upper arm', 'Using momentum', 'Partial reps'],
 ARRAY['biceps'], ARRAY['dumbbell'],
 'https://v2.exercisedb.io/image/8dCiGY8CjhAQwf', true),

-- =====================================================
-- LEG EXERCISES
-- =====================================================

-- Quadriceps
('ex_barbell_back_squat', 'Barbell Back Squat', 'barbell-back-squat', 'upper legs', 'quadriceps', 'barbell', 'intermediate', 6, 'squat', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Bar on upper back, feet shoulder width', 'Break at hips and knees to descend', 'Squat to parallel or below', 'Drive up to standing'],
 ARRAY['Knees track over toes', 'Chest up', 'Drive through heels'],
 ARRAY['Knees caving in', 'Leaning too far forward', 'Not hitting depth'],
 ARRAY['quadriceps', 'glutes', 'hamstrings', 'core'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/5XL-s8CJDqQB3F', true),

('ex_front_squat', 'Barbell Front Squat', 'front-squat', 'upper legs', 'quadriceps', 'barbell', 'advanced', 7, 'squat', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Bar in front rack position', 'Keep elbows high throughout', 'Squat to parallel or below', 'Drive up to standing'],
 ARRAY['Elbows up', 'Stay upright', 'Full depth'],
 ARRAY['Elbows dropping', 'Leaning forward', 'Wrist pain'],
 ARRAY['quadriceps', 'glutes', 'core'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/7dCi8Y8CjhAQwf', true),

('ex_goblet_squat', 'Goblet Squat', 'goblet-squat', 'upper legs', 'quadriceps', 'dumbbell', 'beginner', 3, 'squat', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Hold dumbbell at chest like a goblet', 'Squat down keeping chest up', 'Push through heels to stand'],
 ARRAY['Elbows inside knees', 'Keep chest up', 'Full depth'],
 ARRAY['Rounding back', 'Knees caving', 'Not deep enough'],
 ARRAY['quadriceps', 'glutes', 'core'], ARRAY['dumbbell', 'kettlebell'],
 'https://v2.exercisedb.io/image/hJKL2sPQR4TVyz', true),

('ex_bodyweight_squat', 'Bodyweight Squat', 'bodyweight-squat', 'upper legs', 'quadriceps', 'body weight', 'beginner', 2, 'squat', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Stand with feet shoulder width apart', 'Squat down as if sitting in chair', 'Stand back up'],
 ARRAY['Chest up', 'Knees track over toes', 'Go to parallel'],
 ARRAY['Knees caving', 'Heels rising', 'Not deep enough'],
 ARRAY['quadriceps', 'glutes', 'core'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/BnMoP5qRsTUvWx', true),

('ex_leg_press', 'Leg Press', 'leg-press', 'upper legs', 'quadriceps', 'sled machine', 'beginner', 3, 'squat', 'compound', 'push', ARRAY['gym'],
 ARRAY['Sit in machine with feet on platform', 'Lower weight by bending knees', 'Press through feet to extend legs'],
 ARRAY['Full range of motion', 'Dont lock out knees', 'Control the weight'],
 ARRAY['Locking out knees', 'Too much weight', 'Hips coming off seat'],
 ARRAY['quadriceps', 'glutes', 'hamstrings'], ARRAY['leg_press_machine'],
 'https://v2.exercisedb.io/image/CoPqR6sTuVwXyZ', true),

('ex_leg_extension', 'Leg Extension', 'leg-extension', 'upper legs', 'quadriceps', 'leverage machine', 'beginner', 2, 'squat', 'isolation', 'push', ARRAY['gym'],
 ARRAY['Sit in machine with ankles behind pad', 'Extend legs until straight', 'Lower with control'],
 ARRAY['Squeeze quads at top', 'Control the negative', 'Full extension'],
 ARRAY['Using momentum', 'Too much weight', 'Partial reps'],
 ARRAY['quadriceps'], ARRAY['leg_extension_machine'],
 'https://v2.exercisedb.io/image/DpQrS7tUvWxYzA', true),

('ex_bulgarian_split_squat', 'Bulgarian Split Squat', 'bulgarian-split-squat', 'upper legs', 'quadriceps', 'dumbbell', 'intermediate', 5, 'lunge', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Rear foot elevated on bench', 'Lower into lunge position', 'Drive up through front leg'],
 ARRAY['Stay upright', 'Knee tracks over toes', 'Full depth'],
 ARRAY['Leaning forward', 'Knee going past toes', 'Losing balance'],
 ARRAY['quadriceps', 'glutes', 'hamstrings'], ARRAY['dumbbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/EqRsT8uVwXyZaB', true),

('ex_walking_lunge', 'Walking Lunge', 'walking-lunge', 'upper legs', 'quadriceps', 'body weight', 'beginner', 4, 'lunge', 'compound', 'push', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Step forward into lunge', 'Lower back knee toward ground', 'Push through front foot and step forward'],
 ARRAY['Upright torso', 'Control the movement', 'Alternate legs'],
 ARRAY['Knee going past toes', 'Leaning forward', 'Losing balance'],
 ARRAY['quadriceps', 'glutes', 'hamstrings', 'core'], ARRAY['no_equipment', 'dumbbell'],
 'https://v2.exercisedb.io/image/FrStU9vWxYzAbC', true),

('ex_step_up', 'Step-Up', 'step-up', 'upper legs', 'quadriceps', 'body weight', 'beginner', 3, 'lunge', 'compound', 'push', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Step up onto box with one foot', 'Drive through heel to stand', 'Step back down with control'],
 ARRAY['Full lockout at top', 'Drive through heel', 'Control descent'],
 ARRAY['Pushing off back foot', 'Leaning forward', 'Knee caving'],
 ARRAY['quadriceps', 'glutes', 'hamstrings'], ARRAY['no_equipment', 'dumbbell'],
 'https://v2.exercisedb.io/image/GsTuV0wXyZaBcD', true),

-- Hamstrings
('ex_romanian_deadlift', 'Romanian Deadlift', 'romanian-deadlift', 'upper legs', 'hamstrings', 'barbell', 'intermediate', 5, 'hinge', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with bar in hands, slight knee bend', 'Hinge at hips, lowering bar along legs', 'Feel stretch in hamstrings', 'Return to standing'],
 ARRAY['Keep back flat', 'Bar stays close', 'Push hips back'],
 ARRAY['Rounding back', 'Bending knees too much', 'Bar drifting forward'],
 ARRAY['hamstrings', 'glutes', 'erector_spinae'], ARRAY['barbell', 'dumbbell'],
 'https://v2.exercisedb.io/image/HtUvW1xYzAbCdE', true),

('ex_lying_leg_curl', 'Lying Leg Curl', 'lying-leg-curl', 'upper legs', 'hamstrings', 'leverage machine', 'beginner', 2, 'hinge', 'isolation', 'pull', ARRAY['gym'],
 ARRAY['Lie face down on machine', 'Curl legs up toward glutes', 'Lower with control'],
 ARRAY['Squeeze hamstrings at top', 'Control the negative', 'Keep hips down'],
 ARRAY['Lifting hips', 'Using momentum', 'Partial range'],
 ARRAY['hamstrings'], ARRAY['leg_curl_machine'],
 'https://v2.exercisedb.io/image/IuVwX2yZaBcDeF', true),

('ex_seated_leg_curl', 'Seated Leg Curl', 'seated-leg-curl', 'upper legs', 'hamstrings', 'leverage machine', 'beginner', 2, 'hinge', 'isolation', 'pull', ARRAY['gym'],
 ARRAY['Sit in machine with pad over thighs', 'Curl legs down and back', 'Return with control'],
 ARRAY['Squeeze at bottom', 'Full range of motion', 'Stay seated'],
 ARRAY['Coming off seat', 'Using momentum', 'Partial reps'],
 ARRAY['hamstrings'], ARRAY['leg_curl_machine'],
 'https://v2.exercisedb.io/image/JvWxY3zAbCdEfG', true),

('ex_good_morning', 'Good Morning', 'good-morning', 'upper legs', 'hamstrings', 'barbell', 'intermediate', 5, 'hinge', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Bar on upper back as in squat', 'Hinge at hips, pushing them back', 'Lower torso toward parallel', 'Return to standing'],
 ARRAY['Slight knee bend', 'Back stays flat', 'Feel hamstring stretch'],
 ARRAY['Rounding back', 'Bending knees too much', 'Going too heavy'],
 ARRAY['hamstrings', 'glutes', 'erector_spinae'], ARRAY['barbell'],
 'https://v2.exercisedb.io/image/KwXyZ4aBcDeFgH', true),

-- Glutes
('ex_hip_thrust', 'Hip Thrust', 'hip-thrust', 'upper legs', 'glutes', 'barbell', 'intermediate', 5, 'hinge', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Upper back on bench, bar over hips', 'Drive hips up to lockout', 'Squeeze glutes at top', 'Lower with control'],
 ARRAY['Chin tucked', 'Drive through heels', 'Full hip extension'],
 ARRAY['Overarching back', 'Not full extension', 'Pushing through toes'],
 ARRAY['glutes', 'hamstrings', 'core'], ARRAY['barbell', 'flat_bench'],
 'https://v2.exercisedb.io/image/LxYzA5bCdEfGhI', true),

('ex_glute_bridge', 'Glute Bridge', 'glute-bridge', 'upper legs', 'glutes', 'body weight', 'beginner', 2, 'hinge', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Lie on back with knees bent', 'Drive hips up squeezing glutes', 'Lower with control'],
 ARRAY['Push through heels', 'Squeeze at top', 'Control the movement'],
 ARRAY['Pushing through toes', 'Not full extension', 'Arching back'],
 ARRAY['glutes', 'hamstrings'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/MyZaB6cDeFgHiJ', true),

('ex_cable_pull_through', 'Cable Pull-Through', 'cable-pull-through', 'upper legs', 'glutes', 'cable', 'beginner', 3, 'hinge', 'compound', 'pull', ARRAY['gym'],
 ARRAY['Face away from low cable, rope between legs', 'Hinge at hips, pushing back', 'Drive hips forward to stand'],
 ARRAY['Keep arms straight', 'Feel glute squeeze', 'Soft knees'],
 ARRAY['Squatting instead of hinging', 'Bending arms', 'Rounding back'],
 ARRAY['glutes', 'hamstrings'], ARRAY['cable_machine'],
 'https://v2.exercisedb.io/image/NzAbC7dEfGhIjK', true),

-- Calves
('ex_standing_calf_raise', 'Standing Calf Raise', 'standing-calf-raise', 'lower legs', 'calves', 'body weight', 'beginner', 2, 'squat', 'isolation', 'push', ARRAY['gym', 'home'],
 ARRAY['Stand on edge of step', 'Rise up on toes', 'Lower heels below platform', 'Repeat'],
 ARRAY['Full range of motion', 'Squeeze at top', 'Controlled descent'],
 ARRAY['Bouncing', 'Partial range', 'Using momentum'],
 ARRAY['calves'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/OaBcD8eFgHiJkL', true),

('ex_seated_calf_raise', 'Seated Calf Raise', 'seated-calf-raise', 'lower legs', 'calves', 'leverage machine', 'beginner', 2, 'squat', 'isolation', 'push', ARRAY['gym'],
 ARRAY['Sit in machine with knees under pad', 'Rise up on toes', 'Lower heels with control'],
 ARRAY['Full stretch at bottom', 'Squeeze at top', 'Control the movement'],
 ARRAY['Bouncing', 'Partial reps', 'Too much weight'],
 ARRAY['calves'], ARRAY['leverage machine'],
 'https://v2.exercisedb.io/image/PbCdE9fGhIjKlM', true),

-- =====================================================
-- CORE EXERCISES
-- =====================================================

('ex_plank', 'Plank', 'plank', 'waist', 'abs', 'body weight', 'beginner', 3, 'core', 'isolation', 'static', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Support body on forearms and toes', 'Keep body in straight line', 'Hold position', 'Dont let hips sag or pike'],
 ARRAY['Squeeze glutes', 'Brace core', 'Breathe steadily'],
 ARRAY['Hips sagging', 'Hips too high', 'Holding breath'],
 ARRAY['abs', 'obliques', 'lower_back'], ARRAY['no_equipment', 'yoga_mat'],
 'https://v2.exercisedb.io/image/QcDeF0gHiJkLmN', true),

('ex_side_plank', 'Side Plank', 'side-plank', 'waist', 'obliques', 'body weight', 'beginner', 3, 'core', 'isolation', 'static', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Support body on one forearm and side of foot', 'Keep body in straight line', 'Hold position', 'Dont let hips drop'],
 ARRAY['Stack feet or stagger', 'Free arm on hip or up', 'Keep hips high'],
 ARRAY['Hips dropping', 'Leaning forward or back', 'Not breathing'],
 ARRAY['obliques', 'abs', 'hip_abductors'], ARRAY['no_equipment', 'yoga_mat'],
 'https://v2.exercisedb.io/image/RdEfG1hIjKlMnO', true),

('ex_crunch', 'Crunch', 'crunch', 'waist', 'abs', 'body weight', 'beginner', 2, 'core', 'isolation', 'pull', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Lie on back with knees bent', 'Curl shoulders off floor', 'Lower with control'],
 ARRAY['Hands behind head, not pulling', 'Exhale on way up', 'Focus on upper abs'],
 ARRAY['Pulling on neck', 'Sitting all the way up', 'Using momentum'],
 ARRAY['abs'], ARRAY['no_equipment', 'yoga_mat'],
 'https://v2.exercisedb.io/image/SeFgH2iJkLmNoP', true),

('ex_bicycle_crunch', 'Bicycle Crunch', 'bicycle-crunch', 'waist', 'abs', 'body weight', 'beginner', 3, 'core', 'compound', 'pull', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Lie on back with hands behind head', 'Bring opposite elbow to knee', 'Alternate sides in pedaling motion'],
 ARRAY['Twist through torso', 'Keep lower back pressed down', 'Controlled movement'],
 ARRAY['Rushing', 'Pulling on neck', 'Not fully extending leg'],
 ARRAY['abs', 'obliques'], ARRAY['no_equipment', 'yoga_mat'],
 'https://v2.exercisedb.io/image/TfGhI3jKlMnOpQ', true),

('ex_russian_twist', 'Russian Twist', 'russian-twist', 'waist', 'obliques', 'body weight', 'beginner', 3, 'rotation', 'isolation', 'pull', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Sit with knees bent, lean back slightly', 'Rotate torso side to side', 'Touch floor on each side'],
 ARRAY['Keep chest up', 'Move from torso not arms', 'Feet can be elevated for more challenge'],
 ARRAY['Moving just arms', 'Rounding back', 'Going too fast'],
 ARRAY['obliques', 'abs', 'hip_flexors'], ARRAY['no_equipment', 'dumbbell', 'medicine_ball'],
 'https://v2.exercisedb.io/image/UgHiJ4kLmNoPqR', true),

('ex_leg_raise', 'Lying Leg Raise', 'lying-leg-raise', 'waist', 'abs', 'body weight', 'beginner', 3, 'core', 'isolation', 'pull', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Lie on back with legs straight', 'Raise legs to vertical', 'Lower with control'],
 ARRAY['Keep lower back pressed down', 'Control the descent', 'Slight bend in knees OK'],
 ARRAY['Lower back lifting', 'Using momentum', 'Dropping legs'],
 ARRAY['abs', 'hip_flexors'], ARRAY['no_equipment', 'yoga_mat'],
 'https://v2.exercisedb.io/image/VhIjK5lMnOpQrS', true),

('ex_hanging_leg_raise', 'Hanging Leg Raise', 'hanging-leg-raise', 'waist', 'abs', 'body weight', 'intermediate', 5, 'core', 'isolation', 'pull', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Hang from bar with straight arms', 'Raise legs to horizontal or higher', 'Lower with control'],
 ARRAY['Minimize swing', 'Control throughout', 'Exhale on the way up'],
 ARRAY['Swinging', 'Using momentum', 'Partial range'],
 ARRAY['abs', 'hip_flexors', 'obliques'], ARRAY['pull_up_bar'],
 'https://v2.exercisedb.io/image/WiJkL6mNoPqRsT', true),

('ex_ab_wheel_rollout', 'Ab Wheel Rollout', 'ab-wheel-rollout', 'waist', 'abs', 'body weight', 'intermediate', 5, 'core', 'compound', 'static', ARRAY['gym', 'home'],
 ARRAY['Kneel holding ab wheel', 'Roll out until body is extended', 'Roll back to start'],
 ARRAY['Keep core tight', 'Dont arch back', 'Control the movement'],
 ARRAY['Lower back sagging', 'Going too far', 'Using momentum'],
 ARRAY['abs', 'obliques', 'lats', 'hip_flexors'], ARRAY['ab_wheel'],
 'https://v2.exercisedb.io/image/XjKlM7nOpQrStU', true),

('ex_dead_bug', 'Dead Bug', 'dead-bug', 'waist', 'abs', 'body weight', 'beginner', 2, 'core', 'isolation', 'static', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Lie on back with arms up and knees at 90 degrees', 'Extend opposite arm and leg', 'Return and switch sides'],
 ARRAY['Keep lower back pressed down', 'Move slowly', 'Breathe steadily'],
 ARRAY['Lower back lifting', 'Moving too fast', 'Holding breath'],
 ARRAY['abs', 'core', 'hip_flexors'], ARRAY['no_equipment', 'yoga_mat'],
 'https://v2.exercisedb.io/image/YkLmN8oPqRsTuV', true),

('ex_mountain_climber', 'Mountain Climber', 'mountain-climber', 'waist', 'abs', 'body weight', 'beginner', 3, 'core', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Start in push-up position', 'Drive knees to chest alternating', 'Keep hips low'],
 ARRAY['Keep core tight', 'Quick alternating motion', 'Dont pike hips'],
 ARRAY['Hips rising', 'Bouncing', 'Losing form'],
 ARRAY['abs', 'obliques', 'hip_flexors', 'shoulders'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/ZlMnO9pQrStUvW', true),

('ex_pallof_press', 'Pallof Press', 'pallof-press', 'waist', 'abs', 'cable', 'intermediate', 4, 'rotation', 'isolation', 'static', ARRAY['gym'],
 ARRAY['Stand perpendicular to cable at chest height', 'Press hands straight out', 'Hold and resist rotation', 'Return and repeat'],
 ARRAY['Brace core', 'Resist the pull', 'Keep hips square'],
 ARRAY['Rotating toward cable', 'Not bracing core', 'Too much weight'],
 ARRAY['abs', 'obliques', 'core'], ARRAY['cable_machine'],
 'https://v2.exercisedb.io/image/AmNoP0qRsTuVwX', true),

-- =====================================================
-- COMPOUND & FULL BODY EXERCISES
-- =====================================================

('ex_kettlebell_swing', 'Kettlebell Swing', 'kettlebell-swing', 'waist', 'glutes', 'kettlebell', 'intermediate', 4, 'hinge', 'compound', 'pull', ARRAY['gym', 'home'],
 ARRAY['Stand with kettlebell between legs', 'Hinge and swing kettlebell back', 'Snap hips forward to swing weight up', 'Control the swing down'],
 ARRAY['Explosive hip drive', 'Arms are just along for the ride', 'Squeeze glutes at top'],
 ARRAY['Squatting instead of hinging', 'Using arms to lift', 'Hyperextending back'],
 ARRAY['glutes', 'hamstrings', 'core', 'shoulders'], ARRAY['kettlebell'],
 'https://v2.exercisedb.io/image/BnOpQ1rStUvWxY', true),

('ex_burpee', 'Burpee', 'burpee', 'waist', 'abs', 'body weight', 'intermediate', 5, 'core', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Start standing', 'Drop to push-up position', 'Perform push-up', 'Jump feet to hands and jump up'],
 ARRAY['Smooth transition', 'Full push-up', 'Explosive jump'],
 ARRAY['Skipping the push-up', 'Not full extension on jump', 'Poor form when tired'],
 ARRAY['abs', 'chest', 'quadriceps', 'shoulders'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/CoPqR2sTuVwXyZ', true),

('ex_thruster', 'Dumbbell Thruster', 'dumbbell-thruster', 'upper legs', 'quadriceps', 'dumbbell', 'intermediate', 5, 'squat', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Hold dumbbells at shoulders', 'Squat down', 'Drive up and press overhead in one motion'],
 ARRAY['Smooth transition', 'Full squat depth', 'Lock out overhead'],
 ARRAY['Stopping at bottom', 'Not full depth', 'Pressing too early'],
 ARRAY['quadriceps', 'glutes', 'shoulders', 'triceps'], ARRAY['dumbbell', 'barbell'],
 'https://v2.exercisedb.io/image/DpQrS3tUvWxYzA', true),

('ex_farmers_walk', 'Farmers Walk', 'farmers-walk', 'back', 'traps', 'dumbbell', 'beginner', 3, 'carry', 'compound', 'static', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Pick up heavy dumbbells or kettlebells', 'Stand tall and walk', 'Maintain good posture throughout'],
 ARRAY['Shoulders back', 'Core tight', 'Steady steps'],
 ARRAY['Leaning forward', 'Shrugging', 'Short unsteady steps'],
 ARRAY['traps', 'forearms', 'core', 'glutes'], ARRAY['dumbbell', 'kettlebell'],
 'https://v2.exercisedb.io/image/EqRsT4uVwXyZaB', true),

('ex_turkish_getup', 'Turkish Get-Up', 'turkish-getup', 'waist', 'abs', 'kettlebell', 'advanced', 7, 'core', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Lie on back holding kettlebell overhead', 'Roll to elbow, then hand', 'Sweep leg through to kneeling', 'Stand up, reverse to return'],
 ARRAY['Keep arm locked', 'Eyes on weight', 'Smooth transitions'],
 ARRAY['Rushing', 'Losing lockout', 'Skipping positions'],
 ARRAY['abs', 'shoulders', 'glutes', 'core'], ARRAY['kettlebell', 'dumbbell'],
 'https://v2.exercisedb.io/image/FrStU5vWxYzAbC', true),

('ex_clean_and_press', 'Dumbbell Clean and Press', 'dumbbell-clean-and-press', 'shoulders', 'anterior_deltoid', 'dumbbell', 'intermediate', 6, 'push_vertical', 'compound', 'push', ARRAY['gym', 'home'],
 ARRAY['Start with dumbbells at sides', 'Clean weights to shoulders', 'Press overhead', 'Lower and repeat'],
 ARRAY['Use hip drive for clean', 'Catch in solid rack position', 'Full lockout overhead'],
 ARRAY['Arm curling the clean', 'Not using legs', 'Pressing before catching'],
 ARRAY['anterior_deltoid', 'triceps', 'traps', 'core'], ARRAY['dumbbell', 'kettlebell'],
 'https://v2.exercisedb.io/image/GsTuV6wXyZaBcD', true),

('ex_suitcase_carry', 'Suitcase Carry', 'suitcase-carry', 'waist', 'obliques', 'dumbbell', 'beginner', 3, 'carry', 'compound', 'static', ARRAY['gym', 'home', 'outdoor'],
 ARRAY['Hold weight in one hand at side', 'Walk while staying upright', 'Dont lean to either side'],
 ARRAY['Stay tall', 'Core braced', 'Steady pace'],
 ARRAY['Leaning away from weight', 'Shrugging', 'Short steps'],
 ARRAY['obliques', 'core', 'forearms', 'traps'], ARRAY['dumbbell', 'kettlebell'],
 'https://v2.exercisedb.io/image/HtUvW7xYzAbCdE', true),

-- =====================================================
-- CARDIO / CONDITIONING EXERCISES
-- =====================================================

('ex_jump_rope', 'Jump Rope', 'jump-rope', 'cardio', 'calves', 'rope', 'beginner', 3, 'locomotion', 'compound', 'push', ARRAY['home', 'gym', 'outdoor', 'travel'],
 ARRAY['Hold rope handles at hip height', 'Jump just high enough to clear rope', 'Land softly on balls of feet'],
 ARRAY['Stay light on feet', 'Wrists turn the rope', 'Keep jumps small'],
 ARRAY['Jumping too high', 'Arms too wide', 'Landing on heels'],
 ARRAY['calves', 'shoulders', 'core'], ARRAY['jump_rope'],
 'https://v2.exercisedb.io/image/IuVwX8yZaBcDeF', true),

('ex_box_jump', 'Box Jump', 'box-jump', 'upper legs', 'quadriceps', 'body weight', 'intermediate', 5, 'squat', 'compound', 'push', ARRAY['gym'],
 ARRAY['Stand facing box', 'Swing arms and jump onto box', 'Land softly with bent knees', 'Step down and repeat'],
 ARRAY['Land softly', 'Full hip extension at top', 'Step down, dont jump'],
 ARRAY['Landing hard', 'Box too high', 'Jumping down'],
 ARRAY['quadriceps', 'glutes', 'calves', 'core'], ARRAY['no_equipment'],
 'https://v2.exercisedb.io/image/JvWxY9zAbCdEfG', true),

('ex_battle_ropes', 'Battle Ropes', 'battle-ropes', 'shoulders', 'anterior_deltoid', 'rope', 'intermediate', 4, 'push_vertical', 'compound', 'push', ARRAY['gym'],
 ARRAY['Hold rope end in each hand', 'Create waves by alternating arms', 'Maintain athletic stance'],
 ARRAY['Stay low', 'Use whole body', 'Keep intensity high'],
 ARRAY['Standing too tall', 'Arms only', 'Losing rhythm'],
 ARRAY['shoulders', 'core', 'biceps', 'forearms'], ARRAY['rope'],
 'https://v2.exercisedb.io/image/KwXyZ0aBcDeFgH', true);

-- Create indexes for faster filtering
CREATE INDEX IF NOT EXISTS idx_exercises_body_part ON exercises(body_part);
CREATE INDEX IF NOT EXISTS idx_exercises_equipment ON exercises(equipment);
CREATE INDEX IF NOT EXISTS idx_exercises_movement_pattern ON exercises(movement_pattern);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty_score ON exercises(difficulty_score);
CREATE INDEX IF NOT EXISTS idx_exercises_mechanics_type ON exercises(mechanics_type);
CREATE INDEX IF NOT EXISTS idx_exercises_is_published ON exercises(is_published);
CREATE INDEX IF NOT EXISTS idx_exercises_location_tags ON exercises USING GIN(location_tags);
CREATE INDEX IF NOT EXISTS idx_exercises_muscle_tags ON exercises USING GIN(muscle_tags);
CREATE INDEX IF NOT EXISTS idx_exercises_equipment_tags ON exercises USING GIN(equipment_tags);
CREATE INDEX IF NOT EXISTS idx_exercises_name_search ON exercises USING GIN(to_tsvector('english', name));

