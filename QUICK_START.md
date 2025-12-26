# Quick Start: Deploy to Render in 15 Minutes

## 🎯 Overview
You have a **full-stack Cloud IDE** ready to deploy:
- **Backend:** Express.js API (Terminal, Files, Deploy, Agent)
- **Frontend:** Next.js Dashboard
- **Database:** PostgreSQL (Neon)

---

## ⚡ 15-Minute Deployment

### Step 1: Prepare GitHub (2 min)
```bash
git add .
git commit -m "Cloud IDE - Ready for Render"
git push origin main
```

### Step 2: Create Backend Service on Render (5 min)
1. Go to [render.com/dashboard](https://render.com/dashboard)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repo
4. Settings:
   - **Build:** `cd backend && npm install && npm run build`
   - **Start:** `cd backend && npm start`
5. Click **"Create Web Service"** → Deploy starts automatically

### Step 3: Set Backend Environment Variables (3 min)
In Render dashboard → Environment → Add:
```
PORT=3001
NODE_ENV=production
DATABASE_URL=postgresql://your-neon-url-here
JWT_SECRET=your-secret-key-here
ALLOWED_ORIGINS=https://your-dashboard-url
DOCKER_BACKEND_URL=unix:///var/run/docker.sock
DOCKER_REGISTRY=docker.io
```

### Step 4: Create Frontend Service (3 min)
1. Click **"New +"** → **"Web Service"** again
2. Same repo, settings:
   - **Build:** `cd dashboard && npm install && npm run build`
   - **Start:** `cd dashboard && npm start`
3. Environment:
   ```
   NEXT_PUBLIC_API_URL=https://your-backend-url.onrender.com
   NODE_ENV=production
   ```

### Step 5: Test (2 min)
```bash
# Test backend
curl https://your-backend-url.onrender.com/health

# Open frontend in browser
https://your-dashboard-url.onrender.com
```

---

## 📋 What You Get
✅ Real-time terminal access  
✅ File management system  
✅ Docker project execution  
✅ Git integration  
✅ Automatic deploy pipeline  
✅ User authentication  
✅ Agent system for automation  
✅ Webhook support  

---

## 🔧 Environment Variables You Need

| Variable | Where to Get |
|----------|--------------|
| `DATABASE_URL` | Neon console → Connection string |
| `JWT_SECRET` | Run: `openssl rand -hex 32` |
| `ALLOWED_ORIGINS` | Your Render dashboard frontend URL |

---

## 📞 Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails | Check Node version in Render (should be 20+) |
| Can't connect to DB | Verify DATABASE_URL in environment variables |
| CORS errors | Update ALLOWED_ORIGINS with exact frontend URL |
| 504 timeout | Normal on free tier for long operations; upgrade plan |

---

## 🚀 Next Steps

1. **Custom Domain:** Add your domain in Render settings
2. **Auto-deploy:** Enable in service settings
3. **Monitoring:** Set up Render notifications
4. **Backups:** Enable automatic Neon backups
5. **Scale:** Upgrade Render plan as needed

---

## 📚 Full Documentation
See `RENDER_DEPLOYMENT.md` for detailed step-by-step guide with screenshots and troubleshooting.
