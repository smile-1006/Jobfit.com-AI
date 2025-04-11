/*
  # Initial Schema for JobFit AI

  1. New Tables
    - `jobs`
      - Job postings with title, description, requirements, etc.
    - `candidates`
      - Candidate profiles with contact info and metadata
    - `resumes`
      - Parsed resume data and file storage
    - `matches`
      - Job-candidate matches with scores and status
    - `interviews`
      - Scheduled interviews and feedback
    - `skills`
      - Skill taxonomy and requirements
    
  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Jobs table
CREATE TABLE IF NOT EXISTS jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  department text NOT NULL,
  location text NOT NULL,
  type text NOT NULL,
  description text NOT NULL,
  requirements text[] NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  status text NOT NULL DEFAULT 'active',
  created_by uuid REFERENCES auth.users(id)
);

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view all active jobs" 
  ON jobs FOR SELECT 
  USING (status = 'active');

CREATE POLICY "Users can create jobs"
  ON jobs FOR INSERT
  WITH CHECK (auth.uid() = created_by);

-- Candidates table
CREATE TABLE IF NOT EXISTS candidates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text UNIQUE NOT NULL,
  phone text,
  linkedin_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  status text NOT NULL DEFAULT 'active',
  created_by uuid REFERENCES auth.users(id)
);

ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own candidate profile"
  ON candidates FOR SELECT
  USING (auth.uid() = created_by);

CREATE POLICY "Users can create their candidate profile"
  ON candidates FOR INSERT
  WITH CHECK (auth.uid() = created_by);

-- Resumes table
CREATE TABLE IF NOT EXISTS resumes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  candidate_id uuid REFERENCES candidates(id) NOT NULL,
  file_url text NOT NULL,
  parsed_data jsonb NOT NULL DEFAULT '{}',
  skills text[] NOT NULL DEFAULT '{}',
  experience jsonb[] NOT NULL DEFAULT '{}',
  education jsonb[] NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE resumes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own resumes"
  ON resumes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM candidates
      WHERE candidates.id = resumes.candidate_id
      AND candidates.created_by = auth.uid()
    )
  );

CREATE POLICY "Users can upload their resumes"
  ON resumes FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM candidates
      WHERE candidates.id = candidate_id
      AND candidates.created_by = auth.uid()
    )
  );

-- Matches table
CREATE TABLE IF NOT EXISTS matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid REFERENCES jobs(id) NOT NULL,
  candidate_id uuid REFERENCES candidates(id) NOT NULL,
  resume_id uuid REFERENCES resumes(id) NOT NULL,
  match_score numeric NOT NULL DEFAULT 0,
  skill_match jsonb NOT NULL DEFAULT '{}',
  experience_match jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  status text NOT NULL DEFAULT 'pending'
);

ALTER TABLE matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own matches"
  ON matches FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM candidates
      WHERE candidates.id = matches.candidate_id
      AND candidates.created_by = auth.uid()
    )
  );

-- Interviews table
CREATE TABLE IF NOT EXISTS interviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id uuid REFERENCES matches(id) NOT NULL,
  scheduled_at timestamptz NOT NULL,
  duration interval NOT NULL,
  type text NOT NULL,
  status text NOT NULL DEFAULT 'scheduled',
  feedback jsonb DEFAULT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE interviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own interviews"
  ON interviews FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM matches
      JOIN candidates ON candidates.id = matches.candidate_id
      WHERE matches.id = interviews.match_id
      AND candidates.created_by = auth.uid()
    )
  );

-- Skills table
CREATE TABLE IF NOT EXISTS skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  category text NOT NULL,
  aliases text[] DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can view skills"
  ON skills FOR SELECT
  USING (true);

-- Functions
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER update_jobs_updated_at
  BEFORE UPDATE ON jobs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_candidates_updated_at
  BEFORE UPDATE ON candidates
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_resumes_updated_at
  BEFORE UPDATE ON resumes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_matches_updated_at
  BEFORE UPDATE ON matches
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_interviews_updated_at
  BEFORE UPDATE ON interviews
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_skills_updated_at
  BEFORE UPDATE ON skills
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();