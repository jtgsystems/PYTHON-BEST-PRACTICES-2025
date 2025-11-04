# Modern Python Project Structure - 2025 Standards

## Directory Layouts

### Standard Package Layout (Recommended)
```
myproject/
├── .github/
│   └── workflows/
│       ├── test.yml
│       └── release.yml
├── docs/
│   ├── conf.py
│   ├── index.rst
│   └── api/
├── src/
│   └── myproject/
│       ├── __init__.py
│       ├── __main__.py
│       ├── core/
│       │   ├── __init__.py
│       │   ├── models.py
│       │   └── services.py
│       ├── api/
│       │   ├── __init__.py
│       │   ├── routes.py
│       │   └── schemas.py
│       └── utils/
│           ├── __init__.py
│           └── helpers.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── scripts/
│   ├── setup.py
│   └── deploy.py
├── .env.example
├── .gitignore
├── .pre-commit-config.yaml
├── pyproject.toml
├── README.md
└── LICENSE
```

### Flat Layout (Simple Projects)
```
myproject/
├── myproject/
│   ├── __init__.py
│   ├── main.py
│   └── utils.py
├── tests/
├── pyproject.toml
├── README.md
└── .gitignore
```

### Application Layout (Web Apps)
```
webapp/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── base.py
│   ├── views/
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── api.py
│   ├── services/
│   │   ├── __init__.py
│   │   └── user_service.py
│   ├── static/
│   ├── templates/
│   └── config/
│       ├── __init__.py
│       ├── settings.py
│       └── database.py
├── migrations/
├── tests/
├── requirements/
│   ├── base.txt
│   ├── dev.txt
│   └── prod.txt
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── .env.example
├── pyproject.toml
└── manage.py
```

## Configuration Files

### pyproject.toml (Modern Standard)
```toml
[build-system]
requires = ["hatchling>=1.13.0"]
build-backend = "hatchling.build"

[project]
name = "myproject"
dynamic = ["version"]
description = "A modern Python project"
readme = "README.md"
license = {text = "MIT"}
authors = [
    {name = "Your Name", email = "you@example.com"},
]
maintainers = [
    {name = "Your Name", email = "you@example.com"},
]
keywords = ["python", "example", "project"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.14",
    "Programming Language :: Python :: 3.13",
]
requires-python = ">=3.13"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
    "click>=8.1.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.4.2",
    "pytest-cov>=7.0.0",
    "pytest-xdist>=3.8.0",
    "pytest-mock>=3.15.1",
    "ruff>=0.14.3",
    "black>=25.9.0",
    "mypy>=1.18.2",
    "pre-commit>=4.3.0",
    "bandit[toml]>=1.8.6",
    "safety>=3.6.2",
]
docs = [
    "sphinx>=8.2.3",
    "sphinx-rtd-theme>=3.0.2",
    "myst-parser>=4.0.1",
]
test = [
    "pytest>=8.4.2",
    "pytest-cov>=7.0.0",
    "pytest-mock>=3.15.1",
    "factory-boy>=3.3.3",
]

[project.urls]
Homepage = "https://github.com/yourusername/myproject"
Documentation = "https://myproject.readthedocs.io"
Repository = "https://github.com/yourusername/myproject"
"Bug Tracker" = "https://github.com/yourusername/myproject/issues"
Changelog = "https://github.com/yourusername/myproject/blob/main/CHANGELOG.md"

[project.scripts]
myproject = "myproject.__main__:main"
myproject-admin = "myproject.admin:main"

[tool.hatch.version]
path = "src/myproject/__init__.py"

[tool.hatch.build.targets.wheel]
packages = ["src/myproject"]

# Include tool configurations from previous files
[tool.ruff]
# ... (from ruff-config.toml)

[tool.black]
# ... (from previous examples)

[tool.mypy]
# ... (from previous examples)

[tool.pytest.ini_options]
# ... (from pytest guide)
```

### Package Initialization
```python
# src/myproject/__init__.py
"""MyProject - A modern Python package."""

__version__ = "0.1.0"
__author__ = "Your Name"
__email__ = "you@example.com"

from .core.models import User, Product
from .core.services import UserService, ProductService

__all__ = [
    "User",
    "Product", 
    "UserService",
    "ProductService",
]
```

### Main Module
```python
# src/myproject/__main__.py
"""Command-line interface for MyProject."""

import sys
import click
from typing import Optional

from .core.services import UserService


@click.group()
@click.version_option()
def main() -> None:
    """MyProject CLI tool."""
    pass


@main.command()
@click.argument("name")
@click.option("--email", help="User email address")
def create_user(name: str, email: Optional[str] = None) -> None:
    """Create a new user."""
    service = UserService()
    user = service.create_user(name, email)
    click.echo(f"Created user: {user.name}")


@main.command()
def list_users() -> None:
    """List all users."""
    service = UserService()
    users = service.list_users()
    for user in users:
        click.echo(f"- {user.name} ({user.email})")


if __name__ == "__main__":
    sys.exit(main())
```

## Environment Management

### Environment Variables
```python
# src/myproject/config/settings.py
"""Application settings and configuration."""

import os
from typing import Optional
from pydantic import BaseSettings, validator


class Settings(BaseSettings):
    """Application settings."""
    
    # App configuration
    app_name: str = "MyProject"
    debug: bool = False
    secret_key: str = "dev-secret-key"
    
    # Database
    database_url: str = "sqlite:///./app.db"
    database_echo: bool = False
    
    # API
    api_host: str = "localhost"
    api_port: int = 8000
    api_workers: int = 1
    
    # External services
    redis_url: Optional[str] = None
    email_backend: str = "console"
    
    # Logging
    log_level: str = "INFO"
    log_format: str = "detailed"
    
    @validator("secret_key")
    def validate_secret_key(cls, v: str) -> str:
        if v == "dev-secret-key" and not cls.debug:
            raise ValueError("Must set SECRET_KEY in production")
        return v
    
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


# Global settings instance
settings = Settings()
```

### .env.example
```bash
# Application
APP_NAME=MyProject
DEBUG=false
SECRET_KEY=your-secret-key-here

# Database
DATABASE_URL=postgresql://user:pass@localhost/myproject
DATABASE_ECHO=false

# API
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=4

# External Services
REDIS_URL=redis://localhost:6379/0
EMAIL_BACKEND=smtp

# Logging
LOG_LEVEL=INFO
LOG_FORMAT=json
```

## Modern Package Features

### Entry Points
```python
# src/myproject/cli.py
"""Command-line interface."""

import click
from typing import List

@click.group()
def cli() -> None:
    """MyProject command-line tools."""
    pass

@cli.command()
@click.option("--format", type=click.Choice(["json", "yaml", "csv"]))
def export(format: str = "json") -> None:
    """Export data in specified format."""
    click.echo(f"Exporting data as {format}")

# Plugin system
class PluginManager:
    """Manage plugins for the application."""
    
    def __init__(self):
        self.plugins: List[object] = []
    
    def load_plugins(self) -> None:
        """Load all registered plugins."""
        import pkg_resources
        for entry_point in pkg_resources.iter_entry_points("myproject.plugins"):
            plugin = entry_point.load()
            self.plugins.append(plugin())
```

### Type Annotations
```python
# src/myproject/core/models.py
"""Core data models."""

from __future__ import annotations
from typing import Optional, List, Dict, Any, Protocol
from datetime import datetime
from dataclasses import dataclass, field
from enum import Enum


class UserRole(Enum):
    """User role enumeration."""
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"


@dataclass
class User:
    """User model with full type annotations."""
    
    id: Optional[int] = None
    name: str = ""
    email: str = ""
    role: UserRole = UserRole.USER
    created_at: datetime = field(default_factory=datetime.now)
    metadata: Dict[str, Any] = field(default_factory=dict)
    tags: List[str] = field(default_factory=list)
    
    def __post_init__(self) -> None:
        """Validate user data after initialization."""
        if not self.name:
            raise ValueError("User name is required")
        if "@" not in self.email:
            raise ValueError("Invalid email format")
    
    @property
    def is_admin(self) -> bool:
        """Check if user has admin role."""
        return self.role == UserRole.ADMIN
    
    def add_tag(self, tag: str) -> None:
        """Add a tag to the user."""
        if tag not in self.tags:
            self.tags.append(tag)


class UserRepository(Protocol):
    """Protocol for user repository implementations."""
    
    def save(self, user: User) -> User: ...
    def find_by_id(self, user_id: int) -> Optional[User]: ...
    def find_by_email(self, email: str) -> Optional[User]: ...
    def list_all(self) -> List[User]: ...
```

### Async Support
```python
# src/myproject/core/async_services.py
"""Asynchronous service implementations."""

import asyncio
import aiohttp
from typing import List, Optional, Dict, Any
from contextlib import asynccontextmanager

from .models import User


class AsyncUserService:
    """Asynchronous user service."""
    
    def __init__(self, api_base_url: str):
        self.api_base_url = api_base_url
        self._session: Optional[aiohttp.ClientSession] = None
    
    @asynccontextmanager
    async def session(self):
        """Async context manager for HTTP session."""
        if self._session is None:
            self._session = aiohttp.ClientSession()
        try:
            yield self._session
        finally:
            if self._session:
                await self._session.close()
                self._session = None
    
    async def create_user(self, name: str, email: str) -> User:
        """Create user asynchronously."""
        async with self.session() as session:
            data = {"name": name, "email": email}
            async with session.post(f"{self.api_base_url}/users", json=data) as resp:
                resp.raise_for_status()
                user_data = await resp.json()
                return User(**user_data)
    
    async def get_user(self, user_id: int) -> Optional[User]:
        """Get user by ID asynchronously."""
        async with self.session() as session:
            async with session.get(f"{self.api_base_url}/users/{user_id}") as resp:
                if resp.status == 404:
                    return None
                resp.raise_for_status()
                user_data = await resp.json()
                return User(**user_data)
    
    async def list_users(self, limit: int = 100) -> List[User]:
        """List users asynchronously."""
        async with self.session() as session:
            params = {"limit": limit}
            async with session.get(f"{self.api_base_url}/users", params=params) as resp:
                resp.raise_for_status()
                users_data = await resp.json()
                return [User(**user_data) for user_data in users_data]


async def main() -> None:
    """Example async main function."""
    service = AsyncUserService("https://api.example.com")
    
    # Create multiple users concurrently
    tasks = [
        service.create_user(f"user{i}", f"user{i}@example.com")
        for i in range(10)
    ]
    users = await asyncio.gather(*tasks)
    
    print(f"Created {len(users)} users")
```

## Documentation

### README.md Template
```markdown
# MyProject

[![Tests](https://github.com/yourusername/myproject/workflows/Tests/badge.svg)](https://github.com/yourusername/myproject/actions)
[![Coverage](https://codecov.io/gh/yourusername/myproject/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/myproject)
[![PyPI version](https://badge.fury.io/py/myproject.svg)](https://badge.fury.io/py/myproject)
[![Python versions](https://img.shields.io/pypi/pyversions/myproject.svg)](https://pypi.org/project/myproject/)

A modern Python project with best practices for 2025.

## Features

- 🚀 Fast and efficient
- 🔒 Type-safe with MyPy
- 🧪 Comprehensive test suite
- 📦 Modern packaging with Poetry/Hatch
- 🔧 Developer-friendly tooling

## Installation

```bash
pip install myproject
```

## Quick Start

```python
from myproject import UserService

service = UserService()
user = service.create_user("Alice", "alice@example.com")
print(f"Created user: {user.name}")
```

## Development

```bash
# Clone repository
git clone https://github.com/yourusername/myproject.git
cd myproject

# Install development dependencies
pip install -e ".[dev]"

# Setup pre-commit hooks
pre-commit install

# Run tests
pytest

# Check code quality
ruff check .
mypy src/
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.
```

### API Documentation
```python
# src/myproject/api/routes.py
"""API routes with comprehensive documentation."""

from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional

from ..core.services import UserService
from ..core.models import User, UserRole


app = FastAPI(
    title="MyProject API",
    description="A modern Python API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)


class UserCreate(BaseModel):
    """Schema for creating a user."""
    name: str
    email: str
    role: UserRole = UserRole.USER


class UserResponse(BaseModel):
    """Schema for user responses."""
    id: int
    name: str
    email: str
    role: UserRole
    created_at: str
    
    class Config:
        from_attributes = True


@app.post("/users/", response_model=UserResponse, status_code=201)
async def create_user(
    user_data: UserCreate,
    service: UserService = Depends(get_user_service)
) -> UserResponse:
    """
    Create a new user.
    
    Args:
        user_data: User creation data
        service: User service dependency
        
    Returns:
        Created user data
        
    Raises:
        HTTPException: If user creation fails
    """
    try:
        user = service.create_user(user_data.name, user_data.email, user_data.role)
        return UserResponse.from_orm(user)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: int,
    service: UserService = Depends(get_user_service)
) -> UserResponse:
    """
    Get a user by ID.
    
    Args:
        user_id: User ID to retrieve
        service: User service dependency
        
    Returns:
        User data
        
    Raises:
        HTTPException: If user not found
    """
    user = service.get_user(user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse.from_orm(user)


def get_user_service() -> UserService:
    """Dependency injection for user service."""
    return UserService()
```

## Build and Deployment

### Docker Configuration
```dockerfile
# Dockerfile
FROM python:3.14-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY pyproject.toml ./
RUN pip install -e .

# Copy application code
COPY src/ ./src/

# Create non-root user
RUN useradd --create-home --shell /bin/bash app
USER app

# Expose port
EXPOSE 8000

# Run application
CMD ["python", "-m", "myproject.api"]
```

### Docker Compose
```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/myproject
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis
    volumes:
      - ./src:/app/src

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myproject
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

---

**Key Principles**: Keep it simple, follow standards, prioritize maintainability, and use modern Python features effectively.
