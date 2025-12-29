-- Exercise Metadata Extension
-- Adds video URLs, coaching cues, and progression/regression relationships

-- ============================================
-- ADD NEW COLUMNS TO EXERCISES TABLE
-- ============================================

-- Video and media
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS video_url TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS thumbnail_url TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS gif_url TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS video_duration_seconds INT;

-- Coaching content
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS coaching_cues TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS common_mistakes TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS setup_instructions TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS execution_instructions TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS breathing_cues TEXT;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS tempo_recommendation TEXT; -- e.g., "3-1-1-0" (eccentric-pause-concentric-pause)

-- Progression/Regression relationships
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS progression_id UUID REFERENCES exercises(id);
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS regression_id UUID REFERENCES exercises(id);
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS alternatives UUID[];

-- Injury modifications
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS injury_modifications JSONB DEFAULT '{}';
-- Format: {"shoulder": "Reduce ROM", "lower_back": "Use lighter weight, brace harder"}

-- Force and difficulty metrics
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS force_type TEXT CHECK (force_type IN ('push', 'pull', 'static', 'rotation'));
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS mechanics TEXT CHECK (mechanics IN ('compound', 'isolation'));
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS bilateral BOOLEAN DEFAULT TRUE;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS requires_spotter BOOLEAN DEFAULT FALSE;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS difficulty_score INT CHECK (difficulty_score >= 1 AND difficulty_score <= 10);

-- Metadata and status
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS verified_by UUID REFERENCES admin_users(id);
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS verified_at TIMESTAMPTZ;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS tags TEXT[];
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS external_id TEXT; -- For ExerciseDB API reference

-- ============================================
-- UPDATE EXISTING EXERCISES WITH SAMPLE DATA
-- ============================================

-- Barbell Bench Press
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Retract and depress shoulder blades',
    'Feet flat on floor, drive through heels',
    'Lower bar to lower chest/sternum',
    'Elbows at 45-degree angle to torso',
    'Push through the floor with your legs'
  ],
  common_mistakes = ARRAY[
    'Flaring elbows to 90 degrees',
    'Bouncing bar off chest',
    'Lifting hips off bench',
    'Not touching chest',
    'Uneven bar path'
  ],
  setup_instructions = 'Lie flat on bench with eyes under bar. Grip bar slightly wider than shoulder width. Unrack with straight arms.',
  execution_instructions = 'Lower bar with control to lower chest. Touch chest lightly, then press back up in a slight arc toward face. Lock out arms at top.',
  breathing_cues = 'Inhale at top, brace core. Hold breath during descent. Exhale at sticking point or at top.',
  tempo_recommendation = '3-1-1-0',
  force_type = 'push',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = TRUE,
  difficulty_score = 5,
  tags = ARRAY['powerlifting', 'upper_body', 'chest', 'compound', 'barbell']
WHERE slug = 'barbell-bench-press';

-- Barbell Squat
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Brace core like taking a punch',
    'Break at hips and knees simultaneously',
    'Knees track over toes',
    'Keep chest up, back tight',
    'Drive through full foot, not just heels'
  ],
  common_mistakes = ARRAY[
    'Rounding lower back (butt wink)',
    'Knees caving inward',
    'Coming up on toes',
    'Leaning too far forward',
    'Not hitting depth'
  ],
  setup_instructions = 'Bar on upper traps (high bar) or rear delts (low bar). Feet shoulder width or slightly wider. Toes slightly out.',
  execution_instructions = 'Initiate by pushing hips back and bending knees. Descend until hip crease is below knee (or to depth you can control). Drive up by pushing floor away.',
  breathing_cues = 'Big breath at top, brace hard. Hold through entire rep. Reset breath at top.',
  tempo_recommendation = '3-1-1-0',
  force_type = 'push',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = TRUE,
  difficulty_score = 6,
  injury_modifications = '{"knee": "Limit depth to pain-free range, consider box squat", "lower_back": "Use safety squat bar, reduce load significantly"}',
  tags = ARRAY['powerlifting', 'lower_body', 'quads', 'compound', 'barbell']
WHERE slug = 'barbell-squat';

-- Conventional Deadlift
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Bar over mid-foot',
    'Hips between shoulders and knees',
    'Squeeze armpits, lock lats',
    'Push floor away, dont pull with arms',
    'Lock hips and knees together at top'
  ],
  common_mistakes = ARRAY[
    'Starting with hips too low (squatting the deadlift)',
    'Rounding lower back',
    'Bar drifting away from body',
    'Hyperextending at lockout',
    'Looking up during lift'
  ],
  setup_instructions = 'Stand with feet hip width, toes slightly out. Grip just outside legs. Take slack out of bar before pulling.',
  execution_instructions = 'Brace, push floor away while keeping bar close to body. Once bar passes knees, drive hips forward. Stand tall, dont lean back.',
  breathing_cues = 'Breathe into belly, brace before pull. Hold through lift. Exhale at top.',
  tempo_recommendation = '0-0-1-1',
  force_type = 'pull',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = FALSE,
  difficulty_score = 7,
  injury_modifications = '{"lower_back": "Use trap bar, reduce load, or substitute with RDL", "grip": "Use straps or hook grip"}',
  tags = ARRAY['powerlifting', 'posterior_chain', 'back', 'compound', 'barbell']
WHERE slug = 'conventional-deadlift';

-- Pull-ups
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Initiate with shoulder blades, not arms',
    'Drive elbows down and back',
    'Chest to bar, not chin over bar',
    'Full extension at bottom (dead hang)',
    'Keep core tight, no kipping'
  ],
  common_mistakes = ARRAY[
    'Not going to full extension',
    'Using momentum/kipping',
    'Only getting chin over bar',
    'Shrugging shoulders at top',
    'Swinging body'
  ],
  setup_instructions = 'Hang from bar with overhand grip slightly wider than shoulders. Arms fully extended.',
  execution_instructions = 'Depress shoulder blades, then pull. Drive elbows down toward hips. Pull until chest reaches bar. Lower with control.',
  breathing_cues = 'Inhale at bottom. Exhale as you pull. Control descent.',
  tempo_recommendation = '1-0-1-1',
  force_type = 'pull',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = FALSE,
  difficulty_score = 6,
  injury_modifications = '{"shoulder": "Use neutral grip, limit ROM", "elbow": "Avoid full lockout at bottom"}',
  tags = ARRAY['bodyweight', 'upper_body', 'back', 'lats', 'compound']
WHERE slug = 'pull-ups';

-- Overhead Press
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Squeeze glutes, brace core',
    'Bar starts at collarbone',
    'Press in straight line, head moves back',
    'Lock out with bar over spine',
    'Push head through at top'
  ],
  common_mistakes = ARRAY[
    'Excessive lower back arch',
    'Bar path too far forward',
    'Not locking out',
    'Using leg drive (push press)',
    'Flaring elbows'
  ],
  setup_instructions = 'Unrack bar at collarbone. Grip slightly wider than shoulders. Elbows slightly in front of bar.',
  execution_instructions = 'Squeeze glutes, press bar up and slightly back. Move head back as bar passes face. Lock out overhead.',
  breathing_cues = 'Breathe at bottom. Brace, hold during press. Exhale at lockout.',
  tempo_recommendation = '1-0-1-1',
  force_type = 'push',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = FALSE,
  difficulty_score = 5,
  tags = ARRAY['powerbuilding', 'shoulders', 'compound', 'barbell']
WHERE slug = 'overhead-press';

-- Romanian Deadlift
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Start standing, not from floor',
    'Push hips back like closing car door',
    'Slight knee bend, but knees dont move forward',
    'Feel stretch in hamstrings',
    'Keep bar close to thighs'
  ],
  common_mistakes = ARRAY[
    'Bending knees too much (becomes squat)',
    'Rounding back',
    'Going too deep (past flexibility)',
    'Bar drifting away from body',
    'Hyperextending at top'
  ],
  setup_instructions = 'Hold bar at hip height with overhand grip. Feet hip width. Soft knee bend.',
  execution_instructions = 'Push hips back, lowering bar along thighs. Go until hamstrings fully stretched or back starts to round. Drive hips forward to stand.',
  breathing_cues = 'Inhale at top. Hold during descent. Exhale on way up.',
  tempo_recommendation = '3-1-1-0',
  force_type = 'pull',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = FALSE,
  difficulty_score = 4,
  tags = ARRAY['posterior_chain', 'hamstrings', 'glutes', 'compound', 'barbell']
WHERE slug = 'romanian-deadlift';

-- Goblet Squat
UPDATE exercises SET
  coaching_cues = ARRAY[
    'Hold weight at chest, elbows between knees',
    'Sit down between legs',
    'Push knees out with elbows',
    'Keep torso upright',
    'Full depth is easier with this variation'
  ],
  common_mistakes = ARRAY[
    'Letting weight pull you forward',
    'Not going deep enough',
    'Knees caving in',
    'Rising on toes',
    'Dropping elbows'
  ],
  setup_instructions = 'Hold dumbbell or kettlebell at chest with both hands. Elbows pointing down. Feet shoulder width or wider.',
  execution_instructions = 'Push hips back and down. Use elbows to push knees out at bottom. Descend as deep as mobility allows. Stand up by driving through floor.',
  breathing_cues = 'Inhale on the way down. Exhale as you stand.',
  tempo_recommendation = '2-1-1-0',
  force_type = 'push',
  mechanics = 'compound',
  bilateral = TRUE,
  requires_spotter = FALSE,
  difficulty_score = 2,
  tags = ARRAY['beginner', 'quads', 'compound', 'dumbbell', 'kettlebell']
WHERE slug = 'goblet-squat';

-- ============================================
-- CREATE EXERCISE RELATIONSHIPS
-- ============================================

-- Set up progression/regression chains
UPDATE exercises SET regression_id = (SELECT id FROM exercises WHERE slug = 'goblet-squat') WHERE slug = 'barbell-squat';
UPDATE exercises SET progression_id = (SELECT id FROM exercises WHERE slug = 'barbell-squat') WHERE slug = 'goblet-squat';

UPDATE exercises SET regression_id = (SELECT id FROM exercises WHERE slug = 'romanian-deadlift') WHERE slug = 'conventional-deadlift';
UPDATE exercises SET progression_id = (SELECT id FROM exercises WHERE slug = 'conventional-deadlift') WHERE slug = 'romanian-deadlift';

UPDATE exercises SET regression_id = (SELECT id FROM exercises WHERE slug = 'lat-pulldown') WHERE slug = 'pull-ups';
UPDATE exercises SET progression_id = (SELECT id FROM exercises WHERE slug = 'pull-ups') WHERE slug = 'lat-pulldown';

UPDATE exercises SET regression_id = (SELECT id FROM exercises WHERE slug = 'dumbbell-bench-press') WHERE slug = 'barbell-bench-press';
UPDATE exercises SET progression_id = (SELECT id FROM exercises WHERE slug = 'barbell-bench-press') WHERE slug = 'dumbbell-bench-press';

UPDATE exercises SET regression_id = (SELECT id FROM exercises WHERE slug = 'push-ups') WHERE slug = 'dumbbell-bench-press';
UPDATE exercises SET progression_id = (SELECT id FROM exercises WHERE slug = 'dumbbell-bench-press') WHERE slug = 'push-ups';

-- ============================================
-- CREATE HELPER FUNCTION FOR EXERCISE LOOKUP
-- ============================================

CREATE OR REPLACE FUNCTION get_exercise_with_alternatives(p_exercise_id UUID)
RETURNS TABLE (
  exercise JSONB,
  progression JSONB,
  regression JSONB,
  alternatives JSONB
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    to_jsonb(e.*) as exercise,
    (SELECT to_jsonb(ep.*) FROM exercises ep WHERE ep.id = e.progression_id) as progression,
    (SELECT to_jsonb(er.*) FROM exercises er WHERE er.id = e.regression_id) as regression,
    (
      SELECT jsonb_agg(to_jsonb(ea.*))
      FROM exercises ea 
      WHERE ea.id = ANY(e.alternatives)
    ) as alternatives
  FROM exercises e
  WHERE e.id = p_exercise_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- CREATE VIEW FOR EXERCISE BROWSER
-- ============================================

CREATE OR REPLACE VIEW exercise_browser AS
SELECT 
  e.id,
  e.name,
  e.slug,
  e.description,
  e.movement_pattern,
  e.exercise_type,
  e.difficulty,
  e.difficulty_score,
  e.primary_muscles,
  e.secondary_muscles,
  e.equipment_required,
  e.video_url,
  e.thumbnail_url,
  e.gif_url,
  e.coaching_cues,
  e.common_mistakes,
  e.force_type,
  e.mechanics,
  e.bilateral,
  e.is_verified,
  e.tags,
  -- Progression info
  ep.name as progression_name,
  ep.slug as progression_slug,
  er.name as regression_name,
  er.slug as regression_slug
FROM exercises e
LEFT JOIN exercises ep ON e.progression_id = ep.id
LEFT JOIN exercises er ON e.regression_id = er.id
ORDER BY e.name;

