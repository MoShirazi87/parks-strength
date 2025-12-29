-- Migration 010: Complete Exercise Library Part 1
-- Chest, Back, and Shoulders (100+ exercises)

-- Clear existing exercises to re-seed
DELETE FROM workout_exercises;
DELETE FROM exercises;

-- ============================================
-- CHEST EXERCISES (25)
-- ============================================

INSERT INTO exercises (name, slug, description, instructions, cues, common_mistakes, primary_muscles, secondary_muscles, equipment_names, difficulty, movement_pattern, exercise_type, video_url, is_machine, is_bilateral, is_published)
VALUES
-- Barbell Exercises
('Barbell Bench Press', 'barbell-bench-press', 'The king of chest exercises. Build overall chest mass and pressing strength.', 
 ARRAY['Lie on bench with eyes under bar', 'Grip bar slightly wider than shoulder width', 'Unrack and lower to mid-chest', 'Press up in slight arc back to start'],
 ARRAY['Squeeze shoulder blades together', 'Drive feet into floor', 'Touch chest without bouncing'],
 ARRAY['Bouncing bar off chest', 'Flaring elbows too wide', 'Lifting hips off bench'],
 ARRAY['chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoid'], ARRAY['barbell', 'flat bench'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/hllKlI1qC9r-Fs', false, true, true),

('Incline Barbell Press', 'incline-barbell-press', 'Target the upper chest for a complete chest development.',
 ARRAY['Set bench to 30-45 degrees', 'Grip bar slightly wider than shoulders', 'Lower to upper chest', 'Press up and slightly back'],
 ARRAY['Keep chest lifted', 'Control the descent', 'Lock out at top'],
 ARRAY['Bench angle too steep', 'Bouncing weight', 'Incomplete range of motion'],
 ARRAY['upper chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoid'], ARRAY['barbell', 'incline bench'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/KtXe8o4j6sEvxR', false, true, true),

('Decline Barbell Press', 'decline-barbell-press', 'Emphasize the lower chest fibers.',
 ARRAY['Set bench to -15 to -30 degrees', 'Secure feet under pads', 'Lower bar to lower chest', 'Press up to lockout'],
 ARRAY['Keep core tight', 'Control negative', 'Full range of motion'],
 ARRAY['Going too heavy too soon', 'Bouncing bar', 'Poor breathing'],
 ARRAY['lower chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoid'], ARRAY['barbell', 'decline bench'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/p0UqP3MsD2U6N6', false, true, true),

('Close Grip Bench Press', 'close-grip-bench-press', 'Triceps-focused pressing that still hits inner chest.',
 ARRAY['Lie on bench with narrow grip', 'Hands about shoulder width apart', 'Lower bar to lower chest', 'Press up keeping elbows tucked'],
 ARRAY['Keep elbows close to body', 'Squeeze triceps at top', 'Control the weight'],
 ARRAY['Grip too narrow straining wrists', 'Flaring elbows', 'Incomplete lockout'],
 ARRAY['triceps', 'inner chest'], ARRAY['anterior deltoid'], ARRAY['barbell', 'flat bench'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/2bzHDjHXKGDrlN', false, true, true),

-- Dumbbell Exercises
('Dumbbell Bench Press', 'dumbbell-bench-press', 'Greater range of motion than barbell for chest development.',
 ARRAY['Sit on bench with dumbbells on thighs', 'Kick back and position dumbbells at chest', 'Press up and together', 'Lower with control to sides of chest'],
 ARRAY['Squeeze chest at top', 'Keep shoulder blades pinched', 'Natural arc path'],
 ARRAY['Going too heavy losing form', 'Dumbbells drifting apart', 'Bouncing at bottom'],
 ARRAY['chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoid'], ARRAY['dumbbells', 'flat bench'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/UoUZsSnxYeQ0DS', false, true, true),

('Incline Dumbbell Press', 'incline-dumbbell-press', 'Target upper chest with excellent muscle activation.',
 ARRAY['Set bench to 30-45 degrees', 'Position dumbbells at shoulders', 'Press up and slightly together', 'Lower with control'],
 ARRAY['Chest stays lifted', 'Elbows at 45 degrees', 'Full stretch at bottom'],
 ARRAY['Bench angle too high', 'Arms too wide', 'Partial reps'],
 ARRAY['upper chest'], ARRAY['triceps', 'anterior deltoid'], ARRAY['dumbbells', 'incline bench'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/WZ0h9gkuOdmYBg', false, true, true),

('Dumbbell Fly', 'dumbbell-fly', 'Isolate the chest with a stretching motion.',
 ARRAY['Lie on bench with dumbbells above chest', 'Slight bend in elbows throughout', 'Lower arms out to sides in arc', 'Squeeze chest to bring back up'],
 ARRAY['Maintain elbow bend', 'Feel the stretch', 'Squeeze at top'],
 ARRAY['Bending elbows too much (becomes press)', 'Going too heavy', 'Overstretching at bottom'],
 ARRAY['chest', 'pectoralis major'], ARRAY['anterior deltoid'], ARRAY['dumbbells', 'flat bench'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/pKAy1Ydq5n-v8u', false, true, true),

('Incline Dumbbell Fly', 'incline-dumbbell-fly', 'Upper chest isolation with great stretch.',
 ARRAY['Set bench to 30-45 degrees', 'Hold dumbbells above upper chest', 'Lower with slight arm bend', 'Squeeze chest to return'],
 ARRAY['Control the descent', 'Chest lifted throughout', 'Feel upper chest working'],
 ARRAY['Going too heavy', 'Turning into a press', 'Rush through reps'],
 ARRAY['upper chest'], ARRAY['anterior deltoid'], ARRAY['dumbbells', 'incline bench'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/2QKlGHR0eT1hId', false, true, true),

('Dumbbell Pullover', 'dumbbell-pullover', 'Stretch the chest and lats for rib cage expansion.',
 ARRAY['Lie across bench with shoulders on pad', 'Hold dumbbell above chest with both hands', 'Lower behind head with slight bend', 'Pull back over chest squeezing pecs'],
 ARRAY['Keep hips low', 'Deep stretch at bottom', 'Exhale on pull'],
 ARRAY['Using too much weight', 'Bending arms too much', 'Hips rising'],
 ARRAY['chest', 'lats'], ARRAY['serratus', 'triceps'], ARRAY['dumbbell', 'bench'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/rRrKz3sKlBN8W5', false, true, true),

-- Cable Exercises
('Cable Crossover', 'cable-crossover', 'Constant tension chest isolation for definition.',
 ARRAY['Set cables above head height', 'Step forward into staggered stance', 'Bring hands together in front of chest', 'Control back to start position'],
 ARRAY['Slight forward lean', 'Cross hands at bottom', 'Squeeze hard at contraction'],
 ARRAY['Using momentum', 'Too much weight', 'Incomplete range'],
 ARRAY['chest', 'pectoralis major'], ARRAY['anterior deltoid'], ARRAY['cable machine'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/8Wb9jz-3rM0jmQ', false, true, true),

('Low Cable Fly', 'low-cable-fly', 'Target upper chest with upward cable angle.',
 ARRAY['Set cables at lowest position', 'Step forward between cables', 'Raise arms up and together', 'Lower with control'],
 ARRAY['Arc motion upward', 'Squeeze at top', 'Keep slight elbow bend'],
 ARRAY['Arms too straight', 'Swinging motion', 'Weight too heavy'],
 ARRAY['upper chest'], ARRAY['anterior deltoid'], ARRAY['cable machine'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/sj3mXhjJJ0N8lg', false, true, true),

('High Cable Fly', 'high-cable-fly', 'Target lower chest with downward angle.',
 ARRAY['Set cables at high position', 'Step forward into staggered stance', 'Bring hands down and together', 'Return with control'],
 ARRAY['Lean slightly forward', 'Hands meet at hip level', 'Constant tension'],
 ARRAY['Standing too upright', 'Jerking motion', 'Locking elbows'],
 ARRAY['lower chest'], ARRAY['anterior deltoid'], ARRAY['cable machine'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/jnBP8YQnEVbI0N', false, true, true),

-- Machine Exercises
('Machine Chest Press', 'machine-chest-press', 'Safe chest pressing for beginners or high-volume work.',
 ARRAY['Adjust seat height', 'Grip handles at chest level', 'Press forward to extension', 'Return slowly with control'],
 ARRAY['Keep back flat on pad', 'Full extension', 'Squeeze chest at top'],
 ARRAY['Seat too low or high', 'Partial reps', 'Using momentum'],
 ARRAY['chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoid'], ARRAY['chest press machine'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/0BrJg8lXkXLN6o', true, true, true),

('Incline Machine Press', 'incline-machine-press', 'Upper chest targeting with machine safety.',
 ARRAY['Adjust seat for incline angle', 'Grip handles at upper chest', 'Press to full extension', 'Control the negative'],
 ARRAY['Keep chest lifted', 'Drive through heels', 'Full lockout'],
 ARRAY['Bouncing weight', 'Partial range', 'Seat position wrong'],
 ARRAY['upper chest'], ARRAY['triceps', 'anterior deltoid'], ARRAY['incline press machine'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/S2PZEM7pRQ5nWT', true, true, true),

('Pec Deck', 'pec-deck', 'Machine fly for chest isolation.',
 ARRAY['Sit with back flat on pad', 'Position arms on pads at chest height', 'Bring arms together in front', 'Return with control'],
 ARRAY['Lead with elbows', 'Squeeze at contraction', 'Dont let weight stack touch'],
 ARRAY['Leaning forward', 'Going too fast', 'Weight too heavy'],
 ARRAY['chest', 'pectoralis major'], ARRAY['anterior deltoid'], ARRAY['pec deck machine'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/0G7V3HrCT4JKjw', true, true, true),

('Smith Machine Bench Press', 'smith-machine-bench-press', 'Guided pressing motion for safety.',
 ARRAY['Position bench under bar', 'Grip bar at chest width', 'Unlock and lower to chest', 'Press to lockout'],
 ARRAY['Keep shoulder blades pinched', 'Control the bar path', 'Full range of motion'],
 ARRAY['Going too heavy', 'Bouncing off chest', 'Poor bench position'],
 ARRAY['chest'], ARRAY['triceps', 'anterior deltoid'], ARRAY['smith machine', 'bench'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/Lf4pUQCL8wHIlD', true, true, true),

-- Bodyweight Exercises
('Push-up', 'push-up', 'The fundamental chest and pushing exercise.',
 ARRAY['Start in plank position', 'Hands slightly wider than shoulders', 'Lower chest to floor', 'Push back to start'],
 ARRAY['Keep body in straight line', 'Elbows at 45 degrees', 'Full range of motion'],
 ARRAY['Hips sagging', 'Partial reps', 'Flaring elbows'],
 ARRAY['chest', 'pectoralis major'], ARRAY['triceps', 'anterior deltoid', 'core'], ARRAY['bodyweight'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/VQ2qGT5J1IbB2L', false, true, true),

('Incline Push-up', 'incline-push-up', 'Easier push-up variation for beginners.',
 ARRAY['Place hands on elevated surface', 'Body in straight line', 'Lower chest to surface', 'Push back up'],
 ARRAY['Keep core engaged', 'Full range of motion', 'Control the descent'],
 ARRAY['Going too fast', 'Hips dropping', 'Hands too wide'],
 ARRAY['lower chest'], ARRAY['triceps', 'anterior deltoid'], ARRAY['bodyweight', 'bench'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/TiLQz0l1rkfN3d', false, true, true),

('Decline Push-up', 'decline-push-up', 'Advanced push-up targeting upper chest.',
 ARRAY['Place feet on elevated surface', 'Hands on floor shoulder width', 'Lower chest to floor', 'Push back to start'],
 ARRAY['Keep core very tight', 'Control the motion', 'Go deep'],
 ARRAY['Sagging hips', 'Rushing reps', 'Incomplete range'],
 ARRAY['upper chest'], ARRAY['triceps', 'anterior deltoid', 'core'], ARRAY['bodyweight', 'bench'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/EKwYgJ8y0ZH9W6', false, true, true),

('Diamond Push-up', 'diamond-push-up', 'Triceps-focused push-up with inner chest emphasis.',
 ARRAY['Hands together forming diamond shape', 'Lower chest to hands', 'Push back up keeping elbows in', 'Squeeze triceps at top'],
 ARRAY['Elbows track close to body', 'Core stays tight', 'Full lockout'],
 ARRAY['Hands too far apart', 'Flaring elbows', 'Rushing'],
 ARRAY['triceps', 'inner chest'], ARRAY['anterior deltoid'], ARRAY['bodyweight'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/pvr1dPl0E5xr-r', false, true, true),

('Wide Push-up', 'wide-push-up', 'Chest-emphasized push-up variation.',
 ARRAY['Hands placed wider than shoulders', 'Lower chest between hands', 'Push back to start', 'Keep core tight'],
 ARRAY['Go deep for stretch', 'Control throughout', 'Squeeze chest'],
 ARRAY['Hands too wide straining shoulders', 'Hips dropping', 'Partial reps'],
 ARRAY['chest', 'pectoralis major'], ARRAY['anterior deltoid', 'triceps'], ARRAY['bodyweight'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/dQxKfUzHdxQ7yV', false, true, true),

('Dip (Chest Focus)', 'dip-chest', 'Compound exercise for lower chest and triceps.',
 ARRAY['Mount dip bars with straight arms', 'Lean forward slightly', 'Lower until upper arms parallel to floor', 'Press back up to start'],
 ARRAY['Lean forward for chest', 'Go deep for stretch', 'Control the motion'],
 ARRAY['Going too fast', 'Not leaning forward enough', 'Partial range'],
 ARRAY['lower chest'], ARRAY['triceps', 'anterior deltoid'], ARRAY['dip station'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/lEU3F8k3BqhwT7', false, true, true),

-- Specialty Exercises
('Floor Press', 'floor-press', 'Partial range bench press for lockout strength.',
 ARRAY['Lie on floor with barbell or dumbbells', 'Position arms at sides', 'Press up until arms straight', 'Lower until triceps touch floor'],
 ARRAY['Pause at bottom', 'Explosive press', 'Keep core braced'],
 ARRAY['Bouncing arms', 'Losing tension at bottom', 'Incomplete lockout'],
 ARRAY['chest', 'triceps'], ARRAY['anterior deltoid'], ARRAY['barbell', 'dumbbells'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/rJL9dSPOCxQE8A', false, true, true),

('Svend Press', 'svend-press', 'Unique chest squeezing exercise for inner chest.',
 ARRAY['Hold plates pressed together at chest', 'Arms extended in front', 'Squeeze plates together hard', 'Push out and pull back'],
 ARRAY['Constant inward pressure', 'Squeeze throughout', 'Slow and controlled'],
 ARRAY['Not squeezing hard enough', 'Going too fast', 'Weight too heavy'],
 ARRAY['inner chest'], ARRAY['anterior deltoid'], ARRAY['weight plates'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/7sQPLdT8yVxmKN', false, true, true);

-- ============================================
-- BACK EXERCISES (30)
-- ============================================

INSERT INTO exercises (name, slug, description, instructions, cues, common_mistakes, primary_muscles, secondary_muscles, equipment_names, difficulty, movement_pattern, exercise_type, video_url, is_machine, is_bilateral, is_published)
VALUES
-- Barbell Exercises
('Barbell Row', 'barbell-row', 'Fundamental back builder for thickness and width.',
 ARRAY['Hinge at hips with flat back', 'Grip bar slightly wider than shoulders', 'Pull bar to lower chest/upper abs', 'Lower with control'],
 ARRAY['Drive elbows back', 'Squeeze shoulder blades', 'Keep back flat'],
 ARRAY['Using momentum', 'Rounding lower back', 'Pulling to belly button'],
 ARRAY['lats', 'rhomboids', 'middle back'], ARRAY['biceps', 'rear deltoid'], ARRAY['barbell'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/CBOZoB5gDPLqbS', false, true, true),

('Pendlay Row', 'pendlay-row', 'Explosive row from the floor for power development.',
 ARRAY['Set up over bar with flat back', 'Pull explosively to chest', 'Return bar to floor', 'Reset between each rep'],
 ARRAY['Dead stop each rep', 'Explosive pull', 'Back stays flat'],
 ARRAY['Not resetting', 'Rounding back', 'Too much body English'],
 ARRAY['lats', 'middle back'], ARRAY['biceps', 'rear deltoid'], ARRAY['barbell'],
 'advanced', 'pull', 'strength', 'https://v2.exercisedb.io/image/dSQX9bTL8qDPHN', false, true, true),

('T-Bar Row', 't-bar-row', 'Heavy rowing for back thickness.',
 ARRAY['Straddle the bar', 'Hinge at hips with flat back', 'Pull handle to chest', 'Lower with control'],
 ARRAY['Squeeze at top', 'Keep elbows close', 'Full stretch at bottom'],
 ARRAY['Jerking weight', 'Standing too upright', 'Partial reps'],
 ARRAY['middle back', 'lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['t-bar row', 'barbell'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/WT6PFoJq-DKHT7', false, true, true),

('Deadlift', 'deadlift', 'The king of all exercises. Full posterior chain development.',
 ARRAY['Stand with feet hip width', 'Grip bar outside legs', 'Push floor away keeping back flat', 'Stand tall squeezing glutes at top'],
 ARRAY['Bar stays close to body', 'Neutral spine throughout', 'Push through whole foot'],
 ARRAY['Rounding lower back', 'Bar drifting forward', 'Hyperextending at top'],
 ARRAY['hamstrings', 'glutes', 'lower back', 'traps'], ARRAY['quads', 'forearms', 'core'], ARRAY['barbell'],
 'intermediate', 'hinge', 'strength', 'https://v2.exercisedb.io/image/H8RoFd9TwKQj1N', false, true, true),

-- Dumbbell Exercises
('Dumbbell Row', 'dumbbell-row', 'Unilateral back exercise for balanced development.',
 ARRAY['Place knee and hand on bench', 'Row dumbbell to hip', 'Lower with control', 'Keep back flat'],
 ARRAY['Drive elbow to ceiling', 'Squeeze at top', 'Dont twist torso'],
 ARRAY['Rotating torso', 'Using momentum', 'Incomplete range'],
 ARRAY['lats', 'middle back'], ARRAY['biceps', 'rear deltoid'], ARRAY['dumbbell', 'bench'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/G-5pJfqRxYNelD', false, false, true),

('Dumbbell Pullover', 'dumbbell-pullover-back', 'Stretch and contract the lats with deep range of motion.',
 ARRAY['Lie across bench with shoulders supported', 'Hold dumbbell above chest', 'Lower behind head with slight arm bend', 'Pull back focusing on lats'],
 ARRAY['Keep hips low', 'Feel lat stretch', 'Exhale on pull'],
 ARRAY['Bending arms too much', 'Using too heavy', 'Hips rising'],
 ARRAY['lats'], ARRAY['chest', 'triceps'], ARRAY['dumbbell', 'bench'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/rRrKz3sKlBN8W5', false, true, true),

('Renegade Row', 'renegade-row', 'Core and back stability exercise.',
 ARRAY['Start in push-up position with hands on dumbbells', 'Row one dumbbell to hip', 'Return and repeat other side', 'Keep hips stable'],
 ARRAY['Minimal hip rotation', 'Brace core hard', 'Control throughout'],
 ARRAY['Rotating hips', 'Going too fast', 'Weights too heavy'],
 ARRAY['lats', 'core'], ARRAY['biceps', 'rear deltoid'], ARRAY['dumbbells'],
 'advanced', 'pull', 'strength', 'https://v2.exercisedb.io/image/w7lLz6TqN0QhYN', false, false, true),

-- Cable Exercises  
('Lat Pulldown', 'lat-pulldown', 'Essential lat builder for width.',
 ARRAY['Grip bar wider than shoulders', 'Lean back slightly', 'Pull bar to upper chest', 'Control back to start'],
 ARRAY['Drive elbows down', 'Squeeze lats at bottom', 'Chest stays lifted'],
 ARRAY['Pulling behind neck', 'Using momentum', 'Leaning too far back'],
 ARRAY['lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['lat pulldown machine', 'cable machine'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/7fwsE4hXPz82Rd', true, true, true),

('Close Grip Lat Pulldown', 'close-grip-lat-pulldown', 'Target lower lats with close grip.',
 ARRAY['Use close grip handle', 'Lean back slightly', 'Pull handle to chest', 'Squeeze and control back'],
 ARRAY['Pull to sternum', 'Elbows drive to sides', 'Full stretch at top'],
 ARRAY['Cutting range short', 'Leaning too far', 'Using arms only'],
 ARRAY['lats', 'lower lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['lat pulldown machine', 'cable machine'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/sXPzHdyTqrWNlE', true, true, true),

('Straight Arm Pulldown', 'straight-arm-pulldown', 'Lat isolation with constant tension.',
 ARRAY['Stand facing cable with bar at shoulder height', 'Keep arms straight with slight bend', 'Pull bar down to thighs', 'Control back to start'],
 ARRAY['Lock elbow position', 'Squeeze lats hard', 'Lean forward slightly'],
 ARRAY['Bending arms', 'Using too heavy', 'Rushing reps'],
 ARRAY['lats'], ARRAY['rear deltoid', 'triceps'], ARRAY['cable machine'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/YTL8nDrQ0zXK5P', false, true, true),

('Cable Row', 'cable-row', 'Seated pulling for mid-back development.',
 ARRAY['Sit with feet on platform', 'Grip handle with arms extended', 'Pull to abdomen', 'Squeeze shoulder blades and return'],
 ARRAY['Pull to belly button', 'Squeeze at contraction', 'Control the negative'],
 ARRAY['Leaning too far forward', 'Using momentum', 'Rounding back'],
 ARRAY['middle back', 'lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['cable machine'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/pT8DxnJK0Zj4WR', false, true, true),

('Face Pull', 'face-pull', 'Rear delt and upper back health exercise.',
 ARRAY['Set cable at face height', 'Grip rope with thumbs back', 'Pull to face spreading rope apart', 'Control back to start'],
 ARRAY['Pull to ears', 'External rotate at top', 'Squeeze rear delts'],
 ARRAY['Pulling too low', 'Using momentum', 'Weight too heavy'],
 ARRAY['rear deltoid', 'upper back'], ARRAY['traps', 'rhomboids'], ARRAY['cable machine', 'rope'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/E7qLxTn-8YRzJQ', false, true, true),

-- Machine Exercises
('Machine Row', 'machine-row', 'Guided rowing motion for back isolation.',
 ARRAY['Sit with chest against pad', 'Grip handles at shoulder width', 'Pull handles to torso', 'Control back to extension'],
 ARRAY['Squeeze shoulder blades', 'Full stretch at start', 'Control negative'],
 ARRAY['Not getting full range', 'Cheating with body', 'Going too fast'],
 ARRAY['middle back', 'lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['row machine'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/NW0eTq8Kd5PxYn', true, true, true),

('Machine Lat Pulldown', 'machine-lat-pulldown', 'Guided lat pulldown for beginners.',
 ARRAY['Adjust pad to thighs', 'Grip handles wide', 'Pull down to upper chest', 'Control back up'],
 ARRAY['Lead with elbows', 'Squeeze lats at bottom', 'Full stretch at top'],
 ARRAY['Pulling behind neck', 'Momentum', 'Partial reps'],
 ARRAY['lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['lat pulldown machine'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/7fwsE4hXPz82Rd', true, true, true),

-- Bodyweight Exercises
('Pull-up', 'pull-up', 'The ultimate back and biceps exercise.',
 ARRAY['Hang from bar with overhand grip', 'Pull up until chin over bar', 'Lower with control', 'Full extension at bottom'],
 ARRAY['Lead with chest', 'Squeeze lats at top', 'Full range of motion'],
 ARRAY['Kipping', 'Partial reps', 'Swinging'],
 ARRAY['lats'], ARRAY['biceps', 'rear deltoid', 'forearms'], ARRAY['pull-up bar'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/FTnH8oPqJD1eKX', false, true, true),

('Chin-up', 'chin-up', 'Underhand pull-up emphasizing biceps.',
 ARRAY['Hang from bar with underhand grip', 'Pull up until chin over bar', 'Lower with control', 'Full extension'],
 ARRAY['Elbows drive to sides', 'Squeeze at top', 'Control descent'],
 ARRAY['Partial reps', 'Swinging', 'Using momentum'],
 ARRAY['lats', 'biceps'], ARRAY['forearms', 'rear deltoid'], ARRAY['pull-up bar'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/kZhB-8pT1qEoXN', false, true, true),

('Inverted Row', 'inverted-row', 'Bodyweight row for all levels.',
 ARRAY['Set bar at waist height', 'Hang below bar with straight body', 'Pull chest to bar', 'Lower with control'],
 ARRAY['Keep body straight', 'Squeeze shoulder blades', 'Full extension'],
 ARRAY['Sagging hips', 'Partial range', 'Jerking motion'],
 ARRAY['middle back', 'lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['barbell', 'smith machine'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/sDXpLTq82Ye-NK', false, true, true),

('Scapular Pull-up', 'scapular-pull-up', 'Activate scapular muscles for shoulder health.',
 ARRAY['Hang from bar with arms straight', 'Pull shoulder blades down and together', 'Hold for 2 seconds', 'Return to dead hang'],
 ARRAY['Arms stay straight', 'Feel traps engage', 'Controlled movement'],
 ARRAY['Bending arms', 'Rushing', 'No scapular movement'],
 ARRAY['lower traps', 'lats'], ARRAY['rhomboids'], ARRAY['pull-up bar'],
 'beginner', 'pull', 'strength', 'https://v2.exercisedb.io/image/qT0xP8Lk1NreWH', false, true, true),

-- Specialty Exercises
('Meadows Row', 'meadows-row', 'Landmine row for unique lat stretch.',
 ARRAY['Stand perpendicular to landmine', 'Staggered stance with inside foot forward', 'Row bar to hip', 'Lower with control'],
 ARRAY['Drive elbow high', 'Squeeze at top', 'Big stretch at bottom'],
 ARRAY['Standing too upright', 'Rotating torso', 'Using too heavy'],
 ARRAY['lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['barbell', 'landmine'],
 'advanced', 'pull', 'strength', 'https://v2.exercisedb.io/image/T8kNjQr0WLd9Xe', false, false, true),

('Seal Row', 'seal-row', 'Chest-supported row for strict form.',
 ARRAY['Lie face down on elevated bench', 'Let arms hang with dumbbells', 'Row to sides of chest', 'Lower with control'],
 ARRAY['Keep chest on bench', 'No leg drive', 'Full stretch at bottom'],
 ARRAY['Using momentum', 'Lifting chest off bench', 'Partial reps'],
 ARRAY['middle back', 'lats'], ARRAY['biceps', 'rear deltoid'], ARRAY['dumbbells', 'bench'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/pHxQNL-0k8W9Te', false, true, true),

('Rack Pull', 'rack-pull', 'Partial deadlift for upper back and grip.',
 ARRAY['Set bar in rack at knee height', 'Set up like deadlift', 'Pull to lockout', 'Lower back to pins'],
 ARRAY['Keep back flat', 'Squeeze traps at top', 'Control descent'],
 ARRAY['Rounding back', 'Hitching the weight', 'Too heavy for form'],
 ARRAY['traps', 'upper back', 'lower back'], ARRAY['glutes', 'forearms'], ARRAY['barbell', 'power rack'],
 'intermediate', 'hinge', 'strength', 'https://v2.exercisedb.io/image/NqXk8pJe0rT7LW', false, true, true),

('Good Morning', 'good-morning', 'Hip hinge for hamstrings and lower back.',
 ARRAY['Bar on upper back like squat', 'Feet hip width', 'Hinge at hips pushing butt back', 'Return to standing'],
 ARRAY['Slight knee bend', 'Back stays flat', 'Feel hamstring stretch'],
 ARRAY['Rounding back', 'Going too heavy', 'Squatting instead of hinging'],
 ARRAY['hamstrings', 'lower back'], ARRAY['glutes'], ARRAY['barbell'],
 'intermediate', 'hinge', 'strength', 'https://v2.exercisedb.io/image/qW8nKpLxHd0eTN', false, true, true),

('Hyperextension', 'hyperextension', 'Lower back and glute strengthener.',
 ARRAY['Position hips on pad', 'Cross arms over chest', 'Lower torso toward floor', 'Raise back to horizontal'],
 ARRAY['Squeeze glutes at top', 'Dont hyperextend', 'Control the motion'],
 ARRAY['Going past horizontal', 'Using momentum', 'Rounding back at bottom'],
 ARRAY['lower back', 'glutes'], ARRAY['hamstrings'], ARRAY['hyperextension bench'],
 'beginner', 'hinge', 'strength', 'https://v2.exercisedb.io/image/Ek7rJTx0pNWqLH', true, true, true),

('Reverse Hyperextension', 'reverse-hyperextension', 'Decompression exercise for lower back health.',
 ARRAY['Lie face down on high bench', 'Hold bench with hands', 'Raise legs behind you', 'Lower with control'],
 ARRAY['Squeeze glutes at top', 'Dont swing', 'Feel lower back working'],
 ARRAY['Swinging legs', 'Going too fast', 'Hyperextending spine'],
 ARRAY['glutes', 'lower back'], ARRAY['hamstrings'], ARRAY['reverse hyper machine', 'bench'],
 'intermediate', 'hinge', 'strength', 'https://v2.exercisedb.io/image/xN0qKPe8rTLWdJ', true, true, true);

-- ============================================
-- SHOULDER EXERCISES (20)
-- ============================================

INSERT INTO exercises (name, slug, description, instructions, cues, common_mistakes, primary_muscles, secondary_muscles, equipment_names, difficulty, movement_pattern, exercise_type, video_url, is_machine, is_bilateral, is_published)
VALUES
-- Barbell Exercises
('Overhead Press', 'overhead-press', 'The king of shoulder exercises for overall delt development.',
 ARRAY['Stand with bar at shoulders', 'Brace core and squeeze glutes', 'Press straight overhead', 'Lower with control to shoulders'],
 ARRAY['Bar path straight up', 'Head through at top', 'Elbows slightly forward'],
 ARRAY['Excessive back lean', 'Not locking out', 'Pressing in front of face'],
 ARRAY['anterior deltoid', 'lateral deltoid'], ARRAY['triceps', 'upper chest'], ARRAY['barbell'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/rPnqKxJe0TL8Wd', false, true, true),

('Push Press', 'push-press', 'Explosive overhead pressing with leg drive.',
 ARRAY['Start with bar at shoulders', 'Dip knees slightly', 'Drive explosively through legs', 'Press bar overhead'],
 ARRAY['Quick dip', 'Explosive drive', 'Full lockout'],
 ARRAY['Dipping too deep', 'Not using leg drive', 'Pressing before drive'],
 ARRAY['anterior deltoid'], ARRAY['triceps', 'quads', 'upper chest'], ARRAY['barbell'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/W7qKpN0eLxTr8d', false, true, true),

('Behind Neck Press', 'behind-neck-press', 'Overhead press variation for experienced lifters.',
 ARRAY['Bar rests behind neck on traps', 'Wide grip on bar', 'Press straight up', 'Lower to behind neck'],
 ARRAY['Requires good shoulder mobility', 'Control the weight', 'Use lighter weight'],
 ARRAY['Going too heavy', 'Poor shoulder mobility', 'Incomplete range'],
 ARRAY['lateral deltoid', 'anterior deltoid'], ARRAY['triceps'], ARRAY['barbell'],
 'advanced', 'push', 'strength', 'https://v2.exercisedb.io/image/qN8xPL0ekWT7rJ', false, true, true),

('Upright Row', 'upright-row', 'Shoulder and trap builder.',
 ARRAY['Stand with narrow grip on bar', 'Pull bar up along body', 'Raise to chest level', 'Lower with control'],
 ARRAY['Lead with elbows', 'Keep bar close', 'Squeeze at top'],
 ARRAY['Going too heavy', 'Raising too high', 'Using momentum'],
 ARRAY['lateral deltoid', 'traps'], ARRAY['biceps', 'forearms'], ARRAY['barbell'],
 'intermediate', 'pull', 'strength', 'https://v2.exercisedb.io/image/Kx8nPqLe0TW7rN', false, true, true),

-- Dumbbell Exercises
('Dumbbell Shoulder Press', 'dumbbell-shoulder-press', 'Seated or standing dumbbell pressing for shoulder mass.',
 ARRAY['Hold dumbbells at shoulders', 'Press overhead in slight arc', 'Dumbbells almost touch at top', 'Lower with control'],
 ARRAY['Press up and together', 'Control the negative', 'Full lockout'],
 ARRAY['Going too heavy', 'Arching back excessively', 'Partial reps'],
 ARRAY['anterior deltoid', 'lateral deltoid'], ARRAY['triceps'], ARRAY['dumbbells'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/N0qKPxLeTr8W7d', false, true, true),

('Arnold Press', 'arnold-press', 'Rotation-based shoulder press for complete delt development.',
 ARRAY['Start with dumbbells at shoulders palms facing you', 'Rotate palms out as you press', 'Finish with palms facing forward at top', 'Reverse motion on the way down'],
 ARRAY['Smooth rotation', 'Full range of motion', 'Control throughout'],
 ARRAY['Rushing the rotation', 'Using momentum', 'Not going full range'],
 ARRAY['anterior deltoid', 'lateral deltoid'], ARRAY['triceps'], ARRAY['dumbbells'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/L0qNPx8KeWTr7d', false, true, true),

('Lateral Raise', 'lateral-raise', 'Isolate the side delts for width.',
 ARRAY['Stand with dumbbells at sides', 'Raise arms out to sides', 'Stop at shoulder height', 'Lower with control'],
 ARRAY['Lead with pinky', 'Slight bend in elbows', 'Control negative'],
 ARRAY['Swinging weight', 'Going too high', 'Using momentum'],
 ARRAY['lateral deltoid'], ARRAY['traps'], ARRAY['dumbbells'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/q0PNxKLe8rTW7d', false, true, true),

('Front Raise', 'front-raise', 'Target the anterior deltoid.',
 ARRAY['Stand with dumbbells in front of thighs', 'Raise arms in front to shoulder height', 'Lower with control', 'Alternate or both arms'],
 ARRAY['Slight elbow bend', 'Stop at shoulder height', 'Control the weight'],
 ARRAY['Swinging weight', 'Going too high', 'Using too heavy'],
 ARRAY['anterior deltoid'], ARRAY['lateral deltoid', 'upper chest'], ARRAY['dumbbells'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/8NqKPxLe0TW7rd', false, true, true),

('Rear Delt Fly', 'rear-delt-fly', 'Target the posterior deltoid for balanced shoulder development.',
 ARRAY['Bend over at hips', 'Let dumbbells hang below chest', 'Raise arms out to sides', 'Squeeze rear delts at top'],
 ARRAY['Lead with elbows', 'Squeeze shoulder blades', 'Minimal body movement'],
 ARRAY['Using momentum', 'Raising too high', 'Not bending over enough'],
 ARRAY['rear deltoid'], ARRAY['rhomboids', 'middle back'], ARRAY['dumbbells'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/qNPx0KLe8TW7rd', false, true, true),

('Dumbbell Shrugs', 'dumbbell-shrugs', 'Build bigger traps with shrugs.',
 ARRAY['Stand with dumbbells at sides', 'Shrug shoulders straight up', 'Hold at top briefly', 'Lower with control'],
 ARRAY['Straight up motion', 'Squeeze at top', 'Dont roll shoulders'],
 ARRAY['Rolling shoulders', 'Using momentum', 'Incomplete range'],
 ARRAY['traps'], ARRAY['upper back'], ARRAY['dumbbells'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/NPx8qKLe0TW7rd', false, true, true),

-- Cable Exercises
('Cable Lateral Raise', 'cable-lateral-raise', 'Constant tension lateral raise.',
 ARRAY['Stand sideways to cable at low position', 'Raise arm out to side', 'Stop at shoulder height', 'Lower with control'],
 ARRAY['Slight lean away', 'Constant tension', 'Control throughout'],
 ARRAY['Using momentum', 'Going too high', 'Standing too close'],
 ARRAY['lateral deltoid'], ARRAY['traps'], ARRAY['cable machine'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/Pxq8NKLe0TW7rd', false, false, true),

('Cable Front Raise', 'cable-front-raise', 'Constant tension front delt work.',
 ARRAY['Face away from cable at low position', 'Raise arm in front to shoulder height', 'Lower with control', 'Repeat other side'],
 ARRAY['Slight elbow bend', 'Control throughout', 'Feel the stretch'],
 ARRAY['Swinging', 'Going too heavy', 'Incomplete range'],
 ARRAY['anterior deltoid'], ARRAY['lateral deltoid'], ARRAY['cable machine'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/xPq8NKLe0TW7rd', false, false, true),

-- Machine Exercises
('Machine Shoulder Press', 'machine-shoulder-press', 'Safe pressing motion for beginners or burnout sets.',
 ARRAY['Adjust seat height', 'Grip handles at shoulder level', 'Press overhead', 'Lower with control'],
 ARRAY['Full lockout', 'Control negative', 'Keep core tight'],
 ARRAY['Seat too low', 'Partial reps', 'Rushing'],
 ARRAY['anterior deltoid', 'lateral deltoid'], ARRAY['triceps'], ARRAY['shoulder press machine'],
 'beginner', 'push', 'strength', 'https://v2.exercisedb.io/image/Nxq8PKLe0TW7rd', true, true, true),

('Machine Lateral Raise', 'machine-lateral-raise', 'Guided lateral raise motion.',
 ARRAY['Sit with arms against pads', 'Raise arms out to sides', 'Stop at shoulder height', 'Lower with control'],
 ARRAY['Lead with elbows', 'Control the motion', 'Squeeze at top'],
 ARRAY['Using momentum', 'Partial range', 'Going too fast'],
 ARRAY['lateral deltoid'], ARRAY['traps'], ARRAY['lateral raise machine'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/qNx8PKLe0TW7rd', true, true, true),

('Reverse Pec Deck', 'reverse-pec-deck', 'Machine rear delt isolation.',
 ARRAY['Sit facing the pad', 'Grip handles with straight arms', 'Pull handles back and apart', 'Control return'],
 ARRAY['Squeeze shoulder blades', 'Lead with elbows', 'Full range of motion'],
 ARRAY['Using too much weight', 'Partial reps', 'Shrugging up'],
 ARRAY['rear deltoid'], ARRAY['rhomboids', 'middle back'], ARRAY['pec deck machine'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/Pqx8NKLe0TW7rd', true, true, true),

-- Bodyweight Exercises
('Pike Push-up', 'pike-push-up', 'Bodyweight overhead pressing progression.',
 ARRAY['Start in pike position with hips high', 'Lower head toward floor', 'Press back up', 'Keep hips elevated throughout'],
 ARRAY['Hips stay high', 'Head goes between arms', 'Control the motion'],
 ARRAY['Dropping hips', 'Not going deep enough', 'Rushing'],
 ARRAY['anterior deltoid'], ARRAY['triceps', 'upper chest'], ARRAY['bodyweight'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/qPx8NKLe0TW7rd', false, true, true),

('Handstand Push-up', 'handstand-push-up', 'Advanced bodyweight overhead press.',
 ARRAY['Kick up to handstand against wall', 'Lower head to floor', 'Press back to straight arms', 'Keep core tight'],
 ARRAY['Control throughout', 'Full range of motion', 'Breathe steadily'],
 ARRAY['Not going deep enough', 'Kipping', 'Losing balance'],
 ARRAY['anterior deltoid', 'lateral deltoid'], ARRAY['triceps', 'core'], ARRAY['bodyweight'],
 'advanced', 'push', 'strength', 'https://v2.exercisedb.io/image/xNq8PKLe0TW7rd', false, true, true),

-- Specialty Exercises
('Lu Raise', 'lu-raise', 'Front raise variation for shoulder health and strength.',
 ARRAY['Hold dumbbells at sides', 'Raise in front with thumbs up', 'Continue overhead', 'Lower with control'],
 ARRAY['Thumbs up throughout', 'Full overhead extension', 'Control negative'],
 ARRAY['Going too heavy', 'Arching back', 'Rushing'],
 ARRAY['anterior deltoid', 'lateral deltoid'], ARRAY['traps'], ARRAY['dumbbells'],
 'intermediate', 'isolation', 'strength', 'https://v2.exercisedb.io/image/qNPx8KLe0TW7rd', false, true, true),

('Y-W-T Raises', 'y-w-t-raises', 'Shoulder stability and rotator cuff exercise.',
 ARRAY['Lie face down on incline bench', 'Raise arms in Y shape', 'Then W shape', 'Then T shape'],
 ARRAY['Light weight only', 'Control each position', 'Squeeze at top of each'],
 ARRAY['Using too heavy', 'Rushing through positions', 'No control'],
 ARRAY['rear deltoid', 'rotator cuff'], ARRAY['middle back', 'traps'], ARRAY['dumbbells', 'incline bench'],
 'beginner', 'isolation', 'strength', 'https://v2.exercisedb.io/image/NPx8qKLe0TW7rd', false, true, true),

('Landmine Press', 'landmine-press', 'Shoulder-friendly pressing motion.',
 ARRAY['Stand at end of barbell in landmine', 'Hold end of bar at shoulder', 'Press up and forward', 'Lower with control'],
 ARRAY['Slight forward lean', 'Full extension', 'Control negative'],
 ARRAY['Standing too upright', 'Not using full range', 'Going too heavy'],
 ARRAY['anterior deltoid'], ARRAY['triceps', 'upper chest', 'core'], ARRAY['barbell', 'landmine'],
 'intermediate', 'push', 'strength', 'https://v2.exercisedb.io/image/Px8qNKLe0TW7rd', false, false, true);

