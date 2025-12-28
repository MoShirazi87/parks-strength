-- ═══════════════════════════════════════════════════════════════════════════
-- MIGRATION: Add streak and gamification fields to users table
-- ═══════════════════════════════════════════════════════════════════════════

-- Add new columns to users table for gamification
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS streak_current INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS streak_longest INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS streak_last_workout TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS streak_freezes INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS total_workouts INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS total_volume_lifted DECIMAL DEFAULT 0;

-- Create index for leaderboard queries
CREATE INDEX IF NOT EXISTS idx_users_points ON public.users(points DESC);
CREATE INDEX IF NOT EXISTS idx_users_streak ON public.users(streak_current DESC);

-- ═══════════════════════════════════════════════════════════════════════════
-- NUTRITION TABLES
-- ═══════════════════════════════════════════════════════════════════════════

-- User nutrition targets
CREATE TABLE IF NOT EXISTS public.nutrition_targets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  target_calories INTEGER NOT NULL,
  target_protein INTEGER NOT NULL,
  target_carbs INTEGER NOT NULL,
  target_fat INTEGER NOT NULL,
  goal TEXT NOT NULL DEFAULT 'maintain',
  activity_level TEXT NOT NULL DEFAULT 'moderately_active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_nutrition_targets_user ON public.nutrition_targets(user_id);

-- Food entries log
CREATE TABLE IF NOT EXISTS public.food_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  serving_size DECIMAL NOT NULL,
  serving_unit TEXT NOT NULL DEFAULT 'g',
  calories INTEGER NOT NULL,
  protein INTEGER NOT NULL,
  carbs INTEGER NOT NULL,
  fat INTEGER NOT NULL,
  quality TEXT DEFAULT 'tier3',
  meal_type TEXT NOT NULL,
  logged_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_food_entries_user_date ON public.food_entries(user_id, logged_at DESC);

-- ═══════════════════════════════════════════════════════════════════════════
-- COMMUNITY/TRIBE MESSAGES
-- ═══════════════════════════════════════════════════════════════════════════

-- Tribe/community messages
CREATE TABLE IF NOT EXISTS public.tribe_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  message_type TEXT DEFAULT 'text',
  is_coach_post BOOLEAN DEFAULT FALSE,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tribe_messages_created ON public.tribe_messages(created_at DESC);

-- Message likes
CREATE TABLE IF NOT EXISTS public.tribe_message_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id UUID NOT NULL REFERENCES public.tribe_messages(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(message_id, user_id)
);

-- Message comments
CREATE TABLE IF NOT EXISTS public.tribe_message_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id UUID NOT NULL REFERENCES public.tribe_messages(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  comment TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════════════════════════════════════
-- LEADERBOARD VIEW
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW public.leaderboard_weekly AS
SELECT 
  u.id,
  COALESCE(u.display_name, u.first_name, split_part(u.email, '@', 1)) as display_name,
  u.avatar_url,
  u.points,
  u.streak_current,
  RANK() OVER (ORDER BY u.points DESC) as rank
FROM public.users u
WHERE u.last_active_at > NOW() - INTERVAL '7 days'
ORDER BY u.points DESC
LIMIT 100;

-- ═══════════════════════════════════════════════════════════════════════════
-- RLS POLICIES FOR NEW TABLES
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE public.nutrition_targets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tribe_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tribe_message_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tribe_message_comments ENABLE ROW LEVEL SECURITY;

-- Nutrition targets policies
CREATE POLICY "Users can view own nutrition targets"
  ON public.nutrition_targets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own nutrition targets"
  ON public.nutrition_targets FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own nutrition targets"
  ON public.nutrition_targets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Food entries policies
CREATE POLICY "Users can view own food entries"
  ON public.food_entries FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own food entries"
  ON public.food_entries FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own food entries"
  ON public.food_entries FOR DELETE
  USING (auth.uid() = user_id);

-- Tribe messages policies (visible to all authenticated users)
CREATE POLICY "Authenticated users can view tribe messages"
  ON public.tribe_messages FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can post tribe messages"
  ON public.tribe_messages FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own tribe messages"
  ON public.tribe_messages FOR DELETE
  USING (auth.uid() = user_id);

-- Tribe likes policies
CREATE POLICY "Authenticated users can view likes"
  ON public.tribe_message_likes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can like messages"
  ON public.tribe_message_likes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove own likes"
  ON public.tribe_message_likes FOR DELETE
  USING (auth.uid() = user_id);

-- Tribe comments policies
CREATE POLICY "Authenticated users can view comments"
  ON public.tribe_message_comments FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can post comments"
  ON public.tribe_message_comments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments"
  ON public.tribe_message_comments FOR DELETE
  USING (auth.uid() = user_id);

