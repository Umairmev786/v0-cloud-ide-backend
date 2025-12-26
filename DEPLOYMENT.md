# Deployment Guide

## Prerequisites

- PostgreSQL/Neon database
- Node.js 20+
- GitHub account (optional)
- Render or Railway account (for hosting)

## Environment Variables

### Required
- `DATABASE_URL`: PostgreSQL connection string
- `JWT_SECRET`: Secret key for JWT signing

### Optional
- `GITHUB_TOKEN`: GitHub personal access token
- `OLLAMA_URL`: Ollama server URL (default: http://localhost:11434)
- `DOCKER_BACKEND_URL`: Docker socket URL (default: unix:///var/run/docker.sock)

## Deployment Options

### 1. Render

1. Push code to GitHub
2. Go to [render.com](https://render.com)
3. Create new Web Service
4. Connect GitHub repo
5. Configure environment variables
6. Deploy

### 2. Railway

1. Install Railway CLI: `npm i -g @railway/cli`
2. Run: `railway login`
3. Run: `railway link`
4. Set variables: `railway variables set DATABASE_URL`
5. Deploy: `railway up`

### 3. Self-Hosted (VPS)

1. SSH into server
2. Clone repo: `git clone ...`
3. Install Node: `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -`
4. Install PM2: `npm i -g pm2`
5. Build and start:
   ```bash
   npm run build
   pm2 start dist/server.js --name cloud-ide
   pm2 startup
   pm2 save
   ```

### 4. Docker

```bash
docker build -f backend/Dockerfile.prod -t cloud-ide-backend .
docker run -p 3001:3001 -e DATABASE_URL=... cloud-ide-backend
```

### 5. Vercel (Next.js Dashboard)

1. Go to vercel.com
2. Import project
3. Set environment variables
4. Deploy

## Post-Deployment

1. Run migrations: `npm run migrate`
2. Seed data (optional): `bash scripts/seed-data.sh`
3. Test health: `curl https://your-domain/health`
4. Monitor logs

## Monitoring

### Health Check
```bash
curl https://your-domain/health
```

### Database Connection
```bash
psql $DATABASE_URL -c "SELECT NOW();"
```

### Logs

For PM2:
```bash
pm2 logs cloud-ide
```

For Docker:
```bash
docker logs <container-id>
```

## SSL/TLS

Use a reverse proxy like Nginx:

```nginx
server {
    listen 443 ssl;
    server_name api.example.com;
    
    ssl_certificate /etc/letsencrypt/live/api.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.example.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
    }
}
```

## Database Backups

```bash
# Create backup
bash scripts/backup-db.sh

# Restore from backup
psql $DATABASE_URL < backups/cloud_ide_20251226_120000.sql
```

## Scaling

### Horizontal Scaling
Use a load balancer (Nginx, HAProxy) to distribute traffic across multiple backend instances.

### Database Optimization
- Add indexes for frequently queried columns
- Use connection pooling (pgBouncer)
- Archive old logs

### Caching
- Add Redis for session/cache storage
- Use CDN for static assets
- Cache API responses with SWR

## Security Checklist

- [ ] Change JWT_SECRET to random string
- [ ] Enable HTTPS/SSL
- [ ] Update ALLOWED_ORIGINS for production
- [ ] Set up firewall rules
- [ ] Enable database backups
- [ ] Monitor error logs
- [ ] Use strong database password
- [ ] Keep dependencies updated
- [ ] Regular security audits
- [ ] Set up API rate limiting

## Troubleshooting

### 502 Bad Gateway
- Check if backend is running
- Check database connection
- Review logs

### Database Connection Failed
- Verify DATABASE_URL
- Check network access
- Test with psql

### Deploy Failed
- Check build logs
- Verify environment variables
- Test locally first

## Support

For deployment issues:
1. Check logs
2. Review the README
3. Open a GitHub issue
