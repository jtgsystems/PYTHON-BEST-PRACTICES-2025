# VSCode Python Ultra Linting Setup 2025
# Maximum code quality with intelligent ignores for productivity

param(
    [switch]$BackupExisting = $true
)

$ErrorActionPreference = "Stop"

function Get-VSCodeSettingsPath {
    return "$env:APPDATA\Code\User\settings.json"
}

function Set-UltraLintingSettings {
    $settingsPath = Get-VSCodeSettingsPath
    $settingsDir = Split-Path $settingsPath -Parent
    
    if (!(Test-Path $settingsDir)) {
        New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
    }
    
    # Backup existing settings
    if ($BackupExisting -and (Test-Path $settingsPath)) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        Copy-Item $settingsPath "$settingsPath.backup_$timestamp"
        Write-Host "Backup created: settings.json.backup_$timestamp"
    }
    
    $settings = @{
        # Python Configuration
        "python.defaultInterpreterPath" = "python"
        "python.terminal.activateEnvironment" = $true
        
        # Ultra Ruff Configuration - Maximum Quality
        "ruff.enable" = $true
        "ruff.fixAll" = $true
        "ruff.organizeImports" = $true
        "ruff.showNotifications" = "always"
        
        # Comprehensive Rule Set with Intelligent Ignores
        "ruff.args" = @(
            # Enable ALL major rule categories
            "--select=E,W,F,I,N,D,UP,YTT,ANN,S,BLE,FBT,B,A,COM,C4,DTZ,T10,EM,EXE,FA,ISC,ICN,G,INP,PIE,T20,PYI,PT,Q,RSE,RET,SLF,SLOT,SIM,TID,TCH,INT,ARG,PTH,ERA,PD,PGH,PL,TRY,FLY,NPY,PERF,RUF",
            
            # Strategic ignores for productivity
            "--ignore=E501,W503,E203,E701,E704,E712,E722,E741,W504,D100,D101,D102,D103,D104,D105,D106,D107,D200,D205,D400,D401,D415,ANN101,ANN102,ANN401,S101,S102,S103,S104,S105,S106,S107,FBT001,FBT002,FBT003,T201,T203,PLR0911,PLR0912,PLR0913,PLR0915,PLR2004,PLR5501,C901,COM812,ISC001,Q000,Q001,Q002,Q003,UP007,TRY003,SIM108,PTH100,PTH103,PTH107,PTH110,PTH118,PTH119,PTH123,ERA001,PGH003,PGH004,RET504,RET505,RET506,ARG001,ARG002,ARG005",
            
            # Line length set to reasonable limit
            "--line-length=120",
            
            # Target Python 3.12+
            "--target-version=py312",
            
            # Additional performance settings
            "--cache-dir=.ruff_cache",
            "--respect-gitignore"
        )
        
        # Advanced Formatting
        "editor.formatOnSave" = $true
        "editor.formatOnPaste" = $false
        "editor.formatOnType" = $false
        "editor.codeActionsOnSave" = @{
            "source.organizeImports" = "explicit"
            "source.fixAll.ruff" = "explicit"
            "source.fixAll" = "explicit"
        }
        
        # Black Formatter with Extended Line Length
        "[python]" = @{
            "editor.defaultFormatter" = "ms-python.black-formatter"
            "editor.formatOnSave" = $true
            "editor.tabSize" = 4
            "editor.insertSpaces" = $true
        }
        "black-formatter.args" = @(
            "--line-length=120",
            "--target-version=py312",
            "--skip-string-normalization"
        )
        
        # MyPy Ultra-Strict Type Checking
        "python.analysis.typeCheckingMode" = "strict"
        "python.analysis.autoImportCompletions" = $true
        "python.analysis.diagnosticMode" = "workspace"
        "python.analysis.stubPath" = "typings"
        "mypy-type-checker.args" = @(
            "--strict",
            "--warn-unreachable",
            "--warn-redundant-casts",
            "--warn-unused-ignores",
            "--disallow-any-generics",
            "--check-untyped-defs",
            "--no-implicit-reexport"
        )
        
        # Testing Configuration
        "python.testing.pytestEnabled" = $true
        "python.testing.unittestEnabled" = $false
        "python.testing.autoTestDiscoverOnSaveEnabled" = $true
        "python.testing.pytestArgs" = @("tests", "-v", "--tb=short", "--strict-markers")
        
        # Editor Enhancements
        "editor.rulers" = @(88, 120)
        "editor.tabSize" = 4
        "editor.insertSpaces" = $true
        "editor.detectIndentation" = $false
        "editor.wordWrap" = "off"
        "editor.showFoldingControls" = "always"
        "editor.bracketPairColorization.enabled" = $true
        "editor.guides.bracketPairs" = $true
        "editor.inlineSuggest.enabled" = $true
        
        # Error Display
        "errorLens.enabledDiagnosticLevels" = @("error", "warning", "info")
        "errorLens.followCursor" = "allLines"
        "errorLens.delay" = 200
        
        # File Exclusions for Performance
        "files.exclude" = @{
            "**/__pycache__" = $true
            "**/*.pyc" = $true
            "**/.mypy_cache" = $true
            "**/.ruff_cache" = $true
            "**/.pytest_cache" = $true
            "**/htmlcov" = $true
            "**/.coverage" = $true
            "**/.tox" = $true
            "**/venv" = $true
            "**/.venv" = $true
            "**/env" = $true
            "**/.env" = $true
            "**/node_modules" = $true
            "**/.git" = $true
        }
        
        # Search Exclusions
        "search.exclude" = @{
            "**/__pycache__" = $true
            "**/node_modules" = $true
            "**/venv" = $true
            "**/.venv" = $true
            "**/env" = $true
            "**/.env" = $true
            "**/htmlcov" = $true
            "**/.mypy_cache" = $true
            "**/.ruff_cache" = $true
            "**/.pytest_cache" = $true
            "**/.git" = $true
            "**/dist" = $true
            "**/build" = $true
        }
        
        # Performance Optimizations
        "files.watcherExclude" = @{
            "**/.git/objects/**" = $true
            "**/.git/subtree-cache/**" = $true
            "**/node_modules/**" = $true
            "**/.hg/store/**" = $true
            "**/__pycache__/**" = $true
            "**/.mypy_cache/**" = $true
            "**/.ruff_cache/**" = $true
            "**/.pytest_cache/**" = $true
            "**/venv/**" = $true
            "**/.venv/**" = $true
        }
        
        # Auto-save Configuration
        "files.autoSave" = "afterDelay"
        "files.autoSaveDelay" = 1000
        
        # Git Integration
        "git.enableSmartCommit" = $true
        "git.confirmSync" = $false
        "git.autofetch" = $true
        "git.autoStash" = $true
        
        # Theme
        "workbench.colorTheme" = "GitHub Dark Default"
        "workbench.iconTheme" = "material-icon-theme"
    }
    
    $settingsJson = $settings | ConvertTo-Json -Depth 10
    Set-Content -Path $settingsPath -Value $settingsJson -Encoding UTF8
    
    Write-Host "Ultra linting settings applied: $settingsPath"
}

function New-ProjectLintingConfig {
    if (!(Test-Path ".vscode")) {
        New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null
    }
    
    # Workspace-specific ultra linting
    $workspaceSettings = @{
        "ruff.args" = @(
            "--config=pyproject.toml",
            "--select=ALL",
            "--ignore=E501,W503,E203,D100,D101,D102,D103,D104,D105,D106,D107,ANN101,ANN102,ANN401,S101,FBT001,FBT002,T201,PLR0913,PLR2004,COM812,ISC001",
            "--line-length=120",
            "--target-version=py312"
        )
        "python.testing.pytestArgs" = @("tests", "-v", "--tb=short", "--strict-markers", "--strict-config")
    }
    
    $workspaceJson = $workspaceSettings | ConvertTo-Json -Depth 10
    Set-Content -Path ".vscode/settings.json" -Value $workspaceJson -Encoding UTF8
    
    # Ultra pyproject.toml template
    $pyprojectContent = @'
[tool.ruff]
target-version = "py312"
line-length = 120
indent-width = 4

[tool.ruff.lint]
select = [
    "E", "W", "F", "I", "N", "D", "UP", "YTT", "ANN", "S", "BLE",
    "FBT", "B", "A", "COM", "C4", "DTZ", "T10", "EM", "EXE", "FA",
    "ISC", "ICN", "G", "INP", "PIE", "T20", "PYI", "PT", "Q", "RSE",
    "RET", "SLF", "SLOT", "SIM", "TID", "TCH", "INT", "ARG", "PTH",
    "ERA", "PD", "PGH", "PL", "TRY", "FLY", "NPY", "PERF", "RUF"
]

ignore = [
    "E501", "W503", "E203", "E701", "E704", "W504",
    "D100", "D101", "D102", "D103", "D104", "D105", "D106", "D107",
    "D200", "D205", "D400", "D401", "D415",
    "ANN101", "ANN102", "ANN401",
    "S101", "S102", "S103", "S104", "S105", "S106", "S107",
    "FBT001", "FBT002", "FBT003",
    "T201", "T203",
    "PLR0911", "PLR0912", "PLR0913", "PLR0915", "PLR2004", "PLR5501",
    "C901", "COM812", "ISC001",
    "Q000", "Q001", "Q002", "Q003",
    "UP007", "TRY003", "SIM108",
    "PTH100", "PTH103", "PTH107", "PTH110", "PTH118", "PTH119", "PTH123",
    "ERA001", "PERF203", "PGH003", "PGH004",
    "RET504", "RET505", "RET506",
    "ARG001", "ARG002", "ARG005"
]

fixable = ["ALL"]
unfixable = []

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
skip-magic-trailing-comma = false
line-ending = "auto"

[tool.black]
line-length = 120
target-version = ["py312"]
skip-string-normalization = true

[tool.mypy]
python_version = "3.12"
strict = true
warn_unreachable = true
warn_redundant_casts = true
warn_unused_ignores = true
disallow_any_generics = true
check_untyped_defs = true
no_implicit_reexport = true
show_column_numbers = true
show_error_codes = true
'@
    
    Set-Content -Path "pyproject.toml.ultra-lint" -Value $pyprojectContent -Encoding UTF8
    
    Write-Host "Created .vscode/settings.json with ultra linting"
    Write-Host "Created pyproject.toml.ultra-lint template"
}

# Main execution
Write-Host "VSCode Ultra Linting Setup 2025"

# Check VSCode installation
try {
    $null = & code --version
    Write-Host "VSCode detected"
} catch {
    Write-Host "VSCode not found. Install from: https://code.visualstudio.com/"
    exit 1
}

Set-UltraLintingSettings
New-ProjectLintingConfig

Write-Host ""
Write-Host "Ultra linting configuration complete!"
Write-Host ""
Write-Host "Features Applied:"
Write-Host "  • 1000+ linting rules with intelligent ignores"
Write-Host "  • 120-character line length (productivity focused)"
Write-Host "  • Comprehensive error detection"
Write-Host "  • Auto-fix on save"
Write-Host "  • Strict type checking with MyPy"
Write-Host "  • Performance optimizations"
Write-Host ""
Write-Host "Next Steps:"
Write-Host "1. Restart VSCode"
Write-Host "2. Install tools: pip install ruff black mypy pytest"
Write-Host "3. Copy pyproject.toml.ultra-lint to pyproject.toml"
Write-Host "4. Open Python file - see ultra linting in action"
Write-Host ""
Write-Host "Ignored for Productivity:"
Write-Host "  • Line length violations (Black handles formatting)"
Write-Host "  • Docstring requirements (project-dependent)"
Write-Host "  • Minor complexity warnings"
Write-Host "  • Debug print statements"
Write-Host "  • Overly strict type annotation requirements"
Write-Host ""
Write-Host "Maximum code quality without perfectionism paralysis!"
