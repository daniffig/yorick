# Development Workflow

This document outlines the complete development workflow for the Yorick Funeral Notices application.

## 🚀 Quick Start

### Prerequisites
- Ruby 3.2.8
- PostgreSQL 15
- Docker & Docker Compose

### Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd yorick

# Install dependencies
bundle install

# Start services
docker compose up -d

# Setup database
bin/rails db:setup

# Start development server
bin/dev
```

## 🔧 Development Commands

### Core Development
```bash
# Start development server (Rails + Tailwind watcher)
bin/dev

# Run tests
bin/test

# Run specific test file
bundle exec rails test test/controllers/funeral_notices_controller_test.rb

# Run specific test
bundle exec rails test test/controllers/funeral_notices_controller_test.rb::test_should_get_show_with_valid_parameters
```

### Code Quality
```bash
# Check code quality (linting)
bin/lint

# Auto-fix code quality issues
bin/fix

# Run RuboCop only
bundle exec rubocop

# Run RuboCop with auto-fix
bundle exec rubocop -a


```

### Database Operations
```bash
# Create database
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Reset database
bin/rails db:reset

# Seed database
bin/rails db:seed

# Drop database
bin/rails db:drop
```

### Scraping Operations
```bash
# Scrape funeral notices for a date range
rake funeral_notices:scrape start_date=2024-01-01 end_date=2024-01-31

# Recovery mode (only add missing notices)
recovery_mode=true rake funeral_notices:scrape start_date=2024-01-01 end_date=2024-01-31

# Reindex Elasticsearch
bundle exec rake chewy:reset
```

## 📋 Development Workflow

### ⚠️ **IMPORTANT: Branch Protection Rules**
- **NEVER push directly to main branch** - This is strictly forbidden
- **ALL changes must go through Pull Requests**
- **PRs must pass both tests AND linting before merging**
- **No exceptions to this workflow**

### 1. Feature Development
```bash
# Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/your-feature-name

# Make changes and test locally
bin/test

# Check code quality
bin/lint

# Fix any issues
bin/fix

# Commit changes with conventional commit format
git add .
git commit -m "feat: add your feature description"

# Push and create PR
git push origin feature/your-feature-name
```

### 2. Pull Request Process (MANDATORY)
1. **Create PR** → Triggers CI/CD pipeline automatically
2. **CI Checks** → Tests and linting run automatically
3. **All Checks Must Pass** → Tests AND linting must pass
4. **Merge** → Can merge once checks pass (no review required)

### 3. Branch Protection Rules
The main branch is protected with the following rules:
- **Require pull request before merging**
- **Require status checks to pass before merging**
- **Require branches to be up to date before merging**
- **Include administrators in these restrictions**

### 4. Testing Strategy
- **Unit Tests**: Test individual components and methods
- **Integration Tests**: Test controller actions and API endpoints
- **Service Tests**: Test business logic in service classes
- **System Tests**: Test full user workflows (if needed)

### 5. Code Quality Standards
- **RuboCop**: Ruby code style and best practices
- **Test Coverage**: Minimum 80% coverage required
- **Git Conventions**: Conventional commit messages
- **No direct main pushes**: All changes through PRs

## 🧪 Testing

### Test Structure
```
test/
├── controllers/          # Controller tests
├── models/              # Model tests
├── services/            # Service tests
├── components/          # ViewComponent tests
├── system/              # System tests (if needed)
└── fixtures/            # Test data
```

### Running Tests
```bash
# All tests
bin/test

# Specific test file
bundle exec rails test test/controllers/funeral_notices_controller_test.rb

# Specific test method
bundle exec rails test test/controllers/funeral_notices_controller_test.rb::test_should_get_show_with_valid_parameters

# Tests with verbose output
bundle exec rails test --verbose

# Tests with specific seed
bundle exec rails test --seed 12345
```

### Test Best Practices
- Use descriptive test names
- Test both success and failure cases
- Mock external dependencies
- Use fixtures for test data
- Keep tests focused and isolated

## 🔍 Code Quality

### RuboCop Configuration
- **File**: `.rubocop.yml`
- **Target**: Ruby 3.2
- **Max Line Length**: 120 characters
- **Style**: Single quotes, trailing commas



### Code Quality Commands
```bash
# Check code quality
bin/lint

# Auto-fix issues
bin/fix

# Check specific files
bundle exec rubocop app/controllers/
```

## 🐳 Docker Development

### Services
```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Rebuild services
docker compose up -d --build
```

### Available Services
- **PostgreSQL**: `localhost:5432`
- **Elasticsearch**: `localhost:9200`
- **Rails App**: `localhost:3000`

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows
1. **Test and Lint** (`.github/workflows/test.yml`)
   - Runs on: Pull Requests only
   - Tests: Ruby tests, RuboCop
   - Services: PostgreSQL, Elasticsearch
   - **Must pass before Docker build runs**

2. **PR Docker Build** (`.github/workflows/pr-docker-build.yml`)
   - Runs on: After Test and Lint workflow completes successfully
   - Builds: Docker image for testing
   - Tags: `pr-{branch}`, `{commit-hash}`
   - **Only runs if tests and linting pass**

3. **Main Docker Build** (`.github/workflows/docker-build.yml`)
   - Runs on: Push to main
   - Builds: Production Docker image
   - Tags: `latest`, `main`, `{commit-hash}`

### Local CI Simulation
```bash
# Run all checks locally
bin/test && bin/lint

# Check Docker build
docker build -t yorick:test .
```

## 📝 Git Workflow

### Branch Naming
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `refactor/component-name` - Code refactoring
- `docs/documentation-update` - Documentation updates

### Commit Messages
Use conventional commit format:
```
type(scope): description

feat: add user authentication
fix(controller): handle missing parameters
refactor(service): improve scraping logic
docs: update README with new features
```

### Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation update


## 🔒 Branch Protection Setup

### GitHub Repository Settings
To enforce the PR workflow, configure branch protection rules:

1. **Go to Repository Settings** → Branches
2. **Add rule for main branch**:
   - **Branch name pattern**: `main`
   - **Require a pull request before merging**: ✅
   - **Require status checks to pass before merging**: ✅
   - **Require branches to be up to date before merging**: ✅
   - **Include administrators**: ✅

3. **Required Status Checks**:
   - `test` (from `.github/workflows/test.yml`)
   - `Build Docker Image for Pull Request` (from `.github/workflows/pr-docker-build.yml`)

### Local Git Hooks (Optional)
To prevent accidental pushes to main, you can set up a pre-push hook:

```bash
# Use the provided setup script
bin/setup-git-hooks

# Or manually create .git/hooks/pre-push
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
if [ "$branch" = "main" ]; then
  echo "❌ Direct pushes to main are not allowed!"
  echo "Please create a feature branch and submit a pull request."
  exit 1
fi
EOF

chmod +x .git/hooks/pre-push
```

## 🚨 Troubleshooting

### Common Issues

#### Database Connection Issues
```bash
# Check PostgreSQL status
docker compose ps

# Restart PostgreSQL
docker compose restart db

# Reset database
bin/rails db:reset
```

#### Elasticsearch Issues
```bash
# Check Elasticsearch status
curl http://localhost:9200/_cluster/health

# Restart Elasticsearch
docker compose restart elasticsearch

# Reindex data
bundle exec rake chewy:reset
```

#### Test Failures
```bash
# Clear test cache
bin/rails tmp:clear

# Reset test database
RAILS_ENV=test bin/rails db:reset

# Run tests with verbose output
bundle exec rails test --verbose
```

#### Code Quality Issues
```bash
# Auto-fix RuboCop issues
bundle exec rubocop -a

# Check specific file
bundle exec rubocop app/controllers/funeral_notices_controller.rb
```

## 📚 Additional Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [RuboCop Documentation](https://docs.rubocop.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)

