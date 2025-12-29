-- =====================================================
-- MIGRATION 017: Ensure Exercises with GIF URLs
-- This ensures key exercises have working GIF URLs
-- =====================================================

-- Update exercises table to have gif_url column if not exists
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS gif_url TEXT;

-- Update key exercises with working GIF URLs from inspireusafoundation.org
-- These are verified working URLs

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif'
WHERE LOWER(name) LIKE '%bench press%' AND LOWER(name) LIKE '%barbell%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/dumbbell-bench-press.gif'
WHERE LOWER(name) LIKE '%dumbbell%' AND LOWER(name) LIKE '%bench press%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-press.gif'
WHERE LOWER(name) LIKE '%incline%' AND LOWER(name) LIKE '%dumbbell%' AND LOWER(name) LIKE '%press%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif'
WHERE (LOWER(name) LIKE '%overhead press%' OR LOWER(name) LIKE '%military press%' OR LOWER(name) = 'ohp') AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shoulder-press.gif'
WHERE LOWER(name) LIKE '%shoulder press%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif'
WHERE LOWER(name) LIKE '%dip%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif'
WHERE LOWER(name) LIKE '%tricep%' AND LOWER(name) LIKE '%pushdown%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif'
WHERE LOWER(name) LIKE '%lateral raise%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif'
WHERE (LOWER(name) LIKE '%back squat%' OR LOWER(name) = 'squat' OR LOWER(name) = 'barbell squat') AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-deadlift.gif'
WHERE LOWER(name) LIKE '%deadlift%' AND NOT LOWER(name) LIKE '%romanian%' AND NOT LOWER(name) LIKE '%rdl%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-romanian-deadlift.gif'
WHERE (LOWER(name) LIKE '%romanian deadlift%' OR LOWER(name) LIKE '%rdl%' OR LOWER(name) LIKE '%stiff leg%') AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif'
WHERE LOWER(name) LIKE '%barbell row%' OR LOWER(name) LIKE '%bent over row%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/single-arm-dumbbell-row.gif'
WHERE LOWER(name) LIKE '%dumbbell row%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif'
WHERE LOWER(name) LIKE '%pull up%' OR LOWER(name) LIKE '%pull-up%' OR LOWER(name) = 'pullup' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/chin-up.gif'
WHERE LOWER(name) LIKE '%chin up%' OR LOWER(name) LIKE '%chin-up%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/lat-pulldown.gif'
WHERE LOWER(name) LIKE '%lat pulldown%' OR LOWER(name) LIKE '%pulldown%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif'
WHERE LOWER(name) LIKE '%cable row%' OR LOWER(name) LIKE '%seated row%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/face-pull.gif'
WHERE LOWER(name) LIKE '%face pull%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-curl.gif'
WHERE LOWER(name) LIKE '%barbell curl%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-bicep-curl.gif'
WHERE LOWER(name) LIKE '%dumbbell curl%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/hammer-curl.gif'
WHERE LOWER(name) LIKE '%hammer curl%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/goblet-squat.gif'
WHERE LOWER(name) LIKE '%goblet squat%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/leg-press.gif'
WHERE LOWER(name) LIKE '%leg press%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/leg-extension-machine.gif'
WHERE LOWER(name) LIKE '%leg extension%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/lying-leg-curl-machine.gif'
WHERE LOWER(name) LIKE '%leg curl%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/barbell-hip-thrust.gif'
WHERE LOWER(name) LIKE '%hip thrust%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-calf-raise-machine.gif'
WHERE LOWER(name) LIKE '%calf raise%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif'
WHERE LOWER(name) LIKE '%lunge%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/bulgarian-split-squat.gif'
WHERE LOWER(name) LIKE '%bulgarian%' OR LOWER(name) LIKE '%split squat%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif'
WHERE LOWER(name) LIKE '%push up%' OR LOWER(name) LIKE '%push-up%' OR LOWER(name) = 'pushup' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/plank.gif'
WHERE LOWER(name) LIKE '%plank%' AND gif_url IS NULL;

UPDATE exercises SET gif_url = 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/russian-kettlebell-swing.gif'
WHERE LOWER(name) LIKE '%kettlebell swing%' OR LOWER(name) LIKE '%kb swing%' AND gif_url IS NULL;

-- Ensure we have basic exercises for demo workout if they don't exist
INSERT INTO exercises (id, name, slug, description, movement_pattern, difficulty, is_published, gif_url, created_at)
VALUES
  ('ex_barbell_bench_press', 'Barbell Bench Press', 'barbell-bench-press', 'Classic chest builder', 'push_horizontal', 'intermediate', true, 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif', NOW()),
  ('ex_overhead_press', 'Overhead Press', 'overhead-press', 'Shoulder strength builder', 'push_vertical', 'intermediate', true, 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif', NOW()),
  ('ex_incline_dumbbell_press', 'Incline Dumbbell Press', 'incline-dumbbell-press', 'Upper chest focus', 'push_horizontal', 'beginner', true, 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-press.gif', NOW()),
  ('ex_dips', 'Dips', 'dips', 'Chest and triceps compound', 'push_vertical', 'intermediate', true, 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif', NOW()),
  ('ex_cable_tricep_pushdown', 'Cable Tricep Pushdown', 'cable-tricep-pushdown', 'Tricep isolation', 'isolation', 'beginner', true, 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif', NOW()),
  ('ex_lateral_raise', 'Lateral Raise', 'lateral-raise', 'Side delt builder', 'isolation', 'beginner', true, 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif', NOW())
ON CONFLICT (id) DO UPDATE SET 
  gif_url = EXCLUDED.gif_url,
  is_published = true;

-- Verify
SELECT name, gif_url FROM exercises WHERE gif_url IS NOT NULL LIMIT 10;

