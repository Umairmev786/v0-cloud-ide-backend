# Render Deployment - Backend + Dashboard

## Problem Explained
Render को दोनों services deploy करने पड़ेंगे क्योंकि दोनों अलग-अलग हैं:
- **Backend**: Express.js (Node.js)
- **Dashboard**: Next.js (Node.js)

## Solution: 2 Services बनाओ

### Service 1: Backend
**Dashboard में Settings:**
- **Name**: `cloud-ide-backend`
- **Repository**: `Umairmev786/v0-cloud-ide-backend`
- **Branch**: `main`
- **Root Directory**: `backend`
- **Build Command**: `npm install && npm run build`
- **Start Command**: `npm start`
- **Port**: `3000` (या कोई भी)

**Environment Variables:**
```
DATABASE_URL=postgresql://neondb_owner:npg_jYh2UtGrz8uw@ep-tiny-glade-ahf7ipsb-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
JWT_SECRET=<generate-with-openssl>
ALLOWED_ORIGINS=<backend-url-only>
NODE_ENV=production
```

---

### Service 2: Dashboard (Next.js Frontend)
**Dashboard में Settings:**
- **Name**: `cloud-ide-dashboard`
- **Repository**: `Umairmev786/v0-cloud-ide-backend`
- **Branch**: `main`
- **Root Directory**: `dashboard`
- **Build Command**: `npm install && npm run build`
- **Start Command**: `npm start`
- **Port**: `3001` (या कोई भी)

**Environment Variables:**
```
NEXT_PUBLIC_API_URL=https://cloud-ide-backend.onrender.com
NODE_ENV=production
```

---

## Steps

### 1. Backend Deploy करो
- Render Dashboard → Create Service
- Select GitHub repo
- Root Directory: `backend`
- Build & Start commands above लगाओ
- Environment variables add करो
- Deploy करो
- Backend URL copy करो (example: `https://cloud-ide-backend.onrender.com`)

### 2. Dashboard Deploy करो
- Render Dashboard → Create Service (नया)
- Same repo, same branch
- Root Directory: `dashboard`
- Build & Start commands above लगाओ
- `NEXT_PUBLIC_API_URL` में backend URL paste करो
- Deploy करो

---

## Common Issues

### Issue: Root Directory doesn't exist
**Fix**: Check dashboard में Root Directory सही है

### Issue: Build fails in dashboard
**Fix**: Ensure `npm run build` works locally पहले

### Issue: API connection error
**Fix**: Dashboard में env variable `NEXT_PUBLIC_API_URL` check करो

---

## Testing

जब दोनों deploy हो जाएँ:
```bash
# Backend health check
curl https://cloud-ide-backend.onrender.com/health

# Dashboard
Open https://cloud-ide-dashboard.onrender.com
```

Done! 🚀
