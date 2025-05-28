@echo off
title VSCode Python Setup 2025 - Complete with Linting Rules
echo.
echo 🐍 VSCode Python Best Practices 2025 Setup (with Linting Rules)
echo.

REM Check if VSCode is installed
where code >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ VSCode not found. Install from https://code.visualstudio.com/
    pause
    exit /b 1
)

echo ✅ VSCode found
echo.

echo 🔧 Installing essential extensions...
call code --install-extension ms-python.python --force
call code --install-extension ms-python.black-formatter --force
call code --install-extension charliermarsh.ruff --force
call code --install-extension ms-python.mypy-type-checker --force
call code --install-extension ms-python.debugpy --force
call code --install-extension ms-python.pytest --force
call code --install-extension ryanluker.vscode-coverage-gutters --force
call code --install-extension eamodio.gitlens --force
call code --install-extension ms-vscode.vscode-error-lens --force
call code --install-extension github.github-vscode-theme --force
call code --install-extension pkief.material-icon-theme --force

echo.
echo ⚙️ Configuring VSCode settings with linting rules...

REM Create settings directory if it doesn't exist
if not exist "%APPDATA%\Code\User" mkdir "%APPDATA%\Code\User"

REM Backup existing settings
if exist "%APPDATA%\Code\User\settings.json" (
    copy "%APPDATA%\Code\User\settings.json" "%APPDATA%\Code\User\settings.json.backup" >nul
    echo 📋 Backed up existing settings
)

REM Create comprehensive settings file with linting rules
echo { > "%APPDATA%\Code\User\settings.json"
echo   "python.defaultInterpreterPath": "python", >> "%APPDATA%\Code\User\settings.json"
echo   "python.terminal.activateEnvironment": true, >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Ruff Linting Configuration (2025 Standard)", >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.enable": true, >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.fixAll": true, >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.organizeImports": true, >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.showNotifications": "always", >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.args": [ >> "%APPDATA%\Code\User\settings.json"
echo     "--select=E,W,F,I,N,D,UP,YTT,ANN,S,BLE,FBT,B,A,COM,C4,DTZ,T10,EM,EXE,FA,ISC,ICN,G,INP,PIE,T20,PYI,PT,Q,RSE,RET,SLF,SLOT,SIM,TID,TCH,INT,ARG,PTH,ERA,PD,PGH,PL,TRY,FLY,NPY,PERF,RUF", >> "%APPDATA%\Code\User\settings.json"
echo     "--ignore=D100,D101,D102,D103,D104,D105,D107,ANN101,ANN102,ANN401,S101,FBT001,FBT002,T201,PLR0913,PLR2004", >> "%APPDATA%\Code\User\settings.json"
echo     "--line-length=88" >> "%APPDATA%\Code\User\settings.json"
echo   ], >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Format on Save Configuration", >> "%APPDATA%\Code\User\settings.json"
echo   "editor.formatOnSave": true, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.formatOnPaste": false, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.codeActionsOnSave": { >> "%APPDATA%\Code\User\settings.json"
echo     "source.organizeImports": "explicit", >> "%APPDATA%\Code\User\settings.json"
echo     "source.fixAll.ruff": "explicit", >> "%APPDATA%\Code\User\settings.json"
echo     "source.fixAll": "explicit" >> "%APPDATA%\Code\User\settings.json"
echo   }, >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Testing Configuration", >> "%APPDATA%\Code\User\settings.json"
echo   "python.testing.pytestEnabled": true, >> "%APPDATA%\Code\User\settings.json"
echo   "python.testing.unittestEnabled": false, >> "%APPDATA%\Code\User\settings.json"
echo   "python.testing.autoTestDiscoverOnSaveEnabled": true, >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Type Checking Configuration", >> "%APPDATA%\Code\User\settings.json"
echo   "python.analysis.typeCheckingMode": "strict", >> "%APPDATA%\Code\User\settings.json"
echo   "python.analysis.autoImportCompletions": true, >> "%APPDATA%\Code\User\settings.json"
echo   "python.analysis.diagnosticMode": "workspace", >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Editor Configuration", >> "%APPDATA%\Code\User\settings.json"
echo   "editor.rulers": [88, 100], >> "%APPDATA%\Code\User\settings.json"
echo   "editor.tabSize": 4, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.insertSpaces": true, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.detectIndentation": false, >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Language Specific Settings", >> "%APPDATA%\Code\User\settings.json"
echo   "[python]": { >> "%APPDATA%\Code\User\settings.json"
echo     "editor.defaultFormatter": "ms-python.black-formatter", >> "%APPDATA%\Code\User\settings.json"
echo     "editor.formatOnSave": true, >> "%APPDATA%\Code\User\settings.json"
echo     "editor.tabSize": 4, >> "%APPDATA%\Code\User\settings.json"
echo     "editor.insertSpaces": true >> "%APPDATA%\Code\User\settings.json"
echo   }, >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// File Exclusions", >> "%APPDATA%\Code\User\settings.json"
echo   "files.exclude": { >> "%APPDATA%\Code\User\settings.json"
echo     "**/__pycache__": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/*.pyc": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.mypy_cache": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.ruff_cache": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.pytest_cache": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/htmlcov": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.coverage": true >> "%APPDATA%\Code\User\settings.json"
echo   }, >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Error Display Configuration", >> "%APPDATA%\Code\User\settings.json"
echo   "errorLens.enabledDiagnosticLevels": ["error", "warning", "info"], >> "%APPDATA%\Code\User\settings.json"
echo   "errorLens.followCursor": "allLines", >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Theme and UI", >> "%APPDATA%\Code\User\settings.json"
echo   "workbench.colorTheme": "GitHub Dark Default", >> "%APPDATA%\Code\User\settings.json"
echo   "workbench.iconTheme": "material-icon-theme", >> "%APPDATA%\Code\User\settings.json"
echo. >> "%APPDATA%\Code\User\settings.json"
echo   "// Auto-save", >> "%APPDATA%\Code\User\settings.json"
echo   "files.autoSave": "afterDelay", >> "%APPDATA%\Code\User\settings.json"
echo   "files.autoSaveDelay": 1000 >> "%APPDATA%\Code\User\settings.json"
echo } >> "%APPDATA%\Code\User\settings.json"

echo.
echo ⌨️ Setting up keybindings...

REM Create keybindings
echo [ > "%APPDATA%\Code\User\keybindings.json"
echo   { >> "%APPDATA%\Code\User\keybindings.json"
echo     "key": "ctrl+shift+t", >> "%APPDATA%\Code\User\keybindings.json"
echo     "command": "python.runTestFile", >> "%APPDATA%\Code\User\keybindings.json"
echo     "when": "editorTextFocus && resourceExtname == '.py'" >> "%APPDATA%\Code\User\keybindings.json"
echo   }, >> "%APPDATA%\Code\User\keybindings.json"
echo   { >> "%APPDATA%\Code\User\keybindings.json"
echo     "key": "ctrl+shift+r", >> "%APPDATA%\Code\User\keybindings.json"
echo     "command": "python.runTestMethod", >> "%APPDATA%\Code\User\keybindings.json"
echo     "when": "editorTextFocus && resourceExtname == '.py'" >> "%APPDATA%\Code\User\keybindings.json"
echo   }, >> "%APPDATA%\Code\User\keybindings.json"
echo   { >> "%APPDATA%\Code\User\keybindings.json"
echo     "key": "ctrl+shift+l", >> "%APPDATA%\Code\User\keybindings.json"
echo     "command": "ruff.executeFormat", >> "%APPDATA%\Code\User\keybindings.json"
echo     "when": "editorTextFocus && resourceExtname == '.py'" >> "%APPDATA%\Code\User\keybindings.json"
echo   }, >> "%APPDATA%\Code\User\keybindings.json"
echo   { >> "%APPDATA%\Code\User\keybindings.json"
echo     "key": "f5", >> "%APPDATA%\Code\User\keybindings.json"
echo     "command": "python.execInTerminal", >> "%APPDATA%\Code\User\keybindings.json"
echo     "when": "editorTextFocus && resourceExtname == '.py'" >> "%APPDATA%\Code\User\keybindings.json"
echo   }, >> "%APPDATA%\Code\User\keybindings.json"
echo   { >> "%APPDATA%\Code\User\keybindings.json"
echo     "key": "ctrl+f5", >> "%APPDATA%\Code\User\keybindings.json"
echo     "command": "python.debugCurrentFile", >> "%APPDATA%\Code\User\keybindings.json"
echo     "when": "editorTextFocus && resourceExtname == '.py'" >> "%APPDATA%\Code\User\keybindings.json"
echo   } >> "%APPDATA%\Code\User\keybindings.json"
echo ] >> "%APPDATA%\Code\User\keybindings.json"

echo.
echo 📁 Creating workspace template with comprehensive linting...
if not exist ".vscode" mkdir ".vscode"

echo { > ".vscode\settings.json"
echo   "python.terminal.activateEnvironment": true, >> ".vscode\settings.json"
echo   "python.testing.pytestArgs": ["tests", "-v", "--tb=short"], >> ".vscode\settings.json"
echo   "ruff.args": [ >> ".vscode\settings.json"
echo     "--config=pyproject.toml", >> ".vscode\settings.json"
echo     "--select=E,W,F,I,N,D,UP,YTT,ANN,S,BLE,FBT,B,A,COM,C4,DTZ,T10,EM,EXE,FA,ISC,ICN,G,INP,PIE,T20,PYI,PT,Q,RSE,RET,SLF,SLOT,SIM,TID,TCH,INT,ARG,PTH,ERA,PD,PGH,PL,TRY,FLY,NPY,PERF,RUF", >> ".vscode\settings.json"
echo     "--ignore=D100,D101,D102,D103,D104,D105,D107,ANN101,ANN102,ANN401,S101,FBT001,FBT002,T201,PLR0913,PLR2004" >> ".vscode\settings.json"
echo   ] >> ".vscode\settings.json"
echo } >> ".vscode\settings.json"

echo.
echo 📝 Creating pyproject.toml template with complete linting rules...
echo # Python Best Practices 2025 - Complete Configuration > "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo [tool.ruff] >> "pyproject.toml.template"
echo target-version = "py312" >> "pyproject.toml.template"
echo line-length = 88 >> "pyproject.toml.template"
echo indent-width = 4 >> "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo [tool.ruff.lint] >> "pyproject.toml.template"
echo # Enable comprehensive rule set for master-level Python >> "pyproject.toml.template"
echo select = [ >> "pyproject.toml.template"
echo     "E", "W",    # pycodestyle >> "pyproject.toml.template"
echo     "F",         # Pyflakes >> "pyproject.toml.template"
echo     "I",         # isort >> "pyproject.toml.template"
echo     "N",         # pep8-naming >> "pyproject.toml.template"
echo     "D",         # pydocstyle >> "pyproject.toml.template"
echo     "UP",        # pyupgrade >> "pyproject.toml.template"
echo     "YTT",       # flake8-2020 >> "pyproject.toml.template"
echo     "ANN",       # flake8-annotations >> "pyproject.toml.template"
echo     "S",         # flake8-bandit >> "pyproject.toml.template"
echo     "BLE",       # flake8-blind-except >> "pyproject.toml.template"
echo     "FBT",       # flake8-boolean-trap >> "pyproject.toml.template"
echo     "B",         # flake8-bugbear >> "pyproject.toml.template"
echo     "A",         # flake8-builtins >> "pyproject.toml.template"
echo     "COM",       # flake8-commas >> "pyproject.toml.template"
echo     "C4",        # flake8-comprehensions >> "pyproject.toml.template"
echo     "DTZ",       # flake8-datetimez >> "pyproject.toml.template"
echo     "T10",       # flake8-debugger >> "pyproject.toml.template"
echo     "EM",        # flake8-errmsg >> "pyproject.toml.template"
echo     "EXE",       # flake8-executable >> "pyproject.toml.template"
echo     "FA",        # flake8-future-annotations >> "pyproject.toml.template"
echo     "ISC",       # flake8-implicit-str-concat >> "pyproject.toml.template"
echo     "ICN",       # flake8-import-conventions >> "pyproject.toml.template"
echo     "G",         # flake8-logging-format >> "pyproject.toml.template"
echo     "INP",       # flake8-no-pep420 >> "pyproject.toml.template"
echo     "PIE",       # flake8-pie >> "pyproject.toml.template"
echo     "T20",       # flake8-print >> "pyproject.toml.template"
echo     "PYI",       # flake8-pyi >> "pyproject.toml.template"
echo     "PT",        # flake8-pytest-style >> "pyproject.toml.template"
echo     "Q",         # flake8-quotes >> "pyproject.toml.template"
echo     "RSE",       # flake8-raise >> "pyproject.toml.template"
echo     "RET",       # flake8-return >> "pyproject.toml.template"
echo     "SLF",       # flake8-self >> "pyproject.toml.template"
echo     "SLOT",      # flake8-slots >> "pyproject.toml.template"
echo     "SIM",       # flake8-simplify >> "pyproject.toml.template"
echo     "TID",       # flake8-tidy-imports >> "pyproject.toml.template"
echo     "TCH",       # flake8-type-checking >> "pyproject.toml.template"
echo     "INT",       # flake8-gettext >> "pyproject.toml.template"
echo     "ARG",       # flake8-unused-arguments >> "pyproject.toml.template"
echo     "PTH",       # flake8-use-pathlib >> "pyproject.toml.template"
echo     "ERA",       # eradicate >> "pyproject.toml.template"
echo     "PD",        # pandas-vet >> "pyproject.toml.template"
echo     "PGH",       # pygrep-hooks >> "pyproject.toml.template"
echo     "PL",        # Pylint >> "pyproject.toml.template"
echo     "TRY",       # tryceratops >> "pyproject.toml.template"
echo     "FLY",       # flynt >> "pyproject.toml.template"
echo     "NPY",       # NumPy-specific rules >> "pyproject.toml.template"
echo     "PERF",      # Perflint >> "pyproject.toml.template"
echo     "RUF",       # Ruff-specific rules >> "pyproject.toml.template"
echo ] >> "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo ignore = [ >> "pyproject.toml.template"
echo     "D100", "D101", "D102", "D103", "D104", "D105", "D107",  # Docstring rules >> "pyproject.toml.template"
echo     "ANN101", "ANN102", "ANN401",  # Type annotation exceptions >> "pyproject.toml.template"
echo     "S101",    # Allow assert statements >> "pyproject.toml.template"
echo     "FBT001", "FBT002",  # Boolean positional arguments >> "pyproject.toml.template"
echo     "T201",   # Allow print statements >> "pyproject.toml.template"
echo     "PLR0913", "PLR2004",  # Too many arguments, magic values >> "pyproject.toml.template"
echo ] >> "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo fixable = ["ALL"] >> "pyproject.toml.template"
echo unfixable = [] >> "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo [tool.ruff.lint.per-file-ignores] >> "pyproject.toml.template"
echo "tests/**/*" = ["S101", "PLR2004", "ANN001", "ANN201", "D100", "D103"] >> "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo [tool.ruff.format] >> "pyproject.toml.template"
echo quote-style = "double" >> "pyproject.toml.template"
echo indent-style = "space" >> "pyproject.toml.template"
echo. >> "pyproject.toml.template"
echo [tool.black] >> "pyproject.toml.template"
echo line-length = 88 >> "pyproject.toml.template"
echo target-version = ['py312'] >> "pyproject.toml.template"

echo.
echo ✅ VSCode Python setup complete with comprehensive linting rules!
echo.
echo 📋 Next Steps:
echo 1. Restart VSCode
echo 2. Install Python tools: pip install ruff black mypy pytest
echo 3. Copy pyproject.toml.template to your project as pyproject.toml
echo 4. Open a Python project and see linting in action
echo.
echo 🎯 Features enabled:
echo • Ruff linting with 800+ rules (ultra-fast)
echo • Black formatting on save
echo • MyPy strict type checking
echo • Pytest integration
echo • Error highlighting with Error Lens
echo • Custom keybindings
echo • Comprehensive rule set for Python mastery
echo.
echo ⌨️ Custom Keys:
echo • Ctrl+Shift+T: Run test file
echo • Ctrl+Shift+R: Run test method
echo • Ctrl+Shift+L: Format with Ruff
echo • F5: Run Python file
echo • Ctrl+F5: Debug file
echo.
pause
