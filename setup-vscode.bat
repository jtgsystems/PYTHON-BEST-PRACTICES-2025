@echo off
title VSCode Python Setup 2025
echo.
echo 🐍 VSCode Python Best Practices 2025 Setup
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
echo ⚙️ Configuring settings...

REM Create settings directory if it doesn't exist
if not exist "%APPDATA%\Code\User" mkdir "%APPDATA%\Code\User"

REM Backup existing settings
if exist "%APPDATA%\Code\User\settings.json" (
    copy "%APPDATA%\Code\User\settings.json" "%APPDATA%\Code\User\settings.json.backup" >nul
    echo 📋 Backed up existing settings
)

REM Create new settings file
echo { > "%APPDATA%\Code\User\settings.json"
echo   "python.defaultInterpreterPath": "python", >> "%APPDATA%\Code\User\settings.json"
echo   "python.terminal.activateEnvironment": true, >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.enable": true, >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.fixAll": true, >> "%APPDATA%\Code\User\settings.json"
echo   "ruff.organizeImports": true, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.formatOnSave": true, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.codeActionsOnSave": { >> "%APPDATA%\Code\User\settings.json"
echo     "source.organizeImports": "explicit", >> "%APPDATA%\Code\User\settings.json"
echo     "source.fixAll.ruff": "explicit" >> "%APPDATA%\Code\User\settings.json"
echo   }, >> "%APPDATA%\Code\User\settings.json"
echo   "python.testing.pytestEnabled": true, >> "%APPDATA%\Code\User\settings.json"
echo   "python.testing.unittestEnabled": false, >> "%APPDATA%\Code\User\settings.json"
echo   "python.analysis.typeCheckingMode": "strict", >> "%APPDATA%\Code\User\settings.json"
echo   "editor.rulers": [88, 100], >> "%APPDATA%\Code\User\settings.json"
echo   "editor.tabSize": 4, >> "%APPDATA%\Code\User\settings.json"
echo   "editor.insertSpaces": true, >> "%APPDATA%\Code\User\settings.json"
echo   "[python]": { >> "%APPDATA%\Code\User\settings.json"
echo     "editor.defaultFormatter": "ms-python.black-formatter", >> "%APPDATA%\Code\User\settings.json"
echo     "editor.formatOnSave": true >> "%APPDATA%\Code\User\settings.json"
echo   }, >> "%APPDATA%\Code\User\settings.json"
echo   "files.exclude": { >> "%APPDATA%\Code\User\settings.json"
echo     "**/__pycache__": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/*.pyc": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.mypy_cache": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.ruff_cache": true, >> "%APPDATA%\Code\User\settings.json"
echo     "**/.pytest_cache": true >> "%APPDATA%\Code\User\settings.json"
echo   }, >> "%APPDATA%\Code\User\settings.json"
echo   "workbench.colorTheme": "GitHub Dark Default", >> "%APPDATA%\Code\User\settings.json"
echo   "workbench.iconTheme": "material-icon-theme", >> "%APPDATA%\Code\User\settings.json"
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
echo     "key": "f5", >> "%APPDATA%\Code\User\keybindings.json"
echo     "command": "python.execInTerminal", >> "%APPDATA%\Code\User\keybindings.json"
echo     "when": "editorTextFocus && resourceExtname == '.py'" >> "%APPDATA%\Code\User\keybindings.json"
echo   } >> "%APPDATA%\Code\User\keybindings.json"
echo ] >> "%APPDATA%\Code\User\keybindings.json"

echo.
echo 📁 Creating workspace template...
if not exist ".vscode" mkdir ".vscode"

echo { > ".vscode\settings.json"
echo   "python.terminal.activateEnvironment": true, >> ".vscode\settings.json"
echo   "python.testing.pytestArgs": ["tests", "-v"], >> ".vscode\settings.json"
echo   "ruff.args": ["--config", "pyproject.toml"] >> ".vscode\settings.json"
echo } >> ".vscode\settings.json"

echo.
echo ✅ VSCode Python setup complete!
echo.
echo 📋 Next Steps:
echo 1. Restart VSCode
echo 2. Install Python tools: pip install "ruff>=0.14.3" "black>=25.9.0" "mypy>=1.18.2" pytest
echo 3. Open a Python project
echo 4. Use Ctrl+Shift+P to access Python commands
echo.
echo 🎯 Features enabled:
echo • Ruff linting (ultra-fast)
echo • Black formatting on save
echo • MyPy type checking  
echo • Pytest integration
echo • Custom keybindings
echo.
pause
