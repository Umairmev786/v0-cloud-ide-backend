# Render Environment Variables for Backend

## Copy-Paste These Into Render Dashboard

### Required Variables

```
DATABASE_URL=postgresql://neondb_owner:npg_jYh2UtGrz8uw@ep-tiny-glade-ahf7ipsb-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require

NODE_ENV=production

PORT=3001

JWT_SECRET=your-super-secret-key-12345-change-this-random-string

JWT_EXPIRY=7d

ALLOWED_ORIGINS=https://your-frontend-url.onrender.com,http://localhost:3000
```

### Optional Variables (Keep as default)

```
DOCKER_BACKEND_URL=unix:///var/run/docker.sock

DOCKER_REGISTRY=docker.io

OLLAMA_URL=http://localhost:11434

SANDBOX_TIMEOUT=30000

MAX_OUTPUT_SIZE=1048576

GITHUB_TOKEN=your-github-token-if-needed

GITHUB_WEBHOOK_SECRET=your-webhook-secret-if-needed
```

---

## How to Set Them in Render:

1. Go to your Backend Service Dashboard
2. Click on **Environment** tab
3. Add each variable one by one (click "Add Variable")
4. Copy-paste the values above

---

## Generate New JWT_SECRET

If you want a random JWT_SECRET, run this:

**On Mac/Linux:**
```bash
openssl rand -hex 32
```

**On Windows PowerShell:**
```powershell
[System.Convert]::ToBase64String((1..32 | ForEach-Object {Get-Random -Maximum 256}) -as [byte[]])
```

Then replace `your-super-secret-key-12345-change-this-random-string` with the output.

---

## After Setting Variables:

- The backend will automatically redeploy
- Check Logs tab to verify it's running
- Test the health endpoint:
  ```
  curl https://your-backend.onrender.com/health
