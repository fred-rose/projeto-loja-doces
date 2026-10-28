# DoceFluxo — prototipo de planejamento de producao

Protótipo funcional e **offline** para acompanhar metas diárias da fábrica de doces que abastece quatro lojas: Asa Norte, Noroeste, Gilberto Salomão e Sudoeste.

## UX 2.0 — apontamento rápido

O trabalho diário acontece nos cartões: digite o **total embalado no dia**, toque em **+10** ou **+25**, ou use **Concluir meta**. Os valores válidos são salvos ao digitar, sem botão Salvar. A conclusão preenche somente embalados com a meta; não presume produção e não reduz um excedente já registrado.

Cada cartão mostra meta, embalados, saldo, progresso e situação por texto e cor. Produtos sem apontamento ou pendentes têm destaque. O motivo opcional aparece somente na pendência apurada. Produção e observações ficam recolhidas; metas/lojas, CSV e simulação ficam em seções secundárias. Os botões principais têm pelo menos 50 px de altura.

**Dados preservados:** contrato versão 2 e chave `docefluxo-central-demo-v2` mantidos. Vazio continua não informado, zero é válido e nenhuma ação de embalagem inventa produzidos. Se produção estiver informada, qualquer tentativa de embalar acima dela é bloqueada com orientação no próprio cartão. A persistência continua local à origem do navegador.

O campo ativo não é recriado durante a digitação: saldo, progresso e situação atualizam sem mover o cursor. Notas também salvam ao digitar. Falha de armazenamento mantém os dados na memória e exibe aviso para exportar o CSV.

**Verificação UX 2.0:** `node tests/ux.cjs` passou em 56 verificações; `node tests/mvp.cjs` passou em 44 verificações; `node verificar.cjs` passou com o roteiro HTTP complementar. Foram conferidas oito larguras entre 320 e 1440 px. Nenhuma dependência de execução foi adicionada. Playwright e Edge são usados somente nos testes.

## Como executar (Windows)

1. Extraia os arquivos **diretamente** na pasta `C:\Users\patai\OneDrive\Documentos\Projeto Loja Doces`.
2. Dê dois cliques em `INICIAR.cmd` (ou abra `index.html` no Chrome ou Edge).
3. A data **28/10/2026** abre com quatro produtos e metas **fictícias**; os apontamentos começam em branco.
4. Use **Simular execução** para demonstrar o fluxo, e **Restaurar demonstração** para zerar as alterações locais.

Não é necessário instalar Node, npm, pacotes, banco de dados ou conectar-se à internet.

## Funções incluídas

- Metas de produção por **produto e dia**, registradas na fábrica central.
- Alocação das metas entre as quatro lojas; a soma deve corresponder à meta da fábrica.
- Apontamentos separados de unidades **produzidas** e **embaladas**, centralizados na fábrica.
- Distinção entre **sem apontamento**, **com pendência**, **concluído** e **acima da meta**.
- Registro opcional de motivo e observação sobre desvios.
- Consulta por data, busca por produto, filtros, inclusão/edição/exclusão de metas.
- Filtro por loja: mostra produtos com alocação positiva para a loja, mantendo os totais de fábrica desses produtos. Não representa produção ou entrega daquela loja.
- Exportação de CSV para apresentação.
- Armazenamento local no navegador (localStorage) para este protótipo.
- Layout para desktop e celular.

## Dados de demonstração — não são registros reais

| Produto | Meta da fábrica |
|---|---:|
| Bombons de Morango | 120 |
| Puxa Puxa de Pistache | 80 |
| Cocadas Proteicas | 60 |
| Cookies and Cream | 100 |
| **Total** | **360** |

A divisão por loja também é **inventada**, apenas para possibilitar a demonstração. Não foram fornecidos apontamentos reais, e dados do Takeat representam vendas, **não** produção.

## Observações importantes

- **Saldo no acompanhamento** inclui itens sem apontamento. Isso **não** quer dizer que foram comprovadamente deixados de produzir. A lista distingue explicitamente pendência apurada de falta de conferência.
- Dados não são sincronizados entre navegadores, computadores nem telefones; podem ser apagados ao limpar os dados do navegador ou alterar origem/endereço do arquivo.
- Não é sistema de produção. Não há autenticação, backend, envio às lojas, integração com Takeat nem passagem automática das pendências para o dia seguinte.
- Para uma demonstração com armazenamento local mais previsível, use o mesmo navegador e abra sempre a mesma localização do arquivo.

## Roteiro de demonstração (3 a 5 minutos)

1. Mostrar metas por produto em 28/10 e a distribuição planejada para as quatro lojas.
2. Evidenciar a diferença entre *sem apontamento* e *pendente*.
3. Clicar **Simular execução** (dados de exemplo claramente identificados).
4. Alterar uma quantidade de unidades prontas e embaladas, registrar motivo do desvio e mostrar o saldo.
5. Exportar o CSV do dia.
6. Explicar quais hipóteses ainda precisam de validação com a gerente.

Para decisões e perguntas, veja `DECISOES_E_VALIDACOES.md`.

## Regras dos apontamentos

- Campos em branco significam **não informado**; zero é uma quantidade registrada.
- Pendência apurada = `máximo(0, meta - embalados)`, somente quando embalados foi informado. O saldo geral também inclui metas sem apontamento e não comprova falta de produção.
- Se os dois campos foram informados, embalados não pode superar produzidos. Apontamentos antigos de embalagem são preservados, sem inventar sua produção; campos podem ser preenchidos independentemente enquanto o outro está em branco.
- Quantidades são inteiros entre 0 e 1.000.000; meta deve ser positiva. A soma das quatro alocações deve ser igual à meta.
- Indicadores e distribuição seguem data e loja; busca e situação filtram a lista. O CSV respeita todos os filtros e contém uma linha por produto, com totais da fábrica e quatro colunas de alocação.
- O armazenamento original `docefluxo-central-demo-v2` é preservado na mesma origem do navegador. Abrir pelo Pages constitui outra origem e não importa dados do arquivo local.

## Organização e testes

A versão pronta para publicação está na raiz: `index.html`, `INICIAR.cmd` e documentação. Os quatro arquivos recebidos permanecem intactos em `docefluxo_para_pasta/`, ignorada pelo Git. Não há dependências externas, fontes remotas ou etapa de build.

Em 28/10/2026 passaram **44 verificações automatizadas** com Playwright e Edge: cálculos, zero versus branco, validação, edição e inclusão, persistência e migração, falha de armazenamento, filtros, CSV, restauração e ausência de erros JavaScript. Larguras verificadas: 320, 390, 768, 1024 e 1440 px; capturas também foram inspecionadas. O roteiro adicional `verificar.cjs` passou via servidor HTTP local, incluindo exclusão, simulação e largura de 1280 px. Testes realizados em contexto isolado, sem criar apontamentos no navegador do operador.

Para repetir, disponibilize `playwright` no ambiente de desenvolvimento (não é dependência da aplicação) e execute `node tests/mvp.cjs`. O navegador Microsoft Edge deve estar instalado. Opcionalmente defina `TEST_URL` para testar uma URL HTTP publicada. Capturas ficam em `artifacts/`, ignorada pelo Git.

Também foi executado `verificar.cjs` com testes de exclusão, simulação e seis larguras (incluindo 1280 px). Esse roteiro usa `@playwright/test`, podendo receber seu caminho absoluto em `PLAYWRIGHT_MODULE`. Capturas ficam em `test-results/`, ignorada pelo Git. Falhas de salvamento local deixam um aviso permanente na aplicação; exporte CSV antes de fechar nesse caso. Relatório completo em `RELATORIO_ENTREGA.md`.

## Publicação no GitHub Pages — procedimento e histórico

O repositório existente é `https://github.com/fred-rose/projeto-loja-doces`, vinculado a `origin`, na branch `main`. O ambiente de edição bloqueia a rede da CLI e a escrita em `.git`. A tentativa pelo conector também falhou: GitHub 403, `Resource not accessible by integration`, ao criar a árvore do commit. **A UX 2.0 não foi enviada nem teve deploy validado nesta execução.** O procedimento abaixo conclui pelo terminal local com acesso e permissões. A atualização da branch não comprova o deploy: é necessário verificar o build do commit e a página pública.

URL a verificar: `https://fred-rose.github.io/projeto-loja-doces/`. O resultado efetivamente confirmado é informado na entrega; não presumir sucesso apenas pelo endereço.

Em um terminal PowerShell normal, nesta pasta:

```powershell
gh auth status
# Se necessário, autentique pelo navegador, sem compartilhar credenciais:
gh auth login -h github.com --web
powershell -NoProfile -ExecutionPolicy Bypass -File .\PUBLICAR.ps1
```

O script prepara somente os arquivos da lista de publicação, cria o commit com e-mail privado do GitHub, cria `projeto-loja-doces` público na conta autenticada, envia `main`, solicita Pages com **Deploy from a branch → main → /(root)** e aguarda a publicação. Interrompe se encontrar repositório existente sem vínculo local, origin inesperado ou configuração Pages diferente. Não utiliza force push. Uma falha de validação termina com status pendente; o script só informa sucesso após build do commit e resposta HTTP contendo DoceFluxo.

Alternativa manual, após enviar o commit: no repositório, **Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: main → /(root) → Save**. Aguarde o workflow Pages e abra o endereço que o próprio GitHub exibir. Não apresente um endereço presumido como publicação concluída.
