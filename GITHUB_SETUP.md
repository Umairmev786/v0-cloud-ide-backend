# GitHub Actions Auto-Deployment Setup

## Step 1: Get Your Render Information

Go to [render.com](https://render.com) dashboard and copy:
- **Backend Service ID**: Settings → Deploy Hook (copy ID from URL)
  - Example: `srv-1234567890`
- **Frontend Service ID**: Settings → Deploy Hook (copy ID from URL)
- **Render API Key**: Account Settings → API Keys

## Step 2: Add GitHub Secrets

1. Go to your GitHub repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** and add these 5 secrets:

| Secret Name | Where to Get It |
|-------------|-----------------|
| `RENDER_API_KEY` | Render Account Settings |
| `RENDER_BACKEND_SERVICE_ID` | Render Backend Service ID |
| `RENDER_FRONTEND_SERVICE_ID` | Render Frontend Service ID |
| `RENDER_BACKEND_URL` | https://your-backend.onrender.com |
| `DATABASE_URL` | Your Neon PostgreSQL URL |
| `INTERNAL_API_KEY` | Generate: `openssl rand -hex 32` |

### Example Secret Values:
```
RENDER_API_KEY = rnd_xxxxxxxxxxxxxxxxxxxxx
RENDER_BACKEND_SERVICE_ID = srv-123456789
RENDER_FRONTEND_SERVICE_ID = srv-987654321
RENDER_BACKEND_URL = https://cloud-ide-backend.onrender.com
DATABASE_URL = postgresql://user:pass@host:5432/db
INTERNAL_API_KEY = a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

## Step 3: Create Render Services

### Backend Service
1. Go to Render dashboard → **New+** → **Web Service**
2. Connect your GitHub repo
3. Configure:
   - **Name**: `cloud-ide-backend`
   - **Build**: `cd backend && npm install && npm run build`
   - **Start**: `cd backend && npm start`
   - **Plan**: Starter ($7/month) or higher
4. Go to **Settings** → **Deploy Hook** and copy the Service ID

### Frontend Service
1. Go to Render dashboard → **New+** → **Web Service**
2. Connect your GitHub repo (same repo)
3. Configure:
   - **Name**: `cloud-ide-frontend`
   - **Build**: `cd dashboard && npm install && npm run build`
   - **Start**: `cd dashboard && npm start`
   - **Plan**: Starter ($7/month) or higher
4. Add Environment Variable: `NEXT_PUBLIC_API_URL=https://your-backend.onrender.com`

### Add All Env Variables

**Backend Service - Environment Variables:**
```
DATABASE_URL = (your Neon URL)
JWT_SECRET = openssl rand -hex 32
ALLOWED_ORIGINS = https://your-frontend.onrender.com
NODE_ENV = production
```

**Frontend Service - Environment Variables:**
```
NEXT_PUBLIC_API_URL = https://your-backend.onrender.com
NEXT_PUBLIC_JWT_EXPIRY = 7d
```

## Step 4: Test Deployment

### Manual Trigger
1. Go to GitHub → **Actions** tab
2. Click **Deploy to Render** workflow
3. Click **Run workflow**
4. Watch the logs

### Automatic Trigger (on push)
```bash
git add .
git commit -m "Test auto-deployment"
git push origin main
```

Go to GitHub → **Actions** tab to watch the deployment!

## Step 5: Verify Deployment

After deployment completes:

```bash
# Test backend health
curl https://your-backend.onrender.com/health

# Test frontend
open https://your-frontend.onrender.com
```

## Troubleshooting

### Workflow fails with "Invalid API Key"
- Check if `RENDER_API_KEY` is copied correctly
- Make sure it's in Secrets, not Variables

### Services not deploying
- Verify Service IDs in GitHub Secrets
- Check Render dashboard for build errors
- Look at GitHub Actions logs for details

### Database migrations not running
- Ensure `DATABASE_URL` is set in Render Backend settings
- Check backend logs: Render → Backend Service → Logs

### Frontend can't reach backend
- Verify `NEXT_PUBLIC_API_URL` in Frontend environment
- Check CORS settings in backend
- Ensure both services are running (green status)

## How It Works

1. **Push to GitHub** → GitHub Actions workflow triggers
2. **Build & Deploy** → Both services deploy simultaneously
3. **Run Migrations** → Database updates automatically
4. **Health Check** → System verifies deployment success
5. **Live!** → Your app is live in ~3-5 minutes

## Manual Redeploy

If you need to redeploy without pushing:

```bash
# GitHub Actions tab → Deploy to Render → Run workflow
```

Or use Render dashboard:
1. Go to your service
2. Click **Manual Deploy** → **Deploy latest commit**

---

**All set! Now just push to GitHub and watch it deploy automatically!** 🚀
