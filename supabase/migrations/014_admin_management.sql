-- Migration 014: Admin Management System
-- RLS policies for admin users, audit logging, and content management

-- ============================================
-- CONTENT STATUS ENUM
-- ============================================

DO $$ BEGIN
  CREATE TYPE content_status AS ENUM ('draft', 'review', 'published', 'archived');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- ============================================
-- CONTENT AUDIT LOG TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS content_audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  action TEXT NOT NULL CHECK (action IN ('create', 'update', 'delete', 'publish', 'archive')),
  changes JSONB,
  performed_by UUID REFERENCES users(id),
  performed_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT
);

-- Enable RLS
ALTER TABLE content_audit_log ENABLE ROW LEVEL SECURITY;

-- Only admins can view audit logs
CREATE POLICY "Admins can view audit logs"
  ON content_audit_log FOR SELECT
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- Only admins can create audit logs
CREATE POLICY "Admins can create audit logs"
  ON content_audit_log FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR PROGRAMS
-- ============================================

-- Drop existing program policies if they exist
DROP POLICY IF EXISTS "Published programs readable by authenticated" ON programs;
DROP POLICY IF EXISTS "Admins can manage programs" ON programs;

-- Public can read published programs
CREATE POLICY "Published programs readable"
  ON programs FOR SELECT
  TO authenticated
  USING (is_published = true);

-- Admins can do everything with programs
CREATE POLICY "Admins full access to programs"
  ON programs FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR EXERCISES
-- ============================================

-- Drop existing exercise policies if they exist
DROP POLICY IF EXISTS "Exercises readable by authenticated" ON exercises;
DROP POLICY IF EXISTS "Published exercises readable" ON exercises;
DROP POLICY IF EXISTS "Admins can manage exercises" ON exercises;

-- Public can read published exercises
CREATE POLICY "Published exercises readable"
  ON exercises FOR SELECT
  TO authenticated
  USING (is_published = true);

-- Admins can do everything with exercises
CREATE POLICY "Admins full access to exercises"
  ON exercises FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR WORKOUTS
-- ============================================

-- Drop existing workout policies
DROP POLICY IF EXISTS "Workouts follow program access" ON workouts;
DROP POLICY IF EXISTS "Admins can manage workouts" ON workouts;

-- Users can read workouts from published programs
CREATE POLICY "Workouts readable from published programs"
  ON workouts FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM programs WHERE programs.id = workouts.program_id AND is_published = true
  ));

-- Admins can do everything with workouts
CREATE POLICY "Admins full access to workouts"
  ON workouts FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR WORKOUT SECTIONS
-- ============================================

DROP POLICY IF EXISTS "Workout sections readable" ON workout_sections;
DROP POLICY IF EXISTS "Sections follow workout access" ON workout_sections;

-- Users can read workout sections
CREATE POLICY "Workout sections readable"
  ON workout_sections FOR SELECT
  TO authenticated
  USING (true);

-- Admins can manage workout sections
CREATE POLICY "Admins full access to workout_sections"
  ON workout_sections FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR WORKOUT EXERCISES
-- ============================================

DROP POLICY IF EXISTS "Workout exercises readable" ON workout_exercises;
DROP POLICY IF EXISTS "Workout exercises follow access" ON workout_exercises;

-- Users can read workout exercises
CREATE POLICY "Workout exercises readable"
  ON workout_exercises FOR SELECT
  TO authenticated
  USING (true);

-- Admins can manage workout exercises
CREATE POLICY "Admins full access to workout_exercises"
  ON workout_exercises FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR PROGRAM WEEKS
-- ============================================

DROP POLICY IF EXISTS "Program weeks follow program access" ON program_weeks;

-- Users can read program weeks
CREATE POLICY "Program weeks readable"
  ON program_weeks FOR SELECT
  TO authenticated
  USING (true);

-- Admins can manage program weeks
CREATE POLICY "Admins full access to program_weeks"
  ON program_weeks FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR BADGES
-- ============================================

DROP POLICY IF EXISTS "Badges readable by all" ON badges;

-- Public can read active badges
CREATE POLICY "Active badges readable"
  ON badges FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Admins can manage badges
CREATE POLICY "Admins full access to badges"
  ON badges FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- ADMIN RLS POLICIES FOR EQUIPMENT
-- ============================================

DROP POLICY IF EXISTS "Equipment readable by all" ON equipment;

-- Public can read equipment
CREATE POLICY "Equipment readable"
  ON equipment FOR SELECT
  TO authenticated
  USING (true);

-- Admins can manage equipment
CREATE POLICY "Admins full access to equipment"
  ON equipment FOR ALL
  TO authenticated
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true));

-- ============================================
-- AUDIT TRIGGER FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION log_content_change()
RETURNS TRIGGER AS $$
DECLARE
  action_type TEXT;
  old_data JSONB;
  new_data JSONB;
BEGIN
  -- Determine action type
  IF TG_OP = 'INSERT' THEN
    action_type := 'create';
    old_data := NULL;
    new_data := to_jsonb(NEW);
  ELSIF TG_OP = 'UPDATE' THEN
    action_type := 'update';
    old_data := to_jsonb(OLD);
    new_data := to_jsonb(NEW);
    
    -- Check if this is a publish action
    IF OLD.is_published = false AND NEW.is_published = true THEN
      action_type := 'publish';
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    action_type := 'delete';
    old_data := to_jsonb(OLD);
    new_data := NULL;
  END IF;
  
  -- Insert audit log
  INSERT INTO content_audit_log (
    table_name,
    record_id,
    action,
    changes,
    performed_by
  ) VALUES (
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    action_type,
    jsonb_build_object('old', old_data, 'new', new_data),
    auth.uid()
  );
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- AUDIT TRIGGERS
-- ============================================

-- Programs audit trigger
DROP TRIGGER IF EXISTS audit_programs ON programs;
CREATE TRIGGER audit_programs
  AFTER INSERT OR UPDATE OR DELETE ON programs
  FOR EACH ROW
  EXECUTE FUNCTION log_content_change();

-- Exercises audit trigger
DROP TRIGGER IF EXISTS audit_exercises ON exercises;
CREATE TRIGGER audit_exercises
  AFTER INSERT OR UPDATE OR DELETE ON exercises
  FOR EACH ROW
  EXECUTE FUNCTION log_content_change();

-- Workouts audit trigger
DROP TRIGGER IF EXISTS audit_workouts ON workouts;
CREATE TRIGGER audit_workouts
  AFTER INSERT OR UPDATE OR DELETE ON workouts
  FOR EACH ROW
  EXECUTE FUNCTION log_content_change();

-- ============================================
-- MANAGEMENT VIEWS FOR ADMIN DASHBOARD
-- ============================================

-- View: Exercise statistics
CREATE OR REPLACE VIEW exercise_stats AS
SELECT 
  e.id,
  e.name,
  e.movement_pattern,
  e.difficulty,
  e.is_published,
  COUNT(DISTINCT we.workout_id) as workout_count,
  COUNT(DISTINCT el.id) as total_logs,
  COUNT(DISTINCT wl.user_id) as unique_users
FROM exercises e
LEFT JOIN workout_exercises we ON e.id = we.exercise_id
LEFT JOIN exercise_logs el ON e.id = el.exercise_id
LEFT JOIN workout_logs wl ON el.workout_log_id = wl.id
GROUP BY e.id, e.name, e.movement_pattern, e.difficulty, e.is_published;

-- View: Program statistics
CREATE OR REPLACE VIEW program_stats AS
SELECT 
  p.id,
  p.name,
  p.difficulty,
  p.is_published,
  p.is_premium,
  COUNT(DISTINCT w.id) as workout_count,
  COUNT(DISTINCT upe.user_id) as enrollment_count,
  COUNT(DISTINCT CASE WHEN upe.status = 'active' THEN upe.user_id END) as active_enrollments,
  COUNT(DISTINCT CASE WHEN upe.status = 'completed' THEN upe.user_id END) as completed_enrollments
FROM programs p
LEFT JOIN workouts w ON p.id = w.program_id
LEFT JOIN user_program_enrollments upe ON p.id = upe.program_id
GROUP BY p.id, p.name, p.difficulty, p.is_published, p.is_premium;

-- View: User statistics for admin dashboard
CREATE OR REPLACE VIEW user_stats_admin AS
SELECT 
  u.id,
  u.email,
  u.first_name,
  u.last_name,
  u.display_name,
  u.experience_level,
  u.onboarding_completed,
  u.points,
  u.current_streak,
  u.longest_streak,
  u.total_workouts,
  u.created_at,
  u.last_active_at,
  COUNT(DISTINCT wl.id) as workout_logs_count,
  SUM(wl.duration_seconds) / 3600.0 as total_hours_trained,
  SUM(wl.total_volume) as lifetime_volume
FROM users u
LEFT JOIN workout_logs wl ON u.id = wl.user_id
GROUP BY u.id;

-- ============================================
-- HELPER FUNCTIONS FOR MANAGEMENT APP
-- ============================================

-- Function: Get exercise usage analytics
CREATE OR REPLACE FUNCTION get_exercise_analytics(exercise_uuid UUID)
RETURNS TABLE (
  date DATE,
  total_sets BIGINT,
  total_reps BIGINT,
  avg_weight DECIMAL,
  unique_users BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    DATE(sl.completed_at) as date,
    COUNT(sl.id) as total_sets,
    SUM(sl.reps_completed)::BIGINT as total_reps,
    AVG(sl.weight) as avg_weight,
    COUNT(DISTINCT wl.user_id) as unique_users
  FROM set_logs sl
  JOIN exercise_logs el ON sl.exercise_log_id = el.id
  JOIN workout_logs wl ON el.workout_log_id = wl.id
  WHERE el.exercise_id = exercise_uuid
    AND sl.completed_at > NOW() - INTERVAL '30 days'
  GROUP BY DATE(sl.completed_at)
  ORDER BY date;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Get program performance metrics
CREATE OR REPLACE FUNCTION get_program_metrics(program_uuid UUID)
RETURNS TABLE (
  metric_name TEXT,
  metric_value DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 'total_enrollments'::TEXT, COUNT(*)::DECIMAL FROM user_program_enrollments WHERE program_id = program_uuid
  UNION ALL
  SELECT 'active_enrollments'::TEXT, COUNT(*)::DECIMAL FROM user_program_enrollments WHERE program_id = program_uuid AND status = 'active'
  UNION ALL
  SELECT 'completion_rate'::TEXT, 
    (SELECT COUNT(*)::DECIMAL / NULLIF(COUNT(*) FILTER (WHERE status IN ('active', 'completed')), 0) * 100 
     FROM user_program_enrollments WHERE program_id = program_uuid AND status = 'completed')
  UNION ALL
  SELECT 'avg_days_to_complete'::TEXT, 
    (SELECT AVG(EXTRACT(DAY FROM (completed_at - started_at)))::DECIMAL 
     FROM user_program_enrollments WHERE program_id = program_uuid AND status = 'completed');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- INDEX FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_content_audit_table ON content_audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_content_audit_record ON content_audit_log(record_id);
CREATE INDEX IF NOT EXISTS idx_content_audit_action ON content_audit_log(action);
CREATE INDEX IF NOT EXISTS idx_content_audit_performed_at ON content_audit_log(performed_at);
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin) WHERE is_admin = true;

