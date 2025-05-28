# Python Best Practices 2025 - Project Scaffold Script
# Creates a complete modern Python project structure with all best practices

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = ".",
    
    [Parameter(Mandatory=$false)]
    [switch]$FastAPI,
    
    [Parameter(Mandatory=$false)]
    [switch]$DataScience,
    
    [Parameter(Mandatory=$false)]
    [switch]$CLI,
    
    [Parameter(Mandatory=$false)]
    [switch]$FullStack
)

# Colors for output
$Red = "`e[31m"
$Green = "`e[32m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Cyan = "`e[36m"
$Reset = "`e[0m"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = $Reset)
    Write-Host "${Color}${Message}${Reset}"
}

function New-ProjectDirectory {
    param([string]$Path)
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-ColorOutput "✓ Created: $Path" $Green
    }
}

function New-ProjectFile {
    param([string]$Path, [string]$Content = "")
    $dir = Split-Path $Path -Parent
    if ($dir -and !(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    Set-Content -Path $Path -Value $Content -Encoding UTF8
    Write-ColorOutput "✓ Created: $Path" $Green
}

Write-ColorOutput "🐍 Python Best Practices 2025 - Project Scaffold" $Cyan
Write-ColorOutput "Creating project: $ProjectName" $Yellow

# Create base project structure
$projectRoot = Join-Path $ProjectPath $ProjectName
New-ProjectDirectory $projectRoot

# Core directories
$directories = @(
    "src/$ProjectName",
    "tests/unit",
    "tests/integration",
    "tests/e2e",
    "docs",
    "scripts",
    ".github/workflows"
)

foreach ($dir in $directories) {
    New-ProjectDirectory (Join-Path $projectRoot $dir)
}

# Core configuration files
Write-ColorOutput "📝 Creating configuration files..." $Blue

# pyproject.toml
$pyprojectContent = @"
[build-system]
requires = ["hatchling>=1.13.0"]
build-backend = "hatchling.build"

[project]
name = "$ProjectName"
dynamic = ["version"]
description = "A modern Python project following 2025 best practices"
readme = "README.md"
license = {text = "MIT"}
authors = [
    {name = "Your Name", email = "you@example.com"},
]
keywords = ["python", "modern", "best-practices"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.12",
    "Programming Language :: Python :: 3.13",
]
requires-python = ">=3.12"
dependencies = [
    "click>=8.1.0",
    "pydantic>=2.5.0",
    "python-dotenv>=1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "pytest-xdist>=3.5.0",
    "pytest-mock>=3.12.0",
    "ruff>=0.1.0",
    "black>=23.12.0",
    "mypy>=1.7.0",
    "pre-commit>=3.6.0",
    "bandit[toml]>=1.7.5",
    "safety>=2.3.0",
]
test = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "pytest-mock>=3.12.0",
    "factory-boy>=3.3.0",
]
docs = [
    "sphinx>=7.2.0",
    "sphinx-rtd-theme>=2.0.0",
    "myst-parser>=2.0.0",
]

[project.urls]
Homepage = "https://github.com/yourusername/$ProjectName"
Documentation = "https://$ProjectName.readthedocs.io"
Repository = "https://github.com/yourusername/$ProjectName"
"Bug Tracker" = "https://github.com/yourusername/$ProjectName/issues"

[project.scripts]
$ProjectName = "$ProjectName.__main__:main"

[tool.hatch.version]
path = "src/$ProjectName/__init__.py"

[tool.hatch.build.targets.wheel]
packages = ["src/$ProjectName"]

[tool.ruff]
target-version = "py312"
line-length = 88
indent-width = 4

exclude = [
    ".bzr", ".direnv", ".eggs", ".git", ".hg", ".mypy_cache",
    ".nox", ".pants.d", ".pytype", ".ruff_cache", ".svn", ".tox",
    ".venv", "__pypackages__", "_build", "buck-out", "build",
    "dist", "node_modules", "venv"
]

[tool.ruff.lint]
select = [
    "E", "W", "F", "I", "N", "D", "UP", "YTT", "ANN", "S", "BLE",
    "FBT", "B", "A", "COM", "C4", "DTZ", "T10", "EM", "EXE", "FA",
    "ISC", "ICN", "G", "INP", "PIE", "T20", "PYI", "PT", "Q", "RSE",
    "RET", "SLF", "SLOT", "SIM", "TID", "TCH", "INT", "ARG", "PTH",
    "ERA", "PD", "PGH", "PL", "TRY", "FLY", "NPY", "PERF", "RUF"
]

ignore = [
    "D100", "D101", "D102", "D103", "D104", "D105", "D107",
    "ANN101", "ANN102", "ANN401", "S101", "FBT001", "FBT002",
    "T201", "PLR0913", "PLR2004"
]

fixable = ["ALL"]
unfixable = []

[tool.ruff.lint.per-file-ignores]
"tests/**/*" = ["S101", "PLR2004", "ANN001", "ANN201", "D100", "D103"]
"scripts/**/*" = ["T201", "S603", "PLR2004"]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
skip-magic-trailing-comma = false
line-ending = "auto"

[tool.black]
line-length = 88
target-version = ['py312']
include = '\.pyi?$'

[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
show_column_numbers = true
show_error_codes = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[tool.pytest.ini_options]
minversion = "6.0"
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=src",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=80"
]
testpaths = ["tests"]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests"
]

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/__pycache__/*"]

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

[tool.bandit]
exclude_dirs = ["tests"]
"@

New-ProjectFile (Join-Path $projectRoot "pyproject.toml") $pyprojectContent

# Setup instructions
$setupInstructions = @"

🎉 Project '$ProjectName' created successfully!

📁 Project Structure:
   $projectRoot/
   ├── src/$ProjectName/          # Source code
   ├── tests/                     # Test files  
   ├── docs/                      # Documentation
   ├── scripts/                   # Utility scripts
   ├── .github/workflows/         # CI/CD workflows
   ├── pyproject.toml            # Project configuration
   ├── README.md                 # Project documentation
   └── .pre-commit-config.yaml   # Git hooks

📋 Next Steps:

1. Navigate to your project:
   cd $projectRoot

2. Create a virtual environment:
   python -m venv .venv
   .venv\Scripts\activate  # Windows
   # source .venv/bin/activate  # Linux/Mac

3. Install development dependencies:
   pip install -e ".[dev]"

4. Set up pre-commit hooks:
   pre-commit install

5. Initialize git repository:
   git init
   git add .
   git commit -m "Initial commit: Python Best Practices 2025 project structure"

6. Run initial tests:
   pytest

7. Check code quality:
   ruff check .
   mypy src/
   
🔧 Available Commands:
   make help           # Show all available commands
   make test           # Run tests
   make lint           # Run linting
   make format         # Format code
   make type-check     # Run type checking
   make ci             # Run all CI checks

📚 Documentation:
   - README.md contains project overview
   - Check PYTHON-BEST-PRACTICES-2025 folder for comprehensive guides
   - Follow the learning path in the main README

🚀 Happy coding with Python Best Practices 2025!
"@

Write-ColorOutput $setupInstructions $Green

# If specific project types were selected, add additional guidance
if ($FastAPI) {
    Write-ColorOutput "🚀 FastAPI Project Notes:" $Cyan
    Write-ColorOutput "- Add FastAPI dependencies to pyproject.toml" $Yellow
    Write-ColorOutput "- Check 07-EXAMPLES/fastapi-app.py for complete implementation" $Yellow
    Write-ColorOutput "- Run with: uvicorn $ProjectName.api:app --reload" $Yellow
}

if ($DataScience) {
    Write-ColorOutput "📊 Data Science Project Notes:" $Cyan
    Write-ColorOutput "- Add data science dependencies to pyproject.toml" $Yellow
    Write-ColorOutput "- Check 07-EXAMPLES/data-science-pipeline.py for ML pipeline" $Yellow
    Write-ColorOutput "- Use notebooks/ directory for Jupyter notebooks" $Yellow
}

Write-ColorOutput "`n✨ Your modern Python project is ready! Follow the setup steps above to get started." $Magenta
