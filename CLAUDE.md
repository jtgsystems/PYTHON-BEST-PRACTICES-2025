# Python Best Practices 2025 - Claude Code Reference

Comprehensive Python best practices repository covering modern development standards, tooling, and workflows for 2025.

---

## Repository Overview

**GitHub Repository**: `jtgsystems/PYTHON-BEST-PRACTICES-2025`
**Purpose**: Master-level Python development guide with practical examples, configurations, and automation templates
**Target Audience**: Python developers seeking production-ready best practices
**Python Versions**: 3.13+ (baseline), 3.14 for free-threaded & JIT features

---

## Repository Structure

```
PYTHON-BEST-PRACTICES-2025/
├── 01-CORE-PRINCIPLES/         # PEP standards, naming, design patterns
│   ├── pep8-guide.md
│   └── design-patterns.md
├── 02-LINTING-FORMATTING/      # Ruff, Black, MyPy configurations
│   ├── setup-guide.md
│   └── ruff-config.toml
├── 03-TESTING-FRAMEWORKS/      # pytest, coverage, testing patterns
│   └── pytest-guide.md
├── 04-PROJECT-STRUCTURE/       # Modern project layouts, packaging
│   └── modern-layout.md
├── 05-PERFORMANCE-SECURITY/    # Optimization, security practices
│   ├── performance-optimization.md
│   └── security-practices.md
├── 06-CI-CD-TEMPLATES/         # GitHub Actions, pre-commit, Docker
│   └── github-actions.md
├── 07-EXAMPLES/                # Real-world code examples
│   ├── data-science-pipeline.py
│   └── fastapi-app.py
├── .vscode/                    # VS Code configuration
│   └── settings.json
├── banner.png
├── python-project-scaffold.ps1
├── setup-vscode.bat
├── setup-vscode-complete.bat
├── setup-vscode-ultra-linting.ps1
├── vscode-python-setup.ps1
└── README.md
```

---

## Core Content Areas

### 1. Core Principles (01-CORE-PRINCIPLES/)

**PEP 8 Style Guide** (`pep8-guide.md`):
- Zen of Python principles
- Naming conventions (snake_case, PascalCase, SCREAMING_SNAKE_CASE)
- Code layout and line length (88 chars Black default, 100 max)
- Import organization and blank line rules
- Whitespace rules and operator spacing
- Comments and docstrings (Google style)
- Error handling patterns
- Function and class design principles
- Type hints (PEP 484, 585, 604)
- Modern Python features (context managers, dataclasses, pattern matching)
- Anti-patterns to avoid (mutable defaults, globals, deep nesting)

**Design Patterns** (`design-patterns.md`):
- **Creational Patterns**: Singleton, Factory, Builder
- **Structural Patterns**: Adapter, Decorator, Facade
- **Behavioral Patterns**: Observer, Strategy, Command
- **Modern Python Patterns**: Protocol (structural typing), Context Manager, Async Iterator
- **Anti-patterns**: God Class, Circular Dependencies
- Real-world implementation examples with type hints

### 2. Linting & Formatting (02-LINTING-FORMATTING/)

**Primary Toolchain (2025 Stack)**:
- **Ruff**: Ultra-fast linting (1000x faster than pylint)
- **Black**: Opinionated code formatting (industry standard)
- **MyPy**: Static type checking
- **Pre-commit**: Automated git hooks

**Setup Guide** (`setup-guide.md`):
- Tool installation and IDE integration
- Performance comparison table
- Complete `pyproject.toml` configuration
- VS Code settings integration
- Makefile for development tasks
- Pre-commit configuration
- Migration guides (Pylint→Ruff, Flake8→Ruff)

**Ruff Configuration** (`ruff-config.toml`):
- Comprehensive rule set (70+ rule categories)
- Line length: 88 characters (Black default)
- Target: Python 3.14 (py314)
- Exclude directories (migrations, venv, cache)
- Per-file ignores (tests, scripts, migrations)
- McCabe complexity limit: 10
- Pylint limits: 5 args, 12 branches, 50 statements
- Google docstring convention
- Import sorting (isort compatible)

### 3. Testing Frameworks (03-TESTING-FRAMEWORKS/)

**pytest Master Guide** (`pytest-guide.md`):
- Framework comparison (pytest vs unittest vs Hypothesis)
- Installation and plugin ecosystem (800+ plugins)
- Basic test structure and test classes
- **Fixtures**: Basic, scoped, parametrized, dependency injection
- **Advanced Testing**: Parametrized tests, exception testing, mocking
- **Async Testing**: pytest-asyncio integration
- **Test Organization**: Directory structure, conftest.py, markers
- **Coverage**: Configuration, reporting (HTML, XML, terminal)
- **Performance Testing**: pytest-benchmark, memory profiling
- **CI/CD**: GitHub Actions integration, test selection patterns
- Best practices: one assertion per test, descriptive names, fast tests

### 4. Project Structure (04-PROJECT-STRUCTURE/)

**Modern Layouts** (`modern-layout.md`):
- **Standard Package Layout** (src-based, recommended)
- **Flat Layout** (simple projects)
- **Application Layout** (web apps with models/views/services)
- **pyproject.toml**: Modern unified configuration
- Package initialization and versioning
- Main module and CLI patterns (Click framework)
- Environment management with Pydantic
- Type annotations and dataclasses
- Async support patterns
- API documentation (FastAPI)
- Docker configurations (production, multi-stage dev)
- Docker Compose for development
- README template with badges

### 5. Performance & Security (05-PERFORMANCE-SECURITY/)

**Performance Optimization** (`performance-optimization.md`):
- **Profiling Tools**: cProfile, line_profiler, memory_profiler, py-spy
- **Built-in Optimizations**: Using built-ins, collections module
- **NumPy Vectorization**: Array operations, broadcasting, memory layout
- **Cython**: C extensions for critical paths
- **Database & I/O**: Query optimization, batch operations, file streaming
- **Memory Management**: GC tuning, weak references, object pooling
- **Benchmarking**: Custom framework, performance comparison
- Best practices: measure first, algorithm over micro-optimizations

**Security Practices** (`security-practices.md`):
- **Dependency Security**: safety, bandit, semgrep
- **Input Validation**: Email, username, HTML sanitization, URL validation
- **SQL Injection Prevention**: Parameterized queries, batch operations
- **Authentication**: bcrypt password hashing (12 rounds), secure tokens
- **Session Management**: Timeout, IP validation, CSRF protection
- **Cryptography**: Fernet encryption, RSA public-key, PBKDF2 key derivation
- **Web Security**: CSRF tokens, Content Security Policy, security headers
- **Monitoring**: Security event logging, rate limiting for brute force
- Checklist: code security, auth/authz, data protection, infrastructure

### 6. CI/CD Templates (06-CI-CD-TEMPLATES/)

**GitHub Actions** (`github-actions.md`):
- **Complete CI/CD Pipeline**:
  - Lint and format checking (Ruff, Black, MyPy)
  - Security scanning (Bandit, Safety, Semgrep)
  - Multi-platform testing (Ubuntu, Windows, macOS)
  - Matrix builds (Python 3.13, 3.14)
  - Service containers (PostgreSQL, Redis)
  - Coverage reporting (Codecov)
  - Package building and PyPI deployment
  - Docker image building and pushing
  - Notifications (Slack integration)
- **Pre-commit Configuration**: 15+ hooks including ruff, black, mypy, bandit
- **Makefile**: 30+ development commands (test, lint, format, build, deploy)
- **Dockerfile Templates**: Production and multi-stage development
- **Docker Compose**: Full development environment with services
- **Environment Configuration**: Development and production .env templates
- **Release Automation**: Semantic release, version management
- **Health Checks**: Monitoring endpoints, system metrics

### 7. Examples (07-EXAMPLES/)

**Real-World Code**:
- `data-science-pipeline.py`: ETL workflow with logging, error handling, tests
- `fastapi-app.py`: FastAPI service with authentication, Pydantic models, comprehensive test suite (truncated in repo - tests section visible)

---

## Key Technologies & Tools

### Core Development Tools
- **Python**: 3.13+ (stable), 3.14 (JIT compiler, free-threading)
- **Package Manager**: uv (recommended) or Poetry
- **Linter**: Ruff
- **Formatter**: Black
- **Type Checker**: MyPy or Pyright
- **Testing**: pytest + pytest-cov + pytest-xdist
- **Security**: bandit, safety

### VS Code Integration
- Settings file included in `.vscode/settings.json`
- Ruff extension configuration
- Pytest integration
- Automatic formatting on save

### Automation Scripts
- `python-project-scaffold.ps1`: PowerShell project scaffolding
- `setup-vscode.bat`: Windows VS Code setup
- `setup-vscode-complete.bat`: Complete VS Code configuration
- `setup-vscode-ultra-linting.ps1`: Enhanced linting setup
- `vscode-python-setup.ps1`: Python environment configuration

---

## Quick Start Guide

### Installation
```bash
# Clone repository
git clone https://github.com/jtgsystems/PYTHON-BEST-PRACTICES-2025.git
cd PYTHON-BEST-PRACTICES-2025

# Install core tools
pip install ruff black mypy pytest pytest-cov

# Or use uv package manager (faster)
uv add --dev ruff black mypy pytest pytest-cov

# Install security tools (optional)
pip install bandit safety pre-commit
```

### Essential Commands
```bash
# Linting & Formatting
ruff check .                    # Fast linting
ruff check --fix .             # Auto-fix issues
ruff format .                  # Fast formatting
black .                        # Alternative formatting
mypy .                         # Type checking

# Testing
pytest                         # Run all tests
pytest --cov=src              # With coverage
pytest -x -vs                 # Stop on first failure, verbose

# Security
bandit -r src/                 # Security scan
safety check                   # Dependency vulnerabilities

# Project setup
ruff init                      # Initialize ruff config
pre-commit install            # Setup git hooks
```

---

## Configuration Examples

### pyproject.toml (Master Template)
Location: Examples in `02-LINTING-FORMATTING/setup-guide.md`

Key sections:
- `[tool.ruff]`: Line length (88), target version (py314), exclusions
- `[tool.ruff.lint]`: 70+ rule categories enabled
- `[tool.ruff.format]`: Double quotes, space indent, trailing commas
- `[tool.black]`: Line length (88), target version (py314)
- `[tool.mypy]`: Strict type checking, show error codes
- `[tool.coverage]`: Source paths, omit patterns, exclusions
- `[tool.pytest]`: Addopts, testpaths, markers
- `[tool.bandit]`: Exclusions, skip patterns

### Pre-commit Hooks
Location: `06-CI-CD-TEMPLATES/github-actions.md`

Hooks included:
- trailing-whitespace, end-of-file-fixer
- check-yaml, check-json, check-toml
- ruff (with --fix), ruff-format
- black, mypy, bandit
- isort, pyupgrade, interrogate (docstrings)
- Local: pytest, coverage-check

---

## Best Practices Summary

### Code Quality
1. Follow PEP 8 with 88-character line length (Black default)
2. Use type hints for all function signatures
3. Write docstrings (Google style) for public APIs
4. Aim for 90%+ test coverage on critical paths
5. One assertion per test when possible
6. Use descriptive names that explain intent

### Security
1. Use parameterized queries (never string concatenation)
2. Validate and sanitize all user inputs
3. Hash passwords with bcrypt (12+ rounds)
4. Implement rate limiting on auth endpoints
5. Log security events for monitoring
6. Keep dependencies updated (safety check)

### Performance
1. Profile before optimizing (measure first!)
2. Use built-in functions and collections
3. Leverage NumPy for numerical computations
4. Batch database operations
5. Use generators for large datasets
6. Consider memory patterns and caching

### Project Organization
1. Use src-based layout for packages
2. Separate configuration from code
3. Store secrets in environment variables
4. Document API with OpenAPI/Swagger
5. Include health check endpoints
6. Implement proper logging levels

---

## Learning Path

1. **01-CORE-PRINCIPLES**: Start with PEP 8 and design patterns
2. **02-LINTING-FORMATTING**: Configure tooling and IDE
3. **03-TESTING-FRAMEWORKS**: Write robust tests with pytest
4. **04-PROJECT-STRUCTURE**: Organize code for maintainability
5. **05-PERFORMANCE-SECURITY**: Profile, optimize, and secure
6. **06-CI-CD-TEMPLATES**: Automate testing and deployment
7. **07-EXAMPLES**: Study real-world implementations

---

## Version Control & Repository Info

**Repository**: https://github.com/jtgsystems/PYTHON-BEST-PRACTICES-2025
**Branch**: main
**Latest Commit**: Initial commit with comprehensive best practices
**Local Clone**: `~/Desktop/PYTHON-BEST-PRACTICES-2025/`

### Key Files
- **README.md**: Repository overview, tool list, quick commands
- **banner.png**: Visual banner (793KB)
- Configuration files: pyproject.toml examples throughout guides
- Scripts: PowerShell and Batch scripts for Windows setup
- Examples: FastAPI app, data science pipeline

---

## Python 3.13+ Features (2025)

### New & Experimental
- **Free-Threading Mode**: `--free-threading` flag for true parallelism (no GIL)
- **Experimental JIT**: PEP 744 for up to 30% speed gains
- **Template Strings**: PEP 750 for multiline templating
- **iOS Support**: PEP 730 for mobile devices
- **Enhanced REPL**: Multiline editing, syntax highlighting

### Recommended Versions
- **Production**: Python 3.13+ (stable)
- **Performance**: Python 3.13+ (JIT, free-threading)
- **Development**: Latest stable release

---

## CI/CD Integration

### GitHub Actions Workflow
Location: `06-CI-CD-TEMPLATES/github-actions.md`

**Pipeline Stages**:
1. **Lint & Format**: Ruff, Black, MyPy
2. **Security Scan**: Bandit, Safety, Semgrep
3. **Test**: Multi-OS (Ubuntu, Windows, macOS), Multi-version (3.13, 3.14)
4. **Build**: Package with twine check
5. **Deploy**: PyPI publishing (on release)
6. **Docker**: Image build and push
7. **Notify**: Slack notifications

**Services**: PostgreSQL 15, Redis 7
**Caching**: pip dependencies
**Coverage**: Codecov integration

---

## Docker Support

### Production Dockerfile
- Base: python:3.14-slim
- Non-root user (appuser)
- Health checks
- Security hardening
- Port: 8000

### Development Dockerfile
- Multi-stage build
- Development tools (git, vim, ipdb, jupyter)
- Pre-commit hooks
- Debug mode
- Hot reload

### Docker Compose
- App service with volume mounts
- PostgreSQL 15 with init scripts
- Redis 7
- Nginx reverse proxy
- Separate test services (ephemeral databases)

---

## Additional Resources

### Included Documentation
- Complete `pyproject.toml` templates
- GitHub Actions workflows
- Pre-commit configurations
- Makefile with 30+ commands
- Docker Compose examples
- Health check implementations
- Security logging patterns
- Performance benchmarking code

### External References
- PEP 8: https://peps.python.org/pep-0008/
- Ruff: https://github.com/charliermarsh/ruff
- Black: https://github.com/psf/black
- MyPy: http://mypy-lang.org/
- pytest: https://docs.pytest.org/

---

## Contributing

This repository follows its own best practices for contributions:
- Fork the repository
- Follow PEP 8 style guide (88-character lines)
- Add tests for new features
- Run full CI suite locally (`make ci`)
- Submit pull request with clear description

---

## License

This project is licensed under MIT. See LICENSE file in repository for details.

---

## Notes for Claude Code

### Quick Reference Commands
```bash
# Navigate to repository
cd ~/Desktop/PYTHON-BEST-PRACTICES-2025

# Read specific guides
cat 01-CORE-PRINCIPLES/pep8-guide.md
cat 02-LINTING-FORMATTING/setup-guide.md
cat 03-TESTING-FRAMEWORKS/pytest-guide.md
cat 06-CI-CD-TEMPLATES/github-actions.md

# Review configurations
cat 02-LINTING-FORMATTING/ruff-config.toml
cat .vscode/settings.json

# Check examples
cat 07-EXAMPLES/fastapi-app.py
cat 07-EXAMPLES/data-science-pipeline.py
```

### Repository Highlights
- **Comprehensive**: Covers entire Python development lifecycle
- **Modern**: 2025 tooling (Ruff, uv, Python 3.13)
- **Practical**: Real configuration files and working examples
- **Production-Ready**: Security, performance, CI/CD included
- **Well-Organized**: Clear structure, easy navigation

### Use Cases
1. **Starting New Projects**: Use templates and configurations
2. **Code Review**: Reference style guides and best practices
3. **CI/CD Setup**: Copy GitHub Actions workflows
4. **Security Hardening**: Implement security patterns
5. **Performance Tuning**: Apply optimization techniques
6. **Testing Strategy**: Follow pytest patterns

---

*Last Updated: 2025-12-26*
*Repository: jtgsystems/PYTHON-BEST-PRACTICES-2025*
*GitHub URL: https://github.com/jtgsystems/PYTHON-BEST-PRACTICES-2025*

## Framework Versions

### Development Tools (2025)
- **Ruff**: 0.14.3 (linter & formatter)
- **Black**: 25.9.0 (code formatter)
- **MyPy**: 1.18.2 (type checker)
- **pytest**: Latest (testing framework)
- **uv**: 0.9.7 (package manager)

### Python Versions Supported
- **Python 3.14.0**: Latest with free-threaded builds, JIT compiler
- **Python 3.13.9**: Latest stable (LTS through Oct 2029)
- **Python 3.12**: Security updates through Oct 2028

### Example Applications
- **FastAPI**: Modern async web framework (in examples)
- **Pydantic**: Data validation (in examples)
- No heavy frameworks - focuses on best practices and patterns

---

## Repository Purpose & Audience

### Primary Purpose
This repository serves as a comprehensive reference guide for Python developers who want to:
- Write production-quality Python code following modern best practices
- Set up robust development environments with proper tooling
- Implement secure, performant, and maintainable applications
- Automate testing, linting, and deployment pipelines
- Stay current with Python 3.13+ features and 2025 ecosystem tools

### Target Audience
- **Junior to Mid-level Developers**: Learn industry-standard practices
- **Senior Developers**: Quick reference for tooling configurations
- **Team Leads**: Establish team-wide coding standards
- **DevOps Engineers**: CI/CD pipeline templates and automation
- **Security Engineers**: Security best practices and scanning tools

### How to Use This Repository
1. **New Projects**: Copy configurations from `02-LINTING-FORMATTING/` and `04-PROJECT-STRUCTURE/`
2. **Code Reviews**: Reference `01-CORE-PRINCIPLES/` for style and design guidance
3. **CI/CD Setup**: Use workflows from `06-CI-CD-TEMPLATES/`
4. **Learning**: Follow the numbered directory structure sequentially
5. **Team Standards**: Adopt the provided configs and modify as needed

---

## Automation & Scripts

The repository includes several Windows automation scripts for rapid environment setup:

### PowerShell Scripts
- **python-project-scaffold.ps1**: Creates new Python project structure with all configurations
- **vscode-python-setup.ps1**: Configures Python environment in VS Code
- **setup-vscode-ultra-linting.ps1**: Sets up enhanced linting with multiple tools

### Batch Files
- **setup-vscode.bat**: Basic VS Code Python setup for Windows
- **setup-vscode-complete.bat**: Complete VS Code configuration including extensions

These scripts automate:
- Installation of development tools (Ruff, Black, MyPy, pytest)
- VS Code extension installation and configuration
- Pre-commit hook setup
- Project structure creation
- Git repository initialization

---

## Testing Examples & Patterns

From `07-EXAMPLES/fastapi-app.py`, the repository demonstrates:
- FastAPI application structure with proper routing
- Pydantic models for request/response validation
- Authentication patterns (visible in truncated example)
- Comprehensive test coverage patterns

From `07-EXAMPLES/data-science-pipeline.py`:
- ETL workflow implementation
- Proper logging configuration
- Error handling patterns
- Testing data pipelines

---

## Summary of Key Learnings

### For Claude Code Reference
When working with Python projects, this repository provides:

1. **Configuration Templates**: Copy-paste ready configs for `pyproject.toml`, `.pre-commit-config.yaml`, `ruff.toml`
2. **CI/CD Patterns**: Complete GitHub Actions workflows with security scanning, multi-OS testing, and deployment
3. **Security Patterns**: Input validation, SQL injection prevention, password hashing, CSRF protection
4. **Performance Optimization**: Profiling tools, NumPy vectorization, database optimization
5. **Project Structure**: Three different layout patterns (src-based, flat, application)
6. **Testing Strategies**: pytest fixtures, parametrization, async testing, coverage reporting

### Quick Wins
- Start new projects with proper structure from day one
- Enforce consistent code style across teams with Ruff + Black
- Achieve 90%+ test coverage with pytest patterns
- Automate security scanning with Bandit + Safety
- Deploy with confidence using GitHub Actions templates

---

## Repository Maintenance

### Update Frequency
This repository should be reviewed and updated:
- **Quarterly**: Tool version updates (Ruff, Black, MyPy, pytest)
- **Semi-annually**: Python version support and new features
- **As needed**: Security patches and critical updates

### Current Status (December 2025)
- All tool versions are current as of Q4 2025
- Python 3.14 features documented
- GitHub Actions workflows compatible with latest runners
- Security practices aligned with OWASP standards

---

*Documentation maintained by: jtgsystems*
*For issues or contributions: https://github.com/jtgsystems/PYTHON-BEST-PRACTICES-2025/issues*
