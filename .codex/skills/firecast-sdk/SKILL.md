---
name: firecast-sdk
description: Desenvolva, corrija e revise plug-ins, fichas e interfaces Lua Form para Firecast SDK 3 neste repositório. Use ao trabalhar com .lfm, Lua, module.xml, NDB, chat, rolagens, VHD ou APIs Firecast; não use para Lua genérico sem integração Firecast.
---

# Firecast SDK

Use `docs/Firecast_SDK_-_Single formatado.pdf` como fonte normativa da SDK. Consulte a seção pertinente antes de criar chamadas de API, atributos de tags Lua Form, eventos ou estruturas de mensagem: não deduza esses contratos de Lua convencional.

## Contexto deste projeto

- É um plug-in SDK 3.7b; cada plug-in tem seu `module.xml` (em `fate_core/`, `markdown_preview/` e `vn_scene/`); confirme os metadados e a versão nele.
- As fichas e janelas estão em arquivos `.lfm`; o código Lua de uma ficha fica no bloco `<script><![CDATA[...]]></script>` e deve carregar `firecast.lua` quando usar a SDK.
- `sdk/` contém as pontes Lua da SDK disponibilizadas ao projeto. Leia o módulo relevante para conferir os nomes e a forma de uma API, mas não o altere, exceto quando a solicitação pedir explicitamente mudar a SDK vendorizada.
- Preserve nomes de controles, campos de nó e `dataType` existentes: eles são contratos entre o layout, os scripts e dados já salvos.

## Roteamento pela documentação

Abra a seção correspondente do PDF conforme a mudança:

- estrutura, instalação e publicação: **Projetos de Plug-in**, `module.xml` e **Ferramentas do SDK 3**;
- layouts, propriedades, eventos e controles: **Interfaces Visuais (Lua Forms)** e **Tags suportadas pelo Lua Form**;
- estado persistido, listas e observadores: **NodeDatabase** e **Biblioteca NDB**;
- rolagens, sala e chat: **Chat messaging structures**, **Biblioteca Firecast.Messaging** e **Biblioteca SceneLib**;
- arquivos: **HD Virtual** e **Biblioteca VHD**;
- tarefas assíncronas: **LUAAsync library**;
- diálogos, áudio, rede, idioma ou logs: a biblioteca homônima no sumário do PDF.

Quando o comportamento não estiver claro, pesquise primeiro no PDF e depois localize o uso ou a declaração correspondente em `sdk/` com `rg`. Explique quaisquer limitações da API que a documentação imponha em vez de inventar uma alternativa incompatível.

## Forma de trabalhar

1. Inspecione o `.lfm` afetado e os nomes que ele já expõe antes de editar. Para uma API Firecast, consulte a documentação e o wrapper Lua pertinente.
2. Faça a menor alteração compatível com a ficha e seus dados atuais. Mantenha XML bem-formado e deixe Lua em CDATA quando estiver em um `.lfm`.
3. Para operações que dependem de sala, nó ou interface já inicializados, siga o evento/ciclo de vida indicado pela documentação; não assuma que esses objetos existem durante o carregamento do arquivo.
4. Para chamadas assíncronas, use o modelo `async`/`await` da SDK apenas nos contextos aceitos pela documentação. Trate ausências normais, como uma ficha fora de sala, antes de usar o objeto.
5. Valide a alteração procurando referências aos campos e controles renomeados e, quando houver RDK disponível, teste o plug-in/ficha nele. Relate se a validação no cliente Firecast não pôde ser executada.
