# Linting & Formatting Setup - November 2025 Stack

## Tool Selection Rationale

### Primary Stack (2025)
1. **Ruff 0.14.3+** - Lightning-fast linting, formatting, import sorting, security checks
2. **Black** - Opinionated formatter (useful when matching legacy repos or CI contracts)
3. **MyPy** - Static type checking
4. **Pre-commit** - Automated git hooks

### Performance Comparison
```
Tool          Speed     Coverage    Maintenance
Ruff          ⭐⭐⭐⭐⭐   ⭐⭐⭐⭐     ⭐⭐⭐⭐⭐
Pylint        ⭐         ⭐⭐⭐⭐⭐   ⭐⭐⭐
Flake8        ⭐⭐⭐       ⭐⭐⭐      ⭐⭐⭐
Black         ⭐⭐⭐⭐     ⭐⭐       ⭐⭐⭐⭐⭐
MyPy          ⭐⭐        ⭐⭐⭐⭐⭐   ⭐⭐⭐⭐
```

## Installation & Setup

### Quick Start
```bash
# Essential tools
pip install "ruff>=0.14.3" "black>=25.9.0" "mypy>=1.18.2" pre-commit

# Optional security tools
pip install bandit safety

# With uv (fastest package manager)
uv tool upgrade "uv>=0.9.7"
uv add --dev ruff>=0.14.3 black>=25.9.0 mypy>=1.18.2 pre-commit bandit safety
```

### IDE Integration
- **VS Code**: Install Ruff, Black, and Pylance extensions
- **PyCharm**: Enable external tools for Ruff/Black
- **Vim/Neovim**: Use ALE or CoC plugins

## Configuration Files

### pyproject.toml (Unified Config)
```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "your-project"
dynamic = ["version"]
description = "Your project description"
authors = [{name = "Your Name", email = "you@example.com"}]
license = {text = "MIT"}
requires-python = ">=3.13"

[tool.ruff]
# Same as Black
line-length = 88
indent-width = 4
target-version = "py314"

# Directories to exclude
exclude = [
    ".bzr", ".direnv", ".eggs", ".git", ".hg", ".mypy_cache",
    ".nox", ".pants.d", ".pytype", ".ruff_cache", ".svn", ".tox",
    ".venv", "__pypackages__", "_build", "buck-out", "build",
    "dist", "node_modules", "venv", "migrations"
]

[tool.ruff.lint]
# Enable comprehensive rule set
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # Pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "D",   # pydocstyle
    "UP",  # pyupgrade
    "YTT", # flake8-2020
    "ANN", # flake8-annotations
    "S",   # flake8-bandit
    "BLE", # flake8-blind-except
    "FBT", # flake8-boolean-trap
    "B",   # flake8-bugbear
    "A",   # flake8-builtins
    "COM", # flake8-commas
    "C4",  # flake8-comprehensions
    "DTZ", # flake8-datetimez
    "T10", # flake8-debugger
    "EM",  # flake8-errmsg
    "EXE", # flake8-executable
    "FA",  # flake8-future-annotations
    "ISC", # flake8-implicit-str-concat
    "ICN", # flake8-import-conventions
    "G",   # flake8-logging-format
    "INP", # flake8-no-pep420
    "PIE", # flake8-pie
    "T20", # flake8-print
    "PYI", # flake8-pyi
    "PT",  # flake8-pytest-style
    "Q",   # flake8-quotes
    "RSE", # flake8-raise
    "RET", # flake8-return
    "SLF", # flake8-self
    "SLOT", # flake8-slots
    "SIM", # flake8-simplify
    "TID", # flake8-tidy-imports
    "TCH", # flake8-type-checking
    "INT", # flake8-gettext
    "ARG", # flake8-unused-arguments
    "PTH", # flake8-use-pathlib
    "ERA", # eradicate
    "PD",  # pandas-vet
    "PGH", # pygrep-hooks
    "PL",  # Pylint
    "TRY", # tryceratops
    "FLY", # flynt
    "NPY", # NumPy-specific rules
    "PERF", # Perflint
    "RUF", # Ruff-specific rules
]

# Rules to ignore
ignore = [
    "D100", # Missing docstring in public module
    "D101", # Missing docstring in public class
    "D102", # Missing docstring in public method
    "D103", # Missing docstring in public function
    "D104", # Missing docstring in public package
    "D105", # Missing docstring in magic method
    "ANN101", # Missing type annotation for self
    "ANN102", # Missing type annotation for cls
    "S101",   # Use of assert detected
    "FBT001", # Boolean positional arg in function definition
    "FBT002", # Boolean default value in function definition
]

# Allow autofix for all enabled rules
fixable = ["ALL"]
unfixable = []

# Allow unused variables when underscore-prefixed
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

[tool.ruff.lint.per-file-ignores]
"tests/**/*" = ["PLR2004", "S101", "TID252"]
"**/migrations/*" = ["ALL"]

[tool.ruff.lint.mccabe]
max-complexity = 10

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.lint.pylint]
max-args = 5
max-branches = 12
max-returns = 6
max-statements = 50

[tool.ruff.format]
# Use double quotes for strings
quote-style = "double"
# Indent with spaces, rather than tabs
indent-style = "space"
# Respect magic trailing commas
skip-magic-trailing-comma = false
# Automatically detect the appropriate line ending
line-ending = "auto"

[tool.black]
line-length = 88
target-version = ['py314']
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
  | migrations
)/
'''

[tool.mypy]
python_version = "3.14"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
strict_equality = true
show_column_numbers = true
show_error_codes = true
pretty = true

# Per-module options
[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = [
    "pandas.*",
    "numpy.*",
    "requests.*",
]
ignore_missing_imports = true

[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/migrations/*",
    "*/venv/*",
    "*/__pycache__/*"
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
]
show_missing = true
precision = 2

[tool.pytest.ini_options]
minversion = "6.0"
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=src",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-report=xml",
    "--cov-fail-under=80"
]
testpaths = ["tests"]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests"
]

[tool.bandit]
exclude_dirs = ["tests", "migrations"]
skips = ["B101", "B601"]
```

## Command Cheat Sheet

### Daily Commands
```bash
# Linting & formatting
ruff check .                    # Check all files
ruff check --fix .             # Fix auto-fixable issues
ruff format .                  # Format all files
black .                        # Alternative formatting

# Type checking
mypy src/                      # Check types in src directory
mypy --install-types          # Install missing type stubs

# Testing with coverage
pytest                         # Run tests
pytest --cov=src              # With coverage
pytest -x -vvs                # Stop on first failure, verbose

# Security scanning
bandit -r src/                 # Security vulnerabilities
safety check                  # Check dependencies

# All-in-one check
ruff check . && ruff format . && mypy src/ && pytest
```

### CI/CD Commands
```bash
# Non-interactive mode
ruff check --output-format=github .
black --check --diff .
mypy --no-error-summary .
pytest --junitxml=test-results.xml
```

## Integration Examples

### VS Code Settings (.vscode/settings.json)
```json
{
    "python.linting.enabled": true,
    "python.linting.ruffEnabled": true,
    "python.linting.blackEnabled": false,
    "python.linting.pylintEnabled": false,
    "python.formatting.provider": "black",
    "python.formatting.blackArgs": ["--line-length=88"],
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true,
        "source.fixAll.ruff": true
    },
    "python.analysis.typeCheckingMode": "strict",
    "files.exclude": {
        "**/__pycache__": true,
        "**/.mypy_cache": true,
        "**/.ruff_cache": true
    }
}
```

### Makefile
```makefile
.PHONY: lint format type-check test clean install dev-install

install:
	pip install -e .

dev-install:
	pip install -e ".[dev]"
	pre-commit install

lint:
	ruff check .

format:
	ruff format .
	black .

type-check:
	mypy src/

test:
	pytest

security:
	bandit -r src/
	safety check

ci: lint type-check test security
	@echo "All checks passed!"

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	rm -rf build/ dist/ *.egg-info/
```

### Pre-commit Configuration (.pre-commit-config.yaml)
```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-case-conflict
      - id: check-merge-conflict
      - id: debug-statements

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
        additional_dependencies: [types-requests, types-PyYAML]
        args: [--strict, --ignore-missing-imports]

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: ['-c', 'pyproject.toml']
        additional_dependencies: ['bandit[toml]']

  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: pytest
        language: system
        pass_filenames: false
        always_run: true
```

## Migration Guide

### From Pylint to Ruff
```bash
# 1. Remove old tools
pip uninstall pylint flake8 isort

# 2. Install Ruff
pip install ruff

# 3. Convert configuration
# Old .pylintrc becomes ruff configuration in pyproject.toml

# 4. Update CI scripts
# Replace: pylint src/
# With:    ruff check src/
```

### From Flake8 to Ruff
```bash
# Ruff supports most flake8 rules out of the box
# Map your .flake8 config to pyproject.toml [tool.ruff] section

# Common mappings:
# max-line-length = 88  →  line-length = 88
# ignore = E203,W503     →  ignore = ["E203", "W503"]
# select = E,W,F         →  select = ["E", "W", "F"]
```

## Performance Tips

### Ruff Optimization
```bash
# Use cache directory (automatic)
export RUFF_CACHE_DIR=~/.cache/ruff

# Run only specific rules for speed
ruff check --select F,E9 .

# Parallel execution (automatic in Ruff)
# No special configuration needed
```

### MyPy Performance
```toml
[tool.mypy]
# Cache for faster subsequent runs
cache_dir = ".mypy_cache"

# Skip checking imported modules
follow_imports = "skip"

# Use faster import discovery
namespace_packages = true
```

---

**Pro Tip**: Start with Ruff + Black + MyPy. Add other tools as needed. The 2025 Python toolchain prioritizes speed and developer experience.
