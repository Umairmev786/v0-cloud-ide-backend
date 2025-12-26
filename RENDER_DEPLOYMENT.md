# Render Deployment Guide

Complete step-by-step guide to deploy your Cloud IDE backend and dashboard on Render.

## Part 1: Prepare Your Repository

### Step 1: Create GitHub Repository
```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit: Cloud IDE backend"

# Push to GitHub
git remote add origin https://github.com/yourusername/cloud-ide.git
git branch -M main
git push -u origin main
```

### Step 2: Project Structure for Render
Your repo should look like:
```
cloud-ide/
├── backend/                 # Express backend
│   ├── src/
│   ├── package.json
│   ├── Dockerfile.prod
│   └── tsconfig.json
├── dashboard/               # Next.js frontend
│   ├── app/
│   ├── package.json
│   ├── Dockerfile
│   └── next.config.ts
├── scripts/
├── docker-compose.yml
├── README.md
└── RENDER_DEPLOYMENT.md
```

---

## Part 2: Deploy Backend on Render

### Step 1: Create Render Account
1. Go to [render.com](https://render.com)
2. Sign up with GitHub
3. Authorize Render to access your GitHub repos

### Step 2: Create Backend Web Service
1. Dashboard → Click **"New +"** → Select **"Web Service"**
2. Connect your GitHub repo:
   - Select: `cloud-ide` repository
   - Branch: `main`
   - Click **"Connect"**

### Step 3: Configure Backend Service

Fill in the following settings:

| Setting | Value |
|---------|-------|
| **Name** | `cloud-ide-backend` |
| **Environment** | `Node` |
| **Region** | `Oregon (US West)` or closest to you |
| **Branch** | `main` |
| **Build Command** | `cd backend && npm install && npm run build` |
| **Start Command** | `cd backend && npm start` |
| **Plan** | `Free` (or paid for production) |

### Step 4: Set Environment Variables
Click **"Environment"** and add these variables:

```
PORT=3001
NODE_ENV=production
DATABASE_URL=postgresql://user:password@host:5432/dbname
JWT_SECRET=your-super-secret-key-change-this
JWT_EXPIRY=7d
ALLOWED_ORIGINS=https://cloud-ide-dashboard-xxxxx.onrender.com,https://yourdomain.com
DOCKER_BACKEND_URL=unix:///var/run/docker.sock
DOCKER_REGISTRY=docker.io
```

**Important:** 
- Get `DATABASE_URL` from your Neon database
- Generate a strong `JWT_SECRET` (use: `openssl rand -hex 32`)
- Update `ALLOWED_ORIGINS` with your dashboard URL (see Part 3)

### Step 5: Deploy
1. Click **"Create Web Service"**
2. Render will automatically build and deploy
3. Wait for: `Your service is live` ✅
4. Note the URL: `https://cloud-ide-backend-xxxxx.onrender.com`

### Step 6: Run Database Migrations
Once backend is deployed:

```bash
# Option 1: SSH into Render and run migrations
# (In Render dashboard → Shell → Run command)
npm run migrate

# Option 2: Call migration endpoint
curl -X POST https://cloud-ide-backend-xxxxx.onrender.com/api/health
```

---

## Part 3: Deploy Frontend (Dashboard) on Render

### Step 1: Create Frontend Web Service
1. Dashboard → Click **"New +"** → Select **"Web Service"**
2. Select the same `cloud-ide` GitHub repo
3. Configure:

| Setting | Value |
|---------|-------|
| **Name** | `cloud-ide-dashboard` |
| **Environment** | `Node` |
| **Region** | Same as backend |
| **Branch** | `main` |
| **Build Command** | `cd dashboard && npm install && npm run build` |
| **Start Command** | `cd dashboard && npm start` |

### Step 2: Set Frontend Environment Variables

Click **"Environment"** and add:

```
NEXT_PUBLIC_API_URL=https://cloud-ide-backend-xxxxx.onrender.com
NODE_ENV=production
```

**Important:**
- Replace `cloud-ide-backend-xxxxx.onrender.com` with your actual backend URL
- `NEXT_PUBLIC_` prefix makes it accessible to frontend

### Step 3: Deploy
1. Click **"Create Web Service"**
2. Wait for build and deployment
3. Your dashboard will be available at: `https://cloud-ide-dashboard-xxxxx.onrender.com`

### Step 4: Update Backend CORS
Go back to backend service:
1. Settings → Environment
2. Update `ALLOWED_ORIGINS`:
   ```
   ALLOWED_ORIGINS=https://cloud-ide-dashboard-xxxxx.onrender.com,https://yourdomain.com
   ```
3. Click **"Save"** - Service will auto-redeploy

---

## Part 4: Setup PostgreSQL Database on Render

### Option A: Use Neon (Recommended - Already Set Up)
Your `DATABASE_URL` is already from Neon. Just make sure it's configured in backend environment variables.

### Option B: Use Render PostgreSQL
If you want to use Render's managed database:

1. Dashboard → Click **"New +"** → Select **"PostgreSQL"**
2. Configure:
   - **Name:** `cloud-ide-db`
   - **Database:** `cloudide`
   - **User:** `cloudide_user`
   - **Region:** Same as services
   - **Plan:** `Free` (or paid)

3. Copy the connection string (looks like):
   ```
   postgresql://cloudide_user:password@dpg-xxxxx-a.oregon-postgres.render.com:5432/cloudide
   ```

4. Add to backend environment as `DATABASE_URL`

---

## Part 5: Post-Deployment Checklist

### Test Backend Health
```bash
curl https://cloud-ide-backend-xxxxx.onrender.com/health
```

Expected response:
```json
{
  "status": "ok",
  "timestamp": "2025-01-15T10:00:00Z"
}
```

### Test API Endpoints
```bash
# Register user
curl -X POST https://cloud-ide-backend-xxxxx.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!"}'

# Login
curl -X POST https://cloud-ide-backend-xxxxx.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!"}'
```

### Test Frontend
1. Open `https://cloud-ide-dashboard-xxxxx.onrender.com`
2. Register a new account
3. Create a project
4. Test file operations
5. Test terminal commands

### Check Logs
- **Backend logs:** Render Dashboard → Services → cloud-ide-backend → Logs
- **Frontend logs:** Render Dashboard → Services → cloud-ide-dashboard → Logs

---

## Part 6: Production Optimization

### Enable Auto-Deploy
1. Services → Select service
2. Settings → "Auto-Deploy" → Toggle ON
3. Now every git push to `main` auto-deploys

### Setup Health Checks
1. Settings → Health Check
2. Path: `/health`
3. Check interval: `60` seconds

### Configure Disk Usage Alerts
1. Settings → Notifications
2. Enable alerts for high disk usage

### Setup Custom Domain
1. Services → Dashboard
2. Settings → Custom Domain
3. Add your domain (e.g., `api.yourdomain.com`)
4. Update CNAME in your DNS provider

### Database Backups
For production, use Neon's built-in backup:
- Neon Dashboard → Backups
- Automatic backups every 24 hours
- Retention: 7 days (free), 30 days (paid)

---

## Part 7: Troubleshooting

### Build Fails
**Error:** `npm: command not found`
- Solution: Ensure Node version is set. Settings → Environment → Node version: `20`

### Database Connection Error
**Error:** `ECONNREFUSED`
- Check `DATABASE_URL` is correct
- Verify database is running
- Test connection: `psql $DATABASE_URL`

### Service Crashes
**Check logs:**
```bash
# In Render dashboard
Services → cloud-ide-backend → Logs
```

**Common causes:**
- Missing environment variables
- Database not initialized (run migrations)
- Insufficient memory (upgrade plan)

### CORS Errors
**Error:** `Access to XMLHttpRequest blocked by CORS policy`
- Solution: Update `ALLOWED_ORIGINS` in backend environment
- Include your frontend URL exactly as it appears in browser

### Timeout Issues
**Error:** `504 Gateway Timeout`
- Render free tier has 30-second limit
- Upgrade to paid plan for longer timeouts
- Or optimize database queries

---

## Part 8: Environment Variables Reference

### Required Variables
| Variable | Example | Notes |
|----------|---------|-------|
| `DATABASE_URL` | `postgresql://...` | Neon connection string |
| `JWT_SECRET` | `abc123xyz789...` | Use `openssl rand -hex 32` |
| `PORT` | `3001` | Backend port |
| `NODE_ENV` | `production` | Deployment environment |

### Optional Variables
| Variable | Example | Notes |
|----------|---------|-------|
| `OLLAMA_URL` | `http://localhost:11434` | Local LLM (if self-hosted) |
| `GITHUB_TOKEN` | `ghp_xxxxx` | GitHub API access |
| `DOCKER_BACKEND_URL` | `unix:///var/run/docker.sock` | Docker socket |
| `SANDBOX_TIMEOUT` | `30000` | Command timeout (ms) |

---

## Deployment Summary

```
┌──────────────────────────────────────────────┐
│  Your Deployed System                        │
├──────────────────────────────────────────────┤
│                                              │
│  Frontend (Next.js)                          │
│  └─ cloud-ide-dashboard-xxxxx.onrender.com   │
│                                              │
│  Backend (Express.js)                        │
│  └─ cloud-ide-backend-xxxxx.onrender.com     │
│                                              │
│  Database (PostgreSQL - Neon)                │
│  └─ postgresql://user:pass@neon-host:5432   │
│                                              │
│  All connected via environment variables ✅   │
│  Auto-deployed on git push ✅                 │
│  Health checks enabled ✅                     │
│  Logs streaming in Render dashboard ✅        │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Quick Links

- [Render Dashboard](https://dashboard.render.com)
- [Render Docs](https://render.com/docs)
- [Neon Console](https://console.neon.tech)
- [GitHub](https://github.com)

## Support

If you encounter issues:
1. Check Render logs (Services → Logs)
2. Verify environment variables (Settings → Environment)
3. Test health endpoint: `/health`
4. Check database connectivity

Happy deploying! 🚀
