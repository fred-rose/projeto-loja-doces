# DoceFluxo — Plano B (experimento de priorização)

## Problema
A gerente sabe que não conseguirá cumprir as metas do dia e precisa decidir qual produção priorizar e o que deixar para depois.

## Cenário **inteiramente fictício** de 29/10/2026

Assumimos uma linha de produção, uma janela de **240 minutos efetivos**, lotes inteiros de **10 unidades**, metas diárias e tempos aproximados abaixo. Nenhuma urgência ou duração foi validada com a fábrica.

| Produto | Meta | Urgência fictícia | Tempo por 10 unidades |
|---|---:|---|---:|
| Bombons de Morango | 120 | Alta | 20 min |
| Puxa Puxa de Pistache | 80 | Alta | 15 min |
| Cocadas Proteicas | 60 | Média | 10 min |
| Cookies and Cream | 100 | Baixa | 12 min |

**Tempo para cumprir tudo: 540 minutos**, acima dos 240 disponíveis.

## Critério inventado e auditável

1. Se a opção **Proteger variedade** estiver marcada **e couber no tempo**, reservar primeiro **um lote de 10 por produto**. Esta regra expressa a hipótese de que seria melhor não deixar toda uma linha de doces sem reposição. Pode ser desligada.
2. Com o tempo restante, ordenar produtos por **urgência mais alta** e, em caso de empate, por **menor duração por lote** (depois nome alfabético).
3. Para cada produto em ordem, reservar a maior quantidade possível de lotes inteiros até atingir a meta ou consumir a capacidade disponível. Depois passar ao seguinte.
4. Mostrar **fazer agora** e **adiar** para cada item; nunca registrar isso como produção real nem alterar as metas e apontamentos do painel.

Essa **heurística gulosa** é somente um exemplo de escolha explicável; **não é otimização matemática, nem promete o melhor plano**. Ela ignora estoque, expedição, preparo, pessoal, máquinas e incertezas.

### Resultado no cenário inicial

| Produto | Fazer agora | Adiar |
|---|---:|---:|
| Puxa Puxa de Pistache | 80 | 0 |
| Bombons de Morango | 40 | 80 |
| Cocadas Proteicas | 20 | 40 |
| Cookies and Cream | 10 | 90 |
| **Total** | **150** | **210** |

**232 minutos alocados, 8 minutos de sobra** que não comportam o próximo lote disponível.

## Pontos que precisam ser validados com a gerente

- O que define urgência: estoque mínimo por loja, pedidos, expectativa de venda, risco de ruptura, prazos, margem ou validade?
- Tempos reais por receita/lote e quantidades mínimas; há etapas de preparação, refrigeração ou embalagem?
- A produção possui uma ou várias linhas/equipes paralelas? Há equipamentos compartilhados?
- Deve existir cobertura mínima de cada produto/loja, ou às vezes faz sentido zerar um item?
- Que papel têm expedição, encomendas, produtos perecíveis e as quatro lojas?
- Quem aprova o plano alternativo e como se registra uma decisão de adiar?

## Como publicar junto ao DoceFluxo

1. Copiar `plano-b.html` para a **raiz** de `C:\Users\patai\OneDrive\Documentos\Projeto Loja Doces`, ao lado de `index.html`.
2. Opcional: colocar no painel principal um link discreto `<a href="plano-b.html">Plano B: simular capacidade</a>`.
3. No terminal normal do VS Code, executar:

```powershell
git add plano-b.html
git commit -m "Adiciona simulador ficticio Plano B da producao"
git push origin main
```

4. Após o GitHub Pages publicar, abrir `https://fred-rose.github.io/projeto-loja-doces/plano-b.html`.

Essa página funciona offline, sem bibliotecas externas, e **não utiliza nem altera a chave localStorage** do sistema existente. Nenhuma decisão é gravada como produção. A URL pública só passa a existir após o push e deploy.
