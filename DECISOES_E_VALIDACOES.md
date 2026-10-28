# Decisões, hipóteses e validações — DoceFluxo

## Necessidade atendida
A gerente de produção precisa verificar diariamente se as metas da fábrica central foram atingidas e entender o que ficou por fazer.

## UX 2.0 — operação em cartões

- Embalados é o total acumulado do dia. +10/+25 somam ao total atual; vazio inicia a soma a partir de zero, sem presumir produção.
- Concluir meta registra somente embalados igual à meta. Se o total já atingiu ou superou a meta, a ação fica desabilitada para não diminuir apontamentos.
- Produzidos, notas, edição de metas, distribuição, CSV e simulação continuam disponíveis em áreas recolhidas.
- Motivo aparece somente quando embalados está preenchido e abaixo da meta. É opcional; são mantidas as regras existentes de limpeza do motivo ao concluir ou apagar o apontamento.
- Salvamento de valores válidos e notas ocorre ao digitar. Nenhuma mudança de contrato ou chave localStorage; migração de produzido ausente continua usando nulo.
- Ao digitar, o campo e o cursor permanecem no lugar; somente os indicadores do cartão são atualizados. Os cartões mantêm sua ordem para evitar que o produto mude de posição durante o trabalho. O filtro de situação é aplicado ao escolher o filtro ou atualizar a lista; a digitação mantém o cartão ativo visível até a próxima atualização.
- A validação entre produzidos e embalados se aplica igualmente a digitação e atalhos. Não completar a produção automaticamente para satisfazê-la.
- Testes incluem dados v2 anteriores, toques consecutivos, recarregamento sem sair do campo, CSV e ausência de overflow entre 320 e 1440 px. Uso real com uma mão e vocabulário devem ser validados com os funcionários.

## Decisões
- Centralizar o apontamento por **produto, data e fábrica**, sem confundir distribuição planejada para lojas com expedição efetiva.
- Não transformar vendas do Takeat em suposta produção real.
- Separar claramente falta de apontamento de pendência constatada.
- Priorizar uma tela de operação simples, acessível em desktop e celular.
- Usar HTML/CSS/JS sem backend para respeitar o prazo curto; exportar CSV e manter dados apenas no navegador.

## Hipóteses para este protótipo
- Unidade de contagem: **1 doce**.
- Produção concluída: doce **pronto e embalado**.
- Produção e embalagem têm apontamentos separados. Conclusão e saldo usam embalados; o apontamento de produzidos informa a etapa anterior. Embalados não pode superar produzidos quando ambos são conhecidos. Apontamentos antigos não recebem produção presumida.
- As quatro lojas podem receber alocações planejadas do total da fábrica.
- Distribuições exibidas e metas em 28/10/2026 são **fictícias**.
- Apontamento é efetuado pela gerente; não há conciliação multiusuário.
- Pendências não são automaticamente transferidas entre datas.

## Pontos a validar com a gerente/cliente
1. A produção será registrada apenas como total da fábrica ou cada loja precisará de apontamento próprio de separação/expedição?
2. Para que a pendência seja considerada concluída/justificada, o registro do motivo deve ser obrigatório?
3. Existe fechamento formal do dia, com conferência, aprovação ou bloqueio de edição?
4. Como replanejar pendências: manualmente, por aprovação ou automaticamente?
5. Em qual dispositivo a gerente opera mais: celular ou computador?
6. Quais tipos de motivo, produtos, unidades e regras de excesso de produção são realmente utilizados?
7. Há necessidade de múltiplos operadores, trilha de auditoria, backup ou integração com outros sistemas?

## Fora de escopo
Estoque, compras, receitas, turnos, gestão de funcionários, integração Takeat, rastreio de lotes, fechamento contábil, faturamento, autenticação e sincronização online.

## Complementos de preparação para publicação — 28/10/2026

- A implementação original foi preservada integralmente na subpasta recebida. A raiz contém sua versão ampliada, sem dependências de execução.
- Meta central não é multiplicada por quatro. A loja funciona como filtro de produtos com alocação maior que zero, não como apontamento local de produção. Validar essa interpretação com a cliente.
- Pendência principal é de conclusão/embalagem. Ex.: meta 120, produzidos 100, embalados 80 → saldo 40. Não se soma déficit de produção ao déficit de embalagem, pois isso contaria unidades duas vezes.
- Motivos continuam opcionais e editáveis em pendências apuradas; notas são texto livre. Validar obrigatoriedade dos motivos, eventual separação entre motivos de produção e embalagem e preenchimento independente das duas etapas.
- CSV tem BOM UTF-8, separador ponto e vírgula, aspas escapadas e neutralização de fórmulas em texto. Campos desconhecidos saem vazios; zero sai como zero.
- Dados locais não devem conter informações pessoais ou confidenciais. A revisão dos arquivos de publicação não encontrou credenciais, tokens ou cadastros pessoais. Exportações, capturas, cópia original e arquivos de ambiente são ignorados.
- O roteiro de publicação usa identidade técnica e e-mail privado do GitHub no commit para evitar publicar o e-mail pessoal configurado na máquina. A configuração de identidade e o staging no ambiente de preparação falharam por bloqueio de escrita em `.git`; nenhum commit foi criado.
- O acesso de rede da CLI ao GitHub foi bloqueado pelo ambiente; o aviso de token inválido em `gh auth status` não é prova conclusiva de credencial inválida, porque `gh api user` falhou antes da autenticação, com erro de socket/permissão. O conector reconheceu `fred-rose` e retornou 404 ao consultar `fred-rose/projeto-loja-doces`.
- Publicação e URL real permanecem pendentes de execução em terminal com acesso à rede. O roteiro automatizado está em `PUBLICAR.ps1`.
