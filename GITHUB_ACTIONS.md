# GitHub Actions Workflows

This document explains the GitHub Actions workflows for building and deploying Docker images.

## 🚀 Workflows Overview

### 1. **PR Docker Build** (`.github/workflows/pr-docker-build.yml`)
- **Triggers**: Pull Request opened, synchronized, or reopened
- **Purpose**: Build and test Docker images for PRs
- **Tags**: `pr-{number}`, `{commit-hash}`, `{branch}-{commit-hash}`

### 2. **Main Docker Build** (`.github/workflows/docker-build.yml`)
- **Triggers**: Push to main branch, manual dispatch
- **Purpose**: Build production Docker images
- **Tags**: `latest`, `main`, `{commit-hash}`, semantic versions

## 📋 PR Workflow Details

### **When it runs:**
- Pull Request opened
- New commits pushed to PR
- PR reopened

### **Image Tags Generated:**
```bash
# For PR #10 with commit a1b2c3d4
ghcr.io/daniffig/yorick:pr-10
ghcr.io/daniffig/yorick:a1b2c3d4
ghcr.io/daniffig/yorick:feature-branch-a1b2c3d4
```

### **Usage Example:**
```bash
# Test PR #10 image
docker run -p 3000:3000 \
  -e SECRET_KEY_BASE="your_secret" \
  -e DATABASE_URL="postgresql://..." \
  ghcr.io/daniffig/yorick:pr-10

# Test specific commit
docker run -p 3000:3000 \
  -e SECRET_KEY_BASE="your_secret" \
  -e DATABASE_URL="postgresql://..." \
  ghcr.io/daniffig/yorick:a1b2c3d4
```

## 🏭 Main Workflow Details

### **When it runs:**
- Push to main branch
- Manual workflow dispatch

### **Image Tags Generated:**
```bash
# For main branch with commit a1b2c3d4
ghcr.io/daniffig/yorick:latest  # Always added on main branch push
ghcr.io/daniffig/yorick:main
ghcr.io/daniffig/yorick:a1b2c3d4
ghcr.io/daniffig/yorick:main-a1b2c3d4

# For semantic version v1.2.3
ghcr.io/daniffig/yorick:v1.2.3
ghcr.io/daniffig/yorick:1.2
```

## 🔧 Features

### **Build Caching**
- Uses GitHub Actions cache for faster builds
- Caches Docker layers between builds
- Reduces build time significantly

### **Metadata Extraction**
- Automatic tag generation based on context
- Proper labeling for image management
- Support for semantic versioning

### **Security**
- Minimal permissions required
- Uses GitHub Container Registry
- Secure token handling

## 📊 Workflow Output

### **PR Workflow Output:**
```
✓ Built and pushed images with tags:
ghcr.io/daniffig/yorick:pr-10
ghcr.io/daniffig/yorick:a1b2c3d4
ghcr.io/daniffig/yorick:feature-branch-a1b2c3d4

PR-10 tag: ghcr.io/daniffig/yorick:pr-10
Commit hash tag: ghcr.io/daniffig/yorick:a1b2c3d4
```

### **Main Workflow Output:**
```
✓ Built and pushed images with tags:
ghcr.io/daniffig/yorick:latest
ghcr.io/daniffig/yorick:main
ghcr.io/daniffig/yorick:a1b2c3d4
ghcr.io/daniffig/yorick:main-a1b2c3d4
```

## 🧪 Testing PR Images

### **Using docker-compose.prod.yml with PR image:**

1. **Update the image tag in docker-compose.prod.yml:**
```yaml
services:
  web:
    image: ghcr.io/daniffig/yorick:pr-10  # Replace with your PR number
    # ... rest of configuration
```

2. **Deploy and test:**
```bash
# Set up environment
cp env.example .env
# Edit .env with your values

# Deploy with PR image
docker-compose -f docker-compose.prod.yml up -d

# Check logs
docker-compose -f docker-compose.prod.yml logs -f web
```

### **Direct Docker run:**
```bash
# Test PR image
docker run -d \
  --name yorick-pr-test \
  -p 3000:3000 \
  -e SECRET_KEY_BASE="$(openssl rand -hex 64)" \
  -e DATABASE_URL="postgresql://user:pass@host:5432/db" \
  -e ELASTICSEARCH_URL="http://host:9200" \
  ghcr.io/daniffig/yorick:pr-10

# Check if it's running
docker ps
docker logs yorick-pr-test
```

## 🔄 Workflow Lifecycle

### **Pull Request Process:**
1. **Create PR** → Triggers PR workflow
2. **Push commits** → Rebuilds image with new tags
3. **Test image** → Use `pr-{number}` tag
4. **Merge to main** → Triggers main workflow

### **Main Branch Process:**
1. **Push to main** → Triggers main workflow
2. **Build production image** → Tagged as `latest`
3. **Deploy** → Use `latest` tag for production

## 🚨 Troubleshooting

### **Workflow Failures:**
```bash
# Check workflow status
gh run list --workflow="Build Docker Image for Pull Request"

# View logs
gh run view --log

# Re-run workflow
gh run rerun <run-id>
```

### **Image Pull Issues:**
```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Pull specific image
docker pull ghcr.io/daniffig/yorick:pr-10
```

### **Permission Issues:**
- Ensure repository has `packages: write` permission
- Check if `GITHUB_TOKEN` has sufficient scope
- Verify workflow permissions in repository settings

## 📈 Best Practices

### **For Developers:**
1. **Always test PR images** before merging
2. **Use specific commit hashes** for reproducible builds
3. **Clean up old PR images** periodically
4. **Document any special testing requirements**

### **For Operations:**
1. **Use `latest` tag** for production deployments
2. **Pin to specific tags** for critical environments
3. **Monitor image sizes** and build times
4. **Set up image scanning** for security

## 🔗 Related Documentation

- [Production Deployment Guide](PRODUCTION.md)
- [Docker Configuration](Dockerfile)
- [Environment Configuration](env.example)

---

**Note**: All images are pushed to GitHub Container Registry (ghcr.io) and are publicly accessible unless the repository is private. 