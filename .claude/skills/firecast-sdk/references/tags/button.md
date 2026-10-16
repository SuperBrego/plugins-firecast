# Tag button

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag button

A tag/componente button representa um botão na interface. Excelente para executar uma tarefa
quando o usuário optar por ela!

Herança

          O button possui todas as características de uma tag de texto. Veja:
                         ● Características de todas as tags de textos
                         ● Características de todas as tags visuais

Características

Além das características herdadas, a tag button também possui as seguintes características:

Eventos

Nome do evento  Descrição

onClick         Este evento é invocado quando ocorre um click com o botão

                esquerdo do mouse no controle, ou quando ocorre um “tap

                touch” no controle.

Veja Tratando eventos do Lua Form

Exemplos:

Exemplo 1 - Um botão simples

 <?xml version="1.0" encoding="UTF-8"?>
 <form fame="frmFichaTeste">
              <button left="40" top="40" text="Eu sou um botão" width="150"/>

 </form>

Exemplo 2 - Tratando o evento onClick (estilo 1)

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <button left="40" top="40" text="Clique" onClick="showMessage('olá
 mundo!');"/>
 </form>
Veja também Tratando eventos do Lua Form.

Exemplo 3 - Tratando o evento onClick (estilo 2)

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <button left="40" top="40" text="Clique">
                              <event name="onClick">
                                             local texto = "";

                                             for i = 1, 5, 1 do
                                                            texto = texto .. "Linha " .. i .. "\n";

                                             end;

                                             showMessage(texto);
                              </event>
                </button>
 </form>
Tag col

     The "col" tag/component represents a column in a grid-aligned interface. It is a shorthand for the
     following equivalent declarations:

          <layout g="col"/>
          <layout g-role="col"/>

Inheritage

     The "col" tag inherits all the characteristics of the "layout" tag.

     See:
                               ○ layout tag
                               ○ Characteristics of all visual tags
```
