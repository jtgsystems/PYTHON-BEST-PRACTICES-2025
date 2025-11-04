# GitHub Actions CI/CD Templates - 2025

## Complete GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  release:
    types: [ published ]

env:
  PYTHON_VERSION: "3.14"
  POETRY_VERSION: "1.6.1"

jobs:
  lint-and-format:
    name: Lint and Format Check
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install "ruff>=0.14.3" "black>=25.9.0" "mypy>=1.18.2"

    - name: Run Ruff linting
      run: ruff check .

    - name: Check Black formatting
      run: black --check --diff .

    - name: Run MyPy type checking
      run: mypy src/

  security-scan:
    name: Security Scanning
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Install security tools
      run: |
        pip install bandit safety semgrep

    - name: Run Bandit security linter
      run: bandit -r src/ -f json -o bandit-report.json

    - name: Run Safety dependency check
      run: safety check --json --output safety-report.json

    - name: Run Semgrep
      run: semgrep --config=python --json --output=semgrep-report.json src/

    - name: Upload security reports
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: security-reports
        path: |
          bandit-report.json
          safety-report.json
          semgrep-report.json

  test:
    name: Test Suite
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ["3.13", "3.14"]
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: testdb
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}

    - name: Cache dependencies
      uses: actions/cache@v3
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/pyproject.toml') }}
        restore-keys: |
          ${{ runner.os }}-pip-

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e ".[test]" "ruff>=0.14.3" "black>=25.9.0" "mypy>=1.18.2"

    - name: Run tests with coverage
      run: |
        pytest --cov=src --cov-report=xml --cov-report=html --cov-fail-under=80
      env:
        DATABASE_URL: postgresql://postgres:postgres@localhost:5432/testdb
        REDIS_URL: redis://localhost:6379/0

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        file: ./coverage.xml
        flags: unittests
        name: codecov-umbrella

    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results-${{ matrix.os }}-${{ matrix.python-version }}
        path: |
          htmlcov/
          coverage.xml

  build:
    name: Build Package
    runs-on: ubuntu-latest
    needs: [lint-and-format, security-scan, test]
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Install build dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build twine

    - name: Build package
      run: python -m build

    - name: Check distribution
      run: twine check dist/*

    - name: Upload build artifacts
      uses: actions/upload-artifact@v3
      with:
        name: dist
        path: dist/

  deploy:
    name: Deploy to PyPI
    runs-on: ubuntu-latest
    needs: build
    if: github.event_name == 'release' && github.event.action == 'published'
    environment:
      name: pypi
      url: https://pypi.org/p/your-package
    permissions:
      id-token: write  # IMPORTANT: this permission is mandatory for trusted publishing

    steps:
    - name: Download build artifacts
      uses: actions/download-artifact@v3
      with:
        name: dist
        path: dist/

    - name: Publish to PyPI
      uses: pypa/gh-action-pypi-publish@release/v1

  docker:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest
    needs: [lint-and-format, security-scan, test]
    if: github.ref == 'refs/heads/main' || github.event_name == 'release'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: your-username/your-app
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  notify:
    name: Notify Status
    runs-on: ubuntu-latest
    needs: [deploy, docker]
    if: always()
    steps:
    - name: Notify Slack on Success
      if: needs.deploy.result == 'success'
      uses: 8398a7/action-slack@v3
      with:
        status: success
        text: "🎉 Deployment successful!"
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

    - name: Notify Slack on Failure
      if: failure()
      uses: 8398a7/action-slack@v3
      with:
        status: failure
        text: "❌ Deployment failed!"
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Pre-commit Configuration

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-case-conflict
      - id: check-merge-conflict
      - id: debug-statements
      - id: check-docstring-first
      - id: check-json
      - id: check-toml
      - id: check-xml

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.14.3
    hooks:
      - id: ruff-check
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  - repo: https://github.com/psf/black
    rev: 25.9.0
    hooks:
      - id: black
        language_version: python3.14

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.18.2
    hooks:
      - id: mypy
        additional_dependencies:
          - types-requests
          - types-PyYAML
          - types-redis
        args: [--strict, --ignore-missing-imports]

  - repo: https://github.com/PyCQA/bandit
    rev: 1.8.6
    hooks:
      - id: bandit
        args: ['-c', 'pyproject.toml']
        additional_dependencies: ['bandit[toml]']

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: ["--profile", "black"]

  - repo: https://github.com/econchick/interrogate
    rev: 1.5.0
    hooks:
      - id: interrogate
        args: [--fail-under=80, --verbose]

  - repo: https://github.com/asottile/pyupgrade
    rev: v3.21.0
    hooks:
      - id: pyupgrade
        args: [--py314-plus]

  - repo: local
    hooks:
      - id: pytest-check
        name: pytest-check
        entry: pytest
        language: system
        pass_filenames: false
        always_run: true
        args: [--tb=short, -q]

      - id: coverage-check
        name: coverage-check
        entry: pytest
        language: system
        pass_filenames: false
        always_run: true
        args: [--cov=src, --cov-fail-under=80, --tb=short, -q]
```

## Makefile for Development

```makefile
# Makefile
.PHONY: help install dev-install test lint format type-check security clean docs build deploy

# Colors for terminal output
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install production dependencies
	pip install -e .

dev-install: ## Install development dependencies
	pip install -e ".[dev]"
	pre-commit install

test: ## Run tests
	@echo "$(YELLOW)Running tests...$(NC)"
	pytest

test-cov: ## Run tests with coverage
	@echo "$(YELLOW)Running tests with coverage...$(NC)"
	pytest --cov=src --cov-report=html --cov-report=term-missing

test-watch: ## Run tests in watch mode
	@echo "$(YELLOW)Running tests in watch mode...$(NC)"
	pytest-watch

lint: ## Run linting
	@echo "$(YELLOW)Running Ruff linting...$(NC)"
	ruff check .

lint-fix: ## Run linting with auto-fix
	@echo "$(YELLOW)Running Ruff with auto-fix...$(NC)"
	ruff check --fix .

format: ## Format code
	@echo "$(YELLOW)Formatting code...$(NC)"
	ruff format .
	black .

format-check: ## Check code formatting
	@echo "$(YELLOW)Checking code formatting...$(NC)"
	ruff format --check .
	black --check .

type-check: ## Run type checking
	@echo "$(YELLOW)Running MyPy type checking...$(NC)"
	mypy src/

security: ## Run security checks
	@echo "$(YELLOW)Running security checks...$(NC)"
	bandit -r src/
	safety check

pre-commit: ## Run all pre-commit hooks
	@echo "$(YELLOW)Running pre-commit hooks...$(NC)"
	pre-commit run --all-files

ci: lint format-check type-check test security ## Run all CI checks locally
	@echo "$(YELLOW)All CI checks passed!$(NC)"

clean: ## Clean build artifacts
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf .ruff_cache/
	rm -rf htmlcov/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

docs: ## Build documentation
	@echo "$(YELLOW)Building documentation...$(NC)"
	cd docs && make html

docs-serve: ## Serve documentation locally
	@echo "$(YELLOW)Serving documentation...$(NC)"
	cd docs/_build/html && python -m http.server 8000

build: clean ## Build package
	@echo "$(YELLOW)Building package...$(NC)"
	python -m build

build-check: build ## Build and check package
	@echo "$(YELLOW)Checking package...$(NC)"
	twine check dist/*

docker-build: ## Build Docker image
	@echo "$(YELLOW)Building Docker image...$(NC)"
	docker build -t myproject:latest .

docker-run: ## Run Docker container
	@echo "$(YELLOW)Running Docker container...$(NC)"
	docker run -p 8000:8000 myproject:latest

benchmark: ## Run performance benchmarks
	@echo "$(YELLOW)Running benchmarks...$(NC)"
	pytest tests/benchmarks/ -v

profile: ## Profile application
	@echo "$(YELLOW)Profiling application...$(NC)"
	python -m cProfile -o profile.stats src/myproject/main.py
	python -c "import pstats; p = pstats.Stats('profile.stats'); p.sort_stats('cumulative'); p.print_stats(20)"

update-deps: ## Update dependencies
	@echo "$(YELLOW)Updating dependencies...$(NC)"
	pip install --upgrade pip
	pip-compile --upgrade requirements.in
	pip-compile --upgrade requirements-dev.in

check-deps: ## Check for dependency vulnerabilities
	@echo "$(YELLOW)Checking dependencies...$(NC)"
	safety check
	pip-audit

release-patch: ## Release patch version
	@echo "$(YELLOW)Releasing patch version...$(NC)"
	bump2version patch
	git push origin main --tags

release-minor: ## Release minor version
	@echo "$(YELLOW)Releasing minor version...$(NC)"
	bump2version minor
	git push origin main --tags

release-major: ## Release major version
	@echo "$(YELLOW)Releasing major version...$(NC)"
	bump2version major
	git push origin main --tags
```

## Dockerfile Templates

### Production Dockerfile
```dockerfile
# Dockerfile
FROM python:3.14-slim as base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY pyproject.toml ./
RUN pip install -e .

# Copy application code
COPY src/ ./src/

# Change ownership to non-root user
RUN chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose port
EXPOSE 8000

# Run application
CMD ["python", "-m", "myproject"]
```

### Multi-stage Development Dockerfile
```dockerfile
# Dockerfile.dev
FROM python:3.14-slim as base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Development stage
FROM base as development

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install development dependencies
COPY pyproject.toml ./
RUN pip install -e ".[dev]"

# Install additional development tools
RUN pip install ipdb jupyter

COPY . .

# Set up pre-commit
RUN pre-commit install

CMD ["python", "-m", "myproject", "--debug"]

# Production stage
FROM base as production

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy and install dependencies
COPY pyproject.toml ./
RUN pip install -e .

# Copy application
COPY src/ ./src/

# Security hardening
RUN chown -R appuser:appuser /app
USER appuser

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000

CMD ["python", "-m", "myproject"]
```

## Docker Compose for Development

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
      target: development
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/.venv  # Anonymous volume for virtual environment
    environment:
      - DEBUG=true
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    command: python -m myproject --debug --reload

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app

  # Testing services
  test:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
    environment:
      - DATABASE_URL=postgresql://postgres:password@test_db:5432/test_myapp
      - REDIS_URL=redis://test_redis:6379/0
    depends_on:
      - test_db
      - test_redis
    command: pytest

  test_db:
    image: postgres:15
    environment:
      POSTGRES_DB: test_myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    tmpfs:
      - /var/lib/postgresql/data

  test_redis:
    image: redis:7-alpine
    tmpfs:
      - /data

volumes:
  postgres_data:
```

## Environment Configuration

### .env Templates
```bash
# .env.development
DEBUG=true
LOG_LEVEL=DEBUG

# Database
DATABASE_URL=postgresql://postgres:password@localhost:5432/myapp_dev
DATABASE_ECHO=true

# Redis
REDIS_URL=redis://localhost:6379/0

# API
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=1

# Security
SECRET_KEY=dev-secret-key-not-for-production
CORS_ORIGINS=["http://localhost:3000", "http://localhost:8080"]

# External APIs
EXTERNAL_API_KEY=dev-api-key
EXTERNAL_API_URL=https://api.example.com

# .env.production
DEBUG=false
LOG_LEVEL=INFO

# Database (use environment-specific values)
DATABASE_URL=${DATABASE_URL}
DATABASE_ECHO=false
DATABASE_POOL_SIZE=20
DATABASE_MAX_OVERFLOW=30

# Redis
REDIS_URL=${REDIS_URL}

# API
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=4

# Security
SECRET_KEY=${SECRET_KEY}
CORS_ORIGINS=${CORS_ORIGINS}

# Monitoring
SENTRY_DSN=${SENTRY_DSN}
DATADOG_API_KEY=${DATADOG_API_KEY}

# External APIs
EXTERNAL_API_KEY=${EXTERNAL_API_KEY}
EXTERNAL_API_URL=https://api.example.com
```

## Release Automation

### Semantic Release Configuration
```json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/github",
    [
      "@semantic-release/exec",
      {
        "verifyReleaseCmd": "echo 'Verifying release ${nextRelease.version}'",
        "prepareCmd": "python scripts/prepare-release.py ${nextRelease.version}",
        "publishCmd": "python -m build && twine upload dist/*"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md", "pyproject.toml"],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ]
  ]
}
```

### Release Script
```python
# scripts/prepare-release.py
"""Prepare release by updating version and changelog."""

import sys
import toml
from pathlib import Path

def update_version(version: str) -> None:
    """Update version in pyproject.toml."""
    pyproject_path = Path("pyproject.toml")
    data = toml.load(pyproject_path)
    data["project"]["version"] = version
    
    with open(pyproject_path, "w") as f:
        toml.dump(data, f)
    
    print(f"Updated version to {version}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python prepare-release.py <version>")
        sys.exit(1)
    
    version = sys.argv[1]
    update_version(version)

if __name__ == "__main__":
    main()
```

## Monitoring and Alerts

### Health Check Implementation
```python
# src/myproject/health.py
"""Health check endpoints for monitoring."""

from typing import Dict, Any
import time
import psutil
from fastapi import APIRouter, HTTPException

router = APIRouter()

@router.get("/health")
async def health_check() -> Dict[str, str]:
    """Basic health check."""
    return {"status": "healthy", "timestamp": time.time()}

@router.get("/health/detailed")
async def detailed_health_check() -> Dict[str, Any]:
    """Detailed health check with system metrics."""
    try:
        # Database check
        db_healthy = await check_database()
        
        # Redis check
        redis_healthy = await check_redis()
        
        # System metrics
        cpu_percent = psutil.cpu_percent()
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        health_data = {
            "status": "healthy" if db_healthy and redis_healthy else "unhealthy",
            "timestamp": time.time(),
            "services": {
                "database": "healthy" if db_healthy else "unhealthy",
                "redis": "healthy" if redis_healthy else "unhealthy"
            },
            "system": {
                "cpu_percent": cpu_percent,
                "memory_percent": memory.percent,
                "disk_percent": (disk.used / disk.total) * 100
            }
        }
        
        if not db_healthy or not redis_healthy:
            raise HTTPException(status_code=503, detail=health_data)
        
        return health_data
        
    except Exception as e:
        raise HTTPException(status_code=503, detail={
            "status": "unhealthy",
            "error": str(e)
        })

async def check_database() -> bool:
    """Check database connectivity."""
    try:
        # Add your database check here
        return True
    except Exception:
        return False

async def check_redis() -> bool:
    """Check Redis connectivity."""
    try:
        # Add your Redis check here
        return True
    except Exception:
        return False
```

---

**Key Takeaways**:
- Automate everything: testing, linting, security scanning, deployment
- Use matrix builds for cross-platform compatibility
- Implement proper caching to speed up CI/CD
- Set up monitoring and alerting for production deployments
- Use feature flags and gradual rollouts for safer deployments
- Keep security scanning as part of the CI pipeline
