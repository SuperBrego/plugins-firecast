# Plugin-Firecasts

Conjunto de fichas para o **Firecast**: uma ficha configurável de Fate Core, um editor com visualização de Markdown e uma cena para apresentações no estilo visual novel.

O projeto usa o SDK **Firecast 3.7b** e está identificado no `module.xml` como `br.GodsCorpse.PluginFirecasts` (versão 1.0).

## Fichas incluídas

### Fate Core (`fate_core.lfm`)

Ficha de personagem para Fate Core com três abas:

- **Ficha:** nome, jogador, recarga, pontos de destino, aspectos, perícias, façanhas, extras, estresse e consequências.
- **Extras:** detalhes de até seis extras, incluindo nome, permissão, custo e descrição.
- **Configuração:** ajusta os níveis exibidos da escada de perícias, o número de aspectos, façanhas, extras e caixas de estresse, além da consequência suave extra.

O botão `dF` ao lado de uma perícia envia uma rolagem `4dF` ao chat da sala, somando ou subtraindo o valor informado no campo da perícia. A rolagem requer que a ficha esteja aberta em uma sala do Firecast.

Configuração padrão: escada de +1 a +5, três aspectos livres, seis façanhas, seis linhas de extras, quatro caixas de estresse físico e mental e uma consequência suave extra.

### Markdown Preview (`markdown_preview.lfm`)

Ficha de duas abas para escrever Markdown e renderizá-lo dentro do Firecast. A aba **Editor** contém o texto e o ajuste de largura e altura usados para as imagens; selecione **Renderizar Preview** para atualizar a aba **Preview**.

O renderizador oferece suporte a:

- títulos (`#` a `######`), linhas horizontais e parágrafos;
- negrito, itálico, negrito com itálico, tachado e código em linha;
- links, URLs diretas e imagens no formato `![alt](URL)`;
- listas ordenadas e não ordenadas, citações e blocos delimitados por crases;
- tabelas iniciadas com `|`, incluindo alinhamento de colunas.

No preview, é possível usar **Fundo escuro** e **Ocultar editor**. O conteúdo, as preferências e as dimensões das imagens ficam associados à ficha.

### Visual Novel Scene (`vn_scene.lfm`)

Cena de apresentação de 1280 × 600 para acompanhar o chat da sala. Configure:

- uma imagem de fundo;
- três slots principais — esquerda, centro e direita —, cada qual com três camadas (frente, meio e atrás);
- nome, cor e URL de imagem para cada camada;
- até seis personagens extras.

Ao chegar uma mensagem do chat enviada por **personagem**, a cena procura o nome configurado (sem diferenciar maiúsculas de minúsculas), traz a respectiva camada para a frente, aplica foco ao slot e exibe o diálogo. Personagens extras entram temporariamente no centro. Mensagens enviadas como **narrador** exibem apenas a caixa de narração. Um nome ainda não configurado também mostra o texto, mas sem retrato.

Use `★` para escolher manualmente a camada em foco. Os botões superiores permitem abrir a configuração, limpar somente o diálogo/foco atual e entrar no modo **Apresentação**. O comando **Limpar tudo (nomes e URLs)** apaga a configuração persistida da cena, portanto deve ser usado com cuidado.

## Uso no Firecast

1. Instale ou abra este projeto como um módulo compatível com o SDK Firecast 3.7b.
2. Na sala, crie uma ficha a partir do tipo desejado: **Fate Core**, **Markdown Preview** ou **Visual Novel Scene**.
3. Preencha as configurações específicas de cada ficha. Para a cena, cadastre os nomes exatamente como serão usados nas mensagens impersonadas do chat.

## Estrutura

```text
module.xml            Metadados do módulo
fate_core.lfm         Ficha Fate Core
markdown_preview.lfm  Editor e preview de Markdown
vn_scene.lfm          Cena Visual Novel
sdk/                  Pontes Lua do SDK Firecast incluídas no projeto
```

## Autor

GodsCorpse — [github.com/SuperRego](https://github.com/SuperRego)

