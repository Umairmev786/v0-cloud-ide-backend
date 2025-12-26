# Render pe Backend Deploy करने का सही तरीका

## Backend Deploy करने के लिए:

### **1. Render Dashboard में जाओ**
https://dashboard.render.com/

### **2. New Web Service बनाओ**
- Click: "New +" → "Web Service"
- GitHub repo select करो
- Root directory: `backend`

### **3. Build & Deploy Commands**

**Build Command:**
```
npm install && npm run build
```

**Start Command:**
```
npm start
```

### **4. Environment Variables Add करो**

अपने Render Dashboard में "Environment" section में ये सब add करो:

```env
PORT=3001
NODE_ENV=production
DATABASE_URL=postgresql://user:password@host:port/database
JWT_SECRET=your-super-secret-key-here-generate-random
JWT_EXPIRY=7d
ALLOWED_ORIGINS=https://your-frontend.onrender.com,https://your-domain.com
GITHUB_TOKEN=ghp_your_github_personal_access_token
GITHUB_WEBHOOK_SECRET=webhook-secret-random-string
DOCKER_BACKEND_URL=unix:///var/run/docker.sock
OLLAMA_URL=http://your-ollama-server:11434
SANDBOX_TIMEOUT=30000
MAX_OUTPUT_SIZE=1048576
NEXT_PUBLIC_API_URL=https://your-backend.onrender.com
```

### **5. Database Setup करो**

Render Dashboard में "Query" tab से चला:
```sql
-- Copy करो backend के scripts/001_init_schema.sql में जो SQL है
```

या locally run करो:
```bash
DATABASE_URL="your-db-url" npm run migrate
```

### **Environment Variables का अर्थ:**

| Variable | क्या है | कहाँ से मिलेगा |
|----------|--------|----------------|
| `DATABASE_URL` | PostgreSQL connection string | Neon dashboard |
| `JWT_SECRET` | API auth के लिए random key | `openssl rand -hex 32` |
| `ALLOWED_ORIGINS` | Dashboard URL जो API को call करेगा | your-frontend.onrender.com |
| `GITHUB_TOKEN` | GitHub access के लिए | github.com/settings/tokens |
| `DOCKER_BACKEND_URL` | Docker socket | Render में auto available है |
| `OLLAMA_URL` | Local LLM server URL | अगर अलग server है |
| `NEXT_PUBLIC_API_URL` | Backend URL जो frontend को चाहिए | https://your-backend.onrender.com |

### **Database URL कहाँ से मिलेगा?**

1. Neon.tech dashboard खोलो
2. अपना database select करो
3. "Connection String" copy करो
4. Render में `DATABASE_URL` में paste करो

Example:
```
postgresql://neondb_owner:password@ep-random.us-east-1.neon.tech/neondb
```

### **JWT_SECRET कैसे generate करो?**

Terminal में ये command चला:
```bash
openssl rand -hex 32
```

Output copy करके `JWT_SECRET` में paste कर दो।

### **Deploy होगा या नहीं check करने के लिए:**

1. Render Dashboard → Logs देखो
2. Error दिख रहा है तो बताना
3. Health check करो: `https://your-backend.onrender.com/health`

अगर 200 OK return हो तो सब ठीक है!

### **Frontend के लिए भी same करना होगा:**

- New Web Service बनाओ
- Root directory: `dashboard`
- Build: `npm install && npm run build`
- Start: `npm start`
- Environment: `NEXT_PUBLIC_API_URL=https://your-backend.onrender.com`

---

## Quick Checklist:

- [ ] Backend Web Service बनाया
- [ ] Root directory को `backend` set किया
- [ ] Build command: `npm install && npm run build`
- [ ] Start command: `npm start`
- [ ] DATABASE_URL add किया
- [ ] JWT_SECRET add किया
- [ ] ALLOWED_ORIGINS add किया
- [ ] Database migration run किया
- [ ] Health check endpoint काम कर रहा है
- [ ] Frontend Web Service बनाया
- [ ] Frontend का NEXT_PUBLIC_API_URL सही दिया

---

## Deploy होने में कितना समय?

- **पहली बार**: 5-10 minutes
- **बाद के deploys**: 2-3 minutes (caching के कारण)

---

## Common Errors और Fix:

### Error: "Cannot find module"
**Fix**: `npm install && npm run build` सही लिखा है?

### Error: "Database connection failed"
**Fix**: DATABASE_URL सही है? Neon से copy किया?

### Error: "PORT already in use"
**Fix**: Render automatically set करता है, worry नहीं करो

### Error: "ENOENT no such file or directory"
**Fix**: Root directory को `backend` रखा है?

---

Sab kuch setup ho gaya? Ek dum batao! 🚀
