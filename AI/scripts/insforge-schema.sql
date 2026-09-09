-- InsForge schema for AI Kubernetes Agent dashboard
-- Run via InsForge CLI: npx @insforge/cli db push
-- Or apply through the InsForge dashboard SQL editor

-- Realtime channel pattern (create in InsForge Realtime dashboard):
-- Pattern: investigation:%
-- Description: Live investigation progress updates

CREATE TABLE IF NOT EXISTS investigations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  root_cause TEXT,
  namespace TEXT DEFAULT 'default',
  confidence INTEGER,
  status TEXT NOT NULL DEFAULT 'in_progress',
  explanation TEXT,
  suggested_fix TEXT,
  kubectl_command TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE investigations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own investigations"
  ON investigations FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own investigations"
  ON investigations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own investigations"
  ON investigations FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS investigations_user_id_created_at_idx
  ON investigations (user_id, created_at DESC);
