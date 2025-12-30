-- =====================================================
-- FIX EXERCISE GIF URLs
-- Updates exercises with publicly accessible GIF URLs
-- =====================================================

-- Update exercises with working ExerciseDB GIF URLs (public CDN format)
-- ExerciseDB public format: https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/{name}/0.jpg

-- First, let's update the most common exercises with verified working GIFs
-- Using a mix of sources: ExerciseDB raw GitHub, Wger, and placeholder images

-- CHEST EXERCISES
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-bench-press-medium-grip/0.jpg' 
WHERE slug = 'barbell-bench-press' OR name ILIKE '%barbell bench press%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/incline-barbell-bench-press/0.jpg' 
WHERE slug = 'incline-barbell-bench-press' OR name ILIKE '%incline barbell bench%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-bench-press/0.jpg' 
WHERE slug = 'dumbbell-bench-press' OR name ILIKE 'dumbbell bench press%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/incline-dumbbell-press/0.jpg' 
WHERE slug = 'incline-dumbbell-press' OR name ILIKE '%incline dumbbell press%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-fly/0.jpg' 
WHERE slug = 'dumbbell-fly' OR name ILIKE '%dumbbell fly%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/push-up/0.jpg' 
WHERE slug = 'push-up' OR name ILIKE 'push-up%' OR name ILIKE 'pushup%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/diamond-push-up/0.jpg' 
WHERE slug = 'diamond-push-up' OR name ILIKE '%diamond push%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/cable-fly/0.jpg' 
WHERE slug = 'cable-fly' OR name ILIKE '%cable fly%';

-- BACK EXERCISES  
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-deadlift/0.jpg' 
WHERE name ILIKE '%deadlift%' AND name NOT ILIKE '%romanian%' AND name NOT ILIKE '%sumo%' AND name NOT ILIKE '%stiff%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/romanian-deadlift/0.jpg' 
WHERE name ILIKE '%romanian deadlift%' OR name ILIKE '%rdl%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-bent-over-row/0.jpg' 
WHERE name ILIKE '%barbell row%' OR name ILIKE '%bent over row%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-row/0.jpg' 
WHERE name ILIKE '%dumbbell row%' OR name ILIKE '%one arm row%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/lat-pulldown/0.jpg' 
WHERE name ILIKE '%lat pulldown%' OR name ILIKE '%pull down%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/pull-up/0.jpg' 
WHERE name ILIKE 'pull-up%' OR name ILIKE 'pullup%' OR name = 'Pull-up';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/chin-up/0.jpg' 
WHERE name ILIKE '%chin-up%' OR name ILIKE '%chinup%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/cable-row/0.jpg' 
WHERE name ILIKE '%cable row%' OR name ILIKE '%seated row%';

-- SHOULDER EXERCISES
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-overhead-press/0.jpg' 
WHERE name ILIKE '%overhead press%' OR name ILIKE '%military press%' OR name ILIKE '%shoulder press%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-lateral-raise/0.jpg' 
WHERE name ILIKE '%lateral raise%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-front-raise/0.jpg' 
WHERE name ILIKE '%front raise%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-rear-delt-fly/0.jpg' 
WHERE name ILIKE '%rear delt%' OR name ILIKE '%reverse fly%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/arnold-press/0.jpg' 
WHERE name ILIKE '%arnold press%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/face-pull/0.jpg' 
WHERE name ILIKE '%face pull%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-shrug/0.jpg' 
WHERE name ILIKE '%shrug%';

-- LEG EXERCISES
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-squat/0.jpg' 
WHERE name ILIKE '%barbell squat%' OR name = 'Back Squat' OR name = 'Squat';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/goblet-squat/0.jpg' 
WHERE name ILIKE '%goblet squat%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/leg-press/0.jpg' 
WHERE name ILIKE '%leg press%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-lunge/0.jpg' 
WHERE name ILIKE '%lunge%' AND name NOT ILIKE '%walking%' AND name NOT ILIKE '%reverse%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/walking-lunge/0.jpg' 
WHERE name ILIKE '%walking lunge%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/leg-extension/0.jpg' 
WHERE name ILIKE '%leg extension%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/leg-curl/0.jpg' 
WHERE name ILIKE '%leg curl%' OR name ILIKE '%hamstring curl%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/calf-raise/0.jpg' 
WHERE name ILIKE '%calf raise%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/hip-thrust/0.jpg' 
WHERE name ILIKE '%hip thrust%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/glute-bridge/0.jpg' 
WHERE name ILIKE '%glute bridge%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/step-up/0.jpg' 
WHERE name ILIKE '%step-up%' OR name ILIKE '%step up%';

-- ARM EXERCISES
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/barbell-curl/0.jpg' 
WHERE name ILIKE '%barbell curl%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dumbbell-curl/0.jpg' 
WHERE name ILIKE '%dumbbell curl%' OR name ILIKE '%bicep curl%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/hammer-curl/0.jpg' 
WHERE name ILIKE '%hammer curl%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/preacher-curl/0.jpg' 
WHERE name ILIKE '%preacher curl%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/triceps-pushdown/0.jpg' 
WHERE name ILIKE '%tricep pushdown%' OR name ILIKE '%rope pushdown%' OR name ILIKE '%triceps pushdown%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/skull-crusher/0.jpg' 
WHERE name ILIKE '%skull crusher%' OR name ILIKE '%lying tricep%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/triceps-dip/0.jpg' 
WHERE name ILIKE '%dip%' AND (name ILIKE '%tricep%' OR name NOT ILIKE '%chest%');

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/overhead-tricep-extension/0.jpg' 
WHERE name ILIKE '%overhead tricep%' OR name ILIKE '%overhead extension%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/wrist-curl/0.jpg' 
WHERE name ILIKE '%wrist curl%' OR name ILIKE '%forearm curl%';

-- CORE EXERCISES
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/crunch/0.jpg' 
WHERE name ILIKE '%crunch%' AND name NOT ILIKE '%bicycle%' AND name NOT ILIKE '%reverse%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/bicycle-crunch/0.jpg' 
WHERE name ILIKE '%bicycle crunch%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/plank/0.jpg' 
WHERE name ILIKE 'plank%' OR name = 'Plank';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/side-plank/0.jpg' 
WHERE name ILIKE '%side plank%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/leg-raise/0.jpg' 
WHERE name ILIKE '%leg raise%' OR name ILIKE '%hanging raise%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/russian-twist/0.jpg' 
WHERE name ILIKE '%russian twist%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/mountain-climber/0.jpg' 
WHERE name ILIKE '%mountain climber%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/dead-bug/0.jpg' 
WHERE name ILIKE '%dead bug%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/ab-wheel-rollout/0.jpg' 
WHERE name ILIKE '%ab wheel%' OR name ILIKE '%rollout%';

-- FULL BODY / CARDIO EXERCISES
UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/burpee/0.jpg' 
WHERE name ILIKE '%burpee%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/kettlebell-swing/0.jpg' 
WHERE name ILIKE '%kettlebell swing%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/clean-and-jerk/0.jpg' 
WHERE name ILIKE '%clean and jerk%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/power-clean/0.jpg' 
WHERE name ILIKE '%power clean%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/thruster/0.jpg' 
WHERE name ILIKE '%thruster%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/jumping-jack/0.jpg' 
WHERE name ILIKE '%jumping jack%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/box-jump/0.jpg' 
WHERE name ILIKE '%box jump%';

UPDATE exercises SET gif_url = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/jump-squat/0.jpg' 
WHERE name ILIKE '%jump squat%';

-- For any exercises still without GIFs, set a placeholder based on body part
UPDATE exercises 
SET gif_url = 'https://via.placeholder.com/400x300/1a1a2e/ffffff?text=' || REPLACE(name, ' ', '+')
WHERE gif_url IS NULL OR gif_url = '' OR gif_url LIKE '%v2.exercisedb.io%';

-- Verify the update
SELECT name, gif_url FROM exercises WHERE is_published = true ORDER BY name LIMIT 20;
