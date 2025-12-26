# Vercel Deployment Guide

## Quick Setup

### 1. Create Vercel Project
```bash
cd backend
vercel
```

### 2. Set Environment Variables in Vercel Dashboard
```
DATABASE_URL=postgresql://neondb_owner:npg_jYh2UtGrz8uw@ep-tiny-glade-ahf7ipsb-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
JWT_SECRET=<generate with: openssl rand -hex 32>
NODE_ENV=production
```

### 3. Deploy
```bash
vercel --prod
```

Done! Your backend is now live on Vercel.

## API Endpoints

- POST `/api/auth/register` - Register new user
- POST `/api/auth/login` - Login user
- GET `/api/projects` - List projects
- POST `/api/projects` - Create project
- GET `/api/projects/:projectId` - Get project details
- POST `/api/projects/:projectId/files` - Create file
- GET `/api/projects/:projectId/files` - List files
- PUT `/api/projects/:projectId/files/:fileId` - Update file
- DELETE `/api/projects/:projectId/files/:fileId` - Delete file
- POST `/api/projects/:projectId/deploy` - Log deployment
- GET `/api/projects/:projectId/deploy-logs` - Get deployment logs
- GET `/health` - Health check

## Notes

This is a **simplified, lightweight backend** optimized for Vercel. It includes:
- User authentication (JWT)
- Project management
- File storage
- Deployment logs

Removed features (for serverless compatibility):
- Terminal execution
- Docker management
- Real-time WebSockets
- Long-running processes

If you need these features, consider adding a separate microservice on Render for execution.
