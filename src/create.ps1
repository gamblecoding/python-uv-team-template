# .vscode フォルダ、設定ファイル3つ、および .gitignore を一瞬で自動生成します。
# 1. 必要なフォルダの作成
if (!(Test-Path .vscode)) {
    New-Item -ItemType Directory -Force .vscode | Out-Null
}

# 2. settings.json の自動作成
$settingsJson = @'
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv",
  "python.terminal.activateEnvInTerminal": true,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  },
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "files.eol": "\n",
  "editor.guides.indentation": true,
  "scm.decorations.enabled": true,
  "terminal.integrated.profiles.windows": {
    "PowerShell (uv-enforced)": {
      "source": "PowerShell",
      "icon": "terminal-powershell",
      "args": ["-NoExit", "-File", "${workspaceFolder}/.vscode/enable-uv-warnings.ps1"]
    }
  },
  "terminal.integrated.defaultProfile.windows": "PowerShell (uv-enforced)"
}
'@
[System.IO.File]::WriteAllText("$pwd/.vscode/settings.json", $settingsJson)

# 3. extensions.json の自動作成
$extensionsJson = @'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "charliermarsh.ruff",
    "donjayamanne.githistory"
  ]
}
'@
[System.IO.File]::WriteAllText("$pwd/.vscode/extensions.json", $extensionsJson)

# 4. enable-uv-warnings.ps1 の自動作成
$warningScript = @'
function pip {
    if ($args[0] -eq "install" -and $args.Length -gt 1) {
        $packages = $args[1..($args.Length-1)]
        Write-Host "`n[💡 NOTICE] pip install ではなく 'uv add' を使いましょう！" -ForegroundColor Yellow
        Write-Host "自動的に 'uv add $packages' に変換して実行します...`n" -ForegroundColor Cyan
        uv add $packages
    } else {
        & (Get-Command pip.exe -All | Select-Object -First 1) @args
    }
}
function python {
    if ($args.Length -gt 0 -and $args[0] -notlike "-*") {
        Write-Host "`n[💡 NOTICE] python 直接実行ではなく 'uv run' を使いましょう！" -ForegroundColor Yellow
        Write-Host "自動的に 'uv run python $args' に変換して実行します...`n" -ForegroundColor Cyan
        uv run python @args
    } else {
        & (Get-Command python.exe -All | Select-Object -First 1) @args
    }
}
'@
[System.IO.File]::WriteAllText("$pwd/.vscode/enable-uv-warnings.ps1", $warningScript)

# 5. .gitignore の自動作成（既存のファイルがある場合は上書きせず追記）
$gitignoreContent = @'
__pycache__/
*.pyc
.venv/
venv/
env/
.history/
.DS_Store
Thumbs.db
'@

if (Test-Path .gitignore) {
    $existing = [System.IO.File]::ReadAllText("$pwd/.gitignore")
    if ($existing -notlike "*# --- Added by UV Migration ---*") {
        [System.IO.File]::AppendAllText("$pwd/.gitignore", "`n# --- Added by UV Migration ---`n$gitignoreContent")
        Write-Host ".gitignore に共通設定を追記しました。" -ForegroundColor Yellow
    } else {
        Write-Host ".gitignore は既に設定済みです。" -ForegroundColor Yellow
    }
} else {
    [System.IO.File]::WriteAllText("$pwd/.gitignore", $gitignoreContent)
    Write-Host ".gitignore を新規作成しました。" -ForegroundColor Green
}

Write-Host "`n🎉 共通ファイルの自動配置が完了しました！VS Codeを開き直してください。" -ForegroundColor Green
