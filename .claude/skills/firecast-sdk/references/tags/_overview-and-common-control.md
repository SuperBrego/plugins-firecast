# Lista de tags do Lua Form + propriedades/métodos/eventos comuns a todos os controles visuais

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tags suportadas pelo Lua Form

Tags de componentes  Descrição

 Tag                 Representa um formulário/uma janela genérica.
 form                A tag raiz do arquivo LFM deve ser “form” ou "popupForm". Pode
                     haver mais de um form no arquivo LFM.
                     Leia mais em: Tag form.

popupForm            Representa um formulário/uma janela cuja finalidade é ser exibida
                     na interface como um popup.
                     Leia mais em: Tag popupForm.

layout               Componente visual invisível. Excelente para agrupar ou organizar
                     um conjunto de outros componentes visuais.
                     Leia mais em: Tag layout

button               Um botão. Excelente para executar uma tarefa quando o usuário
                     optar por ela!
                     Leia mais em: Tag button

label                Um componente texto não editável. Usado apenas para mostrar
                     informações.
                     Leia mais em Tag label
image       Uma imagem.
edit        Leia mais em Tag image
textEditor
tabControl  Uma caixa de texto. Componente que permite a edição de texto ou
tab         números.
scrollBox
            Leia mais em Tag edit
rectangle   Uma caixa de texto que permite várias linhas.
richEdit    Leia mais em Tag textEditor
horzLine
path        Um componente que permite adicionar abas à interface. Deve ser
checkBox    usado em conjunto com “tab”
            Leia mais em Tag tabControl

            Uma aba. Deve ser usado em conjunto com “tabControl”
            Leia mais em Tag tab

            Controle que adiciona barras de rolagem, permitindo realizar
            “scroll” nos componentes que estão dentro da caixa. Em
            dispositivos que possuem touch screen, permite também o gesto
            de “pinça” para efetuar zoom do conteúdo.
            Leia mais em Tag scrollBox

            Controle para desenhar um retângulo de cor personalizada na
            interface.
            Leia mais em tag rectangle.

            Caixa de texto de múltiplas linhas com possibilidade de adicionar
            formatação, cores, alinhamentos, imagens, etc
            Leia mais em tag richEdit

            Uma linha horizontal.
            Leia mais em Tag horzLine

            Uma forma geométrica/shape personalizada.
            Leia mais em Tag path.

            Uma caixa de marcação.
            Leia mais em Tag checkBox
imageCheckBox  Uma caixa de marcação onde é possível personalizar a imagem
               apresentada quando está selecionada e quando não está
radioButton    selecionada.
comboBox       Leia mais em Tag imageCheckBox
colorComboBox
popup          Uma caixa de marcação que, quando usada em grupo, permite
dataLink       apenas uma esteja marcada por vez.
flowLayout     Leia mais em Tag radioButton

flowPart       Uma caixa de seleção que permite o usuário selecionar um item
flowLineBreak  entre vários.
recordList     Leia mais em Tag comboBox
dataScopeBox
               Uma caixa de seleção que permite o usuário escolher uma cor
               qualquer.
               Leia mais em Tag colorComboBox

               Controle que permite exibir popups na interface.
               Leia mais em Tag popup

               Controle invisível que monitora mudanças de valores nos campos
               do NodeDatabase
               Leia mais em Tag dataLink

               Controle que organiza controles na interface de forma dinâmica.
               Excelente para criar interfaces que se adaptam para diferentes
               tamanhos de tela.
               Leia mais em Tag flowLayout

               Usado em conjunto com “flowLayout”, define uma parte dinâmica
               do layout dinâmico.
               Leia mais em Tag flowPart

               Usado em conjunto com “flowLayout”, realiza uma quebra de linha
               no layout dinâmico.
               Leia mais em Tag flowLineBreak

               Um controle que permite adicionar uma lista de registros à
               interface.
               Leia mais em Tag recordList

               Um controle que permite definir em qual objeto Nodo seus
               controles salvarão e lerão os dados (NodeDatabase).
               Leia mais em tag dataScopeBox
timer              Controle invisível que executa determinado código LUA de tempo
activityIndicator  em tempo.
progressBar        Leia mais em Tag timer

                   Controle que exibe uma animação na interface para indicar ao
                   usuário que alguma atividade está sendo feita, como um
                   carregamento ou uma espera.
                   Leia mais em Tag activityIndicator

                   Controle que exibe uma barra de progresso/estado na interface.
                   Leia mais em Tag progressBar

Tags especiais     Descrição
                   Tag que associa um código lua a um evento de algum
 Tag               componente/tag.
 event             Leia mais em Tag event
 style
                   Tag que permite a entrada de código de estilo em cascata, muito
 template          similar ao CSS em HTML.
                   Estude um pouco esta tag! Irá ajudar muito!
 import
 group             Leia mais em Tag style
 script
                   Tag avançada que permite a criação de novas tags para serem
                   usadas no arquivo LFM!
                   Estude um pouco esta tag! Irá ajudar muito!
                   Leia mais em Tag template

                   Importa um arquivo XML.
                   Leia mais em Tag import

                   Tag simples cujo único propósito é organizar o XML do arquivo Lua
                   Form.
                   Leia mais em Tag group

                   Define um script/bloco de código em Lua.
                   Leia mais em Tag script
Características de todas as tags visuais

     O SDK3 utiliza o conceito de orientação a objetos nos componentes visuais e todos os
     componentes visuais são objetos do tipo “controle” (herança, em orientação a objetos).
     Isto significa que todos os componentes e tags visuais de arquivo LFM (edit, label, button, layout,
     etc..) possuem as características, propriedades e métodos descritos nesta seção.

Propriedades e atributos de todas as tags visuais

Propriedade  Tipo                                  Valor Padrão    Descrição
visible      Boolean                               true
                                                                   Define se o controle está visível ou
                                                                   invisível.
                                                                   Um controle pode existir invisível e ser
                                                                   exibido quando alguma condição ou
                                                                   ocasião acontecer.

enabled      Boolean                               true            Define se o controle está ativo ou não.

                                                                   Um controle inativo é exibido na

                                                                   interface, mas não é possível interagir

                                                                   com ele, como se tivesse bloqueado.

name         String                                <string vazio>  Define um nome para o controle.
                                                                   O nome deve ser único, isto é, dentro
                                                                   de um form, não é possível existir 2
                                                                   controles com o mesmo nome. Se não
                                                                   for definido um nome para o controle
                                                                   no arquivo LFM, um nome único será
                                                                   gerado para ele em tempo de
                                                                   compilação. Nomear controles é
                                                                   especialmente útil quando se quer
                                                                   trabalhar com códigos LUA.
align  Enumerado:                 “none”  Define o alinhamento visual do
                      ● “none”            controle na interface.
left                  ● “top”             Com esta propriedade é possível
top                   ● “left”            definir um comportamento padrão de
                      ● “bottom”          posicionamento e tamanho para os
                      ● “right”           controles.
                      ● “client”          none – O controle não sofrerá nenhum
                                          tipo de posicionamento e
                                          redimensionamento automático.
                                          top – O controle será posicionado no
                                          topo de seu pai e a largura será
                                          calculada para preencher o espaço. Os
                                          valores de left, top e width são
                                          calculados automaticamente, mas é
                                          possível definir a altura (height).
                                          left – O controle será posicionado à
                                          esquerda de seu pai e a altura será
                                          calculada para preencher o espaço. Os
                                          valores de “left”, “top” e “height” são
                                          calculados automaticamente, mas é
                                          possível definir a largura (width).
                                          bottom - O controle será posicionado
                                          no rodapé de seu pai e a largura é
                                          calculada para preencher o espaço. Os
                                          valores de left, top e width são
                                          calculados automaticamente, mas é
                                          possível definir a altura (height).
                                          right – O controle será posicionado à
                                          direita de seu pai e a altura será
                                          calculada para preencher o espaço. Os
                                          valores de “left”, “top” e “height” são
                                          calculados automaticamente, mas é
                                          possível definir a largura (width).
                                          client – O controle será posicionado de
                                          forma que ocupe toda a área de seu pai.
                                          Os valores de left, top, width e height
                                          são automaticamente calculados.

       Float                      0.0     Define a posição X do controle.
       Float
                                          A posição é relativa a seu pai.

                                          Veja Posição e Tamanho dos Controles.

                                  0.0     Define a posição Y do controle.

                                          A posição é relativa a seu pai.

                                          Veja Posição e Tamanho dos Controles.
width    Float                    Depende do Define a largura do controle.
height   Float
margins  Bounds (Objeto Lua)      controle    Veja Posição e Tamanho dos Controles.

padding  Bounds (Objeto Lua)      Depende do Define a altura do controle.
anchors
         Conjunto de:             controle    Veja Posição e Tamanho dos Controles.
                        ● left
                        ● top     {}          Define o tamanho das margens do
                        ● right               controle, isto é, o tamanho da “borda
                        ● bottom  {}          invisível” que existe ao redor do
                                  “left top”  controle que o separa do outros.
                                              Especialmente útil quando se usa a
                                              propriedade “align”.
                                              O valor desta propriedade é uma tabela
                                              lua com os campos “left”, “right”, “top” e
                                              “bottom”, onde a omissão de algum
                                              campo representa o valor 0.0.
                                              Exemplos de valores:

                                                             ● {} - left, right, top e
                                                                  bottom 0.0

                                                             ● {left = 5} - left 5, demais
                                                                  valores 0

                                                             ● {left = 5, top = 5} – left
                                                                  5, top 5, right 0, bottom
                                                                  0

                                                             ● {left = 5, right = 5, top =
                                                                  5, bottom = 5} – todos
                                                                  os valores 5

                                                             ●

                                              Define o tamanho do preenchimento
                                              do controle, isto é, o tamanho da
                                              “borda invisível” que existe no interior
                                              do controle entre sua periferia e seu
                                              conteúdo.
                                              O valor desta propriedade é uma tabela
                                              lua com os campos “left”, “right”, “top” e
                                              “bottom”, onde a omissão de algum
                                              campo representa o valor 0.0.

                                              Define como o controle é ancorado em
                                              seu pai.
                                              Quando o pai do controle é
                                              redimensionado, o controle mantém
                                              sua posição relativa baseado em sua
                                              âncora.

                                              Exemplos:
                                                             ● “left” presente, ”right”
                                                                  ausente: O controle
                                                                  manterá sempre a
hitTest  Boolean                  Depende do                      mesma posição X.
cursor                            controle                   ● “left” ausente, “right”
         Enumerado:
                   ● "default"    "default"                       presente: A posição X
                   ● "arrow"                                      será calculada
                   ● "handPoint"                                  automaticamente para
                   ● "hourGlass"                                  manter sempre a
                   ● "IBeam"                                      mesma distância entre
                   ● "size"                                       sua borda direita e a
                   ● "sizeNESW"                                   borda direita de seu
                   ● "sizeNS"                                     pai.
                   ● "sizeNWSE"                              ● “left” e “right”
                   ● "sizeWE"                                     presentes: O controle
                   ● "upArrow"                                    manterá tanto a
                   ● "drag"                                       distância entre (1) sua
                   ● "noDrop"                                     borda esquerda com a
                   ● "hSplit"                                     borda esquerda de seu
                                                                  pai; (2) como sua borda
                                                                  direita com a borda
                                                                  direita de se pai. Para
                                                                  isso, a largura do
                                                                  componente será
                                                                  alterada conforme o
                                                                  pai é redimensionado.
                                                             ● “left” e “right”
                                                                  ausentes: O controle
                                                                  não está ancorado e
                                                                  ocorrerá um efeito
                                                                  similar ao de
                                                                  centralização.
                                              O comportamento das âncoras “top” e
                                              “bottom” é o mesmo das âncoras “left”
                                              e “right”, porém agora no eixo Y.

                                              Define se o clique e movimento do
                                              mouse e o touch são capturados por
                                              este controle.

                                              Define qual cursor de mouse deve ser
                                              apresentado quando o mouse estiver
                                              em em cima do controle. OBS: hitTest
                                              deve ser "true" para esta propriedade
                                              ter efeito.

                                                        ● "default" - Cursor padrão,
                                                             uma seta padrão.

                                                        ● "arrow" - Uma seta padrão.
                                                        ● "handPoint" - Uma mão

                                                             com um dedo apontando
                                                             para cima. Normalmente é
                                                             usado para identificar um
                                                             item selecionável/clicável
                                                        ● "hourGlass" - Uma
                                                             ampulheta para indicar um
● "vSplit"          processo em andamento.
● "multiDrag"  ● "IBeam" - Cursor que
● "sqlWait"
● "no"              sinaliza a possibilidade de
● "appStart"
● "help"            entrar com texto no
● "cross"
                    controle.
               ● "size" - Indicação de

                    possibilidade de

                    redimensionamento.
               ● "sizeNESW" - Indicação de

                    possibilidade de

                    redimensionamento no

                    sentido Nordeste-

                    Sudoeste
               ● "sizeNS" - Indicação de

                    possibilidade de

                    redimensionamento no

                    sentido Norte-Sul
               ● "sizeNWSE" - Indicação de

                    possibilidade de

                    redimensionamento no

                    sentido Noroeste-Sudeste
               ● "sizeWE" - Indicação de

                    possibilidade de

                    redimensionamento no

                    sentido Leste-Oeste
               ● "upArrow" - Uma seta

                    apontando para cima.
               ● "drag" - Um cursor

                    indicando que itens estão

                    sendo arrastados.
               ● "noDrop" - Indicação de

                    que não é possível arrastar

                    para este alvo.
               ● "hSplit" - Indicação de

                    splitter horizontal
               ● "vSplit" - Indicação de

                    splitter vertical.
               ● "multiDrag" - Indicação de

                    que vários itens estão

                    sendo arrastados.
               ● "sqlWait" - Ampulheta

                    indicando um processo de

                    banco de dados em

                    andamento.
               ● "no" - Uma indicação de

                    negação, de que não é

                    possível fazer algo.
               ● "appStart" - Combinação

                    de "default" e "hourGlass",

                    normalmente usado para

                    indicar que um aplicativo
hint           String   ""                           está sendo aberto.
                                                ● "help" - Uma seta com um
canFocus       Boolean  Depende do
tabOrder       Integer  controle                     ponto de interrogação.
                                                ● "cross" - Um cursor em

                                                     formato de cruz, usado
                                                     para indicar um
                                                     posicionamento preciso.

                                      Define um texto de ajuda que é exibido
                                      quando o usuário deixar o mouse por
                                      um certo tempo em cima do controle.
                                      Esta propriedade só tem efeito se o
                                      atributo "hitTest" do controle for true.

                                      Define se o controle pode receber o
                                      foco do teclado.

opacity        Float    <automático>  Define um número que representa a
                        1.0           ordem de tabulação do controle, isto é,
rotationAngle  Float                  quando o usuário apertar TAB no
                        0.0           teclado para pular para o próximo
                                      controle de edição.

                                      Define a transparência do controle.
                                      É um número real que varia de 0.0 a
                                      1.0, onde:

                                                     ● 0.0 – totalmente
                                                          transparente

                                                     ● 0.25
                                                     ● 0.5 – parcialmente

                                                          transparente
                                                     ● 0.75
                                                     ● 1.0 – totalmente opaco.
                                                     ●

                                      Define o ângulo de rotação do controle.
                                      O ângulo é medido em graus.

rotationCenterX Float   <centro X do  Define o valor X da coordenada (X, Y)
                        controle>     do pivô de rotação do controle. Usado
                                      em conjunto com “rotationAngle”

rotationCenterY Float   <centro Y do  Define o valor Y da coordenada (X, Y)
                        controle>     do pivô de rotação do controle. Usado
                                      em conjunto com “rotationAngle”

scaleX         Float    1.0           Define o fator de escala que deve ser
scaleY         Float
scale          Float                  aplicado à largura do controle.

                        1.0           Define o fator de escala que deve ser

                                      aplicado à altura do controle.

                        1.0           Define o fator de escala que deve ser

                                      aplicado à largura e altura do controle.
parent               Um objeto               nil             Define ou retorna o objeto parent

                                                             deste controle.

                                                             Não há necessidade de utilizar este

                                                             atributo em tags de arquivos ".lfm",

                                                             pois o parent de cada tag já é setada

                                                             automaticamente conforme seu

                                                             aninhamento.

                                                             Veja também:

                                                             ● Posição e Tamanho dos

                                                             Controles

Métodos de todas as tags visuais

É possível invocar métodos dos controles usando código LUA.

Método                            Descrição

controle:destroy();               Destrói o controle, liberando a memória usada por ele.

                                  Após a chamada “destroy”, não é mais possível utilizar o

                                  controle.

                                  Normalmente você não precisa se preocupar em destruir

                                  os controles, pois isto é feito automaticamente.

controle:setFocus();              Coloca o foco do teclado neste controle.
controle:beginUpdate();
                                  Coloca o controle num estado de “em alteração”. Neste
controle:endUpdate();             estado, as alterações feitas nas propriedades não serão
controle:needRepaint();           apresentadas na interface.
                                  É útil quando se pretende alterar várias propriedades ou
                                  várias vezes, pois o processo fica mais rápido, já que as
                                  mudanças não serão apresentadas na tela de imediato.
                                  Para cada chamada de “beginUpdate”, deve haver uma
                                  chamada de “endUpdate”.

                                  Tira o controle do estado “em alteração”, voltando a seu
                                  comportamento normal.
                                  Para cada chamada de “beginUpdate”, deve haver uma
                                  chamada de “endUpdate”.

                                  Sinaliza o SDK3 que o controle precisa ser redesenhado na
                                  tela.
                                  Normalmente você não precisa se preocupar em chamar
                                  este método!
controle:getChildren();           Retorna um array (tabela lua com chaves de 1 a
                                  QUANTIDADE) contendo os controles que são filhos
                                  destes controles.
                                  Exemplo:

                                    local filhos = self.panel1:getChildren();
                                    local i;

controle:getParent();               for i = 1, #filhos, 1 do
                                       filhos[i]:algumaCoisa();

                                    end;

                                  Retorna o controle pai deste controle ou nil se não houver.

controle:setParent(parent);       Define o controle pai deste controle.
                                  Parâmetros:
controle:isChildFocused();
controle:isFocused();                            ● parent – O objeto controle que será pai
controle:isMouseOver();                               deste controle ou nil.
controle:isVisible();
controle:findControlByName(       Retorna um boolean (true ou false) indicando se este
controlName);                     controle ou algum dos controles filhos está com o foco do
                                  teclado.
controle:getClassName();
                                  Retorna um boolean (true ou false) indicando se este
                                  controle está com o foco do teclado.

                                  Retorna um boolean (true ou false) indicando se o mouse
                                  está por cima do controle (não necessariamenteclicado).

                                  Retorna um boolean (true ou false) indicando se o controle
                                  está visível.

                                  Procura outro controle através do nome passado pelo
                                  parâmetro “controlName” em toda a hierarquia de
                                  controles onde este está.
                                  Retorna o controle ou nil caso não encontre.

                                  Retorna o nome da classe/tipo da tag deste controle.
                                  Exemplos: "edit", "label", "layout", etc..

Eventos de todas as tags visuais

Nome do evento           Descrição
onClick
                         Este evento é invocado quando ocorre um click com o botão
                         esquerdo do mouse no controle, ou quando ocorre um “tap
                         touch” no controle.
                         Parâmetros:

                                        ● event - uma tabela Lua que contém os seguintes
onDblClick                      atributos:
                                                ○ x – posição X (relativa a este
                                                     controle) indicando onde o click

                                                     ocorreu.
                                                ○ y – posição Y (relativa a este

                                                     controle) indicando onde o click

                                                     ocorreu.
                                                ○ shiftKey - true se a tecla shift

                                                     estiver pressionada
                                                ○ ctrlKey - true se a tecla control

                                                     estiver pressionada
                                                ○ altKey - true se a tecla alt estiver

                                                     pressionada
                                                ○ cmdKey - true se a tecla

                                                     command (macOS) estiver

                                                     pressionada
                                                ○ ctrlOrCmdKey - No macOS: true

                                                     se a tecla command estiver

                                                     pressionada. Outros

                                                     dispositivos: true se a tecla

                                                     control estiver pressionada.
                                                ○ isTouch - true se este evento foi

                                                     disparado por causa de um toque

                                                     em um display touchscreen.

            Este evento é invocado quando ocorre um clique duplo com o

            mouse no controle.

            Parâmetros:
                           ● event - uma tabela Lua que contém os seguintes
                                atributos:
                                                ○ x – posição X (relativa a este
                                                     controle) indicando onde o click

                                                     duplo ocorreu.
                                                ○ y – posição Y (relativa a este

                                                     controle) indicando onde o click

                                                     duplo ocorreu.
                                                ○ shiftKey - true se a tecla shift

                                                     estiver pressionada
                                                ○ ctrlKey - true se a tecla control

                                                     estiver pressionada
                                                ○ altKey - true se a tecla alt estiver

                                                     pressionada
                                                ○ cmdKey - true se a tecla

                                                     command (macOS) estiver

                                                     pressionada
                                                ○ ctrlOrCmdKey - No macOS: true

                                                     se a tecla command estiver

                                                     pressionada. Outros

                                                     dispositivos: true se a tecla

                                                     control estiver pressionada.
                                                ○ isTouch - true se este evento foi

                                                     disparado por causa de um toque
onMouseDown                                           em um display touchscreen.
onMouseMove
             Este evento é invocado quando um botão do mouse é

             pressionado sobre o controle ou quando o dedo toca a tela

             (touchscreen).

             Parâmetros:
                            ● event - uma tabela Lua que contém os seguintes
                                 atributos:
                                                 ○ button – indica qual botão do
                                                      mouse foi pressionado, e pode

                                                      conter um dos seguintes valores:

                                                      “left”, “middle” ou “right”...

                                                      Quando o dedo é pressionado

                                                      (touchscreen), este valor é “left”.
                                                 ○ x – posição X (relativa a este

                                                      controle) indicando onde o

                                                      mouse foi pressionado.
                                                 ○ y – posição Y (relativa a este

                                                      controle) indicando onde o

                                                      mouse foi pressionado.
                                                 ○ shiftKey - true se a tecla shift

                                                      estiver pressionada também
                                                 ○ ctrlKey - true se a tecla control

                                                      estiver pressionada também
                                                 ○ altKey - true se a tecla alt estiver

                                                      pressionada também.
                                                 ○ cmdKey - true se a tecla

                                                      command (macOS) estiver

                                                      pressionada também.
                                                 ○ ctrlOrCmdKey - No macOS: true

                                                      se a tecla command estiver

                                                      pressionada. Outros

                                                      dispositivos: true se a tecla

                                                      control estiver pressionada.
                                                 ○ isTouch - true se este evento foi

                                                      disparado por causa de um toque

                                                      em um display touchscreen.

             Observações:
                                            ○ Este evento só é disparado se a
                                                 propriedade hitTest do controle for

                                                 "true"

             Este evento é invocado quando o mouse se movimenta pelo

             controle ou quando o dedo (touchscreen) é arrastado.

             Parâmetros:
                            ● event - uma tabela Lua que contém os seguintes
                                 atributos:
                                                 ○ x – posição X (relativa a este
                                                      controle) indicando para onde o

                                                      mouse moveu.
                                                 ○ y – posição Y (relativa a este

                                                      controle) indicando para onde o

                                                      mouse moveu.
onMouseUp                                      ○ shiftKey - true se a tecla shift
                                                    estiver pressionada

                                               ○ ctrlKey - true se a tecla control
                                                    estiver pressionada

                                               ○ altKey - true se a tecla alt estiver
                                                    pressionada

                                               ○ cmdKey - true se a tecla
                                                    command (macOS) estiver

                                                    pressionada
                                               ○ ctrlOrCmdKey - No macOS: true

                                                    se a tecla command estiver

                                                    pressionada. Outros

                                                    dispositivos: true se a tecla

                                                    control estiver pressionada.
                                               ○ isTouch - true se este evento foi

                                                    disparado por causa de um toque

                                                    em um display touchscreen.

           Observações:
                                          ○ Este evento só é disparado se a
                                               propriedade hitTest do controle for

                                               "true"

           Este evento é invocado quando um botão do mouse é liberado

           sobre o controle ou quando o dedo solta da tela (touchscreen).

           Parâmetros:
                          ● event - uma tabela Lua que contém os seguintes
                               atributos:
                                               ○ button – indica qual botão do
                                                    mouse foi liberado, e pode

                                                    conter um dos seguintes valores:

                                                    “left”, “middle” ou “right”...

                                                    Quando o dedo é levantado

                                                    (touchscreen), este valor é “left”.
                                               ○ x – posição X (relativa a este

                                                    controle) indicando onde o

                                                    mouse foi liberado.
                                               ○ y – posição Y (relativa a este

                                                    controle) indicando onde o

                                                    mouse foi liberado.
                                               ○ shiftKey - true se a tecla shift

                                                    estiver pressionada
                                               ○ ctrlKey - true se a tecla control

                                                    estiver pressionada
                                               ○ altKey - true se a tecla alt estiver

                                                    pressionada
                                               ○ cmdKey - true se a tecla

                                                    command (macOS) estiver

                                                    pressionada
                                               ○ ctrlOrCmdKey - No macOS: true

                                                    se a tecla command estiver

                                                    pressionada. Outros

                                                    dispositivos: true se a tecla
onMouseEnter                                           control estiver pressionada.
                                                  ○ isTouch - true se este evento foi
onMouseLeave
                                                       disparado por causa de um toque
onResize                                               em um display touchscreen.
onEnter       Observações:
onExit                                       ○ Este evento só é disparado se a
onKeyDown                                         propriedade hitTest do controle for
                                                  "true"
              Este evento é invocado quando o mouse entra na área do
              controle.
              Observações:
                                             ○ Este evento só é disparado se a
                                                  propriedade hitTest do controle for
                                                  "true"

              Este evento é invocado quando o mouse sai da área do controle.
              Observações:

                                             ○ Este evento só é disparado se a
                                                  propriedade hitTest do controle for
                                                  "true"'

              Este evento é invocado quando o controle é redimensionado

              Este evento é invocado quando o controle recebe o foco do
              teclado

              Este evento é invocado quando o controle perde o foco do
              teclado.

              Este evento é invocado quando uma tecla (teclado) é
              pressionada.
              Parâmetros:

                             ● event - uma tabela Lua que contém os seguintes
                                  atributos
                                                  ○ key - Cadeia de caracteres
                                                       contendo a letra do teclado que
                                                       foi pressionada
                                                  ○ keyCode – Código numérico da
                                                       tecla que foi pressionada
                                                       (algumas teclas, como F7, por
                                                       exemplo, não representam uma
                                                       letra, daí a necessidade do
                                                       keyCode)
                                                  ○ shiftKey - true se a tecla shift
                                                       estiver pressionada também
                                                  ○ ctrlKey - true se a tecla control
                                                       estiver pressionada também
                                                  ○ altKey - true se a tecla alt estiver
                                                       pressionada também.
                                                  ○ cmdKey - true se a tecla
                                                       command (macOS) estiver
                                                       pressionada também.
                                                  ○ ctrlOrCmdKey - No macOS: true
onKeyUp                                           se a tecla command estiver
onMenu                                            pressionada. Outros
                                                  dispositivos: true se a tecla
                                                  control estiver pressionada.
         Observações:
                   ● Se você tratou a tecla e nenhum outro componente
                        deveria tentar tratá-la, altere o valor de event.key
                        para "" (string vazia) e event.keyCode para 0.
                   ● Se você alterar o valor de key e/ou keyCode, a
                        mudança é incorporada. Caso queira
                        suprimir/ignorar a tecla que acabou de ser
                        pressionada, atribua event.key = "" e event.keyCode
                        = 0.
                   ● Se a combinação de teclas pressionada puder ser um
                        atalho, então event.key virá com valor "" (string
                        vazio) e event.keyCode com valor diferente de 0.
                   ● Se a combinação de teclas pressionada puder ser
                        tratada como um caractere exibível, event.key vira
                        com uma string contendo apenas este caracter e
                        event.keyCode virá com valor igual a 0.

         Este evento é invocado quando uma tecla (teclado) é liberada.
         Parâmetros:

                        ● event - uma tabela Lua que contém as mesmas
                             propriedades descritas no evento onKeyDown
                             mas com informações sobre a tecla liberada.

         Este evento é invocado quando o usuário deseja exibir o Menu
         do controle. Pode ser que o usuário clicou com botão direito do
         mouse, pressionou a tecla menu ou segurou por um longo tempo
         o dedo na tela (LongTouch).
         Parâmetros:

                                        ○ x - Número contendo onde, em
                                             pixels, no eixo X da tela do usuário, o
                                             menu deve ser exibido.

                                        ○ y - Número contendo onde, em
                                             pixels, no eixo Y da tela do usuário, o
                                             menu deve ser exibido.

                                        ○ event - uma tabela Lua que contém
                                             os seguintes atributos:
                                                            ■ x – Número
                                                                  contendo onde, em
                                                                  pixels, no eixo X da
                                                                  tela do usuário, o
                                                                  menu deve ser
                                                                  exibido.
                                                            ■ y – Número
                                                                  contendo onde, em
                                                                  pixels, no eixo Y da
                                                                  tela do usuário, o
                                                                  menu deve ser
onStartDrag                                                           exibido.
                                                                ■ shiftKey – true se a

                                                                      tecla shift estiver

                                                                      pressionada
                                                                ■ ctrlKey – true se a

                                                                      tecla control estiver

                                                                      pressionada
                                                                ■ altKey – true se a

                                                                      tecla alt estiver

                                                                      pressionada
                                                                ■ cmdKey – true se a

                                                                      tecla command

                                                                      (macOS) estiver

                                                                      pressionada
                                                                ■ ctrlOrCmdKey - No

                                                                      macOS: true se a

                                                                      tecla command

                                                                      estiver pressionada.

                                                                      Outros dispositivos:

                                                                      true se a tecla

                                                                      control estiver

                                                                      pressionada.

             Evento que é chamado quando o usuário deseja iniciar o

             processo de arrastar-e-soltar informações partindo deste

             controle e você deseja informar quais ações ou dados existem

             em um determinado ponto do controle.

             Parâmetros:
                       ● drag - Objeto Drag o qual você deve preencher as
                            informações para o RRPG acasalar o drag com o

                            drop.
                       ● x - posição X (relativa a este controle) indicando

                            onde o drag começou.
                       ● y - posição Y (relativa a este controle) indicando

                            onde o drag começou.
                       ● event - uma tabela Lua que contém os seguintes

                            atributos:
                                            ○ x – posição X (relativa a este
                                                 controle) indicando onde o drag

                                                 começou.
                                            ○ y – posição Y (relativa a este

                                                 controle) indicando onde o drag

                                                 começou.
                                            ○ shiftKey – true se a tecla shift estiver

                                                 pressionada
                                            ○ ctrlKey – true se a tecla control

                                                 estiver pressionada
                                            ○ altKey – true se a tecla alt estiver

                                                 pressionada
                                            ○ cmdKey – true se a tecla command

                                                 (macOS) estiver pressionada
                                            ○ ctrlOrCmdKey - No macOS: true se a
onStartDrop                                      tecla command estiver pressionada.

                                                 Outros dispositivos: true se a tecla

                                                 control estiver pressionada.

             Por favor, consulte Arrastando-e-Soltando Informações / Drag

             and Drop para conhecer melhor sobre o processo drag and drop.

             Observações:
                       ● hitTest deve ser "true" para este evento poder ser
                            chamado.

             Evento que é chamado quando alguém arrasta uma informação

             em cima do controle e você deseja informar quais ações ou

             dados existem em um determinado ponto do controle.

             Parâmetros:
                       ● drop - Objeto Drop o qual você deve preencher as
                            informações para o RRPG acasalar o drag com o

                            drop.
                       ● x - posição X (relativa a este controle) indicando

                            onde o drop está tentando ser feito.
                       ● y - posição Y (relativa a este controle) indicando

                            onde o drop está tentando ser feito
                       ● drag - Objeto Drag representando a informação que

                            está sendo arrastada. Você não deve alterar as

                            propriedades deste objeto.
                       ● event - uma tabela Lua que contém os seguintes

                            atributos:
                                            ○ x – posição X (relativa a este
                                                 controle) indicando onde o drop está

                                                 tentando ser feito.
                                            ○ y – posição Y (relativa a este

                                                 controle) indicando onde o drop está

                                                 tentando ser feito
                                            ○ shiftKey – true se a tecla shift estiver

                                                 pressionada
                                            ○ ctrlKey – true se a tecla control

                                                 estiver pressionada
                                            ○ altKey – true se a tecla alt estiver

                                                 pressionada
                                            ○ cmdKey – true se a tecla command

                                                 (macOS) estiver pressionada
                                            ○ ctrlOrCmdKey - No macOS: true se a

                                                 tecla command estiver pressionada.

                                                 Outros dispositivos: true se a tecla

                                                 control estiver pressionada.

             Por favor, consulte Arrastando-e-Soltando Informações / Drag

             and Drop para conhecer melhor sobre o processo drag and drop.

             Observações:
                       ● hitTest deve ser "true" para este evento poder ser
                            chamado.
Características de todas as tags de textos

     O SDK3 utiliza o conceito de orientação a objetos nos componentes visuais e alguns controles são
     controles de texto (Exemplos: button, label, edit).

Herança

     As tags de textos possuem todas as características de um controle qualquer. Veja Características
     de todas as tags visuais.

Características

     Além das características herdadas, todas as tags textos também possuem as seguintes
     características:

Propriedades e Atributos

Propriedade    Tipo                          Valor Padrão      Descrição
text           String                        <string vazio>
                                                               Define o texto que será exibido
fontColor      String contendo uma cor       Em temas          no controle.
                                             escuros, uma cor
                                             clara.            Define a cor do texto.
                                             Em temas claros,  Exemplos:
                                             uma cor escura.
                                                                              ● Black
                                                                              ● White
                                                                              ● #FDFDFD
                                                               Veja String de cores no Lua
                                                               Form para obter a completa de
                                                               cores e outras formas de uso.

fontFamily     String                        <Varia de         Define a fonte que será usada
                                             Plataforma para   nos textos.
fontSize       Float                         Plataforma>       As fontes disponíveis variam
fontStyle                                                      de plataforma para plataforma
               Conjunto de:                  13.0              (Android, iOS, Windows, etc..)
                              ● “bold”
                              ● “italic”                       Define o tamanho da fonte.
                              ● “underline”
                              ● “strikeout”  “”                Define o estilo da fonte...
                                             “leading”         Exemplos:
horzTextAlign  Enumerado:
                              ● “leading”                                     ● “bold”
                              ● “center”                                      ● “bold italic”
                              ● “trailing”                                    ● “italic

                                                                                   underline bold”
                                                                              ● “”

                                                               Define o alinhamento
                                                               horizontal do texto, onde:

                                                                              ● “leading” –
                                                                                   alinhado à
                                                                                   esquerda

                                                                              ● “center”-
                                                                                   centralizado

                                                                              ● “trailing” –
vertTextAlign  Enumerado:                    “center”                           alinhado à
                              ● “leading”                                       direita
                              ● “center”     false
                              ● “trailing”                  Define o alinhamento vertical
                                             <Varia de      do texto, onde:
wordWrap       Boolean                       controle para
                                             controle>                     ● “leading” –
textTrimming   Enumerado:                                                       alinhado ao
                              ● “none”                                          topo.
                              ● “character”
                              ● “word”                                     ● “center”-
                                                                                centralizado

                                                                           ● “trailing” –
                                                                                alinhado ao
                                                                                rodapé.

                                                            True = Quebra de linha
                                                            automática quando o tamanho
                                                            do texto ultrapassar a largura
                                                            do controle
                                                            False = Limitar o texto em
                                                            apenas uma linha, mesmo que
                                                            ultrapasse a largura do
                                                            controle.

                                                            Quando o tamanho do texto
                                                            ultrapassa a largura do
                                                            controle, o que acontece com o
                                                            texto?

                                                                           ● none -
                                                                                Nenhum
                                                                                tratamento
                                                                                especial, o
                                                                                desenho do
                                                                                texto será
                                                                                truncado de
                                                                                forma “cara-
                                                                                crachá”

                                                                           ● character – o
                                                                                caractere mais
                                                                                perto da linha
                                                                                de corte será
                                                                                substituído
                                                                                pelo símbolo
                                                                                “...”

                                                                           ● word – a
                                                                                palavra que
                                                                                estiver mais
                                                                                perto da linha
                                                                                de corte será
                                                                                substituída
                                                                                pelo símbolo
                                                                                “...”
Características de tags shapes

     O SDK3 utiliza o conceito de orientação a objetos nos componentes visuais e alguns controles são
     controles shape (Exemplos: rectangle, horzLine, etc..).

Herança

     As tags shapes possuem todas as características de um controle qualquer. Veja Características de
     todas as tags visuais.

Características

     Além das características herdadas, todas as tags shapes também possuem as seguintes
     características:

Propriedades e Atributos

Propriedade               Tipo              Valor Padrão  Descrição
color                                       "silver"
                          String contendo                 Define a cor do conteúdo da forma.
                          uma cor                         Veja String de cores no Lua Form para obter a
                                                          completa de cores e outras formas de uso.

strokeColor               String contendo   "black"       Define a cor das linhas da borda.
                          uma cor                         Veja String de cores no Lua Form para obter a
                                                          completa de cores e outras formas de uso.

strokeSize                Float             0.0           Define a espessura das linhas da borda.
strokeCap
                          Enumerado:        "flat"        Define o estilo gráfico usado ao desenhar o fim
                                                          das linhas.
                                 ● "flat"                 "flat" - linhas com pontas retangulares
                                 ● "round"                "round" - linhas com pontas arredondadas.
strokeJoin                Enumerado:             "miter"  Define o estilo gráfico usado ao juntar
                                    ● "miter"             segmentos de linha em uma forma.
                                    ● "round"             "miter" - As quinas/junções são "quadradas".
                                    ● "bevel"             "round" - As quinas/junções são arredondadas.
                                                          "bevel" - As quintas/junções são ligadas de forma
                                                          diagonal.

strokeDash                Enumerado:             "solid"  Define o estilo gráfico da linha.
                                    ● "solid"             "solid" - A linha é sólida
                                    ● "dash"              "dash" - A linha é tracejada
                                    ● "dot"               "dot" - A linha é feita de pontos.
                                    ● "dashD              "dashDot" - A linha é alternada entre traços e
                                                          pontos.
                                         ot"              "dashDotDot" - A linha é alternada entre traço,
                                    ● "dashD              ponto e ponto.

                                         otDot"
```
