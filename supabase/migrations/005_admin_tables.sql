-- Admin and Management Database Tables
-- For management application integration

-- ============================================
-- ADMIN USERS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS admin_users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'editor' CHECK (role IN ('super_admin', 'admin', 'editor', 'viewer')),
  permissions JSONB DEFAULT '{}',
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ
);

-- RLS for admin_users
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin users can view other admins" ON admin_users
  FOR SELECT USING (
    auth.uid() IN (SELECT id FROM admin_users)
  );

CREATE POLICY "Super admins can manage admin users" ON admin_users
  FOR ALL USING (
    auth.uid() IN (SELECT id FROM admin_users WHERE role = 'super_admin')
  );

-- ============================================
-- CONTENT VERSIONING TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS content_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type TEXT NOT NULL CHECK (entity_type IN ('program', 'workout', 'exercise', 'article')),
  entity_id UUID NOT NULL,
  version INT NOT NULL DEFAULT 1,
  data JSONB NOT NULL,
  change_summary TEXT,
  created_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_published BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMPTZ
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_content_versions_entity ON content_versions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_content_versions_published ON content_versions(is_published) WHERE is_published = TRUE;

-- RLS for content_versions
ALTER TABLE content_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage content versions" ON content_versions
  FOR ALL USING (
    auth.uid() IN (SELECT id FROM admin_users)
  );

-- ============================================
-- ANALYTICS EVENTS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  session_id UUID,
  event_type TEXT NOT NULL,
  event_name TEXT,
  event_data JSONB DEFAULT '{}',
  device_info JSONB DEFAULT '{}',
  screen_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for analytics queries
CREATE INDEX IF NOT EXISTS idx_analytics_events_type ON analytics_events(event_type);
CREATE INDEX IF NOT EXISTS idx_analytics_events_user ON analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_events_date ON analytics_events(created_at);
CREATE INDEX IF NOT EXISTS idx_analytics_events_session ON analytics_events(session_id);

-- Partitioning hint (for future - partition by month)
COMMENT ON TABLE analytics_events IS 'Consider partitioning by created_at for large datasets';

-- RLS for analytics_events
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can insert their own events" ON analytics_events
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all analytics" ON analytics_events
  FOR SELECT USING (
    auth.uid() IN (SELECT id FROM admin_users)
  );

-- ============================================
-- AGGREGATED ANALYTICS VIEWS
-- ============================================

CREATE OR REPLACE VIEW daily_active_users AS
SELECT 
  DATE(created_at) as date,
  COUNT(DISTINCT user_id) as dau,
  COUNT(*) as total_events
FROM analytics_events
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;

CREATE OR REPLACE VIEW workout_completion_stats AS
SELECT 
  DATE(completed_at) as date,
  COUNT(*) as completions,
  AVG(duration_seconds) as avg_duration,
  SUM(total_volume) as total_volume,
  SUM(points_earned) as total_points
FROM workout_logs
WHERE completed_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(completed_at)
ORDER BY date DESC;

CREATE OR REPLACE VIEW program_enrollment_stats AS
SELECT 
  p.name as program_name,
  p.slug as program_slug,
  COUNT(DISTINCT upe.user_id) as total_enrollments,
  COUNT(DISTINCT CASE WHEN upe.status = 'active' THEN upe.user_id END) as active_enrollments,
  COUNT(DISTINCT CASE WHEN upe.status = 'completed' THEN upe.user_id END) as completions
FROM programs p
LEFT JOIN user_program_enrollments upe ON p.id = upe.program_id
GROUP BY p.id, p.name, p.slug
ORDER BY total_enrollments DESC;

CREATE OR REPLACE VIEW user_engagement_summary AS
SELECT 
  u.id,
  u.email,
  u.display_name,
  u.created_at as signup_date,
  u.last_active_at,
  u.points,
  u.current_streak,
  COUNT(DISTINCT wl.id) as total_workouts,
  COALESCE(SUM(wl.total_volume), 0) as lifetime_volume,
  MAX(wl.completed_at) as last_workout_date
FROM users u
LEFT JOIN workout_logs wl ON u.id = wl.user_id
GROUP BY u.id
ORDER BY u.last_active_at DESC NULLS LAST;

-- ============================================
-- SCHEDULED CONTENT TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS scheduled_content (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_type TEXT NOT NULL CHECK (content_type IN ('notification', 'tip', 'challenge', 'announcement')),
  title TEXT NOT NULL,
  body TEXT,
  target_audience JSONB DEFAULT '{}', -- filters for who receives
  scheduled_for TIMESTAMPTZ NOT NULL,
  sent_at TIMESTAMPTZ,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'cancelled', 'failed')),
  created_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  metadata JSONB DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS idx_scheduled_content_status ON scheduled_content(status, scheduled_for);

-- RLS for scheduled_content
ALTER TABLE scheduled_content ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage scheduled content" ON scheduled_content
  FOR ALL USING (
    auth.uid() IN (SELECT id FROM admin_users)
  );

-- ============================================
-- FEATURE FLAGS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS feature_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  flag_key TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  is_enabled BOOLEAN DEFAULT FALSE,
  rollout_percentage INT DEFAULT 0 CHECK (rollout_percentage >= 0 AND rollout_percentage <= 100),
  target_users UUID[] DEFAULT '{}',
  exclude_users UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS for feature_flags
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read enabled flags" ON feature_flags
  FOR SELECT USING (is_enabled = TRUE);

CREATE POLICY "Admins can manage feature flags" ON feature_flags
  FOR ALL USING (
    auth.uid() IN (SELECT id FROM admin_users WHERE role IN ('super_admin', 'admin'))
  );

-- ============================================
-- APP CONFIGURATION TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS app_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  config_key TEXT UNIQUE NOT NULL,
  config_value JSONB NOT NULL,
  description TEXT,
  is_public BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert some default config
INSERT INTO app_config (config_key, config_value, description, is_public) VALUES
  ('subscription_prices', '{"monthly": 12.99, "annual": 79.99, "currency": "USD"}', 'Subscription pricing', TRUE),
  ('app_version', '{"minimum": "1.0.0", "latest": "1.0.0", "force_update": false}', 'App version requirements', TRUE),
  ('maintenance_mode', '{"enabled": false, "message": ""}', 'Maintenance mode settings', TRUE),
  ('points_multipliers', '{"workout_complete": 50, "per_set": 5, "streak_7": 100, "streak_30": 500}', 'Points system configuration', FALSE),
  ('default_rest_times', '{"compound": 120, "isolation": 60, "warmup": 30}', 'Default rest times in seconds', TRUE)
ON CONFLICT (config_key) DO NOTHING;

-- RLS for app_config
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read public config" ON app_config
  FOR SELECT USING (is_public = TRUE);

CREATE POLICY "Admins can manage all config" ON app_config
  FOR ALL USING (
    auth.uid() IN (SELECT id FROM admin_users WHERE role IN ('super_admin', 'admin'))
  );

-- ============================================
-- AUDIT LOG TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES admin_users(id),
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id UUID,
  old_data JSONB,
  new_data JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_log_admin ON audit_log(admin_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_entity ON audit_log(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_date ON audit_log(created_at);

-- RLS for audit_log
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view audit logs" ON audit_log
  FOR SELECT USING (
    auth.uid() IN (SELECT id FROM admin_users)
  );

CREATE POLICY "System can insert audit logs" ON audit_log
  FOR INSERT WITH CHECK (TRUE);

-- ============================================
-- HELPER FUNCTIONS FOR MANAGEMENT
-- ============================================

-- Function to get user activity summary
CREATE OR REPLACE FUNCTION get_user_activity_summary(p_user_id UUID)
RETURNS TABLE (
  total_workouts BIGINT,
  total_volume NUMERIC,
  total_points INT,
  current_streak INT,
  longest_streak INT,
  favorite_exercise TEXT,
  avg_workout_duration INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(DISTINCT wl.id)::BIGINT as total_workouts,
    COALESCE(SUM(wl.total_volume), 0) as total_volume,
    COALESCE((SELECT u.points FROM users u WHERE u.id = p_user_id), 0) as total_points,
    COALESCE((SELECT u.current_streak FROM users u WHERE u.id = p_user_id), 0) as current_streak,
    COALESCE((SELECT MAX(current_streak) FROM users WHERE id = p_user_id), 0) as longest_streak,
    (
      SELECT e.name 
      FROM exercise_logs el
      JOIN exercises e ON el.exercise_id = e.id
      JOIN workout_logs wl2 ON el.workout_log_id = wl2.id
      WHERE wl2.user_id = p_user_id
      GROUP BY e.id, e.name
      ORDER BY COUNT(*) DESC
      LIMIT 1
    ) as favorite_exercise,
    COALESCE(AVG(wl.duration_seconds)::INT / 60, 0) as avg_workout_duration
  FROM workout_logs wl
  WHERE wl.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to log admin action
CREATE OR REPLACE FUNCTION log_admin_action(
  p_action TEXT,
  p_entity_type TEXT DEFAULT NULL,
  p_entity_id UUID DEFAULT NULL,
  p_old_data JSONB DEFAULT NULL,
  p_new_data JSONB DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
  v_log_id UUID;
BEGIN
  INSERT INTO audit_log (admin_id, action, entity_type, entity_id, old_data, new_data)
  VALUES (auth.uid(), p_action, p_entity_type, p_entity_id, p_old_data, p_new_data)
  RETURNING id INTO v_log_id;
  
  RETURN v_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

