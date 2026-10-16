---
name: firecast-sdk
description: Desenvolvimento de plug-ins para o RRPG Firecast com o SDK 3 (Lua Forms .lfm, module.xml, rdk, NodeDatabase/ndb, fichas, janelas acopláveis, chat, SceneLib). Use ao criar, editar, depurar ou compilar qualquer plug-in deste projeto, arquivos .lfm ou .lua do Firecast, ou quando o usuário perguntar sobre tags, atributos, eventos ou bibliotecas do SDK (Firecast, Firecast.Messaging, ndb, vhd, dialogs, gui, scene...).
---

# Firecast SDK 3 — guia do projeto

Fonte de verdade: `docs/Firecast_SDK_-_Single formatado.pdf`. O texto dele foi extraído para `references/` (ao lado deste arquivo). **Consulte a referência antes de usar uma tag, atributo, evento ou função que você não tenha certeza de que existe** — o `rdk c` rejeita tags/atributos inválidos, e o sandbox só expõe um subconjunto do Lua.

## Estrutura do projeto

- `*.lfm` na raiz — Lua Forms (XML). Cada um vira `output/rdkObjs/<nome>.lfm.lua` no build.
- `module.xml` — id, versão, `sdkVersion` (atual: `3.7b`), `<info lang=...>`.
- `sdk/` — código Lua da ponte com o binário. **Gerado por `rdk p`; não edite.** Útil só para ler assinaturas (`sdk/firecast.lua`, `sdk/ndb.lua`, `sdk/gui.lua`...).
- `output/*.rpk` — plug-in empacotado (artefato de build; não edite).
- `filelist.txt` é só uma listagem de diretório (UTF-16), não é parte do SDK.
- Arquivos/pastas começando com `__` e a pasta `output` são ignorados pelo build.

## Fluxo de trabalho

1. `rdk p` — prepara/atualiza o projeto (recria `sdk/` e `module.xml` se faltar).
2. `rdk c` — compila e valida (módulo, Lua e LFM) → `output/<Modulo>.rpk`.
3. `rdk i` — compila **e instala**; com o Firecast aberto ele recarrega o plug-in; com ele fechado, instala off-line. Não instala se houver erro de validação.
4. `rdk pdf` / `rdk lfm <arquivo.svg|zip>` — converte PDF → SVG → LFM de ficha (cálculos não são convertidos).

`rdk` não está no PATH desta máquina; se o usuário pedir para compilar, localize o executável ou peça o caminho. Depois de editar `.lfm`, valide com `rdk c` quando possível — é o único verificador de tags/atributos.

## Regras essenciais de Lua Form

- Raiz do `.lfm` é `<form>` ou `<popupForm>`. Ficha: `formType="sheetTemplate" dataType="<único, ≥5 chars, [A-Za-z0-9_.], sem começar por dígito>" title="..." name="frmXxx"`. Janela acoplável de mesa: `formType="tablesDock"`. **Não mude `dataType` depois de publicado** (é onde os dados são salvos).
- `name` do form: alfanumérico/`_`, sem dígito inicial; convenção `frm...`.
- Medidas em **pontos lógicos**; posição de filhos é relativa ao pai. Layout por `left/top/width/height`, por `align` (`client`, `top`, `left`, `right`...), `margins="{left=4,top=2}"`, `padding`, ou pelo **Grid System** (`g="row|col|block|container"`, `g-width`, sufixos `-xs/-sm/-md/-lg/-xl`).
- Cores: `#RGB`, `#RRGGBB`, `#RRGGBBAA` ou nomes (`Black`, `Transparent`...).
- **`self`** = instância do form; controles com `name` são acessados como `self.nomeDoControle`. Sem `self.` dá erro. Um form pode ter várias instâncias simultâneas.
- **`sheet`** = nodo do NodeDatabase que é o escopo de dados do form (automático em fichas, `recordList` e janelas acopláveis).
- Funções em `<script>` devem ser `local function f()` ou `function self.f()` — nunca globais (vazam entre instâncias). Use `<![CDATA[ ... ]]>` em scripts com `<`, `>` ou `&`.
- Eventos: atributo de uma linha (`onClick="..."`) ou `<event name="onClick">...</event>` dentro da tag. A doc escreve `onClick`/`onStartDrag`, mas alguns exemplos usam `OnStartDrag`; prefira a grafia `onXxx`.
- Ligação a dados: atributo `field="campo"` (suporta `a.b.c` para nodos filhos, criados sob demanda). Tags com suporte: label, edit, checkBox, comboBox, colorComboBox, image, imageCheckBox, textEditor, recordList, dataLink, dataScopeBox, progressBar. Com `field` e sem escopo, o controle fica desabilitado.
- Campo calculado: `<dataLink field="x">` (ou `fields="{'a','b'}"`) + `<event name="onChange">`; valores vêm como string → use `tonumber(sheet.x) or 0`.
- Lista dinâmica: `<recordList field="itens" templateForm="frmItem">` + um segundo `<form name="frmItem">` (molde de cada item); `:append()` adiciona, `ndb.deleteNode(sheet)` remove dentro do item; painel de detalhes via `dataScopeBox` + `.node = recordList.selectedNode`.
- Permissões por nodo: `ndb.setPermission/getPermission/testPermission`, e `ndb.newObserver(sheet)` para reagir a mudanças.
- Outras tags úteis: `tabControl`+`tab`, `scrollBox`, `flowLayout/flowPart`, `popup`, `timer`, `richEdit`, `style` (CSS-like), `template` (tags customizadas), `import` (dividir o LFM), `group`.

## Sandbox Lua (o que NÃO existe)

Só estão disponíveis: `_G, next, pairs, ipairs, pcall, xpcall, select, tonumber, tostring, type, unpack, assert, error, load, rawget/rawset/rawequal, setmetatable/getmetatable, require, collectgarbage` e as bibliotecas `string`, `table`, `math`, `utf8`, `coroutine`, `os` (só `clock, difftime, time, date`), `debug` (só `getmetatable, setmetatable, traceback`), `package` (`loaded, config`). **Não há `io`, `os.execute`, `dofile`, `loadfile`, `print`**. Arquivos só via `vhd` (HD virtual do plug-in, `/` como raiz, case-sensitive) e `dialogs.openFile/saveFile`. Todos os `.lua` da raiz carregam sozinhos (`/init.lua` primeiro); globais são compartilhados entre os arquivos Lua do plug-in, mas **não** persistem entre execuções.

Para usar as bibliotecas do SDK, faça `require("firecast.lua")` (e equivalentes `require("ndb.lua")`, `"gui.lua"`, `"dialogs.lua"`, `"vhd.lua"`, `"utils.lua"`...) e chame `Firecast.Algo`, `ndb.algo` etc. Padrão já usado no projeto: `Firecast.Messaging.newReceiver("ChatMessageEx", callback)` — **guarde o objeto retornado** (se sofrer GC a escuta é removida).

## Mapa das referências (leia só o que precisar)

Use Grep em `references/` por nome de função/atributo/evento antes de abrir arquivos grandes.

| Tópico | Arquivo |
|---|---|
| Tutoriais (campo calculado, abas, imagem, lista dinâmica, rolagem de dados, ocultar itens, janela acoplável), `module.xml`, `rdk`, Drag & Drop | `references/guides/tutorials-and-tools.md` |
| HD Virtual, modelos de ficha, NodeDatabase, sandbox, Lua Form (escopo de dados, cores, instâncias), Grid System | `references/guides/concepts.md` |
| Estruturas de chat (SendMessageParameters, LogRec, MsgContent, TalemarkOptions, Entity...) | `references/guides/chat-structures.md` |
| Macros em Lua, linguagem Lua, XML, FAQ | `references/guides/macros-and-appendix.md` |
| Lista de todas as tags + propriedades/métodos/eventos comuns a todo controle | `references/tags/_overview-and-common-control.md` |
| Uma tag específica | `references/tags/<tag>.md` (button, edit, label, image, checkBox, comboBox, textEditor, richEdit, rectangle, recordList, gridRecordList, dataLink, dataScopeBox, form, popup, popupForm, style, template, import, script, event, scrollBox, tab, tabControl, flowLayout, flowPart, progressBar, timer, path, ...) |
| Frames/regiões (molduras customizadas) | `references/tags/frames.md` |
| Visão geral das bibliotecas | `references/libs/_index.md` |
| `Firecast` (mesas, personagens, rolagens, biblioteca, chat) | `references/libs/firecast.md` |
| Mensagens/eventos do Firecast (`newReceiver`) | `references/libs/firecast-messaging.md` |
| Plug-ins instalados / ações solicitadas ao Firecast | `references/libs/firecast-plugins.md`, `firecast-requests.md` |
| `ndb` (NodeDatabase, Nodo, Observer, Transaction, permissões) | `references/libs/ndb.md` |
| `gui` (Drag/Drop, InertialMovement...), `dialogs` | `references/libs/gui.md`, `dialogs.md` |
| `vhd`, `internet` (HTTP/downloads), `firedrive`, `system`, `utils` (Stream...), `locale`, `log`, `async`, `audio` | `references/libs/<nome>.md` |
| `scene` (Scene 3: canvas, tokens, fog of war, grid, viewport) | `references/libs/scenelib.md` |

## Observações sobre a documentação

- Algumas páginas do PDF dizem "Conteúdo desta página não consta no documento original" (Introdução, Primeiros passos, Histórico de versões, plug-in multi-idioma, `Tag layout`, fontes embutidas). Para essas, não invente: leia `sdk/*.lua` ou diga que a doc não cobre.
- O texto foi extraído automaticamente: tabelas de propriedades podem ter colunas misturadas; confirme tipo/valor padrão no contexto.
- O PDF documenta o SDK conforme sua versão; o projeto usa `sdkVersion="3.7b"`. Se `sdk/` tiver funções ausentes na doc (ou vice-versa), prefira o que está em `sdk/`.
- Ao entregar código, siga o estilo dos `.lfm` existentes (`fate_core.lfm`, `markdown_preview.lfm`, `vn_scene.lfm`): indentação de 4 espaços, scripts em `<script><![CDATA[...]]></script>`, comentários em português.
