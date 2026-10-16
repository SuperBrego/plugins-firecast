# Biblioteca gui

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca GUI

       A biblioteca gui provê funções relacionadas às interfaces Lua Form.
       Todas as funções estão contidas na table/variável "GUI" da unidade "gui.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "gui.lua"
    require("gui.lua");

    -- Agora é possível acessar as funções da biblioteca
    GUI.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca gui

    function GUI.asyncOpenFirecastURI(uri[, params])

       Shows a user interface capable of displaying the contents of the specified Firecast URI
       Arguments:

                                 ○ uri - A string containing the Firecast URI to open.
                                 ○ (Optional) params - A Lua table that may contain the following optional

                                      fields:
                                                      ■ alwaysCreate - A Boolean; This flag is used when the
                                                           specified URI is already open. If true, Firecast should
               attempt to open yet another instance of the specified

               URI, while the value false means to reuse the existing

               interface. Default: false;
          ■ newTab - A Boolean; true means Firecast should try to

               open the URI in a new tab. Default: false;
          ■ autoFocus - A Boolean; true means the Firecast should

               try to focus the open interface, while the value false

               means to open without focusing it. Default: false;
          ■ canReplace - A Boolean; true means Firecast can use

               the behavior of replacing another existing open

               interface with the interface to open. Default: false.

Return:   ○ A Promise object to track the process.
Remarks:
          ○ If the user cancels the open process, the returned promise will be
Example:       resolved to failure.

          ○ Only Firecast URIs are accepted by this function. To open a generic URL
               in a browser, use the GUI.openInBrowser() function instead.

          ○ For example, you can obtain Firecast URIs using the "firecastURI"
               property of Mesa objects or BibliotecaItem objects.

          ○ Some Firecast URIs may require user attention during the opening
               process, such as joining a room or entering a password to join a room.

GUI.asyncOpenFirecastURI("https://vtt.firecast.app/artifacts/
rooms/1");

GUI.asyncOpenFirecastURI(character.firecastURI,
{alwaysCreate=true,

                                                                                         newTab=true,

autoFocus=true});

function GUI.findControlByName(controlName,
referenceControl)

    Procura outro controle através do nome passado pelo parâmetro “controlName” em
    toda a hierarquia de controles onde "referenceControl" está.

   Parâmetros:
          ○ controlName - uma cadeia de caracteres contendo o nome do controle
               que deseja procurar.

          ○ referenceControl - um controle para servir de referência durante a
               busca. O controle será procurado em toda a hierarquia de controles de

               "referenceControl", isto é, primeiro nos controles que estão dentro

               dele e depois nos controles pais de "referenceControl".

Retorno:

          ○ o controle, se encontrado
          ○ nil caso não encontre.

function GUI.getShiftState()

Return the current keyboard shift state.
Arguments:

     None

Return

          ○ A Lua table with the following fields:
                              ■ shiftKey - A boolean; true if the "shift" key is pressed.
                              ■ ctrlKey - A boolean; true if the "control" key is pressed.
                              ■ altKey - A boolean; true if the "alt" key is pressed (also
                                   known as "menu" key).
                              ■ cmdKey - A boolean; true if the "command" key is
                                   pressed (macOS device).
                              ■ ctrlOrCmdKey - A boolean; true if the "command" key
                                   is pressed in a macOS device; otherwise, true if the

                                   "control" key is pressed in a non-macOS device

function GUI.newActivityIndicator()

Cria e retorna um novo objeto activityIndicator
Parâmetros:

    Não há parâmetros

   Retorno:
       Retorna um objeto activityIndicator

function GUI.newButton()
   Cria e retorna um novo objeto button.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto button.

function GUI.newCheckBox()

   Cria e retorna um novo objeto checkbox.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto checkbox.

function GUI.newCol()

   Cria e retorna um novo objeto col.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Um objeto col.

function GUI.newComboBox()

   Cria e retorna um novo objeto comboBox
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto comboBox
function GUI.newContainer()

   Cria e retorna um novo objeto container.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Um objeto container..

function GUI.newColorComboBox()

   Cria e retorna um novo objeto colorComboBox
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto colorComboBox

function GUI.newDataLink()

   Cria e retorna um novo objeto dataLink
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto dataLink

function GUI.newDataScopeBox()

   Cria e retorna um novo objeto dataScopeBox
   Parâmetros:

       Não há parâmetros
   Retorno:
       Retorna um objeto dataScopeBox

function GUI.newEdit()

   Cria e retorna um novo objeto edit
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto edit

function GUI.newFlowLayout()

   Cria e retorna um novo objeto flowLayout.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto flowLayout.

function GUI.newFlowLineBreak()

   Cria e retorna um novo objeto flowLineBreak.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto flowLineBreak.

function GUI.newFlowPart()

   Cria e retorna um novo objeto flowPart.
   Parâmetros:

       Não há parâmetros
   Retorno:
       Retorna um objeto flowPart.

function GUI.newForm([formName])

Cria e retorna um novo objeto form.

Parâmetros:

                         ○ (OPCIONAL) formName - Se informado, contém uma cadeia de
                               caracteres identificando o "name" de um dos Lua Forms do plug-in,
                               fazendo com que a função busque em todos os arquivos ".lfm" a tag
                               form ou tag popupForm que possuir o atributo name igual a este valor.

Retorno:

          ○ Se "formName" não for informado: Retorna um novo objeto form que

               não possui nenhum outro componente/tag dentro dele.
          ○ Se "formName" for informado:

                              ■ Se a busca encontrar o LuaForm, retorna um objeto

                                   form representando a nova instância do Lua Form.
                              ■ Se a busca não encontrar o LuaForm, retorna nil.

function GUI.newGridRecordList()

Cria e retorna um novo objeto gridRecordList.
Parâmetros:

    Não há parâmetros

   Retorno:
       Um objeto gridRecordList.

function GUI.newGridRecordListPgNav()

Cria e retorna um novo objeto gridRecordListPgNav.
Parâmetros:

    Não há parâmetros
   Retorno:
       Um objeto gridRecordListPgNav.

function GUI.newHorzLine()

   Cria e retorna um novo objeto horzLine
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto horzLine

function GUI.newImage()

   Cria e retorna um novo objeto image
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto image.

function GUI.newImageCheckBox()

   Cria e retorna um novo objeto imageCheckbox.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto imageCheckbox.

function GUI.newLabel()

   Cria e retorna um novo objeto label.
   Parâmetros:

       Não há parâmetros
   Retorno:
       Retorna um objeto label.

function GUI.newLayout()

   Cria e retorna um novo objeto layout.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto layout.

function GUI.newPath()

   Cria e retorna um novo objeto path
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto path

function GUI.newPopup()

   Cria e retorna um novo objeto popup
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto popup

function GUI.newPopupForm([popupFormName])

   Cria e retorna um novo objeto popupForm.
   Parâmetros:
          ○ (OPCIONAL) popupFormName - Se informado, contém uma cadeia de
               caracteres identificando o "name" de um dos Lua Forms do plug-in,
               fazendo com que a função busque em todos os arquivos ".lfm" a tag
               popupForm que possuir o atributo name igual a este valor.

Retorno:

          ○ Se "popupFormName" não for informado: Retorna um novo objeto
               popupForm que não possui nenhum outro componente/tag dentro dele.

          ○ Se "popupFormName" for informado:
                              ■ Se a busca encontrar o LuaForm e se for do tipo
                                   popupForm, retorna um objeto popupForm

                                   representando a nova instância do Lua Form.
                              ■ Se a busca não encontrar o LuaForm ou se encontrar

                                   mas tipo diferente de popupForm, retorna nil.

function GUI.newRadioButton()

Cria e retorna um novo objeto radioButton
Parâmetros:

    Não há parâmetros

   Retorno:
       Retorna um objeto radioButton

function GUI.newRecordList()

Cria e retorna um novo objeto recordList
Parâmetros:

    Não há parâmetros

   Retorno:
       Retorna um objeto recordList

function GUI.newRectangle()

Cria e retorna um novo objeto rectangle
Parâmetros:
       Não há parâmetros

   Retorno:
       Retorna um objeto rectangle

function GUI.newRow()

   Cria e retorna um novo objeto row.
   Parâmetros:

       Não há parâmetros

   Retorno:
       Um objeto row.

function GUI.newScrollBox()

   Cria e retorna um novo objeto scrollBox
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto scrollBox

function GUI.newTab()

   Cria e retorna um novo objeto tab
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto tab

function GUI.newTabControl()

   Cria e retorna um novo objeto tabControl
   Parâmetros:
       Não há parâmetros

   Retorno:
       Retorna um objeto tabControl

function GUI.newTextEditor()

   Cria e retorna um novo objeto textEditor
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto textEditor

function GUI.newTimer()

   Cria e retorna um novo objeto timer
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto timer

function GUI.newProgressBar()

   Cria e retorna um novo objeto progressBar
   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto progressBar

function GUI.newInertialMovement()
   Cria e retorna um novo objeto InertialMovement

   Parâmetros:

       Não há parâmetros

   Retorno:
       Retorna um objeto InertialMovement

function GUI.showPopup(form [, options])

   Exibe uma janela na interface do usuário na forma de um Popup

   Parâmetros:

                             ○ form - O formulário a ser exibido na interface. Pode ser um objeto Lua
                                  Form já instanciado ou um string contendo o nome do form a ser
                                  exibido.
                                                  ■ Caso seja passado o nome do formulário em uma cadeia
                                                       de caracteres, a função percorre todos os "lfm" do plug-
                                                       in à procura da tag form que possuir name igual ao
                                                       informado. Se encontrado, uma nova instância é criada
                                                       para a exibição.

                             ○ (OPCIONAL) options - Uma tabela/objeto LUA contendo as opções da
                                  exibição do popup. As opções são:
                                                  ■ onClose - [function, padrão = nil] - Uma função lua que
                                                       será invocada quando o popup for fechado.
                                                  ■ placement - [string enumerado] - Onde o popup será
                                                       exibido.. Os possíveis valores são:
                                                                       ● "center" - no centro da tela
                                                                       ● "bottom" - na parte de baixo da tela
                                                                       ● "top" - na parte de cima da tela
                                                                       ● "left" - à esquerda na tela
                                                                       ● "right" - à direita na tela
                                                                       ● "topLeft" - no canto superior esquerdo
                                                                            da tela
                                                                       ● "topRight - no canto superior direito da
                                                                            tela
                                                                       ● "bottomLeft" - no canto inferior
                                                                            esquerdo da tela
                                                                       ● "bottomRight" - no canto inferior
                                                                            direito da tela
                                                                       ● "mouse" - onde o mouse está
                                                                            atualmente
                                                                       ● "mouseCenter" - centralizado onde o
                                                                            mouse está atualmente.
   Retorno:
       Se conseguir exibir o form como um popup na interface, retorna true; Senão retorna false.

   Observações:
                             ○ A função não espera o popup fechar para retornar. Após esta chamada,
                                  o código LUA continuará sua execução normal enquanto o form é
                                  mostrado.
                             ○ Se o parâmetro form for uma tag popupForm, os seguintes parâmetros
                                  em options são ignorados (e são usados os atributos correspondentes da
                                  tag no lugar):
                                                  ■ options.placement

function GUI.closePopup(form)

   Fecha uma janela popup que foi previamente aberta pela da função gui.showPopup.
   Parâmetros:

                             ○ form - O formulário a ser fechado/tirado da interface. Pode ser um
                                  objeto Lua Form já instanciado ou um string contendo o nome do form
                                  que foi exibido.
                                                  ■ Caso seja passado o nome do formulário em uma cadeia
                                                       de caracteres, a função percorre todos os popups
                                                       abertos e fecha àqueles que possuírem o nome
                                                       informado.

   Retorno:
       Se conseguir fechar o form, retorna true; Senão retorna false.

function GUI.openInBrowser(url)

   Abre um determinado URL/página web no browser do usuário.
   Parâmetros:

                             ○ url - cadeia de caracteres contendo a URL/caminho da página web que
                                  deve ser aberta. Exemplo "http://www.rrpg.com.br".

   Observações:
                             ○ Se o parâmetro "url" não começar com "http://" e nem com "https://",
                                  automaticamente "http://" será adicionado no inicio da URL antes da
                                  abertura da página.

function GUI.toast(message)
Show a quick informative message to the user that does not require user interaction and hides
automatically after a short time

Parameters

                         ○ message - The message string to be shown

Objeto InertialMovement

  Este objeto é responsável por calcular movimentos inerciais em janelas e scrolls de janela.
  Movimento Inercial é aquele movimento produzido quando você "joga" o dedo numa tela
  touchscreen e a tela continua "scrollando" por conta própria.

Características

Propriedades e atributos

Propriedade                  Tipo     Descrição

active                       Boolean  Define se o objeto está ativo ou
                                      não. Seu valor padrão é true e
                                      quando for false não invoca
                                      eventos.

animated                     Boolean  true - O objeto irá calcular
                                      movimentações inerciais

                                      false - O objeto não irá calcular
                                      movimentações inerciais.

                                      Valor padrão: true

decelerationRate             Double   Um número que define a
                                      desaceleração do movimento
                                      inercial.

                                      O valor padrão é 5.75 e quanto
                                      maior este número, mais rápido
                                      o movimento inercial chega ao
                                      fim.

Métodos                               Descrição
   Método
   inertialMov:setPos(x, y)           Define onde se encontra a posição do
                                      item/scroll.
inertialMov:getPos()               Parâmetros:

inertialMov:setBounds(minX, minY,            ● x - um número contendo a posição
maxX, maxY)                                       no eixo X.
inertialMov:pointerDown(x, y)
inertialMov:pointerMove(x, y)                ● y - um número contendo a posição
inertialMov:pointerUp(x, y)                       no eixo Y.

                                   Retorna onde está a posição atual do
                                   item/scroll.

                                   Retorna:

                                             ● Dois números, o primeiro
                                                  contendo a posição no eixo X e o
                                                  segundo contendo a posição no
                                                  eixo Y.

                                   Exemplo de uso:

                                   local posX, posY = inertialMov:getPos();

                                   Define os limites de posição do item/scroll.

                                   Parâmetros:

                                             ● minX - Posição mínima no eixo X
                                             ● minY - Posição mínima no eixo Y
                                             ● maxX - Posição máxima no eixo X
                                             ● maxY - Posição máxima no eixo Y

                                   Invoque este método quando o mouse/touch
                                   for pressionado em algum lugar.

                                   Parâmetros:

                                             ● x - um número contendo a posição
                                                  no eixo X do clique/toque.

                                             ● y - um número contendo a posição
                                                  no eixo Y do clique/toque.

                                   Invoque este método quando o mouse/touch
                                   se mover pela tela.

                                   Parâmetros:

                                             ● x - um número contendo a NOVA
                                                  posição no eixo X do mouse/dedo.

                                             ● y - um número contendo a NOVA
                                                  posição no eixo Y do mouse/dedo.

                                   Invoque este método quando o botão do
                                   mouse for solto/quando o dedo soltar da tela.
inertialMov:pointerLeave()        Parâmetros:

inertialMov:pointerWheel(deltaX,            ● x - um número contendo a onde
deltaY)                                          no eixo X o mouse/toque foi
                                                 liberado.

                                            ● y - um número contendo a onde
                                                 no eixo Y o mouse/toque foi
                                                 liberado.

                                  Invoque este método quando o mouse/toque
                                  sair dos limites do controle da tela.

                                  Invoque este método quando o usuário rolar a
                                  rodinha do mouse.

                                  Parâmetros:

                                            ● deltaX - um número contendo a
                                                 variação do eixo X, isto é, o
                                                 quanto se pretende scrollar no
                                                 eixo X.

                                            ● deltaY - um número contendo a
                                                 variação do eixo Y, isto é, o quanto
                                                 se pretende scrollar no eixo Y.

Eventos            Descrição
   Nome do evento
   onChange        Este evento é invocado quando o objeto possuir novas
                   coordenadas para seu item/scroll.
                   Utilize o método "getPos" para descobrir a nova posição.

Exemplos

Objeto Drag

  Este objeto é responsável por conter informações da operação arrastar-e-soltar em operação.
  Leia mais sobre a operação Arraste e Solte / Drag And Drop.

Características

Propriedades e atributos
Propriedade                Tipo                         Descrição
dataCount                  Inteiro
                                                        (Somente Leitura) Contém a
actionCount                Inteiro                      quantidade de dados associados
                                                        neste Drag/Arraste.
Métodos
   Método                                               (Somente Leitura) Contém a
                                                        quantidade de ações associadas
   drag:addData(dataType,                               neste Drag/Arraste.
   dataValue)
                                    Descrição
drag:getData(dataType)
                                    Adiciona um dado a este Drag/Arraste.
drag:addAction(dataType,
callback)                           Parâmetros:

                                              ● dataType - Uma cadeia de caracteres
                                                   que define o tipo de dados. Existem
                                                   alguns dataType que são padrões do
                                                   RRPG mas você pode inventar um
                                                   dataType novo, se for o caso. Não
                                                   deixe de ler "Arrastando e Soltando
                                                   Informações / Drag And Drop" para
                                                   mais informações sobre o DataType

                                              ● dataValue - O valor associado ao
                                                   dataType

                                    Retorna um dado deste Drag/Arraste.

                                    Parâmetros:

                                              ● dataType - Uma cadeia de caracteres
                                                   que define o tipo de dados. Existem
                                                   alguns dataType que são padrões do
                                                   RRPG mas você pode inventar um
                                                   dataType novo, se for o caso. Não
                                                   deixe de ler "Arrastando e Soltando
                                                   Informações / Drag And Drop" para
                                                   mais informações sobre o DataType

                                    Retorno:

                                              ● O valor associado ao dataType ou nil
                                                   se não possuir associação.

                                    Adiciona uma ação a este Drag/Arraste.

                                    Parâmetros:
Eventos                                           ● dataType - Uma cadeia de caracteres
   Nome do evento                                      que define o tipo de dados associado
                                                       a esta ação. Existem alguns dataType
                                                       que são padrões do RRPG mas você
                                                       pode inventar um dataType novo, se
                                                       for o caso. Não deixe de ler
                                                       "Arrastando e Soltando Informações
                                                       / Drag And Drop" para mais
                                                       informações sobre o DataType

                                                  ● callback - Uma função que será
                                                       invocada caso o usuário arraste este
                                                       drag a uma área de drop que
                                                       contenha informação do tipo
                                                       "dataType" nela. A função recebe os
                                                       seguintes 2 parâmetros na ordem:
                                                                       ○ value - O valor da
                                                                            informação provida
                                                                            pela área de drop.
                                                                       ○ drop - Objeto Drop
                                                                            que contém as
                                                                            informações da área
                                                                            de drop combinada.

                          Descrição

Exemplos

Objeto Drop

  Este objeto é responsável por conter informações da área de drop em uma operação arraste e
  solte / drag and drop.

  Leia mais sobre a operação Arraste e Solte / Drag And Drop.

Características

Propriedades e atributos

Propriedade               Tipo     Descrição

dataCount                 Inteiro  (Somente Leitura) Contém a
actionCount                Inteiro  quantidade de dados associados
                                    nesta área de Drop.

                                    (Somente Leitura) Contém a
                                    quantidade de ações associadas
                                    nesta área de Drop.

Métodos                             Descrição
   Método
   drop:addData(dataType,           Adiciona um dado a esta área de drop.
   dataValue)
                                    Parâmetros:
   drop:getData(dataType)
                                              ● dataType - Uma cadeia de
                                                   caracteres que define o tipo de
                                                   dados. Existem alguns dataType que
                                                   são padrões do RRPG mas você pode
                                                   inventar um dataType novo, se for o
                                                   caso. Não deixe de ler "Arrastando e
                                                   Soltando Informações / Drag And
                                                   Drop" para mais informações sobre
                                                   o DataType

                                              ● dataValue - O valor associado ao
                                                   dataType

                                    Retorna um dado desta área de drop.

                                    Parâmetros:

                                              ● dataType - Uma cadeia de
                                                   caracteres que define o tipo de
                                                   dados. Existem alguns dataType que
                                                   são padrões do RRPG mas você pode
                                                   inventar um dataType novo, se for o
                                                   caso. Não deixe de ler "Arrastando e
                                                   Soltando Informações / Drag And
                                                   Drop" para mais informações sobre
                                                   o DataType

                                    Retorno:

                                              ● O valor associado ao dataType ou nil
                                                   se não possuir associação.
drop:addAction(dataType,             Adiciona uma ação a esta área de drop.
callback)
                                     Parâmetros:

                                               ● dataType - Uma cadeia de
                                                    caracteres que define o tipo de
                                                    dados associado a esta ação. Existem
                                                    alguns dataType que são padrões do
                                                    RRPG mas você pode inventar um
                                                    dataType novo, se for o caso. Não
                                                    deixe de ler "Arrastando e Soltando
                                                    Informações / Drag And Drop" para
                                                    mais informações sobre o DataType

                                               ● callback - Uma função que será
                                                    invocada caso o usuário arraste uma
                                                    informação que contenha
                                                    "dataType" nela. A função recebe os
                                                    seguintes 4 parâmetros na ordem:
                                                                    ○ value - O valor da
                                                                         informação que está
                                                                         sendo arrastada
                                                                    ○ x - A posição na
                                                                         coordenada x de
                                                                         onde a informação
                                                                         está sendo arrastada
                                                                    ○ y - A posição na
                                                                         coordenada y de
                                                                         onde a informação
                                                                         está sendo arrastada
                                                                    ○ drag - Objeto Drag
                                                                         que contém a
                                                                         informação
                                                                         arrastada

Eventos                   Descrição
   Nome do evento

Exemplos
```
