-- Users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  username VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Projects table
CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  github_url VARCHAR(500),
  repo_name VARCHAR(255),
  branch VARCHAR(100) DEFAULT 'main',
  runtime VARCHAR(50) DEFAULT 'node', -- node, python, go, etc.
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, name)
);

-- Files table
CREATE TABLE files (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  path VARCHAR(1000) NOT NULL,
  content TEXT,
  is_directory BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(project_id, path)
);

-- Terminal sessions
CREATE TABLE terminal_sessions (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  container_id VARCHAR(255),
  status VARCHAR(50) DEFAULT 'active', -- active, stopped, failed
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agent actions (logging)
CREATE TABLE agent_actions (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  session_id INTEGER REFERENCES terminal_sessions(id) ON DELETE SET NULL,
  action_type VARCHAR(100) NOT NULL, -- run_command, create_file, update_file, delete_file, deploy
  action_data JSONB,
  output TEXT,
  status VARCHAR(50) DEFAULT 'pending', -- pending, completed, failed
  error_message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Deploy logs
CREATE TABLE deploy_logs (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  deployment_id VARCHAR(255),
  status VARCHAR(50) DEFAULT 'in_progress', -- in_progress, success, failed
  log_output TEXT,
  error_output TEXT,
  auto_fix_attempted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Webhooks
CREATE TABLE webhooks (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  url VARCHAR(500) NOT NULL,
  event_type VARCHAR(100) NOT NULL, -- deploy_success, deploy_failed, test_run, etc.
  retry_count INTEGER DEFAULT 0,
  max_retries INTEGER DEFAULT 5,
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_projects_user_id ON projects(user_id);
CREATE INDEX idx_files_project_id ON files(project_id);
CREATE INDEX idx_terminal_sessions_project_id ON terminal_sessions(project_id);
CREATE INDEX idx_agent_actions_project_id ON agent_actions(project_id);
CREATE INDEX idx_deploy_logs_project_id ON deploy_logs(project_id);
CREATE INDEX idx_webhooks_project_id ON webhooks(project_id);
