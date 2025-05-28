# 🐍 Python Best Practices 2025

Comprehensive guide to writing reliable, maintainable, and high-performance Python code.

---

## 🔍 Supported Python Versions

- ⚡️ **Python 3.13.2** (Feb 2025) – Stable with JIT compiler & free-threading support  
- 🧪 **Python 3.14** (Alpha) – Template strings (PEP 750), new `TYPE_CHECKING` builtin  
- ✅ **Recommended**: 3.12+ for production, 3.13+ to leverage performance features  

---

## 🚀 New & Experimental Features

- 🆓 **Free-Threading Mode** (`--free-threading`) – no GIL, true parallelism  
- 🔥 **Experimental JIT** (PEP 744) – up to 30% speed gains  
- ✂️ **Template Strings** (PEP 750) – multiline f-string-like templating  
- 📱 **iOS Support** (PEP 730) – Python on mobile devices  
- 💬 **Enhanced REPL** – multiline editing, syntax highlighting  

---

## 📁 Repository Structure

```
01-CORE-PRINCIPLES/      # PEP guidelines, naming conventions, SOLID & design patterns  
02-LINTING-FORMATTING/   # Ruff, Black & MyPy configs + style guide  
03-TESTING-FRAMEWORKS/   # pytest, unittest, coverage examples  
04-PROJECT-STRUCTURE/    # src layout, module vs. package best practices  
05-PERFORMANCE-SECURITY/ # Profiling tips, optimizations & security checks  
06-CI-CD-TEMPLATES/      # GitHub Actions, pre-commit hooks & YAML samples  
07-EXAMPLES/             # Data pipelines, FastAPI demos, real-world code  
output/                  # Generated docs, reports, artifacts  
```

---

## 🛠️ Essential Tools & Setup

### Toolchain

- 🔍 **Linter**: [Ruff](https://github.com/charliermarsh/ruff) – ultra-fast, zero-config linting  
- 🎨 **Formatter**: [Black](https://github.com/psf/black) + Ruff format  
- 🔢 **Type Checker**: [MyPy](http://mypy-lang.org/) or [Pyright](https://github.com/microsoft/pyright)  
- 🧪 **Testing**: [pytest](https://docs.pytest.org/) + [pytest-cov](https://github.com/pytest-dev/pytest-cov)  
- 📦 **Package Manager**: [uv](https://github.com/pdm-project/uv) (recommended) or [Poetry](https://python-poetry.org/)  

### Installation

```powershell
# Install core development tools
pip install ruff black mypy pytest pytest-cov

# Or using uv package manager
uv add --dev ruff black mypy pytest pytest-cov

# Optional security & pre-commit tools
pip install pre-commit bandit safety
```

### Pre-Commit Hooks

Create a `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.4.4  
    hooks:
      - id: ruff

  - repo: https://github.com/psf/black
    rev: 24.4.2  
    hooks:
      - id: black

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.10.0  
    hooks:
      - id: mypy
```

Enable by running:

```bash
pre-commit install
```

---

## 📖 Learning Path

1. **01-CORE-PRINCIPLES** – PEP standards, naming, SOLID & design patterns  
2. **02-LINTING-FORMATTING** – Configure and enforce lint & format rules  
3. **03-TESTING-FRAMEWORKS** – Write robust tests & measure coverage  
4. **04-PROJECT-STRUCTURE** – Organize code for maintainability  
5. **05-PERFORMANCE-SECURITY** – Profile, optimize, and secure applications  
6. **06-CI-CD-TEMPLATES** – Automate linting, testing & deployment pipelines  
7. **07-EXAMPLES** – Explore real-world scripts and template projects  

---

## 🧩 Examples & Templates

- **data-science-pipeline.py** – ETL workflow with logging, error handling & tests  
- **fastapi-app.py** – Minimal FastAPI service with Pydantic models & security checks  

---

## 🎯 Quick Commands Reference

```bash
# Linting & Formatting
ruff check .                    # Fast linting
ruff format .                   # Fast formatting
black .                         # Alternative formatting
mypy .                          # Type checking

# Testing
pytest                          # Run all tests
pytest --cov=src               # With coverage
pytest -x -vs                  # Stop on first failure, verbose

# Security
bandit -r src/                  # Security scan
safety check                   # Dependency vulnerabilities

# Project setup
ruff init                       # Initialize ruff config
pre-commit install             # Setup git hooks
```

---

## ⭐ Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) and follow our code style guidelines.  

---

## 📄 License

This project is licensed under MIT. See [LICENSE](LICENSE) for details.
