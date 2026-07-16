# VS Code helper: translate common direct Python package commands to uv.
function pip {
    if ($args.Count -gt 1 -and $args[0] -eq 'install') {
        $packages = $args[1..($args.Count - 1)]
        Write-Host "`n[NOTICE] Using 'uv add' instead of 'pip install'." -ForegroundColor Yellow
        & uv add @packages
        return
    }

    & uv pip @args
}

function python {
    if ($args.Count -gt 0 -and $args[0] -notlike '-*') {
        Write-Host "`n[NOTICE] Using 'uv run python' for project execution." -ForegroundColor Yellow
        & uv run python @args
        return
    }

    $pythonCommand = Get-Command python.exe -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if (-not $pythonCommand) {
        Write-Error "python.exe was not found. Run 'uv sync' first."
        return
    }
    & $pythonCommand.Source @args
}

