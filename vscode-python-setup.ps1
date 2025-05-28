# VSCode Python Best Practices 2025 - Auto Setup Script
# Configures VSCode for optimal Python development with modern toolchain

param(
    [switch]$InstallExtensions,
    [switch]$ConfigureSettings,
    [switch]$SetupKeybindings,
    [switch]$All
)

$ErrorActionPreference = "Stop"

# Colors
$Green = "`e[32m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Cyan = "`e[36m"
$Reset = "`e[0m"

function Write-Status {
    param([string]$Message, [string]$Color = $Reset)
    Write-Host "${Color}${Message}${Reset}"
}

function Get-VSCodeSettingsPath {
    $os = [System.Environment]::OSVersion.Platform
    switch ($os) {
        "Win32NT" { 
            return "$env:APPDATA\Code\User\settings.json"
        }
        "Unix" {
            if ($IsMacOS) {
                return "$HOME/Library/Application Support/Code/User/settings.json"
            } else {
                return "$HOME/.config/Code/User/settings.json"
            }
        }
        default {
            return "$env:APPDATA\Code\User\settings.json"
        }
    }
}

function Get-VSCodeKeybindingsPath {
    $settingsPath = Get-VSCodeSettingsPath
    $userDir = Split-Path $settingsPath -Parent
    return Join-Path $userDir "keybindings.json"
}

function Install-VSCodeExtensions {
    Write-Status "🔧 Installing essential Python extensions..." $Blue
    
    $extensions = @(
        # Python Development
        "ms-python.python",                    # Official Python extension
        "ms-python.pylint",                    # Pylint support
        "ms-python.black-formatter",          # Black formatter
        "charliermarsh.ruff",                  # Ruff linter (2025 standard)
        "ms-python.mypy-type-checker",        # MyPy type checking
        "ms-python.debugpy",                   # Python debugger
        
        # Testing
        "ms-python.pytest",                   # Pytest integration
        "ryanluker.vscode-coverage-gutters",  # Coverage visualization
        
        # Git & Version Control
        "eamodio.gitlens",                    # Enhanced Git capabilities
        "github.vscode-pull-request-github",  # GitHub integration
        
        # Code Quality
        "ms-vscode.vscode-error-lens",        # Error highlighting
        "streetsidesoftware.code-spell-checker", # Spell checking
        "bradlc.vscode-tailwindcss",          # Tailwind CSS (for web projects)
        
        # Productivity
        "ms-vscode.vscode-json",              # JSON support
        "redhat.vscode-yaml",                 # YAML support
        "ms-vscode.vscode-markdown",          # Markdown support
        "yzhang.markdown-all-in-one",        # Enhanced Markdown
        
        # Docker & Containers
        "ms-vscode-remote.remote-containers", # Dev containers
        "ms-azuretools.vscode-docker",       # Docker support
        
        # Database
        "ms-mssql.mssql",                    # SQL Server
        "mtxr.sqltools",                     # Multi-database support
        
        # API Development
        "humao.rest-client",                 # REST API testing
        "42crunch.vscode-openapi",          # OpenAPI support
        
        # Themes & UI
        "github.github-vscode-theme",        # GitHub theme
        "pkief.material-icon-theme",        # Material icons
        "aaron-bond.better-comments"        # Enhanced comments
    )
    
    foreach ($ext in $extensions) {
        try {
            Write-Status "Installing $ext..." $Yellow
            & code --install-extension $ext --force
        }
        catch {
            Write-Status "Failed to install $ext" $Yellow
        }
    }
    
    Write-Status "✅ Extensions installation complete" $Green
}

function Set-VSCodeSettings {
    Write-Status "⚙️ Configuring VSCode settings..." $Blue
    
    $settingsPath = Get-VSCodeSettingsPath
    $settingsDir = Split-Path $settingsPath -Parent
    
    if (!(Test-Path $settingsDir)) {
        New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
    }
    
    $settings = @{
        # Python Configuration
        "python.defaultInterpreterPath" = "python"
        "python.terminal.activateEnvironment" = $true
        "python.terminal.activateEnvInCurrentTerminal" = $true
        
        # Linting Configuration (Ruff-first approach)
        "python.linting.enabled" = $true
        "python.linting.ruffEnabled" = $true
        "python.linting.pylintEnabled" = $false
        "python.linting.flake8Enabled" = $false
        "python.linting.mypyEnabled" = $true
        "python.linting.banditEnabled" = $true
        
        # Ruff Configuration
        "ruff.enable" = $true
        "ruff.args" = @("--config", "pyproject.toml")
        "ruff.fixAll" = $true
        "ruff.organizeImports" = $true
        
        # Formatting Configuration
        "python.formatting.provider" = "black"
        "python.formatting.blackArgs" = @("--line-length=88")
        "editor.formatOnSave" = $true
        "editor.formatOnPaste" = $false
        "editor.formatOnType" = $false
        
        # Code Actions
        "editor.codeActionsOnSave" = @{
            "source.organizeImports" = $true
            "source.fixAll.ruff" = $true
            "source.fixAll" = $true
        }
        
        # Testing Configuration
        "python.testing.pytestEnabled" = $true
        "python.testing.unittestEnabled" = $false
        "python.testing.pytestArgs" = @("tests")
        "python.testing.autoTestDiscoverOnSaveEnabled" = $true
        
        # Type Checking
        "python.analysis.typeCheckingMode" = "strict"
        "python.analysis.autoImportCompletions" = $true
        "python.analysis.autoSearchPaths" = $true
        "python.analysis.diagnosticMode" = "workspace"
        "python.analysis.stubPath" = "typings"
        
        # Editor Configuration
        "editor.rulers" = @(88, 100)
        "editor.tabSize" = 4
        "editor.insertSpaces" = $true
        "editor.detectIndentation" = $false
        "editor.wordWrap" = "off"
        "editor.showFoldingControls" = "always"
        "editor.foldingStrategy" = "indentation"
        
        # File Associations
        "files.associations" = @{
            "*.py" = "python"
            "*.pyi" = "python"
            "*.pyx" = "python"
            "pyproject.toml" = "toml"
            ".env*" = "dotenv"
            "Dockerfile*" = "dockerfile"
        }
        
        # File Exclusions
        "files.exclude" = @{
            "**/__pycache__" = $true
            "**/*.pyc" = $true
            "**/.mypy_cache" = $true
            "**/.ruff_cache" = $true
            "**/.pytest_cache" = $true
            "**/htmlcov" = $true
            "**/.coverage" = $true
            "**/node_modules" = $true
            "**/.git" = $true
            "**/.DS_Store" = $true
            "**/Thumbs.db" = $true
        }
        
        # Search Configuration
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
        }
        
        # Terminal Configuration
        "terminal.integrated.defaultProfile.windows" = "PowerShell"
        "terminal.integrated.defaultProfile.linux" = "bash"
        "terminal.integrated.defaultProfile.osx" = "zsh"
        "terminal.integrated.cwd" = "`${workspaceFolder}"
        
        # Git Configuration
        "git.enableSmartCommit" = $true
        "git.confirmSync" = $false
        "git.autofetch" = $true
        "git.autoStash" = $true
        
        # Workbench Configuration
        "workbench.colorTheme" = "GitHub Dark Default"
        "workbench.iconTheme" = "material-icon-theme"
        "workbench.tree.indent" = 20
        "workbench.tree.renderIndentGuides" = "always"
        
        # IntelliSense Configuration
        "editor.quickSuggestions" = @{
            "other" = $true
            "comments" = $false
            "strings" = $true
        }
        "editor.suggestSelection" = "first"
        "editor.acceptSuggestionOnCommitCharacter" = $false
        "editor.acceptSuggestionOnEnter" = "on"
        
        # Security
        "security.workspace.trust.untrustedFiles" = "open"
        
        # Performance
        "files.watcherExclude" = @{
            "**/.git/objects/**" = $true
            "**/.git/subtree-cache/**" = $true
            "**/node_modules/**" = $true
            "**/.hg/store/**" = $true
            "**/__pycache__/**" = $true
            "**/.mypy_cache/**" = $true
            "**/.ruff_cache/**" = $true
        }
        
        # Language Specific Settings
        "[python]" = @{
            "editor.defaultFormatter" = "ms-python.black-formatter"
            "editor.tabSize" = 4
            "editor.insertSpaces" = $true
            "editor.formatOnSave" = $true
        }
        
        "[json]" = @{
            "editor.defaultFormatter" = "vscode.json-language-features"
            "editor.tabSize" = 2
        }
        
        "[yaml]" = @{
            "editor.defaultFormatter" = "redhat.vscode-yaml"
            "editor.tabSize" = 2
        }
        
        "[markdown]" = @{
            "editor.defaultFormatter" = "yzhang.markdown-all-in-one"
            "editor.wordWrap" = "on"
        }
        
        # Error Lens Configuration
        "errorLens.enabledDiagnosticLevels" = @("error", "warning", "info")
        "errorLens.followCursor" = "allLines"
        
        # Coverage Gutters
        "coverage-gutters.showGutterCoverage" = $true
        "coverage-gutters.showLineCoverage" = $true
        "coverage-gutters.showRulerCoverage" = $true
        
        # Auto-save
        "files.autoSave" = "afterDelay"
        "files.autoSaveDelay" = 1000
    }
    
    $settingsJson = $settings | ConvertTo-Json -Depth 10
    Set-Content -Path $settingsPath -Value $settingsJson -Encoding UTF8
    
    Write-Status "✅ Settings configured at: $settingsPath" $Green
}

function Set-VSCodeKeybindings {
    Write-Status "⌨️ Setting up custom keybindings..." $Blue
    
    $keybindingsPath = Get-VSCodeKeybindingsPath
    
    $keybindings = @(
        @{
            "key" = "ctrl+shift+t"
            "command" = "python.runTestFile"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "ctrl+shift+r"
            "command" = "python.runTestMethod"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "ctrl+shift+d"
            "command" = "python.debugTestMethod"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "ctrl+shift+l"
            "command" = "ruff.executeFormat"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "ctrl+shift+i"
            "command" = "ruff.executeOrganizeImports"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "f5"
            "command" = "python.execInTerminal"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "ctrl+f5"
            "command" = "python.debugCurrentFile"
            "when" = "editorTextFocus && resourceExtname == '.py'"
        },
        @{
            "key" = "ctrl+shift+`"
            "command" = "python.createTerminal"
        },
        @{
            "key" = "ctrl+shift+p"
            "command" = "workbench.action.showCommands"
        }
    )
    
    $keybindingsJson = $keybindings | ConvertTo-Json -Depth 5
    Set-Content -Path $keybindingsPath -Value $keybindingsJson -Encoding UTF8
    
    Write-Status "✅ Keybindings configured at: $keybindingsPath" $Green
}

function New-WorkspaceSettings {
    Write-Status "📁 Creating .vscode workspace settings..." $Blue
    
    $workspaceDir = ".vscode"
    if (!(Test-Path $workspaceDir)) {
        New-Item -ItemType Directory -Path $workspaceDir -Force | Out-Null
    }
    
    # Workspace settings
    $workspaceSettings = @{
        "python.pythonPath" = ".venv/Scripts/python.exe"
        "python.terminal.activateEnvironment" = $true
        
        # Project-specific linting
        "ruff.args" = @("--config", "pyproject.toml")
        "python.linting.ruffArgs" = @("--config", "pyproject.toml")
        "python.linting.mypyArgs" = @("--config-file", "pyproject.toml")
        
        # Testing
        "python.testing.pytestArgs" = @("tests", "-v", "--tb=short")
        "python.testing.cwd" = "`${workspaceFolder}"
        
        # Tasks
        "tasks.version" = "2.0.0"
    }
    
    $workspaceSettingsJson = $workspaceSettings | ConvertTo-Json -Depth 10
    Set-Content -Path "$workspaceDir/settings.json" -Value $workspaceSettingsJson -Encoding UTF8
    
    # Tasks configuration
    $tasks = @{
        "version" = "2.0.0"
        "tasks" = @(
            @{
                "label" = "Python: Run Tests"
                "type" = "shell"
                "command" = "pytest"
                "args" = @("tests/", "-v", "--cov=src")
                "group" = "test"
                "presentation" = @{
                    "echo" = $true
                    "reveal" = "always"
                    "focus" = $false
                    "panel" = "shared"
                }
                "problemMatcher" = "`$pep8"
            },
            @{
                "label" = "Python: Lint with Ruff"
                "type" = "shell"
                "command" = "ruff"
                "args" = @("check", ".")
                "group" = "build"
                "presentation" = @{
                    "echo" = $true
                    "reveal" = "always"
                    "focus" = $false
                    "panel" = "shared"
                }
            },
            @{
                "label" = "Python: Format with Black"
                "type" = "shell"
                "command" = "black"
                "args" = @(".")
                "group" = "build"
                "presentation" = @{
                    "echo" = $true
                    "reveal" = "silent"
                    "focus" = $false
                    "panel" = "shared"
                }
            },
            @{
                "label" = "Python: Type Check"
                "type" = "shell"
                "command" = "mypy"
                "args" = @("src/")
                "group" = "build"
                "presentation" = @{
                    "echo" = $true
                    "reveal" = "always"
                    "focus" = $false
                    "panel" = "shared"
                }
            },
            @{
                "label" = "Python: Install Dev Dependencies"
                "type" = "shell"
                "command" = "pip"
                "args" = @("install", "-e", ".[dev]")
                "group" = "build"
            },
            @{
                "label" = "Python: Security Check"
                "type" = "shell"
                "command" = "bandit"
                "args" = @("-r", "src/")
                "group" = "test"
            }
        )
    }
    
    $tasksJson = $tasks | ConvertTo-Json -Depth 10
    Set-Content -Path "$workspaceDir/tasks.json" -Value $tasksJson -Encoding UTF8
    
    # Launch configuration for debugging
    $launch = @{
        "version" = "0.2.0"
        "configurations" = @(
            @{
                "name" = "Python: Current File"
                "type" = "python"
                "request" = "launch"
                "program" = "`${file}"
                "console" = "integratedTerminal"
                "justMyCode" = $true
            },
            @{
                "name" = "Python: Module"
                "type" = "python"
                "request" = "launch"
                "module" = "src.main"
                "console" = "integratedTerminal"
                "justMyCode" = $true
            },
            @{
                "name" = "Python: Pytest"
                "type" = "python"
                "request" = "launch"
                "module" = "pytest"
                "args" = @("tests/", "-v")
                "console" = "integratedTerminal"
                "justMyCode" = $false
            },
            @{
                "name" = "Python: FastAPI"
                "type" = "python"
                "request" = "launch"
                "module" = "uvicorn"
                "args" = @("src.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000")
                "console" = "integratedTerminal"
                "justMyCode" = $true
            }
        )
    }
    
    $launchJson = $launch | ConvertTo-Json -Depth 10
    Set-Content -Path "$workspaceDir/launch.json" -Value $launchJson -Encoding UTF8
    
    Write-Status "✅ Workspace settings created in .vscode/" $Green
}

function Show-Usage {
    Write-Status @"
🐍 VSCode Python Best Practices 2025 Setup

Usage: .\vscode-python-setup.ps1 [options]

Options:
  -InstallExtensions     Install essential Python extensions
  -ConfigureSettings     Configure VSCode settings for Python
  -SetupKeybindings     Setup custom Python keybindings
  -All                  Perform all setup tasks

Examples:
  .\vscode-python-setup.ps1 -All
  .\vscode-python-setup.ps1 -InstallExtensions -ConfigureSettings

🎯 This script configures VSCode for optimal Python development with:
  ✅ Ruff linting (2025 standard - 1000x faster than pylint)
  ✅ Black formatting
  ✅ MyPy type checking
  ✅ Pytest integration
  ✅ Modern Python extensions
  ✅ Optimized settings for performance
  ✅ Custom keybindings for productivity
"@ $Cyan
}

# Main execution
if ($All) {
    $InstallExtensions = $true
    $ConfigureSettings = $true
    $SetupKeybindings = $true
}

if (-not ($InstallExtensions -or $ConfigureSettings -or $SetupKeybindings)) {
    Show-Usage
    exit 0
}

Write-Status "🚀 VSCode Python Best Practices 2025 Setup" $Cyan

# Check if VSCode is installed
try {
    $null = & code --version
} catch {
    Write-Status "❌ VSCode not found. Please install VSCode first." $Yellow
    Write-Status "Download from: https://code.visualstudio.com/" $Yellow
    exit 1
}

if ($InstallExtensions) {
    Install-VSCodeExtensions
}

if ($ConfigureSettings) {
    Set-VSCodeSettings
}

if ($SetupKeybindings) {
    Set-VSCodeKeybindings
}

# Always create workspace settings template
New-WorkspaceSettings

Write-Status @"

✅ VSCode Python setup complete!

📋 Next Steps:
1. Restart VSCode to apply all settings
2. Open a Python project
3. Install project dependencies: pip install -e ".[dev]"
4. Test the setup with Ctrl+Shift+P → "Python: Select Interpreter"

🎯 Key Features Enabled:
  • Ruff linting (ultra-fast)
  • Black formatting on save
  • MyPy type checking
  • Pytest integration
  • Error highlighting
  • Auto imports organization
  • Code coverage visualization

⌨️ Custom Keybindings:
  • Ctrl+Shift+T: Run test file
  • Ctrl+Shift+R: Run test method
  • Ctrl+Shift+L: Format with Ruff
  • F5: Run current Python file
  • Ctrl+F5: Debug current file

🔧 Use Command Palette (Ctrl+Shift+P) for Python commands
"@ $Green
