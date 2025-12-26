# Cloud IDE Backend API Documentation

## Base URL
```
http://localhost:3001/api
```

## Authentication

All endpoints (except `/auth/*`) require an `Authorization` header with a valid JWT token:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

## Endpoints

### Authentication

#### Register
```
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "username": "username",
  "password": "password123"
}

Response: 201
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "username"
  }
}
```

#### Login
```
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response: 200
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "username"
  }
}
```

### Projects

#### List Projects
```
GET /projects

Response: 200
[
  {
    "id": 1,
    "user_id": 1,
    "name": "My Project",
    "description": "Project description",
    "github_url": "https://github.com/user/repo",
    "runtime": "node",
    "created_at": "2025-12-26T12:00:00Z",
    "updated_at": "2025-12-26T12:00:00Z"
  }
]
```

#### Create Project
```
POST /projects
Content-Type: application/json

{
  "name": "My Project",
  "description": "Project description",
  "github_url": "https://github.com/user/repo",
  "runtime": "node"
}

Response: 201
{
  "id": 1,
  "user_id": 1,
  "name": "My Project",
  ...
}
```

#### Get Project
```
GET /projects/:projectId

Response: 200
{
  "id": 1,
  "user_id": 1,
  "name": "My Project",
  ...
}
```

#### Update Project
```
PUT /projects/:projectId
Content-Type: application/json

{
  "name": "Updated Name",
  "description": "Updated description",
  "branch": "develop",
  "runtime": "python"
}

Response: 200
{
  "id": 1,
  ...
}
```

#### Delete Project
```
DELETE /projects/:projectId

Response: 200
{
  "message": "Project deleted"
}
```

### Files

#### List Files
```
GET /files/:projectId

Response: 200
[
  {
    "id": 1,
    "project_id": 1,
    "path": "package.json",
    "content": "{...}",
    "is_directory": false,
    "created_at": "2025-12-26T12:00:00Z"
  }
]
```

#### Get File
```
GET /files/:projectId/file?path=package.json

Response: 200
{
  "id": 1,
  "project_id": 1,
  "path": "package.json",
  "content": "{...}",
  "is_directory": false
}
```

#### Create/Update File
```
POST /files/:projectId/file
Content-Type: application/json

{
  "path": "src/index.js",
  "content": "console.log('Hello');",
  "is_directory": false
}

Response: 201
{
  "id": 1,
  "project_id": 1,
  "path": "src/index.js",
  ...
}
```

#### Delete File
```
DELETE /files/:projectId/file?path=src/index.js

Response: 200
{
  "message": "File deleted"
}
```

### Terminal

#### Create Session
```
POST /terminal/:projectId/session

Response: 201
{
  "id": 1,
  "project_id": 1,
  "user_id": 1,
  "status": "active",
  "created_at": "2025-12-26T12:00:00Z"
}
```

#### Execute Command
```
POST /terminal/:projectId/command
Content-Type: application/json

{
  "sessionId": 1,
  "command": "npm install"
}

Response: 200
{
  "output": "added 150 packages..."
}
```

#### Get Sessions
```
GET /terminal/:projectId/sessions

Response: 200
[
  {
    "id": 1,
    "project_id": 1,
    "status": "active",
    ...
  }
]
```

### Agent

#### Execute Action
```
POST /agent/:projectId/execute
Content-Type: application/json

{
  "sessionId": 1,
  "actionType": "run_command",
  "actionData": {
    "command": "npm test"
  }
}

Response: 200
{
  "id": 1,
  "project_id": 1,
  "action_type": "run_command",
  "output": "Test results...",
  "status": "completed"
}
```

#### Get Actions
```
GET /agent/:projectId/actions?limit=50

Response: 200
[
  {
    "id": 1,
    "project_id": 1,
    "action_type": "run_command",
    "status": "completed",
    ...
  }
]
```

#### Get Action Details
```
GET /agent/:projectId/actions/:actionId

Response: 200
{
  "id": 1,
  "project_id": 1,
  "action_type": "run_command",
  ...
}
```

### Deploy

#### Trigger Deployment
```
POST /deploy/:projectId/deploy

Response: 202
{
  "message": "Deployment started",
  "deployLogId": 1
}
```

#### Get Deploy Logs
```
GET /deploy/:projectId/deploy/logs

Response: 200
[
  {
    "id": 1,
    "project_id": 1,
    "status": "success",
    "log_output": "...",
    "auto_fix_attempted": false,
    "created_at": "2025-12-26T12:00:00Z"
  }
]
```

#### Get Deploy Log
```
GET /deploy/:projectId/deploy/logs/:logId

Response: 200
{
  "id": 1,
  "project_id": 1,
  "status": "success",
  ...
}
```

### GitHub

#### Clone Repository
```
POST /github/:projectId/clone
Content-Type: application/json

{
  "repoUrl": "https://github.com/user/repo",
  "branch": "main"
}

Response: 202
{
  "message": "Clone started",
  "projectId": 1
}
```

#### Commit Changes
```
POST /github/:projectId/commit
Content-Type: application/json

{
  "message": "Update files",
  "files": ["src/index.js", "package.json"]
}

Response: 200
{
  "message": "Committed",
  "output": "..."
}
```

#### Push Changes
```
POST /github/:projectId/push
Content-Type: application/json

{
  "branch": "main"
}

Response: 200
{
  "message": "Pushed",
  "output": "..."
}
```

## Error Responses

### 400 Bad Request
```json
{
  "error": "Missing required fields"
}
```

### 401 Unauthorized
```json
{
  "error": "Invalid token"
}
```

### 403 Forbidden
```json
{
  "error": "Access denied"
}
```

### 404 Not Found
```json
{
  "error": "Project not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error"
}
```

## Rate Limiting

No rate limiting implemented by default. Consider adding for production.

## Pagination

Not implemented by default. Use `limit` query parameter where available (e.g., `/api/agent/:projectId/actions?limit=50`).

## Webhooks

Webhooks are triggered on deploy events. Configure URLs in the webhooks table:

```sql
INSERT INTO webhooks (project_id, url, event_type, max_retries)
VALUES (1, 'https://example.com/webhook', 'deploy_success', 5);
```

Events:
- `deploy_success`: Deployment completed successfully
- `deploy_failed`: Deployment failed

Payload:
```json
{
  "event": "deploy_success",
  "data": "Deployment log output..."
}
```

## Testing

Run the API test suite:
```bash
bash scripts/test-api.sh
```

## Support

For issues or questions, check the [README.md](./README.md) or open an issue on GitHub.
