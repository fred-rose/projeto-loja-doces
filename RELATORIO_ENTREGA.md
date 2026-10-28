# Entrega DoceFluxo UX 2.0 — 28/10/2026

## Atualização UX 2.0

- `index.html`: cartões responsivos com meta, total embalado, saldo e progresso; +10, +25 e Concluir meta; salvamento imediato sem recriar o campo ativo; motivos condicionais e detalhes recolhidos.
- `tests/ux.cjs`: 56 verificações de atalhos, limite de produção, digitação contínua, persistência sem blur, dados v2 antigos, filtros e alvos de toque em oito larguras de 320 a 1440 px.
- `tests/mvp.cjs`: atualizado para áreas recolhidas; 44 verificações de regressão passaram.
- `verificar.cjs`: atualizado para cartões e áreas recolhidas; roteiro HTTP complementar passou, incluindo CSV, cálculos, exclusão, simulação e falha de armazenamento.
- `README.md`, `DECISOES_E_VALIDACOES.md` e `PUBLICAR.ps1`: orientação e publicação atualizadas. Originais preservados, nenhuma dependência de execução adicionada.

Contrato v2 e chave `docefluxo-central-demo-v2` preservados. Embalagem não preenche produção. Quantidade desconhecida continua nula; zero continua válido. Totais permanecem centrais, sem duplicação pelas lojas. Capturas locais em `artifacts/ux2-390.png` e `artifacts/ux2-1440.png`.

Repositório existente confirmado: `https://github.com/fred-rose/projeto-loja-doces`, origin/main, base `79b16da`. A escrita local em `.git` e a rede da CLI estão bloqueadas. A tentativa de criar a árvore do commit pelo conector falhou com GitHub 403, `Resource not accessible by integration`. Nenhum commit UX 2.0 foi criado ou enviado. A URL `https://fred-rose.github.io/projeto-loja-doces/` também não pôde ser acessada pela ferramenta web; **deploy da UX 2.0 e validação pública pendentes**. O código remoto não foi alterado.

Se a atualização ou validação remota não for possível, executar em PowerShell local com rede e escrita, na pasta oficial:

```powershell
gh auth status
# Somente se necessário:
gh auth login -h github.com --web
powershell -NoProfile -ExecutionPolicy Bypass -File .\PUBLICAR.ps1
```

O script inclui todos os arquivos da UX 2.0, cria commit, envia main sem force e aguarda o build/HTTP. Se o conector já publicou esta versão, sincronize o Git local antes de tentar um novo push; não use force nem descarte as alterações locais.

## Histórico da preparação inicial

As seções abaixo registram o estado anterior à UX 2.0; os bloqueios e URLs daquela preparação não descrevem automaticamente a situação atual do repositório.

## Arquivos preparados

- `index.html`: versão funcional na raiz; produção e embalagem separadas, filtro por loja, CSV filtrado, validação e aviso de falha de salvamento.
- `README.md` e `DECISOES_E_VALIDACOES.md`: execução, regras, limites, hipóteses e publicação.
- `INICIAR.cmd`: preservado, abre o HTML local.
- `.gitignore` e `.nojekyll`: publicação estática sem cópias, capturas, exportações ou credenciais.
- `tests/mvp.cjs` e `verificar.cjs`: verificação automatizada em navegador, sem dependências de execução da aplicação.
- `PUBLICAR.ps1`: criação segura do repositório, push sem force, Pages main/root e verificação do build/HTTP.
- `RELATORIO_ENTREGA.md`: este relatório.

Os quatro arquivos recebidos em `docefluxo_para_pasta/` permanecem intactos e fora da publicação em duplicidade.

## Testes e resultados

Passaram 44 verificações de `tests/mvp.cjs` em Playwright/Edge, incluindo cálculos, vazio versus zero, validação, edição, inclusão, persistência e migração do armazenamento original, motivos/notas, filtros, CSV e neutralização de fórmulas, restauração e ausência de erros JavaScript.

Também passou `verificar.cjs`, que cobre exclusão, simulação, divisão inteira, aviso de falha de armazenamento e seis larguras: 320, 390, 768, 1024, 1280 e 1440 px, sem rolagem horizontal da página. Capturas desktop e celular inspecionadas. Testes executados em contextos descartáveis; não registram produção no navegador do operador. A sintaxe PowerShell do publicador foi validada; seu fluxo remoto não pôde ser testado por falta de acesso de rede. A revisão dos arquivos de publicação não encontrou senhas, tokens, chaves privadas ou cadastros pessoais; o e-mail pessoal da configuração Git global não foi copiado para os arquivos.

Exemplos conferidos: meta total 360; 100 embalados de meta 120 deixam 20 desse produto e 260 no saldo geral. A simulação fictícia gera 360 produzidos, 289 embalados e saldo 71. Excedentes não compensam déficits de outros produtos.

## GitHub e Pages

- Git e GitHub CLI disponíveis; conta identificada pelo conector: `fred-rose`.
- Git local em `main`, sem commit e sem remoto. O ambiente permite somente leitura em `.git`: `git add` falhou ao criar `.git/index.lock` com `Permission denied`. O commit inicial depende de execução local com escrita.
- **URL do repositório: não disponível; criação remota não confirmada.**
- **URL pública Pages: não disponível; deploy e validação pública pendentes.**
- O terminal bloqueou conexão com `api.github.com` por permissão de socket. O CLI também reportou token inválido, diagnóstico não conclusivo enquanto a rede estiver bloqueada. O conector retornou 404 na consulta a `fred-rose/projeto-loja-doces` e não oferece criação de repositórios nem configuração Pages.

## Funcionalidades e limitações

Metas por produto/dia, distribuição às quatro lojas, produção/embalagem centralizadas, pendências, motivos/notas, filtros de data/loja/situação/produto, CSV e salvamento local. Interface desktop e celular. Todos os dados são demonstrativos.

Sem backend, autenticação, Supabase, Takeat, sincronização, auditoria ou expedição efetiva. Os dados podem ser apagados ao limpar o navegador. CSV não possui importação no MVP. Arquivo local e Pages têm armazenamentos separados. O filtro por loja seleciona produtos destinados à loja, mantendo seus totais centrais de fábrica.

## Hipóteses a validar com o cliente

Confirmar unidade de contagem, quantidades acumuladas por dia, produção obrigatória antes da embalagem, motivos obrigatórios, fechamento do dia, tratamento de excedentes, replanejamento de pendências e necessidade de expedição por loja. Confirmar metas e distribuição reais antes de uso operacional.

## Ação manual pendente

Em PowerShell local com rede, na pasta oficial, executar `gh auth status`; se necessário, `gh auth login -h github.com --web`. Depois executar:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\PUBLICAR.ps1
```

O script solicita Pages com **Deploy from a branch → main → /(root)** e só informa sucesso após conferir o build do commit e resposta pública HTTP 200. Se faltar permissão administrativa: repositório → Settings → Pages → Source: Deploy from a branch → main → /(root) → Save. Obter o endereço fornecido pelo GitHub, abrir a aplicação e testar edição, recarregamento e CSV. Não há URL pública confirmada nesta entrega.
