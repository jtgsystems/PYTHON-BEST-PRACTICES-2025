# PYTHON BEST PRACTICES 2025

## 🐍 Master Python Development - Comprehensive Guide

### Current Python Versions (2025)
- **Python 3.13.2** (Feb 2025) - Latest stable with JIT, free-threading
- **Python 3.14** (Alpha 7) - Template strings (t-strings), TYPE_CHECKING builtin
- **Recommended**: Python 3.12+ for production, 3.13+ for performance

### Key 2025 Features
- **Free-threading mode** (no-GIL) via `--free-threading`
- **Experimental JIT compiler** (PEP 744) - 30% speedups
- **Template strings** (PEP 750) in Python 3.14
- **iOS support** (PEP 730) for mobile development
- **Enhanced interactive REPL** with multiline editing

## 📁 Repository Structure

```
01-CORE-PRINCIPLES/     # PEP standards, naming, design patterns
02-LINTING-FORMATTING/  # Ruff, Black, MyPy configurations
03-TESTING-FRAMEWORKS/  # Pytest, unittest, coverage
04-PROJECT-STRUCTURE/   # Modern project layouts
05-PERFORMANCE-SECURITY # Optimization & security practices
06-CI-CD-TEMPLATES/     # GitHub Actions, pre-commit hooks
07-EXAMPLES/           # Real-world implementation examples
```

## 🚀 Quick Start Checklist

### Essential Tools (2025 Stack)
- **Linter**: Ruff (1000x faster than pylint)
- **Formatter**: Black + Ruff format
- **Type Checker**: MyPy or Pyright
- **Testing**: Pytest + Coverage
- **Package Manager**: uv (fastest) or Poetry

### Installation Commands
```bash
# Core toolchain
pip install ruff black mypy pytest pytest-cov

# or with uv (recommended)
uv add --dev ruff black mypy pytest pytest-cov

# Optional but powerful
pip install pre-commit bandit safety
```

## 📖 Learning Path

### Beginner → Intermediate
1. **Master PEP 8** (01-CORE-PRINCIPLES/pep8-guide.md)
2. **Setup linting** (02-LINTING-FORMATTING/ruff-config.toml)
3. **Write tests** (03-TESTING-FRAMEWORKS/pytest-guide.md)
4. **Structure projects** (04-PROJECT-STRUCTURE/)

### Intermediate → Advanced
1. **Performance optimization** (05-PERFORMANCE-SECURITY/)
2. **Security scanning** (bandit, safety)
3. **CI/CD automation** (06-CI-CD-TEMPLATES/)
4. **Type system mastery** (MyPy advanced patterns)

### Advanced → Expert
1. **Custom metaclasses & descriptors**
2. **C extensions & Cython**
3. **Async/await patterns**
4. **Memory profiling & optimization**

## 🎯 2025 Best Practices Summary

### Code Quality
- Use **Ruff** for linting (replaces flake8, pylint)
- **Black** for consistent formatting
- **MyPy** for type safety
- **Pre-commit hooks** for automation

### Testing Strategy
- **Pytest** as primary framework
- **Coverage.py** for 90%+ coverage
- **Hypothesis** for property-based testing
- **Factory Boy** for test data

### Performance
- **Profile first** with cProfile, py-spy
- **Use built-ins** (collections, itertools)
- **Async/await** for I/O bound tasks
- **Cython/NumPy** for compute-heavy work

### Security
- **Bandit** for vulnerability scanning
- **Safety** for dependency checking
- **Never hardcode secrets**
- **Validate all inputs**

## 📚 Documentation References

### Official Python Docs
- [What's New in Python 3.13](https://docs.python.org/3/whatsnew/3.13.html)
- [Python 3.14 Alpha](https://docs.python.org/3.14/whatsnew/3.14.html)
- [PEP Index](https://peps.python.org/)

### Essential PEPs (2025)
- **PEP 8**: Style Guide (forever relevant)
- **PEP 703**: Free-threading (Python 3.13+)
- **PEP 744**: JIT Compiler (Python 3.13+)
- **PEP 750**: Template strings (Python 3.14)

### Modern Tools
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Pytest Documentation](https://docs.pytest.org/)
- [MyPy Documentation](https://mypy.readthedocs.io/)

## 🔧 Quick Commands Reference

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
pytest --collect-only          # Discover tests
pre-commit install             # Setup git hooks
```

## 🏆 Master-Level Goals

By mastering this repository, you will:
- Write production-ready Python code
- Implement comprehensive testing strategies
- Optimize for performance and security
- Build maintainable, scalable applications
- Lead Python development teams
- Contribute to open-source projects

---

**Last Updated**: May 2025 | **Python Versions**: 3.12-3.14 | **Tools**: Ruff, Black, MyPy, Pytest
