# Cloud IDE Backend System

A production-ready full-featured backend system for a cloud IDE and bot deployment platform.

## 🎯 Overview

This is a complete backend + frontend solution with:
- Express.js API server with JWT authentication
- Next.js web dashboard
- PostgreSQL database (Neon compatible)
- Docker support for project execution
- GitHub integration
- Terminal emulation
- Deployment pipeline with auto-fix
- Webhook system
- Comprehensive logging

## 📁 Project Structure

```
.
├── backend/               # Express.js server
│   ├── src/
│   │   ├── server.ts     # Main server entry
│   │   ├── routes/       # API endpoints
│   │   ├── services/     # Business logic
│   │   ├── middleware/   # Auth & middleware
│   │   ├── db/          # Database connection
│   │   └── config/      # Configuration
│   ├── scripts/         # Migrations & scripts
│   ├── Dockerfile       # Production build
│   └── package.json
│
├── dashboard/            # Next.js frontend
│   ├── app/
│   ├── components/      # React components
│   ├── lib/            # Utilities & API client
│   ├── public/         # Static assets
│   └── package.json
│
├── scripts/            # Deployment scripts
├── docker-compose.yml
└── README.md
```

## ⚙️ Tech Stack

- **Backend**: Express.js 4
- **Frontend**: Next.js 16 + React 19
- **Database**: PostgreSQL 16
- **Auth**: JWT (jsonwebtoken)
- **Styling**: Tailwind CSS 4
- **API Client**: Axios + SWR
- **State**: Zustand

## 🚀 Quick Start

### Option 1: Local Development

```bash
# 1. Setup environment
bash scripts/local-setup.sh

# 2. Start services (in separate terminals)
# Terminal 1: Database
docker run -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:16-alpine

# Terminal 2: Backend
cd backend && npm run dev

# Terminal 3: Dashboard
cd dashboard && npm run dev
```

Visit:
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001
- Health: http://localhost:3001/health

### Option 2: Docker Compose

```bash
docker-compose up
```

### Option 3: Production Deployment

#### Render
```bash
# 1. Push to GitHub
git push origin main

# 2. Connect to Render
# 3. Set environment variables:
#    - DATABASE_URL
#    - JWT_SECRET
#    - GITHUB_TOKEN (optional)

# 4. Deploy using script
bash scripts/deploy-render.sh
```

#### Railway
```bash
bash scripts/deploy-railway.sh
```

## 🔐 Environment Variables

### Backend (.env)
```bash
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
ALLOWED_ORIGINS=https://yourdomain.com
GITHUB_TOKEN=ghp_xxxx
NODE_ENV=production
```

### Dashboard (.env.local)
```bash
NEXT_PUBLIC_API_URL=http://your-backend-url
```

## 📡 API Endpoints

### Auth
- `POST /api/auth/register` - Register
- `POST /api/auth/login` - Login

### Projects
- `GET /api/projects` - List projects
- `POST /api/projects` - Create
- `PUT /api/projects/:id` - Update
- `DELETE /api/projects/:id` - Delete

### Files
- `GET /api/files/:projectId` - List files
- `POST /api/files/:projectId/file` - Create/update
- `DELETE /api/files/:projectId/file` - Delete

### Terminal
- `POST /api/terminal/:projectId/session` - Create session
- `POST /api/terminal/:projectId/command` - Execute command

### Agent
- `POST /api/agent/:projectId/execute` - Execute action
- `GET /api/agent/:projectId/actions` - List actions

### Deploy
- `POST /api/deploy/:projectId/deploy` - Trigger deploy
- `GET /api/deploy/:projectId/deploy/logs` - View logs

### GitHub
- `POST /api/github/:projectId/clone` - Clone repo
- `POST /api/github/:projectId/commit` - Commit
- `POST /api/github/:projectId/push` - Push

## 🏥 Health Check

```bash
curl http://localhost:3001/health
```

Response:
```json
{
  "status": "ok",
  "timestamp": "2025-12-26T...",
  "environment": "production",
  "version": "1.0.0"
}
```

## 🛡️ Security

- ✅ JWT authentication with expiry
- ✅ Password hashing (bcryptjs)
- ✅ Command whitelisting for terminal
- ✅ User isolation per project
- ✅ SQL parameterization
- ✅ CORS configuration
- ✅ Environment variable validation

## 📊 Database Schema

**Users**: email, username, password_hash, timestamps
**Projects**: user_id, name, description, github_url, runtime
**Files**: project_id, path, content, is_directory
**Terminal Sessions**: project_id, user_id, container_id, status
**Agent Actions**: project_id, action_type, action_data, status
**Deploy Logs**: project_id, status, log_output, error_output
**Webhooks**: project_id, url, event_type, retry_count

## 🔧 Troubleshooting

### Database Connection Failed
```bash
# Check DATABASE_URL format
echo $DATABASE_URL

# Test connection
psql $DATABASE_URL -c "SELECT NOW();"
```

### Port Already in Use
```bash
# Kill process on port
lsof -i :3001
kill -9 <PID>
```

### Docker Permission Issues
```bash
# Linux: Add user to docker group
sudo usermod -aG docker $USER
sudo systemctl restart docker
```

### CORS Errors
Update `ALLOWED_ORIGINS` in `.env` to include your domain

## 📈 Performance

- Database connection pooling
- Indexed queries (user_id, project_id, etc.)
- Command execution timeout
- Output size limits (1MB default)
- SWR caching on frontend

## 🚢 Deployment Checklist

- [ ] Set production DATABASE_URL
- [ ] Change JWT_SECRET to secure random string
- [ ] Update ALLOWED_ORIGINS
- [ ] Add GITHUB_TOKEN if using Git integration
- [ ] Build: `npm run build`
- [ ] Test health endpoint
- [ ] Monitor logs and errors
- [ ] Setup automatic backups
- [ ] Configure HTTPS/SSL
- [ ] Setup monitoring/alerting

## 📚 Documentation

- [Backend README](./backend/README.md)
- [Dashboard README](./dashboard/README.md)
- [API Documentation](./API.md) (coming soon)

## 📝 Database Migrations

Run migrations automatically:
```bash
npm run migrate
```

Or manually:
```bash
psql $DATABASE_URL < scripts/001_init_schema.sql
```

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Test locally
4. Submit PR

## 📄 License

MIT

## 🎓 Learning Resources

- [Express.js Docs](https://expressjs.com)
- [Next.js Docs](https://nextjs.org)
- [PostgreSQL Docs](https://postgresql.org)
- [JWT Auth](https://jwt.io)

## 🆘 Support

Issues or questions? Open a GitHub issue or check the README files in each directory.

---

**Ready to deploy?** Start with the [Quick Start](#-quick-start) section above!
