# Tag edit

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag edit

A tag/componente edit representa uma caixa de texto na interface. Um ótimo controle para permitir a
entrada de dados!

Herança

          O edit possui todas as características de uma tag de texto. Veja:
                         ● Características de todas as tags de textos
                         ● Características de todas as tags visuais

Características

Além das características herdadas, a tag EDIT também possui as seguintes características:
Propriedades e atributos

Propriedade  Tipo                  Valor Padrão  Descrição
textPrompt   String
                                   <string       Um texto que é exibido
                                   vazio>        quando o edit está vazio.
                                                 Normalmente é usado
                                                 para orientar o usuário
                                                 qual informação ele deve
                                                 preencher.
                                                 Exemplo: "Preencha com
                                                 seu nome"

transparent  Boolean               false         Quando True, as bordas e
                                   false         o fundo do edit não serão
isPasswordEdit Boolean             false         exibidas, mostrando
                                   "text"        apenas o texto conteúdo e
readOnly     Boolean                             o cursor de digitação.

type         Enumerado:                          Quando true, o edit
                       ● "text"                  conterá uma senha e os
                       ● "number"                caracteres do texto serão
                       ● "float"                 exibidos como um
                                                 caractere coringa.

                                                 Quando true, o edit não
                                                 permite o usuário alterar
                                                 seu conteúdo (somente
                                                 leitura).

                                                 Define que tipo de dados o
                                                 usuário pode digitar neste
                                                 edit.
                                                 "text" - Não há restrições e
                                                 o usuário pode digitar
                                                 qualquer coisa.
                                                 "number" - O usuário pode
                                                 digitar um valor numérico
                                                 inteiro. Veja também as
                                                 propriedades min e max do
                                                 edit. A propriedade
                                                 "keyboardType" é
                                                 automaticamente alterada
                                                 para "numberPad" se ela
                                                 estiver como "default" ou
                                                 "alphabet".
                                                 "float" - O usuário pode
                                                 digitar um valor numérico
                                                 de ponto flutuante
                                                 (números reais, "com
                                                 vírgula")
min            Double                      -           Quando o atributo "type"
max                                        2147483648  for igual a "number" ou
decimalPlaces  Double                      2147483647  "float", define qual o
keyboardType                                           menor valor numérico que
               Integer                     2           este Edit deve aceitar.

               Enumerado:                  "default"   Quando o atributo "type"
                         ● "default"                   for igual a "number" ou
                         ● "numbersAndPun              "float", define qual o maior
                              ctuation"                valor numérico que este
                         ● "numberPad"                 Edit deve aceitar.
                         ● "phonePad"
                         ● "alphabet"                  Quando o atributo "type"
                         ● "url"                       for igual a "float", define
                         ● "email"                     quantas casas decimais
                                                       pode ter o número
                                                       digitado pelo usuário.

                                                       Quando um teclado virtual
                                                       for exibido (como aquele
                                                       nos smartphones e
                                                       tablets), qual é o layout
                                                       preferencial de teclado
                                                       para este conteúdo?
                                                       "default" e "alphabet": Um
                                                       teclado alfanumérico
                                                       padrão.
                                                       "numbersAndPunctuation
                                                       ": Um teclado para entrada
                                                       de números de símbolos de
                                                       pontuação.
                                                       "numberPad": Um teclado
                                                       com apenas números.
                                                       "phonePad": Um teclado
                                                       para entrada de número
                                                       telefônico.
                                                       "url": Um teclado para
                                                       preencher uma URL da
                                                       internet.
                                                       "email": Um teclado para
                                                       preencher endereços de e-
                                                       mail.
enterKeyType     Enumerado:             "default"  Quando um teclado virtual
                           ● "default"             for exibido (como aqueles
                           ● "done"     <string    nos smartphones e
                           ● "go"       vazio>     tablets), este atributo
                           ● "next"                define o ícone que aparece
                           ● "search"   <string    na tecla enter.
                           ● "send"     vazio>     "default" - sem tratamento
                                                   especial.
field            String                 0.0        Observação importante:
                                                   Esta propriedade apenas
frameRegion      String                            muda a aparência do botão
                                                   ENTER. Caso queira dar
asNumber         Double                            uma funcionalidade ao
                                                   enter, trate o evento
                                                   onKeyDown verificando se
                                                   event.keyCode == 13

                                                   Caminho de um campo no
                                                   NodeDatabase.
                                                   Quando associado, o edit
                                                   passa a apresentar e salvar
                                                   o conteúdo no campo
                                                   informado.
                                                   Veja também:

                                                             ● Lua Form e
                                                                  NodeDatabase

                                                             ● NodeDatabase

                                                   Considerando que o
                                                   componente/tag pai possui
                                                   um frame (ver Frames), ao
                                                   definir o valor desta
                                                   propriedade, a posição e
                                                   tamanho deste controle é
                                                   automaticamente
                                                   calculada para se encaixar
                                                   na Região do Frame de
                                                   mesmo nome.
                                                   Veja Frames e Regiões

                                                   Contém o texto do edit
                                                   como um número de ponto
                                                   flutuante (número real). Se
                                                   o texto do edit não for um
                                                   número real válido, a
                                                   propriedade contém 0.

Eventos                  Descrição
 Nome do evento
onChange      Este evento é invocado quando o conteúdo do edit é alterado.
onUserChange
              Este evento é disparado quando o valor do campo do objeto
              Nodo associado (ver atributo "field") for alterado porque o
              usuário alterou o conteúdo do edit.
              Importante: Este evento é disparado APENAS se o atributo
              "field" estiver preenchido corretamente e se a alteração de
              valor ocorrer neste edit mediante ação do usuário.

Veja Tratando eventos do Lua Form

Exemplos:

Exemplo 1 - Edit simples

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <edit left="10" top="10"/>
 </form>

Exemplo 2 - Edit transparente

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <edit left="10" top="10" transparent="true"/>
 </form>
Exemplo 3 - Edit que lê e salva dados no NodeDatabase

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <edit left="10" top="10" field="Destreza" width="250"/>
 </form>

Veja também:
          ● Lua Form e NodeDatabase
          ● NodeDatabase

Exemplo 4 - (Avançado) Uma mini ficha, usando edits, labels, layouts e styles para evitar retrabalho.

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                  <style>
                              layout.LayoutCampo {
                                             width: 64;
                                             align: left;
                                             margins: {left=2, right=2};
                              }
                              layout.LayoutCampo edit {
                                             height:30;
                                             horzTextAlign: center;
                                             fontSize: 20;
                                             align: top;
                              }
                              layout.LayoutCampo label {
                                             align: top;
                                             horzTextAlign: center;
                                             vertTextAlign: leading;
                                             autoSize: true;
                              }
                </style>
                <layout left="10" top="10" width="200" height="64">

                              <layout class="LayoutCampo">
                                             <edit field="combate.armadura"/>
                                             <label text="Armadura"/>

                              </layout>

                              <layout class="LayoutCampo">
                                             <edit field="saude.pontosDeVida"/>
                                             <label text="Pontos de Vida"/>

                              </layout>

                              <layout class="LayoutCampo">
                                             <edit field="equipamentos.carga"/>
                                             <label text="Carga (kg)"/>

                              </layout>
                </layout>
 </form>

Neste exemplo, os atributos dos edits, labels e layouts foram definidos por Estilo em Cascata pela tag
style.
Foram definidos 3 blocos de estilos em cascata:

          ● Um com seletor "layout.LayoutCampo" (aplicado a todas as tags layout de class
               "LayoutCampo")

          ● Um com seletor "layout.LayoutCampo edit" (aplicado a todas as tags edit que
               estão dentro de uma tag layout de class "LayoutCampo")

          ● Um com seletor "layout.LayoutCampo label" (aplicado a todas as tags label que
               estão dentro de uma tag layout de class "LayoutCampo")

Veja também:
Tag STYLE
Tag LABEL
Tag LAYOUT

Exemplo 5 - (Avançado) O mesmo do exemplo 4, porém feito com tags TEMPLATES

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">
                <template name="LayoutUmCampo">
                              <layout width="64" align="left" margins="{left=2, right=2}">
                                             <edit field="$(campo)" height="30" horzTextAlign="center" fontSize="20"

 align="top"/>
                                             <label text="$(titulo)" align="top" horzTextAlign="center"
                                                          vertTextAlign="leading" autoSize="true"/>

                              </layout>
                </template>

                <layout left="10" top="10" width="200" height="64">
                              <LayoutUmCampo campo="combate.armadura" titulo="Armadura"/>
                              <LayoutUmCampo campo="saude.pontosDeVida" titulo="Pontos de Vida"/>
                              <LayoutUmCampo campo="equipamentos.carga" titulo="Carga (kg)"/>

                </layout>
 </form>

Veja também:
Tag TEMPLATE
Tag LABEL
Tag LAYOUT
```
