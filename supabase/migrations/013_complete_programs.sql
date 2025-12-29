-- Migration 013: Complete Programs
-- 6 comprehensive programs with structured workouts

-- Clear existing program data for clean re-seed
DELETE FROM workout_exercises;
DELETE FROM workout_sections;
DELETE FROM workouts;
DELETE FROM program_weeks;
DELETE FROM user_program_enrollments;
DELETE FROM programs;

-- ============================================
-- PROGRAMS
-- ============================================

INSERT INTO programs (id, name, slug, description, short_description, thumbnail_url, hero_image_url, accent_color, duration_weeks, days_per_week, difficulty, focus_areas, goals, is_published, is_premium, display_order, coach_notes, internal_tags)
VALUES
-- Program 1: Foundation Strength (Beginner)
('aa000001-0000-0000-0000-000000000001', 'Foundation Strength', 'foundation-strength', 
 'Build a rock-solid foundation with this comprehensive 8-week beginner program. Learn proper form on all major movements while developing strength, stability, and confidence. Perfect for those new to strength training or returning after a break.',
 'Build your strength foundation from the ground up',
 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1200',
 '#22C55E', 8, 3, 'beginner', 
 ARRAY['full body', 'compound movements', 'form mastery'],
 ARRAY['build_strength', 'learn_form', 'build_muscle'],
 true, false, 1,
 'Focus on form over weight. Progress slowly. This program sets them up for long-term success.',
 ARRAY['beginner', 'foundational', 'full-body']),

-- Program 2: Hypertrophy Max (Intermediate)
('aa000002-0000-0000-0000-000000000002', 'Hypertrophy Max', 'hypertrophy-max',
 'Maximize muscle growth with this 12-week hypertrophy-focused program. Featuring optimal volume, intensity, and exercise selection for serious muscle building. Push/Pull/Legs split for maximum recovery and growth.',
 'Maximum muscle growth with optimal volume training',
 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=800',
 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=1200',
 '#8B5CF6', 12, 6, 'intermediate',
 ARRAY['muscle growth', 'hypertrophy', 'aesthetics'],
 ARRAY['build_muscle', 'aesthetics', 'get_lean'],
 true, false, 2,
 'High volume program. Monitor recovery closely. Deload weeks are crucial.',
 ARRAY['hypertrophy', 'bodybuilding', 'ppl']),

-- Program 3: Functional Athlete (Intermediate)  
('aa000003-0000-0000-0000-000000000003', 'Functional Athlete', 'functional-athlete',
 'Train like an athlete with this 8-week functional fitness program. Combines strength, power, conditioning, and mobility for complete athletic development. Perfect for sports performance or general fitness.',
 'Train like an athlete for complete fitness',
 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800',
 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=1200',
 '#F97316', 8, 4, 'intermediate',
 ARRAY['athletic performance', 'power', 'conditioning', 'mobility'],
 ARRAY['athletic_performance', 'build_strength', 'conditioning'],
 true, false, 3,
 'Emphasize movement quality. Include adequate warmup and cooldown.',
 ARRAY['functional', 'athletic', 'conditioning']),

-- Program 4: Powerbuilding (Advanced)
('aa000004-0000-0000-0000-000000000004', 'Powerbuilding Elite', 'powerbuilding-elite',
 'The best of both worlds: powerlifting strength meets bodybuilding aesthetics. This 16-week advanced program builds maximal strength on the big three while developing a complete, muscular physique.',
 'Combine powerlifting strength with bodybuilding aesthetics',
 'https://images.unsplash.com/photo-1541534741688-6078c6bfbeaf?w=800',
 'https://images.unsplash.com/photo-1541534741688-6078c6bfbeaf?w=1200',
 '#EF4444', 16, 5, 'advanced',
 ARRAY['strength', 'hypertrophy', 'powerlifting'],
 ARRAY['build_strength', 'build_muscle', 'compete'],
 true, true, 4,
 'Heavy compound work followed by accessory volume. Prioritize recovery and nutrition.',
 ARRAY['powerbuilding', 'advanced', 'strength']),

-- Program 5: Home Warrior (Minimal Equipment)
('aa000005-0000-0000-0000-000000000005', 'Home Warrior', 'home-warrior',
 'No gym? No problem. Build serious strength and muscle with minimal equipment. This 8-week program requires only dumbbells and bodyweight, perfect for home training or travel.',
 'Build strength anywhere with minimal equipment',
 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800',
 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=1200',
 '#06B6D4', 8, 4, 'beginner',
 ARRAY['home training', 'minimal equipment', 'bodyweight'],
 ARRAY['build_strength', 'build_muscle', 'convenience'],
 true, false, 5,
 'Adjustable dumbbells recommended. Progress through tempo and volume when weight is limited.',
 ARRAY['home', 'minimal-equipment', 'bodyweight']),

-- Program 6: Quick HIIT (Time-Efficient)
('aa000006-0000-0000-0000-000000000006', 'Quick HIIT 20', 'quick-hiit-20',
 'Maximum results in minimum time. These 20-minute high-intensity sessions combine strength and conditioning for busy people who want real results. Perfect for lunch breaks or early mornings.',
 '20-minute high-intensity workouts for busy people',
 'https://images.unsplash.com/photo-1599058917765-a780eda07a3e?w=800',
 'https://images.unsplash.com/photo-1599058917765-a780eda07a3e?w=1200',
 '#EC4899', 6, 4, 'intermediate',
 ARRAY['time-efficient', 'conditioning', 'fat loss'],
 ARRAY['get_lean', 'conditioning', 'time_efficient'],
 true, false, 6,
 'High intensity requires adequate warmup. Scale movements as needed.',
 ARRAY['hiit', 'conditioning', 'quick']);

-- ============================================
-- PROGRAM WEEKS
-- ============================================

-- Foundation Strength Weeks (8 weeks)
INSERT INTO program_weeks (id, program_id, week_number, name, description, is_deload, focus)
VALUES
('bb000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 1, 'Week 1: Movement Patterns', 'Learn the foundational movement patterns', false, 'form'),
('bb000002-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', 2, 'Week 2: Building the Base', 'Continue developing movement quality', false, 'form'),
('bb000003-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000001', 3, 'Week 3: Adding Load', 'Begin progressive loading', false, 'strength'),
('bb000004-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000001', 4, 'Week 4: Deload', 'Active recovery week', true, 'recovery'),
('bb000005-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000001', 5, 'Week 5: Strength Block', 'Push strength development', false, 'strength'),
('bb000006-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000001', 6, 'Week 6: Progressive Overload', 'Continue building strength', false, 'strength'),
('bb000007-0000-0000-0000-000000000007', 'aa000001-0000-0000-0000-000000000001', 7, 'Week 7: Peak Week', 'Test your progress', false, 'strength'),
('bb000008-0000-0000-0000-000000000008', 'aa000001-0000-0000-0000-000000000001', 8, 'Week 8: Final Assessment', 'Celebrate your gains', false, 'testing'),

-- Hypertrophy Max Weeks (12 weeks - showing first 6)
('bb000009-0000-0000-0000-000000000009', 'aa000002-0000-0000-0000-000000000002', 1, 'Week 1: Accumulation', 'Building training volume', false, 'volume'),
('bb000010-0000-0000-0000-000000000010', 'aa000002-0000-0000-0000-000000000002', 2, 'Week 2: Progressive Volume', 'Increasing sets', false, 'volume'),
('bb000011-0000-0000-0000-000000000011', 'aa000002-0000-0000-0000-000000000002', 3, 'Week 3: Intensification', 'Adding intensity', false, 'intensity'),
('bb000012-0000-0000-0000-000000000012', 'aa000002-0000-0000-0000-000000000002', 4, 'Week 4: Deload', 'Recovery week', true, 'recovery'),
('bb000013-0000-0000-0000-000000000013', 'aa000002-0000-0000-0000-000000000002', 5, 'Week 5: Hypertrophy Focus', 'Maximize muscle growth', false, 'hypertrophy'),
('bb000014-0000-0000-0000-000000000014', 'aa000002-0000-0000-0000-000000000002', 6, 'Week 6: Peak Volume', 'Highest volume week', false, 'volume'),

-- Functional Athlete Weeks (8 weeks - showing first 4)
('bb000015-0000-0000-0000-000000000015', 'aa000003-0000-0000-0000-000000000003', 1, 'Week 1: Movement Foundation', 'Establish movement quality', false, 'form'),
('bb000016-0000-0000-0000-000000000016', 'aa000003-0000-0000-0000-000000000003', 2, 'Week 2: Strength Base', 'Build foundational strength', false, 'strength'),
('bb000017-0000-0000-0000-000000000017', 'aa000003-0000-0000-0000-000000000003', 3, 'Week 3: Power Development', 'Develop explosive power', false, 'power'),
('bb000018-0000-0000-0000-000000000018', 'aa000003-0000-0000-0000-000000000003', 4, 'Week 4: Conditioning Focus', 'Work capacity development', false, 'conditioning'),

-- Powerbuilding Weeks (showing first 4)
('bb000019-0000-0000-0000-000000000019', 'aa000004-0000-0000-0000-000000000004', 1, 'Week 1: Base Building', 'Establish training base', false, 'strength'),
('bb000020-0000-0000-0000-000000000020', 'aa000004-0000-0000-0000-000000000004', 2, 'Week 2: Volume Accumulation', 'Build training volume', false, 'volume'),
('bb000021-0000-0000-0000-000000000021', 'aa000004-0000-0000-0000-000000000004', 3, 'Week 3: Intensity Wave', 'Increase intensity', false, 'intensity'),
('bb000022-0000-0000-0000-000000000022', 'aa000004-0000-0000-0000-000000000004', 4, 'Week 4: Deload', 'Active recovery', true, 'recovery'),

-- Home Warrior Weeks (showing first 4)
('bb000023-0000-0000-0000-000000000023', 'aa000005-0000-0000-0000-000000000005', 1, 'Week 1: Foundation', 'Learn home training fundamentals', false, 'form'),
('bb000024-0000-0000-0000-000000000024', 'aa000005-0000-0000-0000-000000000005', 2, 'Week 2: Building Strength', 'Progressive resistance', false, 'strength'),
('bb000025-0000-0000-0000-000000000025', 'aa000005-0000-0000-0000-000000000005', 3, 'Week 3: Tempo Training', 'Time under tension focus', false, 'hypertrophy'),
('bb000026-0000-0000-0000-000000000026', 'aa000005-0000-0000-0000-000000000005', 4, 'Week 4: Deload', 'Recovery and mobility', true, 'recovery'),

-- Quick HIIT Weeks (showing first 4)
('bb000027-0000-0000-0000-000000000027', 'aa000006-0000-0000-0000-000000000006', 1, 'Week 1: Building Base', 'Establish conditioning base', false, 'conditioning'),
('bb000028-0000-0000-0000-000000000028', 'aa000006-0000-0000-0000-000000000006', 2, 'Week 2: Intensity Increase', 'Push harder', false, 'intensity'),
('bb000029-0000-0000-0000-000000000029', 'aa000006-0000-0000-0000-000000000006', 3, 'Week 3: Work Capacity', 'Increase work output', false, 'conditioning'),
('bb000030-0000-0000-0000-000000000030', 'aa000006-0000-0000-0000-000000000006', 4, 'Week 4: Peak Week', 'Maximum intensity', false, 'peak');

-- ============================================
-- WORKOUTS
-- ============================================

-- Foundation Strength - Week 1 Workouts
INSERT INTO workouts (id, program_id, week_id, name, description, day_of_week, day_number, estimated_duration_minutes, workout_order, difficulty, coach_notes, equipment_needed)
VALUES
-- Foundation Strength Week 1
('cc000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001', 
 'Full Body A: Push Focus', 'Learn fundamental pushing patterns', 'mon', 1, 45, 1, 'beginner',
 'Focus on form over weight. Take your time with each movement.', ARRAY['barbell', 'dumbbells', 'bench']),

('cc000002-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001',
 'Full Body B: Pull Focus', 'Learn fundamental pulling patterns', 'wed', 2, 45, 2, 'beginner',
 'Initiate every pull with your back, not your arms.', ARRAY['barbell', 'dumbbells', 'cable machine']),

('cc000003-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001',
 'Full Body C: Legs Focus', 'Learn fundamental leg patterns', 'fri', 3, 50, 3, 'beginner',
 'Depth matters. Go as low as mobility allows with good form.', ARRAY['barbell', 'dumbbells', 'leg press machine']),

-- Hypertrophy Max Week 1
('cc000004-0000-0000-0000-000000000004', 'aa000002-0000-0000-0000-000000000002', 'bb000009-0000-0000-0000-000000000009',
 'Push Day: Chest & Shoulders', 'High volume pushing for chest and delts', 'mon', 1, 60, 1, 'intermediate',
 'Controlled tempo on all movements. Focus on the squeeze.', ARRAY['barbell', 'dumbbells', 'cable machine', 'bench']),

('cc000005-0000-0000-0000-000000000005', 'aa000002-0000-0000-0000-000000000002', 'bb000009-0000-0000-0000-000000000009',
 'Pull Day: Back & Biceps', 'High volume pulling for back development', 'tue', 2, 60, 2, 'intermediate',
 'Initiate every movement with your back. Squeeze hard at contraction.', ARRAY['barbell', 'dumbbells', 'cable machine', 'lat pulldown']),

('cc000006-0000-0000-0000-000000000006', 'aa000002-0000-0000-0000-000000000002', 'bb000009-0000-0000-0000-000000000009',
 'Legs: Quads & Glutes', 'Heavy leg day focusing on growth', 'wed', 3, 70, 3, 'intermediate',
 'Full depth on all squats. Feel the burn.', ARRAY['barbell', 'leg press machine', 'leg curl machine', 'leg extension machine']),

('cc000007-0000-0000-0000-000000000007', 'aa000002-0000-0000-0000-000000000002', 'bb000009-0000-0000-0000-000000000009',
 'Push Day 2: Triceps Focus', 'Second push day with triceps emphasis', 'thu', 4, 55, 4, 'intermediate',
 'Higher rep work today. Chase the pump.', ARRAY['barbell', 'dumbbells', 'cable machine']),

('cc000008-0000-0000-0000-000000000008', 'aa000002-0000-0000-0000-000000000002', 'bb000009-0000-0000-0000-000000000009',
 'Pull Day 2: Rear Delts', 'Second pull day with rear delt focus', 'fri', 5, 55, 5, 'intermediate',
 'Rear delts need love too. Focus on the mind-muscle connection.', ARRAY['dumbbells', 'cable machine']),

('cc000009-0000-0000-0000-000000000009', 'aa000002-0000-0000-0000-000000000002', 'bb000009-0000-0000-0000-000000000009',
 'Legs 2: Hamstrings & Calves', 'Posterior chain focus', 'sat', 6, 60, 6, 'intermediate',
 'Hamstrings and calves often underdeveloped. Hit them hard.', ARRAY['barbell', 'leg curl machine', 'calf raise machine']),

-- Functional Athlete Week 1
('cc000010-0000-0000-0000-000000000010', 'aa000003-0000-0000-0000-000000000003', 'bb000015-0000-0000-0000-000000000015',
 'Strength: Upper Body', 'Build upper body strength foundation', 'mon', 1, 50, 1, 'intermediate',
 'Quality reps only. Power comes from strength.', ARRAY['barbell', 'dumbbells', 'pull-up bar']),

('cc000011-0000-0000-0000-000000000011', 'aa000003-0000-0000-0000-000000000003', 'bb000015-0000-0000-0000-000000000015',
 'Power: Lower Body', 'Develop lower body explosiveness', 'tue', 2, 45, 2, 'intermediate',
 'Explosive on the concentric. Reset between reps.', ARRAY['barbell', 'kettlebell', 'box']),

('cc000012-0000-0000-0000-000000000012', 'aa000003-0000-0000-0000-000000000003', 'bb000015-0000-0000-0000-000000000015',
 'Conditioning: Full Body', 'Work capacity development', 'thu', 3, 40, 3, 'intermediate',
 'Keep moving. Rest only as prescribed.', ARRAY['kettlebell', 'bodyweight']),

('cc000013-0000-0000-0000-000000000013', 'aa000003-0000-0000-0000-000000000003', 'bb000015-0000-0000-0000-000000000015',
 'Recovery: Mobility', 'Active recovery and mobility work', 'sat', 4, 35, 4, 'beginner',
 'Recovery is where you grow. Take this seriously.', ARRAY['foam roller', 'bodyweight']),

-- Powerbuilding Week 1
('cc000014-0000-0000-0000-000000000014', 'aa000004-0000-0000-0000-000000000004', 'bb000019-0000-0000-0000-000000000019',
 'Heavy Squat Day', 'Squat focus with accessory work', 'mon', 1, 75, 1, 'advanced',
 'Work up to a heavy set of 5. Focus on technique at heavy weights.', ARRAY['barbell', 'squat rack', 'leg press machine']),

('cc000015-0000-0000-0000-000000000015', 'aa000004-0000-0000-0000-000000000004', 'bb000019-0000-0000-0000-000000000019',
 'Heavy Bench Day', 'Bench focus with chest and triceps', 'tue', 2, 70, 2, 'advanced',
 'Heavy compound work first, then pump work.', ARRAY['barbell', 'dumbbells', 'bench']),

('cc000016-0000-0000-0000-000000000016', 'aa000004-0000-0000-0000-000000000004', 'bb000019-0000-0000-0000-000000000019',
 'Back Volume', 'High volume back training', 'thu', 3, 65, 3, 'advanced',
 'Chase the pump on all back movements.', ARRAY['barbell', 'dumbbells', 'cable machine']),

('cc000017-0000-0000-0000-000000000017', 'aa000004-0000-0000-0000-000000000004', 'bb000019-0000-0000-0000-000000000019',
 'Heavy Deadlift Day', 'Deadlift focus with posterior chain', 'fri', 4, 75, 4, 'advanced',
 'Respect the deadlift. Quality over quantity.', ARRAY['barbell', 'trap bar']),

('cc000018-0000-0000-0000-000000000018', 'aa000004-0000-0000-0000-000000000004', 'bb000019-0000-0000-0000-000000000019',
 'Arms & Shoulders', 'Hypertrophy focus for arms', 'sat', 5, 55, 5, 'intermediate',
 'Get your pump on. High reps, short rest.', ARRAY['dumbbells', 'cable machine', 'ez curl bar']),

-- Home Warrior Week 1
('cc000019-0000-0000-0000-000000000019', 'aa000005-0000-0000-0000-000000000005', 'bb000023-0000-0000-0000-000000000023',
 'Upper Body Strength', 'Push and pull with minimal equipment', 'mon', 1, 40, 1, 'beginner',
 'Bodyweight and dumbbells only. Focus on tempo for intensity.', ARRAY['dumbbells', 'bodyweight']),

('cc000020-0000-0000-0000-000000000020', 'aa000005-0000-0000-0000-000000000005', 'bb000023-0000-0000-0000-000000000023',
 'Lower Body Strength', 'Legs and glutes at home', 'tue', 2, 45, 2, 'beginner',
 'Slow eccentrics when weight is limited.', ARRAY['dumbbells', 'bodyweight']),

('cc000021-0000-0000-0000-000000000021', 'aa000005-0000-0000-0000-000000000005', 'bb000023-0000-0000-0000-000000000023',
 'Full Body Circuit', 'Total body conditioning', 'thu', 3, 35, 3, 'beginner',
 'Keep rest short. Maintain heart rate elevated.', ARRAY['dumbbells', 'bodyweight']),

('cc000022-0000-0000-0000-000000000022', 'aa000005-0000-0000-0000-000000000005', 'bb000023-0000-0000-0000-000000000023',
 'Core & Mobility', 'Core strength and flexibility', 'sat', 4, 30, 4, 'beginner',
 'Core work and stretching. Recovery matters.', ARRAY['bodyweight']),

-- Quick HIIT Week 1
('cc000023-0000-0000-0000-000000000023', 'aa000006-0000-0000-0000-000000000006', 'bb000027-0000-0000-0000-000000000027',
 'HIIT: Total Body Blast', '20 minutes of full body intensity', 'mon', 1, 20, 1, 'intermediate',
 'Maximum effort on work periods. Recover fully on rest.', ARRAY['dumbbells', 'bodyweight']),

('cc000024-0000-0000-0000-000000000024', 'aa000006-0000-0000-0000-000000000006', 'bb000027-0000-0000-0000-000000000027',
 'HIIT: Upper Body Focus', '20 minutes upper body blitz', 'tue', 2, 20, 2, 'intermediate',
 'Push hard. This is a sprint not a marathon.', ARRAY['dumbbells', 'bodyweight']),

('cc000025-0000-0000-0000-000000000025', 'aa000006-0000-0000-0000-000000000006', 'bb000027-0000-0000-0000-000000000027',
 'HIIT: Lower Body Burn', '20 minutes leg destroyer', 'thu', 3, 20, 3, 'intermediate',
 'Legs will be on fire. Embrace it.', ARRAY['dumbbells', 'bodyweight']),

('cc000026-0000-0000-0000-000000000026', 'aa000006-0000-0000-0000-000000000006', 'bb000027-0000-0000-0000-000000000027',
 'HIIT: Core Crusher', '20 minutes core and conditioning', 'sat', 4, 20, 4, 'intermediate',
 'Core focus with cardio bursts.', ARRAY['bodyweight']);

-- ============================================
-- WORKOUT SECTIONS
-- ============================================

-- Foundation Strength Day 1 Sections
INSERT INTO workout_sections (id, workout_id, name, section_type, order_index, section_order, notes)
VALUES
('dd000001-0000-0000-0000-000000000001', 'cc000001-0000-0000-0000-000000000001', 'Warmup', 'warmup', 1, 1, 'Get blood flowing and prepare joints'),
('dd000002-0000-0000-0000-000000000002', 'cc000001-0000-0000-0000-000000000001', 'Main Strength', 'main', 2, 2, 'Focus on form with moderate weight'),
('dd000003-0000-0000-0000-000000000003', 'cc000001-0000-0000-0000-000000000001', 'Accessory', 'training', 3, 3, 'Build supporting muscle groups'),
('dd000004-0000-0000-0000-000000000004', 'cc000001-0000-0000-0000-000000000001', 'Cooldown', 'cooldown', 4, 4, 'Stretch and recover'),

-- Foundation Strength Day 2 Sections
('dd000005-0000-0000-0000-000000000005', 'cc000002-0000-0000-0000-000000000002', 'Warmup', 'warmup', 1, 1, 'Prepare for pulling movements'),
('dd000006-0000-0000-0000-000000000006', 'cc000002-0000-0000-0000-000000000002', 'Main Strength', 'main', 2, 2, 'Back and biceps compound work'),
('dd000007-0000-0000-0000-000000000007', 'cc000002-0000-0000-0000-000000000002', 'Accessory', 'training', 3, 3, 'Isolation work for balance'),
('dd000008-0000-0000-0000-000000000008', 'cc000002-0000-0000-0000-000000000002', 'Cooldown', 'cooldown', 4, 4, 'Stretch pulling muscles'),

-- Foundation Strength Day 3 Sections
('dd000009-0000-0000-0000-000000000009', 'cc000003-0000-0000-0000-000000000003', 'Warmup', 'warmup', 1, 1, 'Hip and ankle mobility'),
('dd000010-0000-0000-0000-000000000010', 'cc000003-0000-0000-0000-000000000003', 'Main Strength', 'main', 2, 2, 'Squat and hinge patterns'),
('dd000011-0000-0000-0000-000000000011', 'cc000003-0000-0000-0000-000000000003', 'Accessory', 'training', 3, 3, 'Single leg and isolation'),
('dd000012-0000-0000-0000-000000000012', 'cc000003-0000-0000-0000-000000000003', 'Cooldown', 'cooldown', 4, 4, 'Lower body stretches'),

-- Hypertrophy Max Day 1 Sections (Push)
('dd000013-0000-0000-0000-000000000013', 'cc000004-0000-0000-0000-000000000004', 'Activation', 'warmup', 1, 1, 'Prime the muscles'),
('dd000014-0000-0000-0000-000000000014', 'cc000004-0000-0000-0000-000000000004', 'Heavy Compound', 'main', 2, 2, 'Main pressing movements'),
('dd000015-0000-0000-0000-000000000015', 'cc000004-0000-0000-0000-000000000004', 'Volume Work', 'training', 3, 3, 'Higher rep pump work'),
('dd000016-0000-0000-0000-000000000016', 'cc000004-0000-0000-0000-000000000004', 'Finisher', 'finisher', 4, 4, 'Burnout set'),

-- Hypertrophy Max Day 2 Sections (Pull)
('dd000017-0000-0000-0000-000000000017', 'cc000005-0000-0000-0000-000000000005', 'Activation', 'warmup', 1, 1, 'Wake up the back'),
('dd000018-0000-0000-0000-000000000018', 'cc000005-0000-0000-0000-000000000005', 'Heavy Compound', 'main', 2, 2, 'Rowing and pulldowns'),
('dd000019-0000-0000-0000-000000000019', 'cc000005-0000-0000-0000-000000000005', 'Volume Work', 'training', 3, 3, 'Back detail work'),
('dd000020-0000-0000-0000-000000000020', 'cc000005-0000-0000-0000-000000000005', 'Arms', 'training', 4, 4, 'Biceps pump'),

-- Hypertrophy Max Day 3 Sections (Legs)
('dd000021-0000-0000-0000-000000000021', 'cc000006-0000-0000-0000-000000000006', 'Activation', 'warmup', 1, 1, 'Hip and glute activation'),
('dd000022-0000-0000-0000-000000000022', 'cc000006-0000-0000-0000-000000000006', 'Heavy Compound', 'main', 2, 2, 'Squat and leg press'),
('dd000023-0000-0000-0000-000000000023', 'cc000006-0000-0000-0000-000000000006', 'Isolation', 'training', 3, 3, 'Extensions and curls'),
('dd000024-0000-0000-0000-000000000024', 'cc000006-0000-0000-0000-000000000006', 'Calves', 'training', 4, 4, 'Calf work'),

-- Functional Athlete Day 1 Sections
('dd000025-0000-0000-0000-000000000025', 'cc000010-0000-0000-0000-000000000010', 'Movement Prep', 'warmup', 1, 1, 'Dynamic warmup'),
('dd000026-0000-0000-0000-000000000026', 'cc000010-0000-0000-0000-000000000010', 'Strength', 'main', 2, 2, 'Primary strength work'),
('dd000027-0000-0000-0000-000000000027', 'cc000010-0000-0000-0000-000000000010', 'Accessory', 'training', 3, 3, 'Supporting movements'),

-- Functional Athlete Day 2 Sections
('dd000028-0000-0000-0000-000000000028', 'cc000011-0000-0000-0000-000000000011', 'Movement Prep', 'warmup', 1, 1, 'Explosive prep'),
('dd000029-0000-0000-0000-000000000029', 'cc000011-0000-0000-0000-000000000011', 'Power', 'main', 2, 2, 'Explosive work'),
('dd000030-0000-0000-0000-000000000030', 'cc000011-0000-0000-0000-000000000011', 'Strength', 'training', 3, 3, 'Supporting strength'),

-- Quick HIIT Day 1 Sections
('dd000031-0000-0000-0000-000000000031', 'cc000023-0000-0000-0000-000000000023', 'Quick Warmup', 'warmup', 1, 1, '2 minute warmup'),
('dd000032-0000-0000-0000-000000000032', 'cc000023-0000-0000-0000-000000000023', 'Main Circuit', 'main', 2, 2, '15 minutes of work'),
('dd000033-0000-0000-0000-000000000033', 'cc000023-0000-0000-0000-000000000023', 'Cooldown', 'cooldown', 3, 3, '3 minute cooldown'),

-- Home Warrior Day 1 Sections
('dd000034-0000-0000-0000-000000000034', 'cc000019-0000-0000-0000-000000000019', 'Warmup', 'warmup', 1, 1, 'Bodyweight activation'),
('dd000035-0000-0000-0000-000000000035', 'cc000019-0000-0000-0000-000000000019', 'Push', 'main', 2, 2, 'Pushing movements'),
('dd000036-0000-0000-0000-000000000036', 'cc000019-0000-0000-0000-000000000019', 'Pull', 'training', 3, 3, 'Pulling movements');

-- ============================================
-- WORKOUT EXERCISES
-- ============================================

-- Get exercise IDs dynamically (we'll use slugs to reference)
-- Foundation Strength Day 1 Exercises
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000001-0000-0000-0000-000000000001'::uuid,
  'cc000001-0000-0000-0000-000000000001'::uuid,
  'dd000001-0000-0000-0000-000000000001'::uuid,
  id, 1, 1, NULL, 1, 10, 0, 'Get blood flowing'
FROM exercises WHERE slug = 'arm-circles' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000002-0000-0000-0000-000000000002'::uuid,
  'cc000001-0000-0000-0000-000000000001'::uuid,
  'dd000001-0000-0000-0000-000000000001'::uuid,
  id, 2, 2, NULL, 2, 10, 0, 'Hip mobility'
FROM exercises WHERE slug = 'hip-circles' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000003-0000-0000-0000-000000000003'::uuid,
  'cc000001-0000-0000-0000-000000000001'::uuid,
  'dd000002-0000-0000-0000-000000000002'::uuid,
  id, 1, 1, 'A', 3, 10, 120, 'Focus on form. Pause at chest.'
FROM exercises WHERE slug = 'barbell-bench-press' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000004-0000-0000-0000-000000000004'::uuid,
  'cc000001-0000-0000-0000-000000000001'::uuid,
  'dd000002-0000-0000-0000-000000000002'::uuid,
  id, 2, 2, 'B', 3, 12, 90, 'Full range of motion'
FROM exercises WHERE slug = 'dumbbell-shoulder-press' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000005-0000-0000-0000-000000000005'::uuid,
  'cc000001-0000-0000-0000-000000000001'::uuid,
  'dd000003-0000-0000-0000-000000000003'::uuid,
  id, 1, 1, 'C', 3, 15, 60, 'Control the weight'
FROM exercises WHERE slug = 'lateral-raise' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000006-0000-0000-0000-000000000006'::uuid,
  'cc000001-0000-0000-0000-000000000001'::uuid,
  'dd000003-0000-0000-0000-000000000003'::uuid,
  id, 2, 2, 'D', 3, 12, 60, 'Full lockout'
FROM exercises WHERE slug = 'triceps-pushdown' LIMIT 1;

-- Foundation Strength Day 2 Exercises
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000007-0000-0000-0000-000000000007'::uuid,
  'cc000002-0000-0000-0000-000000000002'::uuid,
  'dd000005-0000-0000-0000-000000000005'::uuid,
  id, 1, 1, NULL, 2, 10, 0, 'Shoulder prep'
FROM exercises WHERE slug = 'band-pull-apart' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000008-0000-0000-0000-000000000008'::uuid,
  'cc000002-0000-0000-0000-000000000002'::uuid,
  'dd000006-0000-0000-0000-000000000006'::uuid,
  id, 1, 1, 'A', 3, 8, 120, 'Drive elbows back'
FROM exercises WHERE slug = 'barbell-row' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000009-0000-0000-0000-000000000009'::uuid,
  'cc000002-0000-0000-0000-000000000002'::uuid,
  'dd000006-0000-0000-0000-000000000006'::uuid,
  id, 2, 2, 'B', 3, 10, 90, 'Full range of motion'
FROM exercises WHERE slug = 'lat-pulldown' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000010-0000-0000-0000-000000000010'::uuid,
  'cc000002-0000-0000-0000-000000000002'::uuid,
  'dd000007-0000-0000-0000-000000000007'::uuid,
  id, 1, 1, 'C', 3, 12, 60, 'Each arm'
FROM exercises WHERE slug = 'dumbbell-row' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000011-0000-0000-0000-000000000011'::uuid,
  'cc000002-0000-0000-0000-000000000002'::uuid,
  'dd000007-0000-0000-0000-000000000007'::uuid,
  id, 2, 2, 'D', 3, 12, 60, 'Squeeze at top'
FROM exercises WHERE slug = 'dumbbell-curl' LIMIT 1;

-- Foundation Strength Day 3 Exercises
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000012-0000-0000-0000-000000000012'::uuid,
  'cc000003-0000-0000-0000-000000000003'::uuid,
  'dd000009-0000-0000-0000-000000000009'::uuid,
  id, 1, 1, NULL, 2, 10, 0, 'Hip prep'
FROM exercises WHERE slug = 'leg-swings' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000013-0000-0000-0000-000000000013'::uuid,
  'cc000003-0000-0000-0000-000000000003'::uuid,
  'dd000009-0000-0000-0000-000000000009'::uuid,
  id, 2, 2, NULL, 2, 10, 0, 'Glute activation'
FROM exercises WHERE slug = 'glute-bridge-hold' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000014-0000-0000-0000-000000000014'::uuid,
  'cc000003-0000-0000-0000-000000000003'::uuid,
  'dd000010-0000-0000-0000-000000000010'::uuid,
  id, 1, 1, 'A', 4, 8, 120, 'Full depth'
FROM exercises WHERE slug = 'barbell-back-squat' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000015-0000-0000-0000-000000000015'::uuid,
  'cc000003-0000-0000-0000-000000000003'::uuid,
  'dd000010-0000-0000-0000-000000000010'::uuid,
  id, 2, 2, 'B', 3, 10, 90, 'Hip hinge pattern'
FROM exercises WHERE slug = 'romanian-deadlift' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000016-0000-0000-0000-000000000016'::uuid,
  'cc000003-0000-0000-0000-000000000003'::uuid,
  'dd000011-0000-0000-0000-000000000011'::uuid,
  id, 1, 1, 'C', 3, 12, 60, 'Each leg'
FROM exercises WHERE slug = 'bulgarian-split-squat' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000017-0000-0000-0000-000000000017'::uuid,
  'cc000003-0000-0000-0000-000000000003'::uuid,
  'dd000011-0000-0000-0000-000000000011'::uuid,
  id, 2, 2, 'D', 3, 15, 60, 'Full extension'
FROM exercises WHERE slug = 'leg-extension' LIMIT 1;

-- Hypertrophy Max Day 1 Exercises (Push)
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000018-0000-0000-0000-000000000018'::uuid,
  'cc000004-0000-0000-0000-000000000004'::uuid,
  'dd000013-0000-0000-0000-000000000013'::uuid,
  id, 1, 1, NULL, 2, 15, 0, 'Activate chest'
FROM exercises WHERE slug = 'push-up' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000019-0000-0000-0000-000000000019'::uuid,
  'cc000004-0000-0000-0000-000000000004'::uuid,
  'dd000014-0000-0000-0000-000000000014'::uuid,
  id, 1, 1, 'A', 4, 8, 120, 'Heavy pressing'
FROM exercises WHERE slug = 'barbell-bench-press' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000020-0000-0000-0000-000000000020'::uuid,
  'cc000004-0000-0000-0000-000000000004'::uuid,
  'dd000014-0000-0000-0000-000000000014'::uuid,
  id, 2, 2, 'B', 4, 10, 90, 'Upper chest focus'
FROM exercises WHERE slug = 'incline-dumbbell-press' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000021-0000-0000-0000-000000000021'::uuid,
  'cc000004-0000-0000-0000-000000000004'::uuid,
  'dd000015-0000-0000-0000-000000000015'::uuid,
  id, 1, 1, 'C', 4, 12, 60, 'Constant tension'
FROM exercises WHERE slug = 'cable-crossover' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000022-0000-0000-0000-000000000022'::uuid,
  'cc000004-0000-0000-0000-000000000004'::uuid,
  'dd000015-0000-0000-0000-000000000015'::uuid,
  id, 2, 2, 'D', 4, 12, 60, 'Build the delts'
FROM exercises WHERE slug = 'lateral-raise' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000023-0000-0000-0000-000000000023'::uuid,
  'cc000004-0000-0000-0000-000000000004'::uuid,
  'dd000016-0000-0000-0000-000000000016'::uuid,
  id, 1, 1, NULL, 3, 15, 45, 'Burn it out'
FROM exercises WHERE slug = 'dumbbell-fly' LIMIT 1;

-- Hypertrophy Max Day 2 Exercises (Pull)
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000024-0000-0000-0000-000000000024'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000017-0000-0000-0000-000000000017'::uuid,
  id, 1, 1, NULL, 2, 15, 0, 'Wake up the back'
FROM exercises WHERE slug = 'band-pull-apart' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000025-0000-0000-0000-000000000025'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000018-0000-0000-0000-000000000018'::uuid,
  id, 1, 1, 'A', 4, 8, 120, 'Pull or use assisted'
FROM exercises WHERE slug = 'pull-up' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000026-0000-0000-0000-000000000026'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000018-0000-0000-0000-000000000018'::uuid,
  id, 2, 2, 'B', 4, 10, 90, 'Heavy rows'
FROM exercises WHERE slug = 'barbell-row' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000027-0000-0000-0000-000000000027'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000019-0000-0000-0000-000000000019'::uuid,
  id, 1, 1, 'C', 4, 12, 60, 'Wide grip'
FROM exercises WHERE slug = 'lat-pulldown' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000028-0000-0000-0000-000000000028'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000019-0000-0000-0000-000000000019'::uuid,
  id, 2, 2, 'D', 3, 15, 60, 'Rear delt focus'
FROM exercises WHERE slug = 'face-pull' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000029-0000-0000-0000-000000000029'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000020-0000-0000-0000-000000000020'::uuid,
  id, 1, 1, 'E', 4, 12, 60, 'Squeeze at top'
FROM exercises WHERE slug = 'dumbbell-curl' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000030-0000-0000-0000-000000000030'::uuid,
  'cc000005-0000-0000-0000-000000000005'::uuid,
  'dd000020-0000-0000-0000-000000000020'::uuid,
  id, 2, 2, 'F', 3, 12, 60, 'Brachialis focus'
FROM exercises WHERE slug = 'hammer-curl' LIMIT 1;

-- Hypertrophy Max Day 3 Exercises (Legs)
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000031-0000-0000-0000-000000000031'::uuid,
  'cc000006-0000-0000-0000-000000000006'::uuid,
  'dd000021-0000-0000-0000-000000000021'::uuid,
  id, 1, 1, NULL, 2, 10, 0, 'Activate glutes'
FROM exercises WHERE slug = 'glute-bridge-hold' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000032-0000-0000-0000-000000000032'::uuid,
  'cc000006-0000-0000-0000-000000000006'::uuid,
  'dd000022-0000-0000-0000-000000000022'::uuid,
  id, 1, 1, 'A', 4, 8, 150, 'Heavy squats'
FROM exercises WHERE slug = 'barbell-back-squat' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000033-0000-0000-0000-000000000033'::uuid,
  'cc000006-0000-0000-0000-000000000006'::uuid,
  'dd000022-0000-0000-0000-000000000022'::uuid,
  id, 2, 2, 'B', 4, 10, 120, 'Volume on leg press'
FROM exercises WHERE slug = 'leg-press' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000034-0000-0000-0000-000000000034'::uuid,
  'cc000006-0000-0000-0000-000000000006'::uuid,
  'dd000023-0000-0000-0000-000000000023'::uuid,
  id, 1, 1, 'C', 4, 12, 60, 'Quad isolation'
FROM exercises WHERE slug = 'leg-extension' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000035-0000-0000-0000-000000000035'::uuid,
  'cc000006-0000-0000-0000-000000000006'::uuid,
  'dd000023-0000-0000-0000-000000000023'::uuid,
  id, 2, 2, 'D', 4, 12, 60, 'Hamstring work'
FROM exercises WHERE slug = 'lying-leg-curl' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000036-0000-0000-0000-000000000036'::uuid,
  'cc000006-0000-0000-0000-000000000006'::uuid,
  'dd000024-0000-0000-0000-000000000024'::uuid,
  id, 1, 1, 'E', 4, 15, 45, 'Calves need love'
FROM exercises WHERE slug = 'standing-calf-raise' LIMIT 1;

-- Quick HIIT Day 1 Exercises
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000037-0000-0000-0000-000000000037'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000031-0000-0000-0000-000000000031'::uuid,
  id, 1, 1, NULL, 1, 30, 0, '30 seconds'
FROM exercises WHERE slug = 'jumping-jacks' 
UNION ALL
SELECT 
  'ee000037-0000-0000-0000-000000000037'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000031-0000-0000-0000-000000000031'::uuid,
  id, 1, 1, NULL, 1, 20, 0, 'Quick warmup'
FROM exercises WHERE slug = 'arm-circles' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000038-0000-0000-0000-000000000038'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000032-0000-0000-0000-000000000032'::uuid,
  id, 1, 1, NULL, 4, 10, 30, '40 on 20 off'
FROM exercises WHERE slug = 'jump-squat' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000039-0000-0000-0000-000000000039'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000032-0000-0000-0000-000000000032'::uuid,
  id, 2, 2, NULL, 4, 10, 30, '40 on 20 off'
FROM exercises WHERE slug = 'push-up' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000040-0000-0000-0000-000000000040'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000032-0000-0000-0000-000000000032'::uuid,
  id, 3, 3, NULL, 4, 10, 30, '40 on 20 off'
FROM exercises WHERE slug = 'mountain-climber' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000041-0000-0000-0000-000000000041'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000032-0000-0000-0000-000000000032'::uuid,
  id, 4, 4, NULL, 4, 15, 30, '40 on 20 off'
FROM exercises WHERE slug = 'kettlebell-swing' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000042-0000-0000-0000-000000000042'::uuid,
  'cc000023-0000-0000-0000-000000000023'::uuid,
  'dd000033-0000-0000-0000-000000000033'::uuid,
  id, 1, 1, NULL, 1, 60, 0, 'Hold and breathe'
FROM exercises WHERE slug = 'child-pose' LIMIT 1;

-- Home Warrior Day 1 Exercises
INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000043-0000-0000-0000-000000000043'::uuid,
  'cc000019-0000-0000-0000-000000000019'::uuid,
  'dd000034-0000-0000-0000-000000000034'::uuid,
  id, 1, 1, NULL, 2, 10, 0, 'Get moving'
FROM exercises WHERE slug = 'arm-circles' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000044-0000-0000-0000-000000000044'::uuid,
  'cc000019-0000-0000-0000-000000000019'::uuid,
  'dd000035-0000-0000-0000-000000000035'::uuid,
  id, 1, 1, 'A', 4, 15, 60, 'Slow eccentrics'
FROM exercises WHERE slug = 'push-up' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000045-0000-0000-0000-000000000045'::uuid,
  'cc000019-0000-0000-0000-000000000019'::uuid,
  'dd000035-0000-0000-0000-000000000035'::uuid,
  id, 2, 2, 'B', 3, 12, 60, 'Full range'
FROM exercises WHERE slug = 'dumbbell-shoulder-press' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000046-0000-0000-0000-000000000046'::uuid,
  'cc000019-0000-0000-0000-000000000019'::uuid,
  'dd000036-0000-0000-0000-000000000036'::uuid,
  id, 1, 1, 'C', 3, 12, 60, 'Each arm'
FROM exercises WHERE slug = 'dumbbell-row' LIMIT 1;

INSERT INTO workout_exercises (id, workout_id, section_id, exercise_id, order_index, exercise_order, letter_designation, sets, reps, rest_seconds, notes)
SELECT 
  'ee000047-0000-0000-0000-000000000047'::uuid,
  'cc000019-0000-0000-0000-000000000019'::uuid,
  'dd000036-0000-0000-0000-000000000036'::uuid,
  id, 2, 2, 'D', 3, 12, 60, 'Squeeze hard'
FROM exercises WHERE slug = 'dumbbell-curl' LIMIT 1;

