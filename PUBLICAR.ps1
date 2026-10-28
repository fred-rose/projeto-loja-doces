$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

function Check-Exit([string]$Action) {
    if ($LASTEXITCODE -ne 0) { throw "Falha: $Action. Publicacao pendente." }
}

try {
    gh auth status
    Check-Exit 'autenticacao gh (execute gh auth login -h github.com --web)'
    $account = gh api user --jq .login
    Check-Exit 'identificar conta'
    if ($account -ne 'fred-rose') { throw 'Autentique como fred-rose para publicar este projeto. Nenhum repositorio foi alterado.' }
    $accountId = gh api user --jq .id
    Check-Exit 'identificar ID para email privado do commit'
    $repo = "$account/projeto-loja-doces"
    $branch = git branch --show-current
    Check-Exit 'consultar branch local'
    if ($branch -ne 'main') { throw 'A branch atual deve ser main. Nenhuma branch foi alterada.' }
    $manifest = @('.gitignore', '.nojekyll', 'index.html', 'README.md', 'INICIAR.cmd', 'DECISOES_E_VALIDACOES.md', 'PUBLICAR.ps1', 'RELATORIO_ENTREGA.md', 'tests/mvp.cjs', 'tests/ux.cjs')
    if (Test-Path -LiteralPath 'verificar.cjs') { $manifest += 'verificar.cjs' }
    $staged = @(git diff --cached --name-only)
    Check-Exit 'verificar arquivos ja preparados'
    if (@($staged | Where-Object { $_ -notin $manifest }).Count -gt 0) {
        throw 'Ha arquivos fora da lista de publicacao no staging. Revise-os antes de continuar.'
    }
    git add -- $manifest
    Check-Exit 'preparar somente arquivos necessarios'
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        git -c user.name=DoceFluxo -c "user.email=$accountId+$account@users.noreply.github.com" commit -m 'Simplifica apontamento com cartões e ações rápidas no DoceFluxo UX 2.0'
        Check-Exit 'criar commit local'
    } elseif ($LASTEXITCODE -ne 0) { throw 'Falha ao verificar alteracoes para commit.' }
    $remotes = @(git remote)
    Check-Exit 'consultar remotos'
    $hasOrigin = $remotes -contains 'origin'
    if ($hasOrigin) {
        $origin = git remote get-url origin
        Check-Exit 'consultar origin'
        if ($origin -notin @("https://github.com/$repo.git", "https://github.com/$repo", "git@github.com:$repo.git")) {
            throw "Origin inesperado: $origin. Nenhum remoto foi substituido."
        }
        gh repo view $repo --json nameWithOwner --jq .nameWithOwner
        Check-Exit 'verificar repositorio vinculado'
    } else {
        # Usar uma listagem bem-sucedida evita confundir falha de rede com inexistencia.
        $repositories = gh api --paginate 'user/repos?per_page=100&affiliation=owner' --jq '.[].full_name'
        Check-Exit 'verificar repositorios existentes'
        if ($repositories -contains $repo) {
            throw "$repo ja existe e nao esta vinculado. Revise-o antes de configurar origin manualmente."
        }
        gh repo create $repo --public --source . --remote origin --description 'DoceFluxo: MVP demonstrativo de acompanhamento da producao de doces'
        Check-Exit 'criar repositorio publico'
    }
    git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push -u origin main
    Check-Exit 'enviar main sem force push'
    $commit = git rev-parse HEAD
    Check-Exit 'identificar commit publicado'
    # JSON por stdin preserva os tipos esperados pela API Pages.
    $payload = @{ build_type = 'legacy'; source = @{ branch = 'main'; path = '/' } } | ConvertTo-Json -Depth 3 -Compress
    $ErrorActionPreference = 'Continue'
    $pagesRaw = gh api "repos/$repo/pages" 2>&1
    $pagesExit = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    if ($pagesExit -eq 0) {
        $pages = ($pagesRaw -join "`n") | ConvertFrom-Json
        if ($pages.build_type -ne 'legacy' -or $pages.source.branch -ne 'main' -or $pages.source.path -ne '/') {
            throw 'Pages ja possui outra configuracao. Revise Settings > Pages; nenhuma configuracao foi substituida.'
        }
    } elseif (($pagesRaw -join ' ') -match '404') {
        $pagesRaw = $payload | gh api --method POST "repos/$repo/pages" --input -
        Check-Exit 'ativar Pages (Settings > Pages > Deploy from a branch > main > /(root))'
        $pages = ($pagesRaw -join "`n") | ConvertFrom-Json
    } else { throw "Nao foi possivel consultar Pages: $pagesRaw" }
    $url = $pages.html_url
    if (-not $url) { throw 'A API nao retornou uma URL Pages real. Validacao pendente.' }
    Write-Host "Repositorio: https://github.com/$repo"
    Write-Host "URL fornecida pelo GitHub (aguardando validacao): $url"
    for ($attempt = 1; $attempt -le 30; $attempt++) {
        $ErrorActionPreference = 'Continue'
        $buildRaw = gh api "repos/$repo/pages/builds/latest" 2>$null
        $buildExit = $LASTEXITCODE
        $ErrorActionPreference = 'Stop'
        if ($buildExit -eq 0) {
            $build = ($buildRaw -join "`n") | ConvertFrom-Json
            if ($build.status -eq 'built' -and $build.commit -eq $commit) {
                try {
                    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 20
                    if ($response.StatusCode -eq 200 -and $response.Content -match 'DoceFluxo' -and $response.Content -match 'product-grid' -and $response.Content -match 'data-action="plus10"' -and $response.Content -match 'data-action="complete"') {
                        Write-Host "PUBLICADO E VALIDADO: $url (commit $commit)"
                        exit 0
                    }
                } catch { Write-Host 'Aguardando propagacao HTTP...' }
            }
            if ($build.status -eq 'errored') { throw 'O build Pages falhou. Consulte Actions no repositorio.' }
        }
        Write-Host "Publicacao ainda pendente: tentativa $attempt de 30."
        Start-Sleep -Seconds 10
    }
    throw 'Tempo de espera encerrado. Publicacao ainda nao validada; consulte Actions e Settings > Pages.'
} catch {
    Write-Error $_
    exit 1
}
