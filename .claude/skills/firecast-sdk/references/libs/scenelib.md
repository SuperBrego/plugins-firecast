# Biblioteca scenelib

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca SceneLib

       Biblioteca que contém funções relacionadas ao Scene 3/Tabuleiro de combate do RRPG

       Todas as funções estão contidas na unidade "scene.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "scene.lua"
    require("scene.lua");

    -- Agora é possível acessar as funções da biblioteca
    SceneLib.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca SceneLib

    function SceneLib.getLoadedScenes()

       Retorna um array de Scenes que estão rodando no RRPG no momento.
       Retorno:

                                 ○ Array (tabela lua indexada de 1 a #tabela) de objeto Scene

    function SceneLib.registerPlugin(attachCallback)

       Registra um plug-in de scene no RRPG.
       Parâmetros:

                                 ○ attachCallback - Uma função que será invocada para cada Scene
                                      rodando ou que vier a ser carregado. Esta função recebe dois
                                      parâmetros na seguinte ordem: scene (um objeto Scene) e attachment
                                      (um objeto ScenePluginAttachment) representando, respectivamente,
                                      o scene o qual o plug-in deve instalar e um objeto que identifica esta
                                      ligação entre o plug-in e o scene.

       Retorno:
                                 ○ Um identificador do plug-in registrado que poderá ser utilizado
                                      posteriormente como parâmetro para a função
                                      SceneLib.unregisterPlugin para desregistrá-lo.

       Observações:
                                 ○ Um pacote .rpk (plugin SDK 3) pode instalar mais de um Plug-in de
                                      Scene.
                                 ○ Um plug-in de scene pode existir mesmo quando não há nenhum Scene
                                      rodando no RRPG, não tem problema.
                                 ○ Um plug-in de scene pode se anexar a mais de 1 scene ao mesmo
                                      tempo! A função "attachCallback" será chamada uma vez para cada
                                      Scene existente e uma instância do objeto ScenePluginAttachment será
                                      criada para representar cada uma desta ligação "plugin x scene".
                         ○ Assim como um plug-in pode se anexar a vários scenes, um scene pode
                               estar anexado a vários plug-ins. É uma relação N:N (leia-se: N para N).

Exemplo de um plug-in simples que apenas exibe uma mensagem quando se anexa a um Scene:

            require("scene.lua");

            require("dialogs.lua");

SceneLib.registerPlugin(

function (scene, attachment)

              showMessage("Plugin anexado a um tabuleiro de
tamanho " ..

                                    scene.worldWidth ..
scene.worldMetricName .. " x " ..

                                    scene.worldHeight ..
scene.worldMetricName ..

                  " de cor de fundo "..

scene.bkgColor);

end);

function SceneLib.unregisterPlugin(pluginID)

   Desregistra um plug-in de scene do RRPG que fora previamente instalado pela função
   SceneLib.registerPlugin
   Parâmetros:

                             ○ pluginID - O identificador do plugin que deseja desinstalar. Este valor é
                                  retornado pela função SceneLib.registerPlugin .

   Observações:
                             ○ Normalmente não é preciso se preocupar em desregistrar plug-ins de
                                  scene pois o RRPG já faz este trabalho automaticamente quando o .rpk
                                  é descarregado da memória.
function SceneLib.Math.newRotationMatrix(angle, pivoX, pivoY)

   Cria e retorna uma Matriz de rotação 2D
   Parâmetros:

                             ○ angle - O ângulo da rotação em graus
                             ○ pivoX - A posição X do pivô da rotação
                             ○ pivoY - A posição Y do pivô da rotação
   Retorno:
                             ○ A Matriz de rotação. (Um tipo de dados interno)

function SceneLib.Math.transformPoint(x, y, matrix)

   Transforma a posição de um ponto ao multiplicá-lo por uma matriz.
   Parâmetros:

                             ○ x - A posição X do ponto
                             ○ y - A posição Y do ponto
                             ○ matrix - Uma matriz de transformação.
   Retorno:
                             ○ x - A nova posição X
                             ○ y - A nova posição Y

function SceneLib.Math.rotatePoint(x, y, angle, pivoX, pivoY)

   Rotaciona um ponto.
   Parâmetros:

                             ○ x - A posição X do ponto
                             ○ y - A posição Y do ponto
                             ○ angle - O ângulo da rotação em graus
                             ○ pivoX - A posição X do pivô da rotação
                             ○ pivoY - A posição Y do pivô da rotação
   Retorno:
                             ○ x - A nova posição X
                             ○ y - A nova posição Y
Visão geral da SceneLib

(Conteúdo desta página não consta no documento original.)

Métrica do Mundo vs Métrica da Tela

(Conteúdo desta página não consta no documento original.)

As camadas do tabuleiro

(Conteúdo desta página não consta no documento original.)

Objeto Scene

  O Objeto Scene representa um "tabuleiro de combate" aberto pelo usuário e é a instância principal
  de um Scene e, através deste objeto, o programador consegue acessar todas as propriedades do
  mesmo.

  O programador não consegue instanciar um "Objeto Scene" através do SDK 3, mas:

                                 ○ Consegue descobrir todos os Scenes abertos pelo usuário utilizando a
                                      função SceneLib.getScenes

                                 ○ Consegue instalar um plug-in de Scene para todos os plug-ins abertos (e
                                      que vierem a ser abertos depois) utilizando a função
                                      SceneLib.registerPlugin.

Herança

       O objeto Scene herda de SceneBaseObject e possui também todas as suas características.

Características

  Além das características herdadas, o objeto Scene também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                             Descrição

worldWidth                Double                           Define a LARGURA do tabuleiro
                                                           de combate. O valor desta
                                                           propriedade contem o valor em
                                                           Métrica do Mundo Scene.

worldHeight               Double                           Define a ALTURA do tabuleiro de
                                                           combate. O valor desta
                                                           propriedade contem o valor em
                                                           Métrica do Mundo Scene.

worldMetricNam            String                           Define o nome da métrica do
e             String de Color        mundo que é usada por este scene.
bkgColor      String
bkgImageURL                          Exemplo: "m", "km", "cm", etc..
              Enumerado:
workingLayer            ● "backgrou  Exemplo2: supondo que a
                             nd"     propriedade worldWidth = 60 e
                        ● "objects"  worldMetricName = "km",
                        ● "tokens"   intepreta-se que tabuleiro possui
                                     uma largura de 60 quilômetros.

                                     Define a cor de fundo do tabuleiro.

                                     Exemplo: "white", "black",
                                     "#FFDE05"

                                     Contém a URL da imagem/bitmap
                                     que será renderizada como fundo
                                     do tabuleiro.

                                     Este valor:

                                                     ● Pode ser um
                                                          endereço de
                                                          internet
                                                          (exemplo:
                                                          “http://xxxx.com.
                                                          br/a.png”)

                                                     ● Pode ser o
                                                          caminho de um
                                                          arquivo contido
                                                          no pacote do
                                                          plugin.

                                                     ● Pode ser um
                                                          arquivo que se
                                                          encontra no HD
                                                          Virtual do plugin
                                                          instalado.

                                     Define qual em que camada do
                                     scene o usuário está trabalhando.

                                     "map" - O usuário está
                                     trabalhando na camada
                                     Background

                                     "objects" - O usuário está
                                     trabalhando na camada Objetos

                                     "tokens" - O usuário está
                                     trabalhando na camada Tokens.

                                     Este é um valor local e não é
viewport        Objeto SceneViewport  compartilhado com os outros
                                      usuários que estão visualizando o
grid            Objeto                mesmo scene.
items           SceneGridLayer
fogOfWar        Objeto                Saiba mais sobre as camadas em:
isGM            SceneGraphicItemList  As camadas do tabuleiro
isViewingAsGM   Objeto
                SceneFogOfWar         (Somente Leitura) Objeto
isViewingWalls  Boolean               viewport do Scene. Objeto que
                Boolean               contém propriedades sobre a
                                      "tela" do Scene, como "Qual região
                Boolean               do scene o usuário está vendo",
                                      "Qual o zoom que o usuário
                                      aplicou no tabuleiro?", etc..

                                      (Somente Leitura) Objeto que
                                      contém características,
                                      informações e utilitários a respeito
                                      da GRID do scene.

                                      (Somente Leitura) Objeto que
                                      reúne os itens visuais do tabuleiro
                                      como tokens.

                                      (Somente Leitura) Objeto que
                                      reúne informações e operações
                                      com o FogOfWar/Névoa de
                                      Guerra do Tabuleiro de combate.

                                      (Somente Leitura) True se o
                                      usuário atual é mestre deste scene
                                      ou false.

                                      True se o usuário atual for mestre
                                      e estiver visualizado como mestre
                                      do scene.

                                      O usuário atual pode ser mestre
                                      mas desejar ver como os jogadores
                                      estão enxergando o scene, então
                                      isGM = true e isViewingAsGM =
                                      false.

                                      True se o usuário atual for mestre
                                      e estiver visualizado as
                                      paredes/áreas opacas do
                                      tabuleiro.
currentUserID   String                           (Somente Leitura) Contém o login
                                                 do usuário atual que está
renderAsPlayer  Boolean                          utilizando o Scene.

Métodos                                          (Somente Leitura) Uma
   Método                                        propriedade bem peculiar e mais
   scene:newTransaction()                        difícil de explicar. Algumas vezes,
                                                 mesmo quando "isGM" é true e
   scene:pushTransaction(transaction)            "isViewingAsGM" é true, o
                                                 tabuleiro deve ser renderizado
                                                 como "visualizando como
                                                 jogador".

                                                 Esta propriedade foi feita
                                                 inicialmente pensando na
                                                 integração do Firecast com o
                                                 programa "OBS Studio" para
                                                 streaming. Enquanto o mestre está
                                                 visualizando o tabuleiro como GM,
                                                 o tabuleiro deve ser renderizado
                                                 como jogador para o "OBS Studio".

                                       Descrição

                                       Cria um NodeTransaction que poderá ser
                                       utilizado para gerenciar as mudanças
                                       feitas localmente no Scene.

                                       Retorna:

                                                 ● Um objeto NodeTransaction
                                                      que poderá ser utilizado em
                                                      scene:pushTransaction()

                                       Ativa uma transação para controlar
                                       mudanças no Scene.

                                       Parâmetros:

                                                 ● transaction - um objeto
                                                      NodeTransaction
                                                      previamente criado pela
                                                      função scene:newTransaction
                                                      que controlará as próximas
                                                      mudanças no Scene.

                                       Observações:

                                                 ● Após ativar uma transação,
scene:popTransaction()                 todas as alterações que
                                       ocorrerem no Scene serão
                                       mantidas localmente e não
                                       serão compartilhadas
                                       automaticamente com os
                                       outros usuários. Você deverá
                                       controlar o que acontecerá
                                       com estas mudanças ao
                                       invocar
                                       "transaction:rollback()" se
                                       quiser desfazê-las ou
                                       "transaction:commit()" para
                                       confirmá-las e compartilhar-
                                       lhas com os outros usuários.
                                  ● Para cada chamada de
                                       scene:pushTransaction(), deve
                                       haver uma chamada de
                                       scene:popTransaction().

                        Desativa a última transação ativada no
                        Scene pela função
                        scene:pushTransaction()

                        Observações:

                                  ● Para cada chamada de
                                       scene:pushTransaction(), deve
                                       haver uma chamada de
                                       scene:popTransaction().

                                  ● Se antes de chamar
                                       pushTransaction o Scene já
                                       estava sendo controlado por
                                       alguma transação, esta
                                       transação é restaurada.

                                  ● Apenas invocar este método
                                       não é o suficiente para realizar
                                       o controle das mudanças.
                                       Você o invocar o método
                                       "rollback()" da transaction se
                                       quiser desfazer as mudanças
                                       capturadas ou invocar o
                                       método "commit()" da
                                       transaction para confirmar e
                                       compartilhar as mudanças
                                       capturadas.
scene:broadcastMessage(messageId,    Envia uma mensagem a todos os outros
message [, loopBack])                usuários que estão com o scene aberto.

scene:newBroadcastListener(messageI  Parâmetros:
d, callback)
                                               ● messageId - Uma cadeia de
                                                    caracteres contendo a
                                                    identificação da mensagem.

                                               ● message - A mensagem a ser
                                                    transmitida. Aqui são aceitos
                                                    textos, tabelas lua, números e
                                                    booleanos.

                                               ● (OPICIONAL) loopBack -
                                                    Informa se quer que esta
                                                    mensagem seja retransmitida
                                                    para você mesmo. Valor
                                                    padrão: false

                                     Observações:

                                               ● A mensagem enviada é
                                                    entregue a todos os outros
                                                    usuários conectados no scene.

                                               ● Para receber as mensagens
                                                    recebidas, o usuário
                                                    destinatário deve ter
                                                    previamente invocado a
                                                    função
                                                    scene:newBroadcastListener

                                     Cria uma escuta de mensagens para
                                     receber mensagens postadas pela função
                                     scene:broadcastMessage

                                     Parâmetros:

                                               ● messageId - Uma cadeia de
                                                    caracteres contendo a
                                                    identificação das mensagens
                                                    que deseja receber. Deve ser
                                                    igual ao messageId usado na
                                                    função
                                                    scene:broadcastMessage.

                                               ● callback - Uma função que
                                                    será invocada ao receber
                                                    mensagens. Esta função
                                                    recebe três parâmetros na
                                                    seguinte ordem:
                                                                    ○ sender -
                                                                         Cadeia de
scene:sendDelayedUpdates()                                      caracteres
                                                                contendo o
                                                                login do
                                                                usuário que
                                                                enviou a
                                                                mensagem
                                                           ○ messageId -
                                                                Cadeia de
                                                                caracteres
                                                                contendo a
                                                                identificação
                                                                da mensagem
                                                                recebida
                                                           ○ message - A
                                                                mensagem
                                                                que foi
                                                                postada.

                            Retorno:

                                      ● Retorna um objeto
                                           representando o Listener.

                            Observações:

                                      ● Importante: Mantenha
                                           referência ao objeto
                                           retornado por esta função
                                           enquanto quiser que a escuta
                                           esteja ativa. Se o coletor de
                                           lixo LUA coletar este objeto, a
                                           escuta é destruída e a função
                                           callback não será mais
                                           invocada.

                                      ● Se quiser destruir a escuta
                                           imediatamente, invoque a
                                           função destroy do objeto
                                           retornado.... obj:destroy();

                            Force the scene to transmit all the
                            pending delayed updates caused by the
                            network transfer optimization

Eventos                     Descrição
   Nome do evento
   onWorkingLayerChange     Evento que é chamado quando a propriedade
                            workingLayer for alterada.
onGMStateChange                   Evento que é chamado quando as propriedades isGM,
                                  isViewingAsGM ou isViewingWalls mudarem.

Exemplos

Exemplo 1 - Um Plugin de Scene que, ao se anexar a um tabuleiro, exibe uma mensagem com algumas
características do Scene.

    require("scene.lua");

    require("dialogs.lua");

SceneLib.registerPlugin(
       function (scene, attachment)
              showMessage("Plugin anexado a um tabuleiro de tamanho " ..
                                    scene.worldWidth .. scene.worldMetricName .. " x " ..
                                    scene.worldHeight .. scene.worldMetricName ..
                                    " de cor de fundo ".. scene.bkgColor);
       end);

Objeto SceneBaseObject

  A classe SceneBaseObject é uma abstração e todos os outros objetos do SceneLib herdam desta
  classe. Isto significa que não é possível existir um objeto SceneBaseObject diretamente e que sua
  existência está condicionada à existência dos objetos que herdam dele.

Características

  Todos os objetos que herdam de SceneBaseObject possuem as seguintes características:

Propriedades e atributos

Propriedade               Tipo    Descrição

objectType                String  (Somente Leitura) Cadeia de
                                  caracteres que informam o tipo
isObjectAlive            Boolean      do objeto. Exemplos de valores:
                                      "scene", "viewport", "token",
objectID                 Integer      etc..
userData                 Objeto Nodo
                                      (Somente Leitura) Contém true
                                      se o objeto ainda estiver vivo no
                                      código fonte do RRPG ou false
                                      se ele já foi destruído

                                      (Somente Leitura) Contém um
                                      número único que identifica o
                                      objeto no RRPG local.

                                      (Somente Leitura) Contém um
                                      objeto nodo de um
                                      NodeDatabase que armazena
                                      dados extras que o programador
                                      possa querer armazenar.

                                      Cada Objeto do Scene 3 possui
                                      seu próprio userData.

                                      Saiba mais lendo sobre
                                      NodeDatabase e sobre Objeto
                                      Nodo.

Métodos                               Descrição
   Método
   obj:isType(typeName)               Retorna true se o objeto é do tipo "typeName",
   obj:beginUpdate()                  senão retorna false.

   obj:endUpdate()                    Coloca o objeto em estado de alteração. Se
                                      você for fazer várias mudanças em um objeto
                                      de uma única vez, talvez seja possível obter
                                      uma melhoria de performance usando
                                      beginUpdate.

                                      para cada chamada de beginUpdate, deve
                                      haver 1 chamada de endUpdate

                                      Retira o objeto do estado de alteração que foi
                                      previamente configurado pela função
                                      beginUpdate.

                                      para cada chamada de beginUpdate, deve
                                      haver 1 chamada de endUpdate
obj:newUserDataLink([field])  Cria e retorna um novo objeto DataLink que
                              monitora um determinado field do objeto nodo
                              "userData".

                              Parâmetros:

                                        ● (OPCIONAL) field - Uma cadeia de
                                             string contendo o nome/caminho
                                             do campo que será monitorado.

                              Retorna:

                                        ● Um objeto dataLink que monitora o
                                             field solicitado do "userData" deste
                                             objeto.

                              Observações:

                                        ● Esta é a melhor maneira de
                                             capturar mudança de valores nos
                                             valores de userData.

Eventos            Descrição
   Nome do evento

Objeto SceneCanvas

  O Objeto SceneCanvas representa como um item do Scene deve ser desenhado na tela do usuário
  e, no fundo, é uma lista de operações gráficas que devem ser executadas para compor a aparência
  de um item no tabuleiro.

  O SceneCanvas de um item gráfico pode ser obtido através da propriedade "canvas" de um que
  herde de objeto SceneGraphicItem

  A grande vantagem em utilizar o SceneCanvas é que as operações gráficas são persistidas no scene
  e serão executadas no tabuleiro de cada usuário, mesmo que algum não tenha instalado algum
  determinado plug-in.

Herança

       O objeto SceneCanvas herda de SceneBaseObject e possui também todas as suas
       características.

Características

  Além das características herdadas, o objeto SceneCanvas também possui as seguintes
  características:
Propriedades e atributos  Tipo     Descrição
   Propriedade            Integer
   opCount                         (Somente Leitura) Contém a
                                   quantidade de operações
                                   gráficas que este Canvas possui.

Métodos                            Descrição
   Método
   canvas:getOp(index)             Retorna a operação gráfica de índice passado por
                                   parâmetro.

                                   Parâmetros:

                                                                  ○ index - Um número
                                                                       inteiro informando
                                                                       qual operação gráfica
                                                                       do canvas você deseja
                                                                       obter. Este valor deve
                                                                       estar entre 0 e
                                                                       "opCount" - 1

                                   Retorno:

                                                                  ○ Um objeto
                                                                       SceneDrawingOp
                                                                       representando a
                                                                       operação gráfica do
                                                                       índice informado.

                                   Observação:

                                                                  ○ O item retornado
                                                                       pode ser uma
                                                                       operação gráfica de
                                                                       bitmap/imagem
                                                                       (objeto
                                                                       SceneDrawingOpBitm
                                                                       ap) ou uma operação
                                                                       gráfica de
                                                                       caminho/formas/políg
                                                                       onos (objeto
                                                                       SceneDrawingOpPath
                                                                       ). Para saber qual é o
                                                                       tipo da operação
                                                                       gráfica, verifique a
                                                                       propriedade
                                                                       objectType do objeto
canvas:addBitmap()                                      retornado.
canvas:addPath()
canvas:addText()    Adiciona uma operação gráfica de desenho de
                    bitmap/imagem ao canvas.

                    Parâmetros:

                         Nenhum

                    Retorno:

                                                   ○ Um objeto
                                                        SceneDrawingOpBitm
                                                        ap representando a
                                                        operação gráfica
                                                        criada.

                    Adiciona uma operação gráfica de desenho de
                    caminho/formas/polígonos ao canvas.

                    Parâmetros:

                         Nenhum

                    Retorno:

                                                   ○ Um objeto
                                                        SceneDrawingOpPath
                                                        representando a
                                                        operação gráfica
                                                        criada.

                    Adiciona uma operação gráfica de desenho de
                    texto ao canvas.

                    Parâmetros:

                         Nenhum

                    Retorno:

                                                   ○ Um objeto
                                                        SceneDrawingOpText
                                                        representando a
                                                        operação gráfica
                                                        criada.
   canvas:findByName(name)  Localiza uma operação gráfica pelo seu nome.

   canvas:clear()           Parâmetros:
Eventos
                                                           ○ name - Um texto, o
                                                                nome da operação
                                                                gráfica que está
                                                                procurando neste
                                                                Canvas/Item do
                                                                Scene.

                            Retorno:

                                                           ○ Se o Scene encontrar
                                                                uma operação gráfica
                                                                cuja propriedade
                                                                name for igual ao
                                                                texto informado,
                                                                retorna um objeto
                                                                SceneDrawingOp
                                                                representando a
                                                                operação gráfica
                                                                localizada.

                                                           ○ Se o Scene não
                                                                encontrar, retorna nil.

                            Observação:

                                                           ○ O item retornado
                                                                pode ser uma
                                                                operação gráfica de
                                                                bitmap/imagem
                                                                (objeto
                                                                SceneDrawingOpBitm
                                                                ap) ou uma operação
                                                                gráfica de
                                                                caminho/formas/políg
                                                                onos (objeto
                                                                SceneDrawingOpPath
                                                                ). Para saber qual é o
                                                                tipo da operação
                                                                gráfica, verifique a
                                                                propriedade
                                                                objectType do objeto
                                                                retornado.

                            Limpa o canvas excluindo todas as operações
                            gráficas contida nele.
Nome do evento  Descrição

Exemplos

Exemplo 1 - Um plug-in que adiciona/remove uma marca personalizada quando o usuário clica nos itens
do scene.
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

-- Manipular o evento OnMouseDown do Viewport

              scene.viewport.onMouseDown = function(event)
                     -- Usuário clicou no Scene
                     -- Transformar as coordenadas de tela em métrica de mundo
                     local worldX, worldY =

scene.viewport:screenToWorld(event.x, event.y);

            -- Localizar o item que o usuário clicou
            local item = scene.items:itemAtPoint(worldX, worldY);

            if item ~= nil then
                   -- Encontrou um item na posição clicada.
                   local NOME_MINHA_MARCA = "MarcaExemplo";

            -- Localizar uma operação gráfica neste item com o

nosso nome

                             local opGrafica =
item.canvas:findByName(NOME_MINHA_MARCA);
                             if opGrafica == nil then
                                    --[[ A operação gráfica da minha marca ainda não
                                           existe neste token/item. Vamos criar ]]

                                    opGrafica = item.canvas:addBitmap();
                                    opGrafica.name = NOME_MINHA_MARCA;
                                  -- Abaixo, URL da imagem da nossa marca.
                                    opGrafica.url =
"https://wiki.teamfortress.com/w/images/d/dd/Bleed_drop.png?
t=20110425044341";
                                    opGrafica.x = 0.25;
                                    opGrafica.width = 0.3;
                                    opGrafica.y = -0.1;
                                    opGrafica.height = 0.3;
                                    opGrafica.z = 10;
                             else
                                    -- Vamos apagar nossa operação gráfica
previamente criada
                                    opGrafica:delete();
                             end;
                     end;
              end;
end);

                   Item sem a marca  Item com a marca
Exemplo 2 -

Objeto SceneDrawingOp

  O Objeto SceneDrawingOp representa uma operação gráfica de um SceneCanvas .

Herança

       O objeto SceneDrawingOp herda de SceneBaseObject e possui também todas as suas
       características.

Abstração

  Esta é uma classe abstrata e você nunca encontrará um objeto SceneDrawingOp vivo sem ser uma
  das seguintes classes:

            ● Objeto SceneDrawingOpBitmap
            ● Objeto SceneDrawingOpPath

Características

  Além das características herdadas, o objeto SceneDrawingOp também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo       Descrição
objectType  String:                 (Somente Leitura) Contém um
                      ● "opBitmap"  texto que identifica o tipo da
x                     ● "opPath"    operação gráfica e pode conter
y                     ● "opText"    um dos seguintes valores:

            Double                            ● "opBitmap" - este
            Double                                 operação gráfica é
                                                   um Objeto
                                                   SceneDrawingOpBit
                                                   map, uma
                                                   imagem/bitmap.

                                              ● "opPath" - esta
                                                   operação gráfica é
                                                   um Objeto
                                                   SceneDrawingOpPa
                                                   th, um
                                                   caminho/forma/polí
                                                   gono.

                                              ● "opText" - Esta
                                                   operação gráfica é
                                                   um Objeto
                                                   SceneDrawingOpTe
                                                   xt, um texto.

                                    Contém a posição X de onde
                                    esta operação gráfica deve ser
                                    renderizada.

                                    Por padrão, este valor está em
                                    uma métrica relativa ao
                                    SceneCanvas de um item no
                                    scene e é normalizado entre 0.0
                                    e 1.0, onde 0.0 = canto esquerdo
                                    do item, 0.5 = centro do item e
                                    1.0 = canto direito do item.
                                    (Item, neste caso, é o
                                    Token/UserDrawing/EffectArea
                                    desta operação gráfica)

                                    Contém a posição Y de onde
                                    esta operação gráfica deve ser
                                    renderizada.

                                    Por padrão, este valor está em
                                    uma métrica relativa ao
                                    SceneCanvas de um item no
width   Double  scene e é normalizado entre 0.0
                e 1.0, onde 0.0 = canto superior
height  Double  do item, 0.5 = centro do item e
                1.0 = canto inferior do item
z       Double  (Item, neste caso, é o
                Token/UserDrawing/EffectArea
                desta operação gráfica)

                Contém a largura que a
                operação gráfica deve ser
                renderizada.

                Por padrão, este valor está em
                uma métrica relativa ao
                SceneCanvas de um item no
                scene e é normalizado entre 0.0
                e 1.0, onde 0.5 = metade da
                largura do item, 1.0 = largura do
                item e 2.0 = duas vezes a largura
                do item. (Item, neste caso, é o
                Token/UserDrawing/EffectArea
                desta operação gráfica)

                Contém a altura que a operação
                gráfica deve ser renderizada.

                Por padrão, este valor está em
                uma métrica relativa ao
                SceneCanvas de um item no
                scene e é normalizado entre 0.0
                e 1.0, onde 0.5 = metade da
                altura do item, 1.0 = altura do
                item e 2.0 = duas vezes a altura
                do item. (Item, neste caso, é o
                Token/UserDrawing/EffectArea
                desta operação gráfica)

                Contém um número para definir
                a ordem Z da operação gráfica,
                isto é, a ordem em que deve ser
                renderizada.

                Exemplo: Se A e B forem duas
                operações gráficas de um
                mesmo Item de Scene e se A
                possuir ordem Z equivalente a 5
                e B possuir ordem Z equivalente
                a 10, a operação gráfica A
                aparecerá abaixo da operação
                gráfica B na tela.
name        String                   Um texto auxiliar qualquer para
opacity                              ajudar a identificar qual é esta
rotMode     Double                   operação gráfica.

visibility  Enumerado:               Pode ser utilizado pela função
rotation              ● "default"    "canvas:findByName()" do
rotCenterX            ● "ignoreCanv  objeto SceneCanvas para fácil
                           asRot"    localização.

            Enumerado:               Define a opacidade da operação
            "everyone"               gráfica.
            "gmOnly"
                                     Este valor varia de 0.0 a 1.0,
            Double                   onde 0.0 = totalmente
            Double                   transparente e 1.0 = totalmente
                                     opaco.

                                     Define como a operação gráfica
                                     deve se comportar em relação à
                                     rotação do item/canvas dono da
                                     operação gráfica.

                                     "default": Padrão, a operação
                                     gráfica deve ser rotacionada
                                     conforme a rotação de seu
                                     canvas/item do scene.

                                     "ignoreCanvasRot": A
                                     renderização desta operação
                                     gráfica deve ignorar a rotação
                                     de seu canvas/item do scene.

                                     Define quem pode visualizar
                                     esta operação gráfica:

                                     "everyone": Padrão, todos
                                     podem visualizar esta operação
                                     gráfica.

                                     "gmOnly": Apenas o mestre da
                                     mesa pode ver esta operação
                                     gráfica.

                                     Define a rotação da operação
                                     gráfica em graus.

                                     Define onde, no eixo X da
                                     operação gráfica, está o pivô de
                                     rotação.

                                     O valor varia entre 0.0 a 1.0:
rotCenterY      Double                            ● 0.0 = lado esquerdo
                                                       do desenho.
drawingTrigger  Conjunto:
                          ● "hover"               ● 0.5 = centro do
                          ● "selected"                 desenho (Padrão)

                                                  ● 1.0 = lado direito do
                                                       desenho.

                                        Define onde, no eixo Y da
                                        operação gráfica, está o pivô de
                                        rotação.

                                        O valor varia entre 0.0 a 1.0:

                                                  ● 0.0 = parte superior
                                                       do desenho.

                                                  ● 0.5 = centro do
                                                       desenho (Padrão).

                                                  ● 1.0 = parte inferior
                                                       do desenho.

                                        Define gatilhos para esta
                                        operação ser desenhada.

                                        É um conjunto, uma tabela
                                        contendo um ou mais dos
                                        seguintes itens:

                                        "hover" - Quando o mouse
                                        estiver por cima do
                                        objeto/token.

                                        "selected" - Quando o
                                        objeto/token estiver
                                        selecionado.

                                        Exemplos:

                                                  ● {} - Não há gatilhos,
                                                       sempre é desenhada

                                                  ● {"hover"} - Quando o
                                                       mouse estiver por
                                                       cima do item.

                                                  ● {"hover", "selected"}
                                                       - Quando o mouse
                                                       estiver por cima do
                                                       item ou quando o
                                                       item estiver
                                                       selecionado.
outOfOrderMode  Enumerado:                Define se a operação gráfica
                          ● "noOutOfOr    possui um comportamento fora
xMetric                        der"       da ordem padrão.
yMetric                   ● "afterFogOf
widthMetric                    WarLayer"  "noOutOfOrder" - (Padrão) A
heightMetric              ● "beforeOwne   operação não possui
                               rLayer"    comportamento de desenho
                          ● "afterOwner   fora da ordem e é desenhado na
                               Layer"     ordem normal.

                Enumerado:                "afterFogOfWarLayer" - A
                          ● "screenMetri  operação possui
                               c"         comportamento de desenho
                          ● "worldMetric  fora de ordem. É desenhada
                               "          após a camada de Fog Of War
                          ● "canvasMetri  ser desenhada no tabuleiro.
                               c"
                          ● "cellMetric"  "beforeOwnerLayer" - A
                                          operação possui
                                          comportamento de desenho
                                          fora de ordem. Ela é desenhada
                                          abaixo da camada do item que a
                                          possui.

                                          "afterOwnerLayer" -
                                          "beforeOwnerLayer" - A
                                          operação possui
                                          comportamento de desenho
                                          fora de ordem. Ela é desenhada
                                          acima da camada do item que a
                                          possui.

                                          Altera a medida em que as
                                          propriedades "x", "y", "width" e
                                          "height" foram informadas:

                                          "canvasMetric" - (Padrão) A
                                          propriedade está representado
                                          em métricas de canvas, onde,
                                          por exemplo, 0.5 = metade da
                                          largura/altura do
                                          token/desenho e 1.0 =
                                          largura/altura do
                                          token/desenho.

                                          "screenMetric" - A propriedade
                                          está representado em métricas
                                          de tela.

                                          "worldMetric" - A propriedade
                                          está representado em métricas
                                          de mundo.
xOrigin                Double                        "cellMetric" - A propriedade
yOrigin                                              está representado em métricas
                                                     de células. (Exemplo, 0.5 = meia
Métodos                                              célula do grid, 2 = duas células
   Método                                            do grid)
   drawingOp:delete()
                                                     Contém a posição de origem no
                                                     eixo X e no eixo Y de onde as
                                                     propriedades "x" e "y" são
                                                     relativas.

                                                     Este valor está em uma métrica
                                                     relativa ao SceneCanvas de um
                                                     item no scene e é normalizado
                                                     entre 0.0 e 1.0, onde 0.0 = canto
                                                     esquerdo do item, 0.5 = centro
                                                     do item e 1.0 = canto direito do
                                                     item. (Item, neste caso, é o
                                                     Token/UserDrawing/EffectArea
                                                     desta operação gráfica)

                                                     Observação: Estes valores são
                                                     úteis apenas quando é usado
                                                     xMetric/yMetric diferente de
                                                     "canvasMetric".

                                                     Exemplo:

                                                     x = -1;

                                                     xMetric = "cellMetric";

                                                     xOrigin = 0.5;

                                                     width=2

                                                     widthMetric="cellMetric"

                                                     Faz com que a operação gráfica
                                                     tenha largura equivalente a 2
                                                     células do grid e sua posição X
                                                     seja equivalente ao "centro X do
                                                     token menos 1 célula do grid"
                                                     (Horizontalmente alinhado)

                               Descrição

                               Remove/Apaga a operação gráfica do Canvas do
                               Item no Scene.
Eventos            Descrição
   Nome do evento

Exemplos

Exemplo 1 - Um plug-in que adiciona/remove uma marca personalizada quando o usuário clica nos itens
do scene.
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

-- Manipular o evento OnMouseDown do Viewport

              scene.viewport.onMouseDown = function(event)
                     -- Usuário clicou no Scene
                     -- Transformar as coordenadas de tela em métrica de mundo
                     local worldX, worldY =

scene.viewport:screenToWorld(event.x, event.y);

            -- Localizar o item que o usuário clicou
            local item = scene.items:itemAtPoint(worldX, worldY);

            if item ~= nil then
                   -- Encontrou um item na posição clicada.
                   local NOME_MINHA_MARCA = "MarcaExemplo";

            -- Localizar uma operação gráfica neste item com o

nosso nome

                             local opGrafica =
item.canvas:findByName(NOME_MINHA_MARCA);
                             if opGrafica == nil then
                                    --[[ A operação gráfica da minha marca ainda não
                                           existe neste token/item. Vamos criar ]]

                                    opGrafica = item.canvas:addBitmap();
                                    opGrafica.name = NOME_MINHA_MARCA;
                                  -- Abaixo, URL da imagem da nossa marca.
                                    opGrafica.url =
"https://wiki.teamfortress.com/w/images/d/dd/Bleed_drop.png?
t=20110425044341";
                                    opGrafica.x = 0.25;
                                    opGrafica.width = 0.3;
                                    opGrafica.y = -0.1;
                                    opGrafica.height = 0.3;
                                    opGrafica.z = 10;
                             else
                                    -- Vamos apagar nossa operação gráfica
previamente criada
                                    opGrafica:delete();
                             end;
                     end;
              end;
end);

                   Item sem a marca  Item com a marca
Exemplo 2 -

Objeto SceneDrawingOpBitmap

  O Objeto SceneDrawingOpBitmap representa uma operação gráfica de um Bitmap/Imagem em um
  SceneCanvas .

Herança

       O objeto SceneDrawingOpBitmap herda de SceneDrawingOp e possui também TODAS todas
       as suas características.

       Veja também:

                                 ○ Objeto SceneDrawingOp
                                 ○ Objecto SceneBaseObject

Características

  Além das características herdadas, o objeto SceneDrawingOpBitmap também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo       Descrição
objectType  String "opBitmap"  (Somente Leitura) Contém um
url         String             texto que identifica o tipo da
                               operação gráfica - "opBitmap".
flipHorz    Boolean
flipVert    Boolean            Contém a URL da imagem/bitmap
grayscale   Boolean            que será renderizada.
colorBlend  String de Cor
                               Este valor:

                                               ● Pode ser um
                                                    endereço de
                                                    internet (exemplo:
                                                    “http://xxxx.com.b
                                                    r/a.png”)

                                               ● Pode ser o
                                                    caminho de um
                                                    arquivo contido no
                                                    pacote do plugin.

                                               ● Pode ser um
                                                    arquivo que se
                                                    encontra no HD
                                                    Virtual do plugin
                                                    instalado.

                               Determina se a imagem deve ser
                               desenhada de forma espelhada
                               horizontalmente.

                               Determina se a imagem deve ser
                               desenhada de forma espelhada
                               verticalmente.

                               Determina se imagem deve ser
                               desenhada usando um filtro de
                               cores que transforma a imagem em
                               uma imagem de escala cinzenta.

                               Determina se a imagem deve ser
                               desenhada utilizando um filtro que
                               misturando as cores originais com
                               uma cor definida pela propriedade
                               "colorBlend".

                               O valor padrão é "#00000000" e
                               significa não realizar misturar de
                               cores.

                               Exemplo: "Blue" fará com que a
                               imagem seja desenhada misturada
colorMask  String de Cor            com a cor azul.
filterEx
           Enumerado:               Determina se a imagem deve ser
                     ● "none"       desenhada utilizando um filtro que
                          (Padrão)  seleciona as cores da imagem
                     ● "glow"       realizando uma multiplicação das
                     ● "innerGlo    cores da imagem pela cor definida
                          w"        em "colorMask".
                     ● "blur"
                     ● "sepia"      O valor padrão é "#FFFFFFFF" e
                                    significa que todas as coras
                                    originais da imagem deve ser
                                    desenhadas sem alteração.

                                    Exemplo: "Blue" fará com que a
                                    imagem seja desenhada
                                    selecionando apenas os tons azuis
                                    pois os componentes da cor azul
                                    são R = 0, G = 0 e B = 255, o que
                                    transformando em notação de
                                    ponto flutuante fica R = 0.0, G = 0.0,
                                    B = 1.0... Para cada pixel da imagem,
                                    o Red será multiplicado por 0, o
                                    Green será multiplicado por 0 e o
                                    Blue será multiplicado por 1.0.

                                    Determina se a imagem deve ser
                                    desenhada com mais algum filtro de
                                    imagem especial.

                                    "none" - Nenhum filtro especial.

                                    "glow" - Um filtro que adiciona uma
                                    incandescência à imagem. Não
                                    esqueça de preencher a
                                    propriedade "filterExColor" ao
                                    utilizar este filtro.

                                    "innerGlow" - Um filtro que
                                    adiciona um brilho interno à
                                    imagem. Não esqueça de preencher
                                    a propriedade "filterExColor" ao
                                    utilizar este filtro.

                                    "blur" - Um filtro que aplica um
                                    "borrão" na imagem.

                                    "sepia" - Um filtro que aplica um
                                    tom marrom na imagem.
   filterExColor  String de Cor            Alguns filtros permitem escolher
   frame                                   uma cor como parâmetro.
   sourceRect     Enumerado:
                            ● "none"       Se a propriedade filterEx for:
Métodos                          (Padrão)
   Método                   ● "boton"      "glow" - Esta propriedade contém a
                                           cor da incandescência que será
                  Estrutura SceneRect      criada na imagem.

                                           "innerGlow" - Esta propriedade
                                           contém a cor do brilho interno que
                                           será criado na imagem.

                                           A cor padrão é "Red"

                                           Determina se a imagem deve ser
                                           desenhada com alguma borda.

                                           "none" - A imagem será desenhada
                                           sem bordas.

                                           "boton" - A imagem será desenhada
                                           com borda de um bóton
                                           arredondado.

                                           Determina, utilizando uma
                                           Estrutura SceneRect, qual porção
                                           da imagem original deve ser
                                           desenhada.

                                           Os valores de left, top, right e
                                           bottom vão de 0.0 a 1.0, onde 0.0 =
                                           representa o inicio e 1.0 o final do
                                           eixo.

                                           O valor padrão é: {left=0.0, top=0.0,
                                           right=1.0, bottom=1.0} ... isto é,
                                           desenhar todo contéudo da imagem
                                           original.

                                           Exemplo:

                                                     ● {left=0.5, top=0,
                                                          right=1.0, bottom=0.5}
                                                          - Desenhar apenas o
                                                          quadrante superior-
                                                          direita da imagem.

                  Descrição
Eventos            Descrição
   Nome do evento

Exemplos

Exemplo 1 - Um plug-in que adiciona/remove uma marca personalizada quando o usuário clica nos itens
do scene.
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

-- Manipular o evento OnMouseDown do Viewport

              scene.viewport.onMouseDown = function(event)
                     -- Usuário clicou no Scene
                     -- Transformar as coordenadas de tela em métrica de mundo
                     local worldX, worldY =

scene.viewport:screenToWorld(event.x, event.y);

            -- Localizar o item que o usuário clicou
            local item = scene.items:itemAtPoint(worldX, worldY);

            if item ~= nil then
                   -- Encontrou um item na posição clicada.
                   local NOME_MINHA_MARCA = "MarcaExemplo";

            -- Localizar uma operação gráfica neste item com o

nosso nome

                             local opGrafica =
item.canvas:findByName(NOME_MINHA_MARCA);
                             if opGrafica == nil then
                                    --[[ A operação gráfica da minha marca ainda não
                                           existe neste token/item. Vamos criar ]]

                                    opGrafica = item.canvas:addBitmap();
                                    opGrafica.name = NOME_MINHA_MARCA;
                                  -- Abaixo, URL da imagem da nossa marca.
                                    opGrafica.url =
"https://wiki.teamfortress.com/w/images/d/dd/Bleed_drop.png?
t=20110425044341";
                                    opGrafica.x = 0.25;
                                    opGrafica.width = 0.3;
                                    opGrafica.y = -0.1;
                                    opGrafica.height = 0.3;
                                    opGrafica.z = 10;
                             else
                                    -- Vamos apagar nossa operação gráfica
previamente criada
                                    opGrafica:delete();
                             end;
                     end;
              end;
end);

                   Item sem a marca        Item com a marca
Exemplo 2 -

Objeto SceneDawingOpPath

  O Objeto SceneDrawingOpPath representa uma operação gráfica de um caminho/forma/polígono
  em um SceneCanvas .

Herança

       O objeto SceneDrawingOpPath herda de SceneDrawingOp e possui também TODAS todas as
       suas características.

       Veja também:

                                 ○ Objeto SceneDrawingOp
                                 ○ Objecto SceneBaseObject

Características

  Além das características herdadas, o objeto SceneDrawingOpPath também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo             Descrição

objectType                String "opPath"  (Somente Leitura) Contém um texto que
data, pathData  String         identifica o tipo da operação gráfica -
ou path                        "opBitmap".

color           String de Cor  Define a forma vetorial do path. Este
                               texto deve estar no mesmo padrão do
strokeColor     String de Cor  path do SVG e do XAML.

strokeSize      Double         Consulte a documentação deles na
                               internet!

                               Outro link que pode ajudar:
                               http://www.w3schools.com/svg/svg_pat
                               h.asp

                               Observação Importante: Path será
                               automaticamente redimensionado para
                               ficar com a mesma dimensão definida
                               para esta operação gráfica.

                               Define a cor do conteúdo da forma.

                               Veja String de cores para obter a
                               completa de cores e outras formas de
                               uso.

                               Define a cor do conteúdo da forma.

                               Valor padrão: White

                               Define a cor do contorno da forma.

                               Veja String de cores para obter a
                               completa de cores e outras formas de
                               uso.

                               Define a cor do conteúdo da forma.

                               Valor padrão: Black

                               Define a largura do contorno da forma.
                               O significado deste número depende do
                               valor da propriedade "strokeSizeMetric"

                               Valor padrão: 0.0;
strokeSizeMetri  Enumerado:             Define em que medida a propriedade
c                          ● "scree     "strokeSize" está medida.
                                nMetri
strokeCap                       c"      "screenMetric" - (Padrão) strokeSize
strokeJoin                 ● "world     está representado em métricas de tela.
                                Metric
                                "       "worldMetric" - strokeSize está
                           ● "canva     representado em métricas de mundo.
                                sMetri
                                c"      "canvasMetric" - strokeSize está
                           ● "cellM     representado em métricas de canvas,
                                etric"  onde, por exemplo, 0.5 = metade da
                                        largura/altura do token/desenho e 1.0 =
                 Enumerado:             largura/altura do token/desenho.
                           ● "flat"
                           ● "round     "cellMetric" - strokeSize está
                                "       representado em métricas de células.
                                        (Exemplo, 0.5 = meia célula do grid, 2 =
                 Enumerado:             duas células do grid)
                           ● "miter"
                           ● "round     Define o estilo gráfico usado ao
                                "       desenhar o fim das linhas.
                           ● "bevel"
                                        "flat" - linhas com pontas retangulares

                                        "round" - linhas com pontas
                                        arredondadas.

                                        Valor padrão: "flat"

                                        Define o estilo gráfico usado ao juntar
                                        segmentos de linha em uma forma.

                                        "miter" - As quinas/junções são
                                        "quadradas".

                                        "round" - As quinas/junções são
                                        arredondadas.

                                        "bevel" - As quintas/junções são ligadas
                                        de forma diagonal.

                                        Valor padrão: "miter"
   strokeDash      Enumerado:             Define o estilo gráfico da linha.

Métodos                      ● "solid"    "solid" - A linha é sólida
   Método                    ● "dash"
                             ● "dot"      "dash" - A linha é tracejada
                             ● "dashD
                                          "dot" - A linha é feita de pontos.
                                  ot"
                             ● "dashD     "dashDot" - A linha é alternada entre
                                          traços e pontos.
                                  otDot"
                                          "dashDotDot" - A linha é alternada entre
                                          traço, ponto e ponto.

                                          Valor padrão: "solid"

                   Descrição

Eventos            Descrição
   Nome do evento

Exemplos

Exemplo 1 - Um plug-in que adiciona/remove um triângulo amarelo quando o usuário clica nos itens do
scene.
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

-- Manipular o evento OnMouseDown do Viewport

              scene.viewport.onMouseDown = function(event)
                     -- Usuário clicou no Scene
                     -- Transformar as coordenadas de tela em métrica de mundo
                     local worldX, worldY =

scene.viewport:screenToWorld(event.x, event.y);

            -- Localizar o item que o usuário clicou
            local item = scene.items:itemAtPoint(worldX, worldY);

            if item ~= nil then
                   -- Encontrou um item na posição clicada.
                   local NOME_MINHA_MARCA = "MarcaExemplo";

            -- Localizar uma operação gráfica neste item com o

nosso nome

                             local opGrafica =
item.canvas:findByName(NOME_MINHA_MARCA);
                 if opGrafica == nil then
                        --[[ A operação gráfica da minha marca ainda não
                               existe neste token/item. Vamos criar ]]

                   opGrafica = item.canvas:addPath();
                   opGrafica.name = NOME_MINHA_MARCA;

largura do item    -- Começar a desenhar no X equivalente a 80% da
altura do item     -- Começar a desenhar no Y equivalente a 25% da
                   opGrafica.x = 0.8;
                   opGrafica.y = 0.25;

                                    opGrafica.width = 0.5; -- Largura do Path: 50%
da largura do item

                   opGrafica.height = 0.4; -- Altura do Path: 40%

da altura do item

                   opGrafica.z = 10;

                   -- Cores e estilo do PATH
                   opGrafica.color = "yellow";
                opGrafica.strokeSize = 1;

                -- O path data (Um triângulo apontado para a

direita)

                opGrafica.data = "M 0 0 L 1 0.5 L 0 1 Z";

                else

                                    -- Vamos apagar nossa operação gráfica
previamente criada

                opGrafica:delete();

                end;

          end;

          end;

end);

Item sem a marca

                                     Item com a marca
Exemplo 2 -

Objeto SceneDrawingOpText

  O Objeto SceneDrawingOpText representa uma operação gráfica de um texto em um SceneCanvas
  .

Herança

       O objeto SceneDrawingOpText herda de SceneDrawingOp e possui também TODAS todas as
       suas características.

       Veja também:

                                 ○ Objeto SceneDrawingOp
                                 ○ Objecto SceneBaseObject

Características

  Além das características herdadas, o objeto SceneDrawingOpText também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo                    Descrição

objectType                String "opText"         (Somente Leitura) Contém um
                                                  texto que identifica o tipo da
                                                  operação gráfica - "opBitmap".

text                      String                  O texto a ser desenhado no
color                     String de Cor           canvas.

fontStyle                 Uma tabela contendo de  Define a cor do texto.
                          um ou mais dos
                          seguintes valores:      Veja String de cores para obter
                                                  a completa de cores e outras
                                                  formas de uso.

                                                  Valor padrão: Black.

                                                  Define o estilo que será
                                                  aplicado ao texto e pode ser a
                                                  combinação de 0 ou mais dos
                                                  seguintes valores:
   horzTextAlign            ● "bold"       "bold" - Texto negrito
                            ● "italic"
   vertTextAlign            ● "underline"  "italic" - Texto em itálico
                            ● "strikeout"
   aspect                                  "underline" - Texto com
Métodos           Enumerado:               underline.
                            ● "leading"
   Método                   ● "center"     "strikeout" - Texto tachado.
                            ● "trailing"
                                           Exemplos:
                  Enumerado:                         ● {} - (Valor padrão)
                            ● "leading"              ● {"bold", "italic"} -
                            ● "center"                    (negrito e itálico)
                            ● "trailing"             ● {"bold"} - (apenas
                                                          negrito)
                  Double
                                           Define como será o
                                           alinhamento horizontal do
                                           texto.

                                           "leading" - Alinhado à esquerda

                                           "center" - Alinhado ao centro

                                           "trailing" - Alinhado à direita

                                           Valor padrão: "leading"

                                           Define como será o
                                           alinhamento vertical do texto.

                                           "leading" - Alinhado ao topo.

                                           "center" - Alinhado ao centro

                                           "trailing" - Alinhado ao fundo.

                                           Valor padrão: "center".

                                           (Somente Leitura) Retorna o
                                           aspecto do conteúdo do texto,
                                           isto é, a divisão entre a largura
                                           do texto por sua altura.

                  Descrição

Eventos
Nome do evento            Descrição

Exemplos

Objeto SceneEffectArea

(Conteúdo desta página não consta no documento original.)

Objeto SceneFogOfWar

  O Objeto SceneFogOfWar é responsável por lidar a névoa de guerra do scene.

Herança

       O objeto SceneFogOfWar herda de SceneBaseObject e possui também TODAS todas as suas
       características.

       Veja também:

                                 ○ Objecto SceneBaseObject

Características

  Além das características herdadas, o objeto SceneDrawingOpText também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo                             Descrição

objectType                String "fogOfWar"                (Somente Leitura) Contém um
enabled       Boolean                   texto que identifica o tipo do
ambientLight  Enumerado:                objeto - "fogOfWar"

sharingMode             ● "intense"     Define se o Fog of War está
                        ● "weak"        ativo no tabuleiro.
                        ● "none"
                                        Apenas o mestre pode alterar
              Enumerado:                esta propriedade.
                        ● "individual"
                        ● "group"       Define qual é a iluminação
                                        ambiente do scene e pode ser:

                                                  ● "intense" (Padrão) -
                                                       Todo o tabuleiro
                                                       recebe uma
                                                       iluminação de
                                                       ambiente Intensa.
                                                       Exemplo: Ambiente
                                                       à luz do sol.

                                                  ● "weak" - Todo o
                                                       tabuleiro recebe
                                                       uma iluminação de
                                                       ambiente fraca.
                                                       Exemplo: Luz do
                                                       luar.

                                                  ● "none" - O tabuleiro
                                                       não recebe nenhum
                                                       tipo de iluminação
                                                       do ambiente.

                                        Define como ocorre o
                                        compartilhamento de visão
                                        entre os membros do grupo.

                                                  ● "individual"
                                                       (Padrão) - Cada
                                                       membro do grupo
                                                       enxerga apenas o
                                                       que seus
                                                       personagens
                                                       enxergam.

                                                  ● "group" - Cada
                                                       membro do grupo
                                                       enxerga o que todo
                                                       o grupo enxerga.
Métodos                                 Descrição
   Método
   fogOfWar:setArea(polygon, areaType)  Configura uma área do
                                        tabuleiro para se
                                        comportar como um
                                        determinado tipo de
                                        área de Fog of War.

                                        Parâmetros:

                                                  ● polygon -
                                                       Um array
                                                       de tabelas
                                                       que contém
                                                       propriedad
                                                       es x e y (em
                                                       métrica de
                                                       mundo), e
                                                       cada cada
                                                       item do
                                                       array
                                                       representa
                                                       ndo um
                                                       vértice do
                                                       polígono.
                                                       Este é o
                                                       polígono
                                                       que será
                                                       configurad
                                                       o.

                                                  ● areaType -
                                                       O tipo que
                                                       esta área se
                                                       comportará
                                                       como. Pode
                                                       ser um dos
                                                       seguintes
                                                       valores:
                                                                       ○
                                                                       "

                                                                       ○
                                                                       "

                                                                       ○
                                                                       "

                                                                       ○
                                                                       "
fogOfWar:resetAreas();           Observações:
fogOfWar:addOpaqueArea(polygon)
                                           ● Apenas o
                                                mestre
                                                pode
                                                configurar
                                                áreas do
                                                tabuleiro

                                 Reseta todas as áreas
                                 definidas no tabuleiro.
                                 Isto é, todo o tabuleiro
                                 passará a ser uma área
                                 do tipo "explorable".

                                 Observações:

                                           ● Apenas o
                                                mestre
                                                pode
                                                configurar
                                                áreas do
                                                tabuleiro

                                 Adiciona uma área
                                 opaca/parede ao
                                 tabuleiro.

                                 Parâmetros:

                                           ● polygon -
                                                Um array
                                                de tabelas
                                                que contém
                                                propriedad
                                                es x e y (em
                                                métrica de
                                                mundo), e
                                                cada cada
                                                item do
                                                array
                                                representa
                                                ndo um
                                                vértice do
                                                polígono.
                                                Este é o
                                                polígono
                                                que será
                                                configurad
                                                o.
fogOfWar:removeOpaqueArea(polygon)  Observações:
fogOfWar:resetOpaqueAreas();
                                              ● Apenas o
                                                   mestre
                                                   pode
                                                   configurar
                                                   áreas
                                                   opacas do
                                                   tabuleiro.

                                    Remove uma área
                                    opaca/parede ao
                                    tabuleiro.

                                    Parâmetros:

                                              ● polygon -
                                                   Um array
                                                   de tabelas
                                                   que contém
                                                   propriedad
                                                   es x e y (em
                                                   métrica de
                                                   mundo), e
                                                   cada cada
                                                   item do
                                                   array
                                                   representa
                                                   ndo um
                                                   vértice do
                                                   polígono.
                                                   Este é o
                                                   polígono
                                                   que será
                                                   removido
                                                   das áreas
                                                   opacas.

                                    Observações:

                                              ● Apenas o
                                                   mestre
                                                   pode
                                                   configurar
                                                   áreas
                                                   opacas do
                                                   tabuleiro.

                                    Remove todas as áreas
                                    opacas do tabuleiro.

                                    Observações:
fogOfWar:testCircleMovementCollisionVsOpaqueAreas(cent            ● Apenas o
erX, centerY, r, offsetX, offsetY)                                     mestre
                                                                       pode
                                                                       configurar
                                                                       áreas
                                                                       opacas do
                                                                       tabuleiro.

                                                        Verifica se um
                                                        determinado círculo
                                                        movendo colide com
                                                        alguma área
                                                        opaca/parede do
                                                        tabuleiro.

                                                        Parâmetros:

                                                                  ● centerX -
                                                                       Centro do
                                                                       círculo no
                                                                       eixo X (em
                                                                       métrica de
                                                                       mundo)
                                                                       antes de
                                                                       realizar o
                                                                       movimento

                                                                  ● centerX -
                                                                       Centro do
                                                                       círculo no
                                                                       eixo Y (em
                                                                       métrica de
                                                                       mundo)
                                                                       antes de
                                                                       realizar o
                                                                       movimento
                                                                       .

                                                                  ● r - Raio do
                                                                       círculo (em
                                                                       métrica de
                                                                       mundo)

                                                                  ● offsetX -
                                                                       Define o
                                                                       sentido e
                                                                       comprimen
                                                                       to do
                                                                       movimento
                                                                       do círculo
                                                                       no eixo X
                                                                       (em
                                                                       métrica de
                                                                       mundo) ...
               Exemplo:
               1.0 significa
               que o
               círculo
               andou 1.0
               métrica
               mundo
               para a
               direita.
          ● offsetX -
               dirX -
               Define o
               sentido e
               comprimen
               to do
               movimento
               do círculo
               no eixo Y
               (em
               métrica de
               mundo) ...
               Exemplo:
               1.0 significa
               que o
               círculo
               andou 1.0
               métrica
               mundo
               para baixo.

Retorno:

     Esta função retorna
     3 valores na
     seguinte ordem:

          ● true se o
               ocorre uma
               colisão
               durante o
               movimento
               ou false

          ● Centro do
               círculo no
               eixo X (em
               métrica de
               mundo)
               onde
               ocorreu a
               colisão.

          ● Centro do
               círculo no
                              eixo Y (em
                              métrica de
                              mundo)
                              onde
                              ocorreu a
                              colisão.

Eventos            Descrição
   Nome do evento

Exemplos

Objeto SceneGraphicItem

  O Objeto GraphicItem representa um único item gráfico no Scene, como, por exemplo, um token.

Herança

       O objeto SceneGraphicItem herda de SceneBaseObject e possui também todas as suas
       características.

Abstração

  Esta é uma classe abstrata e você nunca encontrará um objeto SceneGraphicItem vivo sem ser uma
  das seguintes classes:

            ● Objeto SceneToken
            ● Objeto SceneEffectArea
            ● Objeto SceneUserDrawing
  Por ser uma abstração, um objeto SceneGraphicItem possui todas as características que são
  comuns aos objetos listados acima.
Características

  Além das características herdadas, o objeto SceneGraphicItem também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo                     Descrição

scene                     Objeto Scene             (Somente Leitura) Contém o
                                                   Objeto Scene a qual este item
                                                   gráfico pertence.

objectType                String:                  (Somente Leitura) Contém um
                                                   texto que identifica o tipo do
                                    ● "token"      objeto gráfico e pode conter um
                                    ● "effectArea  dos seguintes valores:

                                         "                   ● "token" - este item
                                    ● "userDrawi                  gráfico é um Objeto
                                                                  SceneToken
                                         ng"
                                                             ● "effectArea" - este
                                                                  item gráfico é um
                                                                  Objeto
                                                                  SceneEffectArea

                                                             ● "userDrawing" -
                                                                  este item gráfico é
                                                                  um Objeto
                                                                  SceneUserDrawing

width                     Double                   Contem a LARGURA do item em
height                                             métrica de mundo.
layer                     Double                   Contem a ALTURA do item em
                                                   métrica de mundo.
x                         Enumerado:               Define em qual camada do
                                    ● "backgroun   tabuleiro este item se encontra.
                                         d"
                                    ● "objects"    Contém, em métrica de mundo,
                                    ● "tokens"     a posição do item no eixo X.

                          Double
y           Double   Contém, em métrica de mundo,
                     a posição do item no eixo Y.
z           Double
                     Contém um número para definir
rotation    Double   a ordem Z do item, isto é, a
visible     Boolean  ordem em que o item é
snapToGrid  Boolean  desenhado na tela.

locked      Boolean  Exemplo: Se A e B forem dois
                     items de uma mesma camada do
selected    Boolean  scene e se A possuir ordem Z
isHover     Boolean  equivalente a 5 e B possuir
                     ordem Z equivalente a 10, o
                     item A aparecerá abaixo do item
                     B na tela.

                     Contém um ângulo em graus
                     que define a rotação do item na
                     interface.

                     Se for true, o item deve ser
                     desenhado para todos. Se for
                     false, o item deve ser desenhado
                     apenas para o mestre.

                     Define como o item deve se
                     posicionar em relação ao grid.

                     Se for true, o item deve se
                     ajeitar para se encaixar na grid
                     do tabuleiro. Se for false, o item
                     não deve tentar ajeitar sua
                     posição de forma automática.

                     Se true, os usuários não
                     conseguirão mover o item pelo
                     scene. Ótimo para, após o
                     tabuleiro tiver sido montado
                     pelo mestre, evitar que os
                     usuários movam peças sem
                     querer e desmontarem o scene.

                     Indica se o item está contido na
                     lista de itens selecionados do
                     usuário atual.

                     Indica se o mouse do usuário
                     está em cima do item.
isMine         Boolean             (Somente Leitura) Contém true
ownerUserID    String              se o usuário atual do RRPG
canBeRendered  Boolean             puder controlar/for dono do
                                   item.
canvas         Objeto SceneCanvas
                                   Contém o login do usuário do
                                   RRPG que é dono deste item.

                                   (Somente Leitura) Contém true
                                   se o item pode ser renderizado
                                   na tela do usuário.

                                   O valor desta propriedade
                                   considera o Fog of War do
                                   tabuleiro.

                                   (Somente Leitura) Contém o
                                   objeto SceneCanvas do item.
                                   Este objeto contém as
                                   operações gráficas que compõe
                                   a aparência do item;

                                   Se for um SceneToken, por
                                   exemplo, você encontrará um
                                   item dentro de canvas que é
                                   responsável por desenhar a
                                   imagem no tabuleiro.

                                   Se for um SceneUserDrawing,
                                   dentro de canvas você
                                   encontrará as informações do
                                   desenho que o usuário fez.

Métodos                          Descrição
   Método
   item:getCenter([snapToGrid])  Retorna onde no mundo do tabuleiro fica o
                                 centro do item.

                                 Parâmetros:

                                           ● (OPCIONAL) snapToGrid -
                                                Booleano. Se True, o scene
                                                retornará a posição mais perto do
                                                centro do item que se encaixe na
                                                grid. False, o scene não tentará
                                                fazer nenhum tipo de
item:setCenter(worldX, worldY[,                 arredondamento. Se este
snapToGrid])                                    parâmetro não for informado, o
                                                scene usará o valor da propriedade
                                                "snapToGrid" do item como
                                                parâmetro.

                                 Retorno:

                                      A função retorna dois números na seguinte
                                      ordem:

                                                                ○ worldX - A posição
                                                                     central no eixo X
                                                                     em relação ao
                                                                     tabuleiro, em
                                                                     métrica de mundo.

                                                                ○ worldY - A posição
                                                                     central no eixo Y
                                                                     em relação ao
                                                                     tabuleiro, em
                                                                     métrica de mundo.

                                 Exemplo:

                                 local wX, wY = scene.items[1]:getCenter();

                                 Move o item de forma que seu centro ocupe a
                                 posição passada como parâmetro.

                                 Parâmetros:

                                                                ○ worldX - Posição
                                                                     no eixo X do
                                                                     tabuleiro, em
                                                                     métrica de mundo,
                                                                     onde o centro do
                                                                     item deve ficar.

                                                                ○ worldY - Posição
                                                                     no eixo Y do
                                                                     tabuleiro, em
                                                                     métrica de mundo,
                                                                     onde o centro do
                                                                     item deve ficar.

                                                                ○ (OPCIONAL)
                                                                     snapToGrid -
                                                                     Booleano. Caso
                                                                     seja True, o Scene
                                                                     tentará
                                                                     arredondar a
                                                                     posição de forma
                                                                     que o item se
                                                                     encaixe no grid do
item:getBounds()                                                      tabuleiro. Se não
                                                                      informado, o scene
item:setBounds(left, top, right,                                      utiliza o valor da
bottom[, rotation])                                                   propriedade
                                                                      "snapToGrid" do
                                                                      próprio item.

                                  Retorna as informações dos limites do item no
                                  scene.

                                  Esta função retorna 5 valores na seguinte
                                  ordem:

                                            ● left - Valor numérico em métrica
                                                 de mundo contendo o valor da
                                                 propriedade "x" do item.

                                            ● top - Valor numérico em métrica
                                                 de mundo contendo o valor da
                                                 propriedade "y" do item.

                                            ● right - Valor numérico em métrica
                                                 de mundo contendo o valor da
                                                 propriedade "x + width" do item.

                                            ● bottom - Valor numérico em
                                                 métrica de mundo contendo o
                                                 valor da propriedade "y + height"
                                                 do item.

                                            ● rotation - Valor numérico
                                                 contendo o valor da propriedade
                                                 "rotation" do item.

                                  Altera os limites do item no scene.

                                  Parâmetros

                                            ● left - Valor numérico em métrica
                                                 de mundo contendo o valor da
                                                 propriedade "x" do item.

                                            ● top - Valor numérico em métrica
                                                 de mundo contendo o valor da
                                                 propriedade "y" do item.

                                            ● right - Valor numérico em métrica
                                                 de mundo contendo o valor da
                                                 propriedade "x + width" do item.

                                            ● bottom - Valor numérico em
                                                 métrica de mundo contendo o
                                                 valor da propriedade "y + height"
                                                 do item.

                                            ● (OPCIONAL) rotation - Valor
                                                 numérico contendo o valor da
                                                 propriedade "rotation" do item.
item:getCellsOccupied()        Retorna as células do grid que o item está
                               ocupando no momento.
item:compareZOrder(otherItem)
                               Parâmetros:
item:doSnapToGrid()
item:delete()                       Não há

                               Retorno:

                                                              ○ Um array (tabela
                                                                   lua indexada de 1 a
                                                                   #tabela) de tabelas
                                                                   luas, cada uma
                                                                   contendo as
                                                                   propriedades "i"e
                                                                   "j" das
                                                                   coordenadas Aij de
                                                                   cada célula
                                                                   ocupada pelo item.

                               Realiza uma comparação de ordem Z entre
                               dois graphics itens e retorna a ordem em
                               relação aos dois.

                               Parâmetros:

                                         ● otherItem - Outro objeto
                                              SceneGraphicItem com o qual
                                              deseja comparar

                               Retorno:

                                         ● -1 se item fica abaixo de otherItem
                                         ● 0 se item fica exatamente na

                                              mesma ordem z
                                         ● 1 se item fica acima de otherItem

                               Ajusta a posição atual do item para que fique
                               agarrado ao grid.

                               Remove o item do tabuleiro.

Eventos            Descrição
   Nome do evento
   onBeforeDraw    Evento de renderização. Quando estiver neste evento,
                   utilize os métodos de renderização do viewport para
                   realizar pinturas na tela do usuário. Não realize tarefas
                   pesadas neste evento!
onAfterDraw     Este evento é chamado antes do RRPG desenhar o item
onBoundsChange  gráfico na tela.

                Evento de renderização. Quando estiver neste evento,
                utilize os métodos de renderização do viewport para
                realizar pinturas na tela do usuário. Não realize tarefas
                pesadas neste evento!

                Este evento é chamado depois do RRPG desenhar o item
                gráfico na tela.

                Evento que é chamado quando os limites do item for
                alterado (posição, largura, altura, rotação, etc..)

                Parâmetros:

                          ● item - objeto SceneGraphicItem que sofreu a
                               alteração nos limites.

Exemplos
Exemplo 1 - Um plugin que movimenta de forma simples os itens do Scene com o mouse
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

              -- Variáveis para armazenar informações sobre o "arrastar"
dos itens

              local objMouseDown = nil; -- Qual objeto está sendo
arrastado

              local selecaoX, selecaoY; -- Em que ponto do item o usuário
clicou (em relação ao centro do item)

              -- Manipular o evento onMouseUp do Viewport afim de detectar
o click do mouse

        scene.viewport.onMouseDown =

           function(event)

           -- Converter para métrica de mundo a posição do

clique

           local wx, wy = scene.viewport:screenToWorld(event.x,

event.y);

           -- Descobrir qual item se encontra neste ponto
           objMouseDown = scene.items:itemAtPoint(wx, wy);
         if objMouseDown ~= nil then
                -- Existe um item nesta posição.

         -- Vamos obter onde fica a posição central deste

item

                                    local centerX, centerY =
objMouseDown:getCenter();

         if objMouseDown.snapToGrid then

               -- Movimento "agarrado" ao grid

                                           -- Vamos pegar a posição do mundo e
arredondar para o centro

               -- de uma célula mais próxima

                                           local cellI, cellJ =
scene.grid:worldToCell(wx, wy);

               wx, wy = scene.grid:cellToWorld(cellI,

cellJ);

         end;

                                    -- calcular onde no item o usuário clicou, em
relação ao seu centro.

                                    selecaoX = wx - centerX;
                                    selecaoY = wy - centerY;
                             end;
                     end;
       -- Manipular o evento onMouseMove para arrastar o item

       scene.viewport.onMouseMove =

            function(event)

            if objMouseDown ~= nil then

            -- Mouse moveu e existe um item selecionado

            -- Converter a posição clicada para métrica de

mundo

                                    local wx, wy =
scene.viewport:screenToWorld(event.x, event.y);

            if objMouseDown.snapToGrid then

                  -- Movimento agarrado ao grid

                                           -- Arredondar a posição do mouse para o
centro de uma célula mais

                  -- próxima.

                                           local newCellI, newCellJ =
scene.grid:worldToCell(wx, wy);

                  wx, wy = scene.grid:cellToWorld(newCellI,

newCellJ);

            end;

            -- Calcular o novo centro do item
            local centerX, centerY =
objMouseDown:getCenter();
                                    centerX = wx - selecaoX;
                                    centerY = wy - selecaoY;

                                    -- Setar o novo centro do item.
                                    objMouseDown:setCenter(centerX, centerY);
                             end;
                     end;

-- Manipular o evento onMouseUp para parar de arrastar o item

scene.viewport.onMouseUp =

            function(event)

            -- Mouse liberou o click, vamos

            -- sinalizar para o onMouseMove que não estamos mais

arrastando

            -- ninguem

                   objMouseDown = nil;
            end;

                end);

Exemplo 2 - Um plug-in que adiciona/remove uma marca personalizada quando o usuário clica nos itens
do scene.
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

-- Manipular o evento OnMouseDown do Viewport

              scene.viewport.onMouseDown = function(event)
                     -- Usuário clicou no Scene
                     -- Transformar as coordenadas de tela em métrica de mundo
                     local worldX, worldY =

scene.viewport:screenToWorld(event.x, event.y);

            -- Localizar o item que o usuário clicou
            local item = scene.items:itemAtPoint(worldX, worldY);

            if item ~= nil then
                   -- Encontrou um item na posição clicada.
                   local NOME_MINHA_MARCA = "MarcaExemplo";

            -- Localizar uma operação gráfica neste item com o

nosso nome

                             local opGrafica =
item.canvas:findByName(NOME_MINHA_MARCA);
                             if opGrafica == nil then
                                    --[[ A operação gráfica da minha marca ainda não
                                           existe neste token/item. Vamos criar ]]

                                    opGrafica = item.canvas:addBitmap();
                                    opGrafica.name = NOME_MINHA_MARCA;
                                  -- Abaixo, URL da imagem da nossa marca.
                                    opGrafica.url =
"https://wiki.teamfortress.com/w/images/d/dd/Bleed_drop.png?
t=20110425044341";
                                    opGrafica.x = 0.25;
                                    opGrafica.width = 0.3;
                                    opGrafica.y = -0.1;
                                    opGrafica.height = 0.3;
                                    opGrafica.z = 10;
                             else
                                    -- Vamos apagar nossa operação gráfica
previamente criada
                                    opGrafica:delete();
                             end;
                     end;
              end;
end);

             Item sem a marca

                                   Item com a marca

Objeto SceneGraphicItemList

  O Objeto SceneGraphicItem é um objeto que contém a coleção de todos os itens gráficos/visuais do
  tabuleiro, como os tokens.

  O SceneGraphicItemList de um scene pode ser obtido através da propriedade "items" do objeto
  Scene

Herança

       O objeto SceneGraphicItemList herda de SceneBaseObject e possui também todas as suas
       características.

Características

  Além das características herdadas, o objeto SceneGraphicItemList também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo     Descrição

operador #                Integer  (Somente Leitura) Contem a
                                   quantidade de itens gráficos que
                                   existem no scene.

                                   Exemplo:

                                   local qtDeItens = #scene.items;

operador []               Objeto   (Somente Leitura) Contem um
count      SceneGraphicItem  objeto SceneGraphicItem
selection                    representando um item gráfico do
           Integer           scene, como um token.
           Array de
           SceneGraphicItem  O valor passado dentro do colchete
                             deve ser um número entre 1 a
                             "count".

                             Exemplo de uso:
                             local item1 = scene.items[1]; --
                             Primeiro item
                             local item2 = scene.items[2];

                             -- Percorrendo todos os itens
                             gráficos do scene

                             for i = 1, #scene.items, 1 do

                              local umItem = scene.items[i];

                             end;

                             (Somente Leitura), equivale ao
                             operador #. Contem a quantidade
                             de itens gráficos que existem no
                             scene.

                             (Somente Leitura) Retorna um
                             array (uma tabela lua indexada de 1
                             a #array) contendo os itens do
                             scene que estão selecionados no
                             momento.

Métodos                      Descrição
   Método
   list:get(index)           Equivalente ao operador [], retorna um
                             SceneGraphicItem representando um item
   list:enumAtPoint(worldX,  gráfico do scene, como um token.
                             Parâmetros:

                                                            ○ index - um número
                                                                 inteiro entre 1 e
                                                                 "count"

                             Retorno:
                                  Um objeto SceneGraphicItem.

                             Dada uma posição em métrica de mundo,
worldY [, layer])  retorna todos os SceneGraphicItem do scene
                   que podem ser encontrados neste ponto (isto é,
                   se o ponto for uma posição dentro do item).

                   Parâmetros:

                                                  ○ worldX - Número em
                                                       métrica de mundo
                                                       que contem a
                                                       coordenada X da
                                                       ponto.

                                                  ○ worldY - Número em
                                                       métrica de mundo
                                                       que contem a
                                                       coordenada Y do
                                                       ponto.

                                                  ○ (OPCIONAL) layer -
                                                       String contendo uma
                                                       camada. Se este
                                                       parâmetro for
                                                       informado, apenas
                                                       itens que estiverem
                                                       na camada
                                                       informada serão
                                                       enumeradas por esta
                                                       função. Se este
                                                       parâmetro não
                                                       informado, todos os
                                                       itens no ponto serão
                                                       retornados,
                                                       independente de
                                                       qual camada
                                                       pertencer.

                   Retorno:

                        Um array (tabela lua com índices de 1 a
                        #tabela) de objetos SceneGraphicItem. Caso
                        nenhum item seja encontrado na posição
                        informada, o array vem vazio.

                   Observação:

                        O array retornado pela função vem
                        ordenado pela posição Z dos itens quando há
                        sobreposição. Isto é, quando um item ocupa
                        o mesmo espaço que outro item ocupa, a
                        função garante que o item que é desenhado
                        mais abaixo apareça antes no array
                        retornado do que o item que é desenhado
                        acima dele.Se um item achado não sobrepor
                        nenhum outro item, sua ordem no array
list:enumInRect(rect [, layer])       retornado é indefinida (Ordenação Z apenas
                                      dos itens em sobreposição).

                                 Dado um retângulo em métrica de mundo,
                                 retorna todos os SceneGraphicItem do scene
                                 que sobrepõe ao retângulo (que coincidem,
                                 justapõe, que intercedem, etc..)

                                 Parâmetros:

                                                                ○ rect - Um retângulo
                                                                     em estrutura
                                                                     SceneRect com
                                                                     valores em métrica
                                                                     de mundo.

                                                                ○ (OPCIONAL) layer -
                                                                     String contendo uma
                                                                     camada. Se este
                                                                     parâmetro for
                                                                     informado, apenas
                                                                     itens que estiverem
                                                                     na camada
                                                                     informada serão
                                                                     enumeradas por esta
                                                                     função. Se este
                                                                     parâmetro não
                                                                     informado, todos os
                                                                     itens no ponto serão
                                                                     retornados,
                                                                     independente de
                                                                     qual camada
                                                                     pertencerem.

                                 Retorno:

                                      Um array (tabela lua com índices de 1 a
                                      #tabela) de objetos SceneGraphicItem. Caso
                                      nenhum item seja encontrado no retângulo
                                      informado, o array vem vazio.

                                 Observação:

                                      O array retornado pela função vem
                                      ordenado pela posição Z dos itens quando há
                                      sobreposição. Isto é, quando um item ocupa
                                      o mesmo espaço que outro item ocupa, a
                                      função garante que o item que é desenhado
                                      mais abaixo apareça antes no array
                                      retornado do que o item que é desenhado
                                      acima dele.Se um item achado não sobrepor
                                      nenhum outro item, sua ordem no array
                                      retornado é indefinida (Ordenação Z apenas
list:itemAtPoint(worldX, worldY       dos itens em sobreposição).
[, layer])
                                 Dada uma posição em métrica de mundo,
                                 retorna um SceneGraphicItem do scene que se
                                 encontra neste ponto.

                                 Parâmetros:

                                                                ○ worldX - Número em
                                                                     métrica de mundo
                                                                     que contem a
                                                                     coordenada X da
                                                                     ponto.

                                                                ○ worldY - Número em
                                                                     métrica de mundo
                                                                     que contem a
                                                                     coordenada Y do
                                                                     ponto.

                                                                ○ (OPCIONAL) layer -
                                                                     String contendo uma
                                                                     camada. Se este
                                                                     parâmetro for
                                                                     informado, apenas
                                                                     itens que estiverem
                                                                     na camada
                                                                     informada serão
                                                                     retornados por esta
                                                                     função. Se este
                                                                     parâmetro não
                                                                     informado, todos os
                                                                     itens no ponto
                                                                     poderão ser
                                                                     retornados,
                                                                     independente de
                                                                     qual camada
                                                                     pertencerem.

                                 Retorno:

                                                                ○ Se houver algum
                                                                     item na posição
                                                                     informada, retorna
                                                                     um
                                                                     SceneGraphicItem,
                                                                     aquele mais acima na
                                                                     ordem Z, isto é, o
                                                                     que é desenhado
                                                                     acima dos outros.

                                                                ○ Se não houver item
                                                                     na posição
                                                                     informada, retorna
   list:clearSelection()                                               nil.
   list:addToken([layer])
                                  Deseleciona todos os itens que estavam na lista
   list:addUserDrawing([layer])   de seleção do usuário.

Eventos                           Adiciona um novo Token ao tabuleiro.
   Nome do evento                 Parâmetros:
   onItemAdded
                                             ● (OPCIONAL) layer - Define em qual
   onItemRemoved                                  camada o novo token deve aparecer.
                                                  Pode conter "background", "objects"
                                                  ou "tokens".

                                  Retorno:
                                             ● Objeto SceneToken representando o
                                                  novo token.

                                  Adiciona um novo UserDrawing ao tabuleiro.
                                  Parâmetros:

                                             ● (OPCIONAL) layer - Define em qual
                                                  camada o novo user drawing deve
                                                  aparecer. Pode conter "background",
                                                  "objects" ou "tokens".

                                  Retorno:
                                             ● Objeto SceneUserDrawing
                                                  representando o novo desenho de
                                                  usuário.

                                 Descrição

                                 Evento invocado quando um item for adicionado
                                 ao scene, seja porque acabou de ser criado ou
                                 porque estava invisível e se tornou visível agora.
                                 Parâmetros:

                                           ● Item - Um objeto SceneGraphicItem
                                                representando o item que foi
                                                adicionado.

                                 Evento invocado quando um item for removido do
                                 scene, seja porque foi destruído ou porque se
                                 tornou invisível.
onItemSelected     Parâmetros:
onItemDeselected
onItemLayerChange            ● Item - Um objeto SceneGraphicItem
                                  representando o item que foi
                                  removido.

                   Evento invocado quando um item for adicionado à
                   seleção de itens do usuário.

                   Parâmetros:

                             ● Item - Um objeto SceneGraphicItem
                                  representando o item que foi
                                  selecionado.

                   Evento invocado quando um item for removido da
                   seleção de itens do usuário.

                   Parâmetros:

                             ● Item - Um objeto SceneGraphicItem
                                  representando o item que foi
                                  removido da seleção.

                   Evento invocado quando a camada de um item for
                   alterada.

                   Parâmetros:

                             ● Item - Um objeto SceneGraphicItem
                                  representando o item que teve a
                                  propriedade "layer" alterada.

Exemplos
Exemplo 1 - Um plugin que descobre em qual item do scene o usuário clicou
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

              -- Manipular o evento onMouseUp do Viewport afim de detectar
o click do mouse

        scene.viewport.onMouseUp =

           function(event)

           -- Converter para métrica de mundo a posição do

clique

           local wx, wy = scene.viewport:screenToWorld(event.x,

event.y);

           -- Localizar o objeto mais acima da posição clicada
           local o = scene.items:itemAtPoint(wx, wy);

                  -- Exibir uma mensagem
                  if o ~= nil then

                         showMessage("Clique em um objeto");
                  else

                         showMessage("Clique em nada");
                  end;
           end;
       end);

Objeto SceneGridLayer

  O Objeto SceneGridLayer representa o grid do tabuleiro de combate e possui informações e
  utilitários a respeito do mesmo.

  O SceneGridLayer de um scene pode ser obtido através da propriedade "grid" do objeto Scene

Herança

       O objeto SceneGridLayer herda de SceneBaseObject e possui também todas as suas
       características.

Características

  Além das características herdadas, o objeto também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                   Descrição

scene                     Objeto Scene           (Somente Leitura) Contém o
                                                 Objeto Scene a qual este
                                                 SceneGridLayer pertence.

gridType                  Enumerado:             Define o tipo de grid que o
                                    ● "square"   tabuleiro de combate utiliza.
                                    ● "vertHex"
                                    ● "horzHex"  "square": Grid com células
                                                 quadradas

                                                 "vertHex": Grid com células
                                                 hexagonais organizadas
                                                 verticalmente.
                                           "horzHex": Grid com células
                                           hexagonais organizadas
                                           horizontalmente.

squareDiagonals  Enumerado:                Quando gridType for "square",
offsetX                    ● "simplified"  esta propriedade define como as
                           ● "manhatta     diagonais do grid quadriculado
                                n"         devem se comportar e pode ser
                           ● "alternated   um dos seguintes valores:
                                "
                           ● "euclidean"             ● "simplified" - (Valor
                                                          padrão) Movimento
                 Double                                   pelas diagonais
                                                          simplificado. Andar
                                                          pelas diagonais
                                                          possui o mesmo
                                                          "custo" que andar
                                                          pelas laterais.

                                                     ● "manhattan" - O
                                                          movimento pelas
                                                          diagonais custam 2x
                                                          o custo de andar
                                                          pelas laterais.

                                                     ● "alternated" - O
                                                          primeiro movimento
                                                          diagonal custa 1x, o
                                                          segundo custa 2x, o
                                                          terceiro custa 1x, o
                                                          quarto 2x, e assim
                                                          por diante.

                                                     ● "euclidean" - O custo
                                                          de andar pelas
                                                          diagonais é igual à
                                                          distância real.

                                           Define o deslocamento em
                                           métrica de mundo que a
                                           primeira célula do grid (i:0, j:0)
                                           deve receber no eixo X.
offsetY   Double  Em outras palavras, offsetX e
                  offsetY são usadas para ajuste
cellSize  Double  fino para posicionar
                  corretamente o grid no
                  tabuleiro.

                  O RRPG faz um "WrapAround"
                  no offset: Se você especificar um
                  OffsetX que equivalha a 3,3
                  células por exemplo, o RRPG
                  fará um deslocamento de apenas
                  0,3 células, pois deslocar 3,3 ou
                  deslocar 0,3 células produz o
                  mesmo resultado visual.

                  Define o deslocamento em
                  métrica de mundo que a
                  primeira célula do grid (i:0, j:0)
                  deve receber no eixo Y.

                  Em outras palavras, offsetX e
                  offsetY são usadas para ajuste
                  fino para posicionar
                  corretamente o grid no
                  tabuleiro.

                  O RRPG faz um "WrapAround"
                  no offset: Se você especificar um
                  OffsetY que equivalha a 3,1
                  células por exemplo, o RRPG
                  fará um deslocamento de apenas
                  0,1 células, pois deslocar 3,1 ou
                  deslocar 0,1 células produz o
                  mesmo resultado visual.

                  Define o tamanho de cada célula
                  do grid em métrica de mundo.
                  Exemplo: 1.5 significa que cada
                  célula do grid ocupam 1.5
                  metros no espaço do mundo do
                  tabuleiro (ou outra unidade de
                  medida, conforme a propriedade
                  scene.worldMetricName).

                  Dimensões se o gridType for
                  "square":
                                          Dimensões se o gridType for
                                          "vertHex":

                                          Dimensões se o gridType for

gridColor                  String de Cor  "horzHex":
gridThickness              Double
                                          Define a cor da linha do grid.
drawGrid                   Boolean
                                          Define, em métrica de tela, a
rowCount                   Integer        espessura das linhas do grid.

colCount                   Integer        True se as linhas do grid devem
                                          ser desenhadas, ou false se as
                                          linhas do grid devem ser
                                          invisíveis.

                                          (Somente Leitura) Com base no
                                          tamanho do tabuleiro
                                          (propriedade scene.worldWidth)
                                          e no tamanho de cada célula da
                                          grid (cellSize), esta propriedade
                                          contém quantas linhas a
                                          grid/matriz tem.

                                          (Somente Leitura) Com base no
                                          tamanho do tabuleiro
                                          (scene.worldHeight) e no
                                          tamanho de cada célula da grid
                                          (cellSize), esta propriedade
                                          contém quantas colunas a
                                          grid/matriz tem.

Métodos                             Descrição
   Método                           Dada uma coordenada de matriz/grid Aij, retorna
   grid:cellToWorld(i, j)
qual é a posição central desta célula em métrica de
mundo.

Parâmetros:

                               ○ i - Número inteiro
                                    contendo qual linha a
                                    célula se encontra, o
                                    valor "i" da coordenada
                                    Aij. A primeira linha da
                                    grid começa no índice
                                    0.

                               ○ j - Número inteiro
                                    contendo qual coluna a
                                    célula se encontra, o
                                    valor "j" da coordenada
                                    Aij. A primeira coluna
                                    da grid começa no
                                    índice 0.

Retorno:

     Esta função retorna dois valores na seguinte
     ordem:

                               ○ worldX - Um número
                                    em métrica de mundo
                                    contendo onde, no eixo
                                    X, fica o centro da
                                    célula informada.

                               ○ worldY - Um número
                                    em métrica de mundo
                                    contendo onde, no eixo
                                    Y, fica o centro da
                                    célula informada.

Observações:

          ● Se a célula não existir de fato na grid, a
               função retornará a posição de onde
               seria o centro desta célula se ela
               existisse.

Exemplo:

local wX, wY = scene.grid:cellToWorld(10, 5);

Neste exemplo, o centro da célula [Linha 10,
Coluna 5] fica na coordenada (wX, wY) em métrica
de mundo.
grid:worldToCell(worldX,  Dada uma posição em métrica de mundo, retorna
worldY)                   qual célula da grid que este ponto pertence.

                          Parâmetros:

                                                         ○ worldX - Número em
                                                              métrica de mundo
                                                              contendo a posição no
                                                              eixo X

                                                         ○ worldY - Número em
                                                              métrica de mundo
                                                              contendo a posição no
                                                              eixo Y

                          Retorno:

                               Esta função retorna dois valores na seguinte
                               ordem:

                                                         ○ i - Número inteiro
                                                              contendo qual linha a
                                                              célula se encontra

                                                         ○ j - Número inteiro
                                                              contendo qual coluna a
                                                              célula se encontra

                          Observações:

                                    ● Se o ponto (worldX, worldY) não estiver
                                         dentro das dimensões do tabuleiro, a
                                         função retornará qual célula a posição
                                         se refere se o tabuleiro fosse maior.

                          Exemplo:

                          local i, j = scene.grid:worldToCell(16, 6);

                          Meste exemplo, a posição do mundo (x: 16, y: 6)
                          pertence à célula Aij [Linha i, Coluna j].
grid:shortestPath(srcI, srcJ,  Dada duas coordenadas de matriz/grid Aij, calcula e
destI, destJ[, options])       retorna o caminho mais curto entres as duas
                               células da grid.

                               Parâmetros:

                                                              ○ srcI - Número inteiro
                                                                   contendo qual linha a
                                                                   célula origem se
                                                                   encontra, o valor "i" da
                                                                   coordenada Aij. A
                                                                   primeira linha da grid
                                                                   começa no índice 0.

                                                              ○ srcJ - Número inteiro
                                                                   contendo qual coluna a
                                                                   célula origem se
                                                                   encontra, o valor "j" da
                                                                   coordenada Aij. A
                                                                   primeira coluna da grid
                                                                   começa no índice 0.

                                                              ○ destI - Número inteiro
                                                                   contendo qual linha a
                                                                   célula destino se
                                                                   encontra, o valor "i" da
                                                                   coordenada Aij.

                                                              ○ destJ - Número inteiro
                                                                   contendo qual coluna a
                                                                   célula destino se
                                                                   encontra, o valor "j" da
                                                                   coordenada Aij.

                                                              ○ (OPCIONAL) options -
                                                                   Uma tabela lua
                                                                   contendo opções de
                                                                   como o caminho mais
                                                                   curto deve ser
                                                                   calculado e pode
                                                                   possuir os seguintes
                                                                   atributos:
                                                                                  ■ diagona
                                                                                        ls -
                                                                                        Válido
                                                                                        apenas
                                                                                        para
                                                                                        grid do
                                                                                        tipo
                                                                                        "square
                                                                                        ",
                                                                                        Define
                                                                                        como o
                                                                                        cálculo
                                                                                        deve se
     compor
     tar em
     relação
     às
     diagona
     is do
     grid e
     pode
     conter
     um dos
     seguint
     es
     valores:

                 ●
                 "si

                 ●
                 "

                 ●
                 "a

                 ●
                 "e

■ endOf
     Grid -
     O que
     acontec
     e
     quando
     a célula
     destino
     estiver
     fora
     dos
     limites
     do
     tabuleir
     o/grid?
     Pode
     conter
     um dos
     seguint
     es
     valores:
                 ●
                 "f

                 ●
                 "c
                 ●
                 "t

■ continu
     ationD
     ata - Se
     quiser
     emend
     ar
     caminh
     os de
     forma
     adequa
     da,
     passe
     aqui o
     continu
     ationD
     ata
     retorna
     do pela
     última
     chamad
     a de
     shortes
     tPath.

■ trackC
     ollision
     s - True
     se
     quiser
     que o
     sistema
     rastreie
     colisõe
     s
     durant
     eo
     movim
     ento. O
     padrão
     é false.

■ collisio
     nRadiu
     s-
     Compri
     mento
     do raio
     de um
     círculo
                                                         (em
                                                         métrica
                                                         de
                                                         mundo)
                                                         que
                                                         será
                                                         utilizad
                                                         o
                                                         durant
                                                         eo
                                                         rastreio
                                                         de
                                                         colisõe
                                                         s de
                                                         movim
                                                         ento.

Retorno:

     Esta função retorna 4 valores na seguinte
     ordem:

                               ○ success - True se
                                    conseguiu encontrar
                                    um menor caminho ou
                                    false se não foi possível.

                               ○ distance - Quando
                                    success for true,
                                    contém um número
                                    contendo a distância do
                                    caminho encontrado
                                    em métrica de mundo .

                               ○ steps - Quando success
                                    for true, contém os
                                    movimentos
                                    necessários no grid
                                    para chegar ao destino.
                                    É um array (tabela lua
                                    indexada de 1 a
                                    #tabela) de tabelas
                                    luas, cada uma
                                    contendo as
                                    propriedades "i"e "j"
                                    das coordenadas Aij de
                                    cada célula no caminho.

                               ○ continuationData - Um
                                    valor que você pode
                                    passar para a próxima
                                    chamada de
                                    "grid:shortestPath" se
                                    quiser emendar
                                    caminhos de forma
                   adequada.

Eventos            Descrição
   Nome do evento
   onChange        Evento que é disparado quando o Grid do scene mudar.

                   As seguintes situações disparam este evento:

                             ● Alteração no tamanho do Scene (propriedades
                                  scene.worldWidth e scene.worldHeight)

                             ● Alteração em algumas das seguintes
                                  propriedades do grid: gridType, cellSize,
                                  offsetX, offsetY, gridColor, gridThickness e
                                  drawGrid

Exemplos
Exemplo 1 - Um plug-in que descobre em qual célula do grid o usuário clicou

        require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

              -- Manipular o evento onMouseUp do Viewport afim de detectar
o click do mouse

              scene.viewport.onMouseUp =
                     function (event)
                             -- Converter coordenada de tela do click para

coordenada de mundo
                             local wx, wy = scene.viewport:screenToWorld(event.x,
                                                                                                             event.y);
grid  -- Converter coordenada de mundo para coordenada do
      local i, j = scene.grid:worldToCell(wx, wy);

                     -- Exibir uma Mensagem sobre a célula clicada
                     showMessage("Click na célula [Linha " .. i ..

                                           ", Coluna " .. j .. "]");
              end;
end);

Objeto ScenePluginAttachment

(Conteúdo desta página não consta no documento original.)

Objeto SceneUserDrawing

  O Objeto SceneUserDrawing representa um único item gráfico no Scene do tipo "desenho do
  usuário".

Herança

       O objeto SceneUserDrawing herda de SceneGraphicItem e possui também TODAS todas as
       suas características.
       Veja também:

                                 ○ Objeto SceneGraphicItem
                                 ○ Objecto SceneBaseObject

Características

  Além das características herdadas, o objeto SceneUserDrawing também possui as seguintes
  características:
Propriedades e atributos

Propriedade               Tipo                  Descrição

objectType                String "userDrawing"  (Somente Leitura) Contém um
                                                texto que identifica o tipo do
                                                objeto gráfico - "userDrawing".

Métodos                              Descrição
   Método
   userDrawing:markAsMyDrawing();    Marca o UserDrawing como pertencente ao
                                     usuário atual.

                                     A marca de dono do userDrawing permite
                                     usuários com +jogadores desenhar e
                                     controlar seus desenhos no scene.

                                     Se o usuário atual for MESTRE, esta função
                                     transforma o desenho em um desenho que
                                     faz parte do scene e não pertence a ninguém.

                                     Se o usuário atual for +JOGADOR e se o
                                     item tiver acabado de ser criado, esta função
                                     marca o desenho como "desenho de
                                     jogador".

                                     Se o usuário atual for +JOGADOR mas o
                                     item já existir, a função não faz nada.

Eventos                   Descrição
   Nome do evento
Exemplos
Exemplo 1 -

Exemplo 2 -

Objeto SceneToken

  O Objeto SceneToken representa um único item gráfico no Scene do tipo token, isto é,
  personagens, objetos e outros símbolos gráficos.

Herança

       O objeto SceneToken herda de SceneGraphicItem e possui também TODAS todas as suas
       características.

       Veja também:

                                 ○ Objeto SceneGraphicItem
                                 ○ Objecto SceneBaseObject

Características

  Além das características herdadas, o objeto SceneToken também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo                 Descrição

objectType                String "token"       (Somente Leitura) Contém
                                               um texto que identifica o
                                               tipo do objeto gráfico -
                                               "token".

image                     Objeto               (Somente Leitura) Contém
                          SceneDrawingOpBitma  um Objeto
name            p                       SceneDrawingOpBitmap
facingMode      String                  com os detalhes da imagem
friendOrFoe     Enumerado:              principal do token.

ownerUserID               ● "rotate"    Define o nome do token.
ownerCharacter            ● "drawArrow  Este nome é exibido
                                        visualmente no Scene.
                               "
                                        Define como o Scene deve
                Enumerado:              indicar visualmente para que
                          ● "unknown"   lado o token está virado.
                          ● "friend"
                          ● "neutral"   "rotate": Rotacionar a
                          ● "foe"       imagem para a direção.

                String                  "drawArrow": Não
                Inteiro                 rotacionar a imagem e
                                        desenhar uma seta para a
                                        direção.

                                        Define se este token é hostil
                                        ou amigável ao grupo do
                                        RRPG.

                                        "unknown" - Desconhecido,
                                        o mestre não definiu ou é um
                                        objeto.

                                        "friend" - Este token
                                        representa alguém/algo
                                        amigável aos personagens do
                                        grupo.

                                        "neutral" - Este token
                                        representa alguém/algo
                                        neutro ao grupo.

                                        "foe" - Este token representa
                                        alguém/algo hostil aos
                                        personagens do grupo.

                                        Contém o login do usuário do
                                        RRPG que é dono deste
                                        token e pode movimentá-lo.

                                        Contém o ID interno do
                                        personagem deste token.

                                        Este valor é equivalente ao
                                        valor da propriedade
                                        "codigoIntero" do objeto
visionIntenseLightRan  Double   "BibliotecaItem"
ge
                                0 = Não foi definido o
visionWeakLightRang    Double   personagem.
e
                                Define, em métrica de
visionDarknessRange    Double   mundo, o alcance da visão do
                                token sob luz intensa.
visionHaveVision       Boolean
                                Define, em métrica de
visionAngle            Double   mundo, o alcance da visão do
                                token sob luz fraca (exemplo:
lightIntenseRange      Double   Luz do luar, uma vela fraca,
                                etc..)
lightWeakRange         Double
                                Define, em métrica de
lightAngle             Double   mundo, o alcance da visão do
                                token na escuridão total.

                                Define se o token possui
                                visão/enxerga coisas no
                                tabuleiro.

                                Padrão: False

                                Define, em graus, o ângulo de
                                visão do token.

                                Padrão: 360

                                Define, em métrica de
                                mundo, o alcance da luz
                                intensa emitida por este
                                token.

                                Se for igual a 0, este token
                                não emite luz intensa.

                                Padrão: 0

                                Define, em métrica de
                                mundo, o alcance da luz fraca
                                emitida por este token.

                                Se for igual a 0, este token
                                não emite luz fraca.

                                Padrão: 0

                                Define, em graus, o ângulo da
barValue1                     String         luz emitida por este token.
barValue2                     String         Padrão: 360
barValue3                     String de Cor  Define o valor atual de uma
                              Boolean        das barrinhas do token.
barMax1
barMax2                                      Define o valor máximo de
barMax3                                      uma das barrinhas do token.

barColor1                                    Define a cor de uma das
barColor2                                    barrinhas do token.
barColor3
                                             (Somente Leitura) Contém
isMine                                       true se o token for
                                             controlado pelo usuário
                                             atual do RRPG.

Métodos                                  Descrição
   Método
   token:clearMemoryAreas();             No FogOfWar, limpa a memória do Token das
                                         áreas que ele já viu em algum momento do
                                         passado.

Eventos                       Descrição
   Nome do evento
Exemplos
Exemplo 1 -

Exemplo 2 -

Objeto SceneViewport

  O Objeto Viewport representa a tela do usuário, a janela de exibição, onde o scene está sendo
  renderizado.

  O Viewport de um scene pode ser obtido através da propriedade "viewport" do objeto Scene

Herança

       O objeto SceneViewport herda de SceneBaseObject e possui também todas as suas
       características.

Características

  Além das características herdadas, o objeto SceneViewport também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo          Descrição

scene                     Objeto Scene  (Somente Leitura) Contém o
                                        Objeto Scene que este Viewport
                                        renderiza.

width                     Double        (Somente Leitura) Contem a
                                        LARGURA em Métrica de Tela do
                                        viewport, isto é, da janela onde o
                                        scene está sendo renderizado.
height  Double  (Somente Leitura) Contem a
worldX  Double  ALTURA em Métrica de Tela do
                viewport, isto é, da janela onde o
worldY  Double  scene está sendo renderizado.

                Define, em Métrica de Mundo,
                em qual posição do eixo X do
                mundo o ponto (X: 0, Y: 0) da tela
                aponta.

                As propriedades "worldX" e
                "worldY" servem para fazer
                "scroll" no scene.

                Se quiser fazer um scroll para a
                direita, por exemplo, incrementa-
                se o valor de worldX. Se quiser
                fazer um scroll para cima,
                decrementa-se o valor de
                worldY;

                Este é um valor local e não é
                compartilhado com os outros
                usuários que estão visualizando o
                mesmo scene.

                Define, em Métrica de Mundo,
                em qual posição do eixo Y do
                mundo o ponto (X: 0, Y: 0) da tela
                aponta.

                As propriedades "worldX" e
                "worldY" servem para fazer
                "scroll" no scene.

                Se quiser fazer um scroll para a
                direita, por exemplo, incrementa-
                se o valor de worldX. Se quiser
                fazer um scroll para cima,
                decrementa-se o valor de
                worldY;

                Este é um valor local e não é
                compartilhado com os outros
                usuários que estão visualizando o
                mesmo scene.
scale  Double  Define a escala entre a Métrica
               do Mundo e a Métrica da Tela do
               Scene.

               Em outras palavras, esta
               propriedade controla o "zoom"
               do Scene.

               Exemplo: Um valor 32.0 significa
               que cada unidade métrica do
               mundo ocupam 32 unidades
               métricas de tela.

               Se quiser, por exemplo, efetuar
               um zoom+ no scene, incrementa-
               se "scale". Se quiser reduzir o
               zoom pela metade, divide-se por
               dois o valor de "scale".

               Este é um valor local e não é
               compartilhado com os outros
               usuários que estão visualizando o
               mesmo scene.
cursor  Enumerado:               Define qual cursor de mouse
                  ● "default"    deve ser apresentado quando o
                  ● "arrow"      mouse estiver em em cima do
                  ● "handPoint"  viewport do scene.
                  ● "hourGlass"
                  ● "IBeam"                ● "default" - Cursor
                  ● "size"                      padrão, uma seta
                  ● "sizeNESW"                  padrão.
                  ● "sizeNS"
                  ● "sizeNWSE"             ● "arrow" - Uma seta
                  ● "sizeWE"                    padrão.
                  ● "upArrow"
                  ● "drag"                 ● "handPoint" - Uma
                  ● "noDrop"                    mão com um dedo
                  ● "hSplit"                    apontando para cima.
                  ● "vSplit"                    Normalmente é
                  ● "multiDrag"                 usado para
                  ● "sqlWait"                   identificar um item
                  ● "no"                        selecionável/clicável
                  ● "appStart"
                  ● "help"                 ● "hourGlass" - Uma
                  ● "cross"                     ampulheta para
                                                indicar um processo
                                                em andamento.

                                           ● "IBeam" - Cursor que
                                                sinaliza a
                                                possibilidade de
                                                entrar com texto no
                                                controle.

                                           ● "size" - Indicação de
                                                possibilidade de
                                                redimensionamento.

                                           ● "sizeNESW" -
                                                Indicação de
                                                possibilidade de
                                                redimensionamento
                                                no sentido Nordeste-
                                                Sudoeste

                                           ● "sizeNS" - Indicação
                                                de possibilidade de
                                                redimensionamento
                                                no sentido Norte-Sul

                                           ● "sizeNWSE" -
                                                Indicação de
                                                possibilidade de
                                                redimensionamento
                                                no sentido Noroeste-
                                                Sudeste

                                           ● "sizeWE" - Indicação
                                                de possibilidade de
                                                redimensionamento
                                                no sentido Leste-
                                                Oeste

                                           ● "upArrow" - Uma
Métodos                                                           seta apontando para
   Método                                                         cima.
   viewport:screenToWorld(screenX,                          ● "drag" - Um cursor
                                                                  indicando que itens
                                                                  estão sendo
                                                                  arrastados.
                                                            ● "noDrop" - Indicação
                                                                  de que não é possível
                                                                  arrastar para este
                                                                  alvo.
                                                            ● "hSplit" - Indicação
                                                                  de splitter horizontal
                                                            ● "vSplit" - Indicação
                                                                  de splitter vertical.
                                                            ● "multiDrag" -
                                                                  Indicação de que
                                                                  vários itens estão
                                                                  sendo arrastados.
                                                            ● "sqlWait" -
                                                                  Ampulheta indicando
                                                                  um processo de
                                                                  banco de dados em
                                                                  andamento.
                                                            ● "no" - Uma indicação
                                                                  de negação, de que
                                                                  não é possível fazer
                                                                  algo.
                                                            ● "appStart" -
                                                                  Combinação de
                                                                  "default" e
                                                                  "hourGlass",
                                                                  normalmente usado
                                                                  para indicar que um
                                                                  aplicativo está sendo
                                                                  aberto.
                                                            ● "help" - Uma seta
                                                                  com um ponto de
                                                                  interrogação.
                                                            ● "cross" - Um cursor
                                                                  em formato de cruz,
                                                                  usado para indicar
                                                                  um posicionamento
                                                                  preciso.

                                    Descrição

                                    Converte uma posição definida em métricas
                                    de tela em uma posição definida em
screenY)                           métricas de mundo.

viewport:screenToWorld(screenRect  Em outras palavras, esta função responde a
)                                  seguinte pergunta: O ponto (screenX,
                                   screenY) da tela do usuário representa qual
                                   ponto (worldX, worldY) do tabuleiro?

                                   Esta conversão leva em consideração o
                                   "scroll" e o "zoom" (propriedades worldX,
                                   worldY e scale) do Viewport.

                                   Parâmetros:

                                                                  ○ screenX - a
                                                                       posição do eixo
                                                                       X do ponto da
                                                                       tela

                                                                  ○ screenY - a
                                                                       posição do eixo
                                                                       Y do ponto da
                                                                       tela

                                   Retorno:

                                                                  ○ Esta função
                                                                       retorna 2
                                                                       valores na
                                                                       seguinte ordem:
                                                                       worldX e
                                                                       worldY
                                                                       contendo o
                                                                       ponto
                                                                       convertido em
                                                                       métricas de
                                                                       mundo.

                                   Exemplo de uso:

                                   local worldX, worldY =
                                   scene.viewport:screenToWorld(10, 50);

                                   Converte um retângulo definido em
                                   métricas de tela em um retângulo definido
                                   em métricas de mundo.

                                   Em outras palavras, esta função responde a
                                   seguinte pergunta: O retângulo
                                   "screenRect" da tela do usuário representa
                                   qual retângulo do tabuleiro?

                                   Esta conversão leva em consideração o
                                   "scroll" e o "zoom" (propriedades worldX,
                                   worldY e scale) do Viewport.
                                Parâmetros:  ○ screenRect -
                                Retorno:          Uma tabela
                                                  SceneRect
                                                  contendo o
                                                  retângulo que
                                                  será convertido.

                                             ○ Uma tabela
                                                  SceneRect
                                                  contendo o
                                                  retângulo
                                                  convertido em
                                                  métricas de
                                                  mundo.

viewport:worldToScreen(worldX,  Converte uma posição definida em métricas
worldY)                         de mundo em uma posição definida em
                                métricas de tela.

                                Em outras palavras, esta função responde a
                                seguinte pergunta: O ponto (worldX,
                                worldY) do mundo do scene fica em qual
                                posição (screenX, screenY) na tela do
                                usuário?

                                Esta conversão leva em consideração o
                                "scroll" e o "zoom" (propriedades worldX,
                                worldY e scale) do Viewport.

                                Parâmetros:

                                                               ○ worldX - a
                                                                    posição do eixo
                                                                    X do mundo do
                                                                    scene.

                                                               ○ worldY - a
                                                                    posição do eixo
                                                                    Y do mundo do
                                                                    scene.

                                Retorno:

                                                               ○ Esta função
                                                                    retorna 2
                                                                    valores na
                                                                    seguinte ordem:
                                                                    screenX e
                                                                    screenY
                                                                    contendo o
viewport:worldToScreen(worldRect)                                      ponto
viewport:getScrollBounds()                                             convertido em
                                                                       métricas de tela.

                                   Exemplo de uso:

                                   local screenX, screenY =
                                   scene.viewport:worldToScreen(3, 4.5);

                                   Converte um retângulo definido em
                                   métricas de mundo em um retângulo
                                   definido em métricas de tela.

                                   Em outras palavras, esta função responde a
                                   seguinte pergunta: O retângulo "worldRect"
                                   do mundo do scene ocupa qual retângulo da
                                   tela do usuário?

                                   Esta conversão leva em consideração o
                                   "scroll" e o "zoom" (propriedades worldX,
                                   worldY e scale) do Viewport.

                                   Parâmetros:

                                                                  ○ worldRect -
                                                                       Uma tabela
                                                                       SceneRect
                                                                       contendo o
                                                                       retângulo que
                                                                       será convertido.

                                   Retorno:

                                                                  ○ Uma tabela
                                                                       SceneRect
                                                                       contendo o
                                                                       retângulo
                                                                       convertido em
                                                                       métricas de tela.

                                   Retorna os limites de scroll para os valores
                                   worldX e worldY.

                                   Retorno:

                                        Esta função retorna 4 valores numéricos
                                        na seguinte ordem e definição:

                                                                  ○ minX - Um
                                                                       número. O
                                                                       scene não deixa
                                                                       a propriedade
                                                                       worldX ficar
                                                                       menor que este
viewport:setupToolCategory(name,                                      valor.
title, order)                                                    ○ minY - Um

                                                                      número. O
                                                                      scene não deixa
                                                                      a propriedade
                                                                      worldY ficar
                                                                      menor que este
                                                                      valor;
                                                                 ○ maxX - Um
                                                                      número. O
                                                                      scene não deixa
                                                                      a propriedade
                                                                      worldX ficar
                                                                      maior que este
                                                                      valor.
                                                                 ○ maxY - Um
                                                                      número. O
                                                                      scene não deixa
                                                                      a propriedade
                                                                      worldY ficar
                                                                      maior que este
                                                                      valor.

                                  Exemplo de uso:

                                  local minX, minY, maxX, maxY =
                                  viewport:getScrollBounds();

                                  Atualiza ou cria uma categoria de
                                  ferramentas no Scene.

                                  Parâmetros:

                                                                 ○ name - Uma
                                                                      cadeia de
                                                                      caracteres
                                                                      contendo o
                                                                      nome da
                                                                      categoria. Este
                                                                      nome pode ser
                                                                      referenciado
                                                                      depois pela
                                                                      função
                                                                      addToolButton

                                                                 ○ title - Uma
                                                                      cadeia de
                                                                      caracteres
                                                                      contendo a
                                                                      descrição/título
                                                                      da categoria.

                                                                 ○ order - Um
viewport:addToolButton(categoryNa                                        número
me, title, iconURL, order, options,                                      definindo a
callback [, deactivationCallback])                                       ordem da
                                                                         categoria. Esta
                                                                         categoria será
                                                                         exibida
                                                                         depois/abaixo
                                                                         de outra
                                                                         categoria de
                                                                         ordem menor.
                                                                         (A grosso modo,
                                                                         quem tiver
                                                                         número de
                                                                         ordem menor
                                                                         fica na frente)

                                     Adiciona um botão-ferramenta ao Scene.

                                     Parâmetros:

                                                                    ○ categoryName -
                                                                         O nome da
                                                                         categoria em
                                                                         que o botão
                                                                         deve ser
                                                                         inserido. Este é
                                                                         o mesmo nome
                                                                         usado na função
                                                                         setupToolCateg
                                                                         ory. Se for
                                                                         especificado
                                                                         uma categoria
                                                                         inexistente, ela
                                                                         será criada.

                                                                    ○ title - Cadeia de
                                                                         caracteres
                                                                         contendo o
                                                                         título do botão.

                                                                    ○ iconURL -
                                                                         Cadeia de
                                                                         caracteres
                                                                         contendo o
                                                                         endereço/camin
                                                                         ho de uma
                                                                         imagem que
                                                                         será utilizada
                                                                         como ícone da
                                                                         ferramenta.
                                                                                        ■P
                                                                                              o
                                                                                              d
e

s
e
r

u
m

e
n
d
e
r
e
ç
o

d
e

i
n
t
e
r
n
e
t
(
e
x
e
m
p
l
o
:
“
h
t
t
p
:
/
/
x
x
x
x
.
     c
     o
     m
     .
     b
     r
     /
     a
     .
     p
     n
     g
     ”
     )
■P
     o
     d
     e

     s
     e
     r

     o

     c
     a
     m
     i
     n
     h
     o

     d
     e

     u
     m

     a
     r
     q
     u
     i
     v
     o

     c
     o
     n
     t
     i
     d
     o

     n
     o

     p
     a
     c
     o
     t
     e

     d
     o

     p
     l
     u
     g
     i
     n
     .
■P
     o
     d
     e

     s
     e
     r

     u
     m

     a
     r
     q
     u
     i
     v
     o

     q
     u
     e

     s
     e
                         e
                         n
                         c
                         o
                         n
                         t
                         r
                         a

                         n
                         o

                         H
                         D

                         V
                         i
                         r
                         t
                         u
                         a
                         l
                         d
                         o

                         p
                         l
                         u
                         g
                         i
                         n

                         i
                         n
                         s
                         t
                         a
                         l
                         a
                         d
                         o
                         .
○ order - Um
     número
     contendo a
     ordem do botão
     em sua
     categoria. A
     grosso modo,
     quem tiver um
     número de
     ordem menor
     fica na frente.
○ options - nil ou
     uma tabela LUA
     podendo conter
     os seguintes
     atributos:

                    ■"
                         s
                         e
                         l
                         e
                         c
                         t
                         a
                         b
                         l
                         e
                         "

                         -
                         B
                         o
                         o
                         l
                         e
                         a
                         n
                         o
                         ,
                         o
                         n
                         d
                         e

                         t
                         r
                         u
                         e

                         s
                         i
                         g
                         n
                         i
                         f
                         i
                         c
                         a

                         q
u
e

a

f
e
r
r
a
m
e
n
t
a

é

u
m
a

f
e
r
r
a
m
e
n
t
a

s
e
l
e
c
i
o
n
á
v
e
l
.
U
m
a

f
e
r
r
a
m
e
n
t
a

s
e
l
e
c
i
o
n
á
v
e
l
p
e
r
m
a
n
e
c
e

a
t
i
v
a

a
t
é

q
u
e

f
i
q
u
e
"
n
ã
o

s
e
l
e
c
i
o
n
a
d
a
"
.
P
o
r

p
a
d
r
ã
o
,
e
s
t
e

v
a
l
o
r

é

f
a
l
s
e

e
s
i
g
n
i
f
i
c
a

q
u
e

a

f
e
r
r
a
m
e
n
t
a

e
x
e
c
u
t
a

a
l
g
o

q
u
e

n
ã
o

p
r
e
     c
     i
     s
     a

     m
     u
     d
     a
     r

     s
     e
     l
     e
     ç
     ã
     o

     d
     a

     f
     e
     r
     r
     a
     m
     e
     n
     t
     a

     a
     t
     i
     v
     a
     .
■d
     e
     f
     a
     u
     l
     t
     O
     f
     C
     a
     t
e
g
o
r
y

-
B
o
o
l
e
a
n
o

o
n
d
e

t
r
u
e

s
i
g
n
i
f
i
c
a

q
u
e

e
s
t
a

f
e
r
r
a
m
e
n
t
a

é

a

p
a
d
r
ã
o

d
a

c
a
t
e
g
o
r
i
a

q
u
e

e
s
t
á

e

q
u
e

e
l
a

s
e
r
á

u
t
i
l
i
z
a
d
a

q
u
a
n
d
o

o

u
s
u
á
r
i
o

c
l
i
c
a
r

n
a

c
a
t
e
g
o
r
i
a
.
O
     p
     a
     d
     r
     ã
     o

     é

     f
     a
     l
     s
     e
     .
■d
     o
     n
     t
     F
     o
     c
     u
     s

     -
     B
     o
     o
     l
     e
     a
     n
     o

     o
     n
     d
     e

     t
     r
     u
     e

     s
     i
     g
     n
     i
     f
i
c
a

q
u
e

a

f
e
r
r
a
m
e
n
t
a

n
ã
o

d
e
v
e

s
e
r

f
o
c
a
d
a

c
o
m
o

f
e
r
r
a
m
e
n
t
a

p
a
d
r
ã
o

d
a

c
a
t
e
g
o
r
i
a

a
p
ó
s

o

u
s
u
á
r
i
o

c
l
i
c
a
r

n
e
l
a
.
O

p
a
d
r
ã
o

é

f
a
l
s
e
.
D
o
n
t
F
o
c
u
s

n
ã
o

f
u
n
c
i
o
n
a

s
e

s
e
l
e
c
t
                         a
                         b
                         l
                         e

                         e
                         s
                         t
                         i
                         v
                         e
                         r

                         a
                         t
                         i
                         v
                         o
                         .
○ callback - Uma
     função que será
     chamada
     quando o
     usuário
     ativar/clicar
     esta ferramenta.
○ (OPCIONAL)
     deactivationCall
     back - Uma
     função que será
     chamada
     quando esta
     ferramenta
     estava
     selecionada e o
     usuário
     selecionou
     outra. Este
     callback é
     chamado
     apenas se a
     ferramenta for
     do tipo
     "selecionável" e
     o Scene espera
     que sua
     ferramenta pare
     de fazer o que
     ela faz quando
     selecionada.
                                   Retorno:

                                             ○ Esta função
                                                  retorna um
                                                  número
                                                  identificador do
                                                  ToolButton no
                                                  scene. Este
                                                  mesmo valor
                                                  pode ser
                                                  utilizado
                                                  posteriormente
                                                  na função
                                                  removeToolBut
                                                  ton.

viewport:removeToolButton(toolID)  Remove um botão ferramenta que foi
                                   previamente adicionado pela função
viewport:checkToolButton(toolID[,  addToolButton.
checked])
                                   Parâmetros:

                                                                  ○ toolID - Um
                                                                       número
                                                                       identificador do
                                                                       ToolButton.
                                                                       Este valor é
                                                                       retornado pela
                                                                       função
                                                                       addToolButton.

                                   Marca ou desmarca um ToolButton. A
                                   marcação é uma mera indicação visual para
                                   o usuário entender que o Tool está ativo de
                                   alguma forma.

                                   Podem existir mais de 1 ToolButton
                                   marcados ao mesmo tempo.

                                   Parâmetros:

                                                                  ○ toolID - toolID -
                                                                       Um número
                                                                       identificador do
                                                                       ToolButton.
                                                                       Este valor é
                                                                       retornado pela
                                                                       função
                                                                       addToolButton.

                                                                  ○ (OPCIONAL)
                                                                       checked - Um
                                                                       booleano, onde
viewport:isToolButtonChecked(toolI                                      true significa
D)                                                                      marcar o tool
                                                                        button e false
viewport:selectDefaultToolButton()                                      significa
viewport:selectToolButton(toolID)                                       desmarcar o
                                                                        tool button. Se
                                                                        não informado,
                                                                        true será
                                                                        utilizado como
                                                                        padrão.

                                    Retorna se um determinado ToolButto está
                                    marcado. A marcação é uma mera indicação
                                    visual para o usuário entender que o Tool
                                    está ativo de alguma forma.

                                    Podem existir mais de 1 ToolButton
                                    marcados ao mesmo tempo.

                                    Parâmetros:

                                                                   ○ toolID - toolID -
                                                                        Um número
                                                                        identificador do
                                                                        ToolButton.
                                                                        Este valor é
                                                                        retornado pela
                                                                        função
                                                                        addToolButton.

                                    Retorno:

                                                                   ○ Um Boolean,
                                                                        onde true
                                                                        significa que o
                                                                        toolbutton está
                                                                        marcado.

                                    Seleciona a Ferramenta/Tool Button
                                    padrão. Pode existir apenas uma ferramenta
                                    selecionada ao mesmo tempo e representa a
                                    ferramenta que o usuário está trabalhando
                                    no momento.

                                    A ferramenta padrão normalmente é a de
                                    "selecionar/movimentar" itens do scene.

                                    Seleciona a Ferramenta/Tool Button
                                    especificada pelo padrão. Pode existir
                                    apenas uma ferramenta selecionada ao
                                    mesmo tempo e representa a ferramenta
                                    que o usuário está trabalhando no
                                    momento.
                                    Parâmetros:

                                                 ○ toolID - toolID -
                                                      Um número
                                                      identificador do
                                                      ToolButton.
                                                      Este valor é
                                                      retornado pela
                                                      função
                                                      addToolButton.

viewport:showForm(form[, options])  Exibe uma janela na interface do usuário na
                                    forma de um Popup flutuante acima do
                                    viewport do scene.

                                    Parâmetros:

                                              ● form - O formulário a ser
                                                   exibido na interface. Deve ser
                                                   um objeto Lua Form já
                                                   instanciado.

                                              ● (OPCIONAL) options - Uma
                                                   tabela/objeto LUA contendo as
                                                   opções da exibição do popup. As
                                                   opções são:
                                                                   ○ onClose -
                                                                        [function,
                                                                        padrão = nil] -
                                                                        Uma função lua
                                                                        que será
                                                                        invocada
                                                                        quando o popup
                                                                        for fechado.
                                                                   ○ placement -
                                                                        [string
                                                                        enumerado] -
                                                                        Onde o popup
                                                                        será exibido.. Os
                                                                        possíveis
                                                                        valores são:
                                                                                       ■"
                                                                                             c
                                                                                             e
                                                                                             n
                                                                                             t
                                                                                             e
                                                                                             r
                                                                                             "
     -
     n
     o

     c
     e
     n
     t
     r
     o

     d
     a

     t
     e
     l
     a
■"
     b
     o
     t
     t
     o
     m
     "

     -
     n
     a

     p
     a
     r
     t
     e

     d
     e

     b
     a
     i
     x
     o

     d
     a

     t
     e
     l
     a
■"
     t
     o
     p
     "

     -
     n
     a

     p
     a
     r
     t
     e

     d
     e

     c
     i
     m
     a

     d
     a

     t
     e
     l
     a
■"
     l
     e
     f
     t
     "

     -
     à

     e
     s
     q
     u
     e
     r
     d
     a
     n
     a

     t
     e
     l
     a
■"
     r
     i
     g
     h
     t
     "

     -
     à

     d
     i
     r
     e
     i
     t
     a

     n
     a

     t
     e
     l
     a
■"
     t
     o
     p
     L
     e
     f
     t
     "

     -
     n
     o

     c
     a
     n
     t
     o

     s
     u
     p
     e
     r
     i
     o
     r

     e
     s
     q
     u
     e
     r
     d
     o

     d
     a

     t
     e
     l
     a
■"
     t
     o
     p
     R
     i
     g
     h
     t
     -
     n
     o

     c
     a
     n
     t
     o

     s
     u
     p
     e
     r
     i
     o
     r

     d
     i
     r
     e
     i
     t
     o

     d
     a

     t
     e
     l
     a
■"
     b
     o
     t
     t
     o
     m
     L
     e
     f
     t
     "

     -
     n
     o

     c
     a
     n
     t
     o

     i
     n
     f
     e
     r
     i
     o
     r
     e
     s
     q
     u
     e
     r
     d
     o

     d
     a

     t
     e
     l
     a
■"
     b
     o
     t
     t
     o
     m
     R
     i
     g
     h
     t
     "

     -
     n
     o

     c
     a
     n
     t
     o

     i
     n
     f
     e
     r
     i
     o
     r

     d
     i
     r
     e
     i
     t
     o

     d
     a

     t
     e
     l
     a
■"
     m
     o
     u
     s
     e
     "

     -
     o
     n
     d
     e

     o

     m
     o
     u
     s
     e

     e
     s
     t
     á

     a
     t
     u
     a
     l
     m
     e
     n
     t
     e
■"
     m
     o
     u
     s
     e
     C
     e
     n
     t
     e
     r
     "

     -
     c
     e
     n
     t
     r
     a
     l
     i
     z
     a
     d
     o

     o
     n
     d
     e

     o

     m
     o
     u
     s
     e

     e
     s
     t
     á

     a
     t
     u
     a
     l
     m
     e
     n
     t
     e
     .
■n
     i
     l
     o
     u

     n
     ã
     o

     i
     n
     f
     o
     r
     m
     a
     d
     o

     -
     P
     o
     s
     i
     ç
     ã
     o

     p
     e
     r
     s
     o
     n
     a
     l
     i
     z
     a
     d
     a
     .
viewport:closeForm(form)     Retorno:
                                 Se conseguir exibir o form como um

                             popup no viewport, retorna true; Senão
                             retorna false.

                             Observações:

                                       ● A função não espera o popup
                                            fechar para retornar. Após esta
                                            chamada, o código LUA
                                            continuará sua execução normal
                                            enquanto o form é mostrado.

                             Fecha uma janela popup que foi
                             previamente aberta pela da função
                             viewport:showPopup.

                             Parâmetros:

                                       ● form - O formulário a ser
                                            fechado/tirado da interface.
                                            Deve ser um objeto Lua Form já
                                            instanciado

viewport:needRepaint()       Retorno:
                                 Se conseguir fechar o form, retorna true;

                             Senão retorna false.

                             Informa ao RRPG que o Scene precisa ser
                             redesenhado.

Métodos para renderização

  Todos os métodos listados abaixos são válidos APENAS dentro de eventos "onBeforeDraw"s e
  "OnAfterDraw"s

Método                       Descrição

viewport:prepareFill(color)  Prepara o viewport para renderizar o
                             preenchimento de polígonos com uma
                             cor sólida.

                             Parâmetros:

                                       ● color - uma cadeia de
                                            caracteres contendo uma
                                            cor.

                             Observações:
viewport:prepareDraw(color [, thickness,            ● Após chamar este método,
strokeCap, strokeJoin, strokeDash])                      os métodos viewport:fill***
                                                         utilizarão esta cor no
                                                         desenho.

                                          Prepara o viewport para renderizar o
                                          contorno de polígonos com uma cor
                                          sólida.

                                          Parâmetros:

                                                    ● color - uma cadeia de
                                                         caracteres contendo uma
                                                         cor.

                                                    ● (OPCIONAL) thickness - A
                                                         espessura do contorno
                                                         métrica de tela. Se omitido,
                                                         o valor padrão é 1.0;

                                                    ● (OPCIONAL) strokeCap -
                                                         Define o estilo gráfico
                                                         usado ao desenhar o fim das
                                                         linhas. Pode ser "flat"
                                                         (linhas com pontas
                                                         retangulares) ou "round"
                                                         (linhas com pontas
                                                         arredondadas). Se omitido,
                                                         o valor padrão é "flat".

                                                    ● (OPCIONAL) strokeJoin -
                                                         Define o estilo gráfico
                                                         usado ao juntar segmentos
                                                         de linha em uma forma.
                                                         Pode ser "miter" (As
                                                         quinas/junções são
                                                         "quadradas"), "round" (As
                                                         quinas/junções são
                                                         arredondadas) ou "bevel"
                                                         (As quintas/junções são
                                                         ligadas de forma diagonal).
                                                         Se omitido, o valor padrão é
                                                         "miter"

                                                    ● (OPCIONAL) strokeDash -
                                                         Define o estilo gráfico da
                                                         linha. Pode ser "solid" (A
                                                         linha é sólida), "dash" (A
                                                         linha é tracejada), "dot" (A
                                                         linha é feita de pontos),
                                                         "dashDot" (A linha é
                                                         alternada entre traços e
                                                         pontos), ou "dashDotDot"
                                                         (A linha é alternada entre
                                                         traço, ponto e ponto). Se
viewport:prepareFont(size [,fontName,                        omitido, o valor padrão é
bold, italic, underline])                                    "solid"

viewport:fillRect(left, top, right, bottom[,  Observações:
opacity])
                                                        ● Após chamar este método,
                                                             os métodos
                                                             viewport:draw*** utilizarão
                                                             estas configurações.

                                              Prepara o viewport para preencher
                                              textos com uma determinada fonte.

                                              Parâmetros:

                                                        ● size - Um número contendo
                                                             o tamanho da fonte. Ex: 12

                                                        ● (OPCIONAL) fontName - O
                                                             nome da fonte a ser usada.
                                                             Se nil, uma fonte padrão
                                                             será utilizada.

                                                        ● (OPCIONAL) bold - True se
                                                             desejar que a fonte esteja
                                                             em negrito.

                                                        ● (OPCIONAL) italic - True se
                                                             desejar que a fonte esteja
                                                             em itálico.

                                                        ● (OPCIONAL) underline -
                                                             True se desejar que a fonte
                                                             esteja sublinhada.

                                              Desenha o preenchimento de um
                                              retângulo na tela do scene.

                                              Parâmetros:

                                                        ● left - Posição esquerda (no
                                                             eixo X) em métrica de tela
                                                             de onde o retângulo deve
                                                             ser preenchido.

                                                        ● top - Posição superior (no
                                                             eixo Y) em métrica de tela
                                                             de onde o retângulo deve
                                                             ser preenchido.

                                                        ● right - Posição direita (no
                                                             eixo X) em métrica de tela
                                                             de onde o retângulo deve
                                                             ser preenchido.

                                                        ● bottom - Posição inferior
                                                             (no eixo Y) em métrica de
                                                             tela de onde o retângulo
                                                             deve ser preenchido.
viewport:fillEllipse(left, top, right,            ● (OPCIONAL) opacity - Um
bottom[, opacity])                                     número entre 0.0 e 1.0
                                                       definindo a opacidade do
                                                       desenho, onde 0.0 =
                                                       totalmente transparente e
                                                       1.0 = totalmente opaco. Se
                                                       este parâmetro não for
                                                       informado, será utilizado
                                                       1.0.

                                        Observações:

                                                  ● Para definir o material/cor
                                                       do retângulo, invoque
                                                       primeiro o método
                                                       "prepareFill"

                                        Desenha o preenchimento de uma
                                        elipse/figura oval na tela do scene.

                                        Parâmetros:

                                                  ● left - Posição esquerda (no
                                                       eixo X) em métrica de tela
                                                       de onde a elipse deve ser
                                                       preenchida.

                                                  ● top - Posição superior (no
                                                       eixo Y) em métrica de tela
                                                       de onde a elipse deve ser
                                                       preenchida.

                                                  ● right - Posição direita (no
                                                       eixo X) em métrica de tela
                                                       de onde a elipse deve ser
                                                       preenchida.

                                                  ● bottom - Posição inferior
                                                       (no eixo Y) em métrica de
                                                       tela de onde a elipse deve
                                                       ser preenchida.

                                                  ● (OPCIONAL) opacity - Um
                                                       número entre 0.0 e 1.0
                                                       definindo a opacidade do
                                                       desenho, onde 0.0 =
                                                       totalmente transparente e
                                                       1.0 = totalmente opaco. Se
                                                       este parâmetro não for
                                                       informado, será utilizado
                                                       1.0.

                                        Observações:

                                                  ● Para definir o material/cor
                                                       da elipse, invoque primeiro
viewport:fillPolygon(polygon[, opacity])                 o método "prepareFill"
viewport:fillACell(i, j [, opacity])
                                          Desenha o preenchimento de um
                                          polígono na tela do scene.

                                          Parâmetros:

                                                    ● polygon - Um array de
                                                         tabelas que contém
                                                         propriedades x e y, e cada
                                                         cada item do array
                                                         representando um vértice
                                                         do polígono.

                                                    ● (OPCIONAL) opacity - Um
                                                         número entre 0.0 e 1.0
                                                         definindo a opacidade do
                                                         desenho, onde 0.0 =
                                                         totalmente transparente e
                                                         1.0 = totalmente opaco. Se
                                                         este parâmetro não for
                                                         informado, será utilizado
                                                         1.0.

                                          Observações:

                                                    ● Para definir o material/cor
                                                         do polígono, invoque
                                                         primeiro o método
                                                         "prepareFill"

                                          Desenha o preenchimento de uma
                                          célula do grid do scene.

                                          Parâmetros:

                                                    ● i - a posição i da célula "Aij"
                                                    ● j - a posição j da célula "Aij"
                                                    ● (OPCIONAL) opacity - Um

                                                         número entre 0.0 e 1.0
                                                         definindo a opacidade do
                                                         desenho, onde 0.0 =
                                                         totalmente transparente e
                                                         1.0 = totalmente opaco. Se
                                                         este parâmetro não for
                                                         informado, será utilizado
                                                         1.0.

                                          Observações:

                                                    ● Para definir o material/cor
                                                         do retângulo, invoque
                                                         primeiro o método
viewport:drawRect(left, top, right,                 "prepareFill"
bottom[, opacity])
                                     Desenha o contorno de um retângulo
                                     na tela do scene.

                                     Parâmetros:

                                               ● left - Posição esquerda (no
                                                    eixo X) em métrica de tela
                                                    de onde o retângulo deve
                                                    ser preenchido.

                                               ● top - Posição superior (no
                                                    eixo Y) em métrica de tela
                                                    de onde o retângulo deve
                                                    ser preenchido.

                                               ● right - Posição direita (no
                                                    eixo X) em métrica de tela
                                                    de onde o retângulo deve
                                                    ser preenchido.

                                               ● bottom - Posição inferior
                                                    (no eixo Y) em métrica de
                                                    tela de onde o retângulo
                                                    deve ser preenchido.

                                               ● (OPCIONAL) opacity - Um
                                                    número entre 0.0 e 1.0
                                                    definindo a opacidade do
                                                    desenho, onde 0.0 =
                                                    totalmente transparente e
                                                    1.0 = totalmente opaco. Se
                                                    este parâmetro não for
                                                    informado, será utilizado
                                                    1.0.

                                     Observações:

                                               ● Para definir o material/cor
                                                    do retângulo, invoque
                                                    primeiro o método
                                                    "prepareDraw"
viewport:drawEllipse(left, top, right,   Desenha o contorno de uma
bottom[, opacity])                       elipse/figura oval na tela do scene.

viewport:drawLine(startX, startY, endX,  Parâmetros:
endY [,opacity])
                                                   ● left - Posição esquerda (no
                                                        eixo X) em métrica de tela
                                                        de onde a elipse deve ser
                                                        preenchida.

                                                   ● top - Posição superior (no
                                                        eixo Y) em métrica de tela
                                                        de onde a elipse deve ser
                                                        preenchida.

                                                   ● right - Posição direita (no
                                                        eixo X) em métrica de tela
                                                        de onde a elipse deve ser
                                                        preenchida.

                                                   ● bottom - Posição inferior
                                                        (no eixo Y) em métrica de
                                                        tela de onde a elipse deve
                                                        ser preenchida.

                                                   ● (OPCIONAL) opacity - Um
                                                        número entre 0.0 e 1.0
                                                        definindo a opacidade do
                                                        desenho, onde 0.0 =
                                                        totalmente transparente e
                                                        1.0 = totalmente opaco. Se
                                                        este parâmetro não for
                                                        informado, será utilizado
                                                        1.0.

                                         Observações:

                                                   ● Para definir o material/cor
                                                        da elipse, invoque primeiro
                                                        o método "prepareDraw"

                                         Desenha uma linha na tela do scene.

                                         Parâmetros:

                                                   ● startX - Posição no eixo X
                                                        em métrica de tela de onde
                                                        a linha deve se originar.

                                                   ● startY - Posição no eixo Y
                                                        em métrica de tela de onde
                                                        a linha deve se originar.

                                                   ● endX - Posição no eixo X em
                                                        métrica de tela de onde a
                                                        linha deve finalizar.

                                                   ● endY - Posição no eixo X em
                                                        métrica de tela de onde a
viewport:textSize(txt)                                   linha deve finalizar.
viewport:fillText(x, y, txt [, opacity])            ● (OPCIONAL) opacity - Um

                                                         número entre 0.0 e 1.0
                                                         definindo a opacidade do
                                                         desenho, onde 0.0 =
                                                         totalmente transparente e
                                                         1.0 = totalmente opaco. Se
                                                         este parâmetro não for
                                                         informado, será utilizado
                                                         1.0.

                                          Calcula o tamanho do texto usando a
                                          fonte configurada no viewport.

                                          Parâmetros:

                                                    ● txt - A cadeia de caracteres
                                                         que será medida.

                                          Retorno:

                                                    ● x - A largura do texto em
                                                         métrica de tela

                                                    ● y - A altura do texto em
                                                         métrica de tela

                                          Observações:

                                                    ● Para definir a fonte,
                                                         invoque primeiro o método
                                                         "prepareFont"

                                          Desenha um texto no scene.

                                          Parâmetros:

                                                    ● x - Posição no eixo X em
                                                         métrica de tela de onde o
                                                         texto deve começar a ser
                                                         desenhado.

                                                    ● y - Posição no eixo Y em
                                                         métrica de tela de onde o
                                                         texto deve começar a ser
                                                         desenhado.

                                                    ● txt - A cadeia de caracteres
                                                         que será desenhada.

                                                    ● (OPCIONAL) opacity - Um
                                                         número entre 0.0 e 1.0
                                                         definindo a opacidade do
                                                         desenho, onde 0.0 =
                                                         totalmente transparente e
                                                         1.0 = totalmente opaco. Se
                                                         este parâmetro não for
viewport:fillTextFit(x, y, right, bottom,                 informado, será utilizado
txt[, horzTextAlign, vertTextAlign, ,                     1.0.
opacity])
                                           Observações:
viewport:pushRenderState()
                                                     ● Para definir a fonte,
                                                          invoque primeiro o método
                                                          "prepareFont"

                                                     ● Para definir o material/cor
                                                          do texto, invoque primeiro
                                                          o método "prepareFill"

                                           Desenha um texto no scene de forma a
                                           fazer cabe-lo da melhor forma em um
                                           retângulo definido.

                                           Parâmetros:

                                                     ● x - Posição no eixo X em
                                                          métrica de tela de onde o
                                                          texto deve começar a ser
                                                          desenhado.

                                                     ● y - Posição no eixo Y em
                                                          métrica de tela de onde o
                                                          texto deve começar a ser
                                                          desenhado.

                                                     ● right - Posição no eixo X em
                                                          métrica de tela de onde o
                                                          texto deve começar a ser
                                                          desenhado.

                                                     ● txt - A cadeia de caracteres
                                                          que será desenhada.

                                                     ● (OPCIONAL) opacity - Um
                                                          número entre 0.0 e 1.0
                                                          definindo a opacidade do
                                                          desenho, onde 0.0 =
                                                          totalmente transparente e
                                                          1.0 = totalmente opaco. Se
                                                          este parâmetro não for
                                                          informado, será utilizado
                                                          1.0.

                                           Observações:

                                                     ● Para definir a fonte,
                                                          invoque primeiro o método
                                                          "prepareFont"

                                                     ● Para definir o material/cor
                                                          do texto, invoque primeiro
                                                          o método "prepareFill"

                                           Salva as configurações atuais de
viewport:popRenderState()              renderização para que possam ser
viewport:pushRotationTransform(angle,  restauradas mais tardes usando
centerX, centerY)                      popRenderState.

viewport:pushWorldToScreenTransform(   Observação: Para cada chamada de
);                                     pushRenderState, deve haver uma
                                       chamada de popRenderState.

                                       Restaura as configurações de
                                       renderização previamente salvadas
                                       pelo método pushRenderState.

                                       Observação: Para cada chamada de
                                       pushRenderState, deve haver uma
                                       chamada de popRenderState.

                                       Empurra uma transformação de
                                       rotação no viewport.

                                       Parâmetros:

                                                 ● angle - Angulo em graus da
                                                      rotação que deve ser feita.

                                                 ● centerX - Posição do pivô
                                                      de rotação no eixo X em
                                                      métrica de tela.

                                                 ● centerY - Posição do pivô
                                                      de rotação no eixo Y em
                                                      métrica de tela.

                                       Observações:

                                                 ● As próximas renderizações
                                                      serão rotacionadas com
                                                      esta configuração até a
                                                      chamada de popTransform.

                                                 ● Para cada chamada de
                                                      pushRotationTransform
                                                      deve haver uma chamada
                                                      de popTransform.

                                       Empurra uma transformação de
                                       coordenadas em métrica de mundo
                                       para métrica de tela no viewport.

                                       Após a chamada desta função, todos os
                                       métodos de desenho entenderão que as
                                       coordenadas passadas estão em
                                       métrica de mundo.

                                       Observações:
   viewport:popTransform();                           ● Para cada chamada de
Eventos                                                    pushWorldToScreenTransf
                                                           orm deve haver uma
   Nome do evento                                          chamada de popTransform.
   onChange
                                           Remove do viewport a última
   onMouseDown                             transformação que havia sido
                                           empurrada.

                             Descrição

                             Evento que é disparado quando o Viewport do
                             scene mudar.

                             As seguintes situações disparam este evento:

                                       ● Alteração no tamanho da tela
                                            (propriedades width e height)

                                       ● Alteração no scroll do viewport
                                            (propriedades worldX e worldY)

                                       ● Alteração no zoom do viewport
                                            (propriedade scale)

                             Este evento é invocado quando um botão do
                             mouse é pressionado sobre o Viewport ou quando
                             o dedo toca a tela (touchscreen).

                             Parâmetros:

                                            ● event - uma tabela Lua que contém
                                                 os seguintes atributos:
                                                                 ○ button – indica
                                                                      qual botão do
                                                                      mouse foi
                                                                      pressionado, e
                                                                      pode conter um
                                                                      dos seguintes
                                                                      valores: “left”,
                                                                      “middle” ou
                                                                      “right”... Quando o
                                                                      dedo é pressionado
                                                                      (touchscreen), este
                                                                      valor é “left” e
                                                                      isTouch = true.
                                                                 ○ x – posição X em
                                                                      métrica de tela
                                                                      indicando onde o
                                                                      mouse foi
onMouseMove                                           pressionado.
                                                 ○ y – posição Y em

                                                      métrica de tela
                                                      indicando onde o
                                                      mouse foi
                                                      pressionado.
                                                 ○ shiftKey - true se a
                                                      tecla shift estiver
                                                      pressionada.
                                                 ○ ctrlKey - true se a
                                                      tecla control
                                                      estiver
                                                      pressionada.
                                                 ○ altKey - true se a
                                                      tecla alt estiver
                                                      pressionada.
                                                 ○ cmdKey - true se a
                                                      tecla command
                                                      (macOS) estiver
                                                      pressionada.
                                                 ○ ctrlOrCmdKey -
                                                      No macOS: true se
                                                      a tecla command
                                                      estiver
                                                      pressionada.
                                                      Outros
                                                      dispositivos: true
                                                      se a tecla control
                                                      estiver
                                                      pressionada.
                                                 ○ isTouch - true se
                                                      este evento foi
                                                      disparado por
                                                      causa de um toque
                                                      em um display
                                                      touchscreen.

             Este evento é invocado quando o mouse se
             movimenta pelo viewport ou quando o dedo
             (touchscreen) é arrastado pelo viewport.

             Parâmetros:

                            ● event - uma tabela Lua que contém
                                 os seguintes atributos:
                                                 ○ x – posição X em
                                                      métrica de tela
                                                      indicando para
                                                      onde o mouse
                                                      moveu.
                                                 ○ y – posição Y em
onMouseUp                                           métrica de tela
                                                    indicando para
                                                    onde o mouse
                                                    moveu.
                                               ○ shiftKey - true se a
                                                    tecla shift estiver
                                                    pressionada
                                                    também
                                               ○ ctrlKey - true se a
                                                    tecla control
                                                    estiver
                                                    pressionada
                                                    também
                                               ○ altKey - true se a
                                                    tecla alt estiver
                                                    pressionada
                                                    também.
                                               ○ cmdKey - true se a
                                                    tecla command
                                                    (macOS) estiver
                                                    pressionada.
                                               ○ ctrlOrCmdKey -
                                                    No macOS: true se
                                                    a tecla command
                                                    estiver
                                                    pressionada.
                                                    Outros
                                                    dispositivos: true
                                                    se a tecla control
                                                    estiver
                                                    pressionada.
                                               ○ isTouch - true se
                                                    este evento foi
                                                    disparado por
                                                    causa de um toque
                                                    em um display
                                                    touchscreen.

           Este evento é invocado quando um botão do
           mouse é liberado sobre o Viewport ou quando o
           dedo solta da tela (touchscreen).

           Parâmetros:

                          ● event - uma tabela Lua que contém
                               os seguintes atributos:
                                               ○ button – indica
                                                    qual botão do
                                                    mouse foi liberado,
                                                    e pode conter um
                                                    dos seguintes
onMouseDblClick                                           valores: “left”,
                                                          “middle” ou
                                                          “right”... Quando o
                                                          dedo é levantado
                                                          (touchscreen), este
                                                          valor é “left” e
                                                          isTouch = true.
                                                     ○ x – posição X em
                                                          métrica de tela
                                                          indicando onde o
                                                          mouse foi liberado.
                                                     ○ y – posição Y em
                                                          métrica de tela
                                                          indicando onde o
                                                          mouse foi liberado.
                                                     ○ shiftKey - true se a
                                                          tecla shift estiver
                                                          pressionada
                                                          também
                                                     ○ ctrlKey - true se a
                                                          tecla control
                                                          estiver
                                                          pressionada
                                                          também
                                                     ○ altKey - true se a
                                                          tecla alt estiver
                                                          pressionada
                                                          também.
                                                     ○ cmdKey - true se a
                                                          tecla command
                                                          (macOS) estiver
                                                          pressionada.
                                                     ○ ctrlOrCmdKey -
                                                          No macOS: true se
                                                          a tecla command
                                                          estiver
                                                          pressionada.
                                                          Outros
                                                          dispositivos: true
                                                          se a tecla control
                                                          estiver
                                                          pressionada.
                                                     ○ isTouch - true se
                                                          este evento foi
                                                          disparado por
                                                          causa de um toque
                                                          em um display
                                                          touchscreen.

                 Este evento é invocado quando o usuário realiza a
ação duplo clique com o mouse sobre o Viewport.

Parâmetros:

               ● event - uma tabela Lua que contém
                    os seguintes atributos:
                                    ○ x – posição X em
                                         métrica de tela
                                         indicando onde
                                         ocorreu o duplo
                                         clique.
                                    ○ y – posição Y em
                                         métrica de tela
                                         indicando onde
                                         ocorreu o duplo
                                         clique.
                                    ○ shiftKey - true se a
                                         tecla shift estiver
                                         pressionada.
                                    ○ ctrlKey - true se a
                                         tecla control
                                         estiver
                                         pressionada.
                                    ○ altKey - true se a
                                         tecla alt estiver
                                         pressionada.
                                    ○ cmdKey - true se a
                                         tecla command
                                         (macOS) estiver
                                         pressionada.
                                    ○ ctrlOrCmdKey -
                                         No macOS: true se
                                         a tecla command
                                         estiver
                                         pressionada.
                                         Outros
                                         dispositivos: true
                                         se a tecla control
                                         estiver
                                         pressionada.
                                    ○ isTouch - true se
                                         este evento foi
                                         disparado por
                                         causa de um toque
                                         em um display
                                         touchscreen.

Observação: Este evento é disparado junto com
onMouseDown e onMouseUp na seguinte ordem:
Mouse Down -> Mouse Up -> Mouse Down -> Dbl
Click -> Mouse Up
onMouseWheel          Este evento é invocado quando a "rodinha" do
onFallbackMouseWheel  mouse é é rolada sobre o Viewport.

                      Parâmetros:

                                     ● event - uma tabela Lua que contém
                                          os seguintes atributos:
                                                          ○ delta - Um número
                                                               que indica a
                                                               distancia que a
                                                               roda foi rodada. Se
                                                               for positivo,
                                                               significa que a
                                                               rodinha foi rolada
                                                               para cima e se for
                                                               negativo significa
                                                               que ela foi rolada
                                                               para baixo.
                                                          ○ shiftKey - true se a
                                                               tecla shift estiver
                                                               pressionada
                                                          ○ ctrlKey - true se a
                                                               tecla control
                                                               estiver
                                                               pressionada
                                                          ○ altKey - true se a
                                                               tecla alt estiver
                                                               pressionada
                                                          ○ ctrlOrCmdKey -
                                                               No macOS: true se
                                                               a tecla command
                                                               estiver
                                                               pressionada.
                                                               Outros
                                                               dispositivos: true
                                                               se a tecla control
                                                               estiver
                                                               pressionada.
                                                          ○ cmdKey - true se a
                                                               tecla command
                                                               (macOS) estiver
                                                               pressionada.

                      Se seu evento controlou adequadamente este
                      evento e não quer que nenhum outro plug-in tente
                      manipular mais este evento, retorne
                      explicitamente true usando "return true;"

                      Idêntico ao evento onMouseWheel, porém é
                      chamado apenas quando nenhum código tratar o
                      evento onMouseWheel.
onGestureBeginZoom  Este evento é invocado quando o usuário,
onGestureZoom       utilizando o TouchScreen e seus dedos, começa a
onGestureEndZoom    realizar um gesto de zoom.

                    Parâmetros:

                              ● x - Número, a posição CENTRAL no
                                   eixo X em métrica de tela de onde o
                                   gesto foi iniciado. Esta posição é o pivô
                                   do zoom.

                              ● y - Número, a posição CENTRAL no
                                   eixo Y em métrica de tela de onde o
                                   gesto foi iniciado. Esta posição é o pivô
                                   do zoom.

                    Observações: Neste momento, o usuário ainda não
                    realizou zoom, apenas destacou sua intenção de o
                    fazer.

                    Retorne explicitamente true para indicar ao Scene
                    que você já lidou com este evento e nenhum outro
                    script precisa se preocupar com ele.

                    Este evento é invocado quando o usuário,
                    utilizando o TouchScreen e seus dedos, realiza um
                    gesto de zoom.

                    Parâmetros:

                              ● x - Número, a posição CENTRAL no
                                   eixo X em métrica de tela de onde o
                                   gesto foi realizado. Esta posição é o
                                   pivô do zoom.

                              ● y - Número, a posição CENTRAL no
                                   eixo Y em métrica de tela de onde o
                                   gesto foi realizado. Esta posição é o
                                   pivô do zoom.

                              ● delta - Um número contendo a
                                   distância em métrica de tela do zoom
                                   desejado. Se negativo, é um gesto de
                                   zoom out. Este valor é a variação da
                                   distância deste o último evento
                                   onGestureZoom.

                    Retorne explicitamente true para indicar ao Scene
                    que você já lidou com este evento e nenhum outro
                    script precisa se preocupar com ele.

                    Este evento é invocado quando o usuário,
                    utilizando o TouchScreen e seus dedos, finaliza um
                    gesto de zoom.
onGestureBeginRotation  Parâmetros:
onGestureRotation
                                  ● x - Número, a posição CENTRAL no
                                       eixo X em métrica de tela de onde o
                                       gesto foi finalizado. Esta posição é o
                                       pivô do zoom.

                                  ● y - Número, a posição CENTRAL no
                                       eixo Y em métrica de tela de onde o
                                       gesto foi finalizado. Esta posição é o
                                       pivô do zoom.

                        Observações: Neste momento, o usuário já
                        realizou todo zoom que queria fazer.

                        Retorne explicitamente true para indicar ao Scene
                        que você já lidou com este evento e nenhum outro
                        script precisa se preocupar com ele.

                        Este evento é invocado quando o usuário,
                        utilizando o TouchScreen e seus dedos, começa a
                        realizar um gesto de rotação.

                        Parâmetros:

                                  ● x - Número, a posição CENTRAL no
                                       eixo X em métrica de tela de onde o
                                       gesto foi iniciado. Esta posição é o pivô
                                       da rotação.

                                  ● y - Número, a posição CENTRAL no
                                       eixo Y em métrica de tela de onde o
                                       gesto foi iniciado. Esta posição é o pivô
                                       da rotação.

                        Observações: Neste momento, o usuário ainda não
                        realizou rotação, apenas destacou sua intenção de
                        o fazer.

                        Retorne explicitamente true para indicar ao Scene
                        que você já lidou com este evento e nenhum outro
                        script precisa se preocupar com ele.

                        Este evento é invocado quando o usuário,
                        utilizando o TouchScreen e seus dedos, realiza um
                        gesto de rotação.

                        Parâmetros:

                                  ● x - Número, a posição CENTRAL no
                                       eixo X em métrica de tela de onde o
                                       gesto foi realizado. Esta posição é o
                                       pivô da rotação.
onGestureEndRotation            ● y - Número, a posição CENTRAL no
onGestureBeginPan                    eixo Y em métrica de tela de onde o
                                     gesto foi realizado. Esta posição é o
                                     pivô da rotação.

                                ● angle - Número contendo o ângulo da
                                     rotação em graus. Valor positivo
                                     significa rotação em sentido anti-
                                     horário, valor negativo em sentido
                                     horário. Este valor é a variação do
                                     ângulo deste o último evento
                                     onGestureRotation.

                      Retorne explicitamente true para indicar ao Scene
                      que você já lidou com este evento e nenhum outro
                      script precisa se preocupar com ele.

                      Este evento é invocado quando o usuário,
                      utilizando o TouchScreen e seus dedos, finaliza um
                      gesto de rotação.

                      Parâmetros:

                                ● x - Número, a posição CENTRAL no
                                     eixo X em métrica de tela de onde o
                                     gesto foi finalizado. Esta posição é o
                                     pivô da rotação.

                                ● y - Número, a posição CENTRAL no
                                     eixo Y em métrica de tela de onde o
                                     gesto foi finalizado. Esta posição é o
                                     pivô da rotação.

                      Observações: Neste momento, o usuário já
                      realizou toda rotação que queria fazer.

                      Retorne explicitamente true para indicar ao Scene
                      que você já lidou com este evento e nenhum outro
                      script precisa se preocupar com ele.

                      Este evento é invocado quando o usuário,
                      utilizando o TouchScreen e seus dedos, começa a
                      realizar um gesto de deslize/scroll.

                      Parâmetros:

                                ● x - Número, a posição no eixo X em
                                     métrica de tela de onde o gesto foi
                                     iniciado.

                                ● y - Número, a posição no eixo Y em
                                     métrica de tela de onde o gesto foi
                                     iniciado.

                      Observações: Neste momento, o usuário ainda não
                      realizou deslizamento, apenas destacou sua
onGesturePan      intenção de o fazer.
onGestureEndPan
onGestureLongTap  Retorne explicitamente true para indicar ao Scene
                  que você já lidou com este evento e nenhum outro
                  script precisa se preocupar com ele.

                  Este evento é invocado quando o usuário,
                  utilizando o TouchScreen e seus dedos, realiza um
                  gesto de deslize/scroll.

                  Parâmetros:

                            ● x - Número, a posição no eixo X em
                                 métrica de tela de onde o gesto foi
                                 realizado. Este representa onde, no
                                 viewport, está o ponteiro/dedo.

                            ● y - Número, a posição no eixo Y em
                                 métrica de tela de onde o gesto foi
                                 realizado. Este representa onde, no
                                 viewport, está o ponteiro/dedo.

                  Retorne explicitamente true para indicar ao Scene
                  que você já lidou com este evento e nenhum outro
                  script precisa se preocupar com ele.

                  Este evento é invocado quando o usuário,
                  utilizando o TouchScreen e seus dedos, finaliza um
                  gesto de deslize/scroll.

                  Parâmetros:

                            ● x - Número, a posição no eixo X em
                                 métrica de tela de onde o gesto foi
                                 finalizado.

                            ● y - Número, a posição no eixo Y em
                                 métrica de tela de onde o gesto foi
                                 finalizado.

                  Retorne explicitamente true para indicar ao Scene
                  que você já lidou com este evento e nenhum outro
                  script precisa se preocupar com ele.

                  Este evento é invocado quando o usuário,
                  utilizando o TouchScreen e seus dedos, realiza um
                  gesto de longTap (pressionar e segurar por algum
                  tempo)

                  Parâmetros:

                            ● x - Número, a posição no eixo X em
                                 métrica de tela de onde o gesto foi
                                 realizado.
onKeyDown            ● y - Número, a posição no eixo Y em
                          métrica de tela de onde o gesto foi
                          realizado.

           Retorne explicitamente true para indicar ao Scene
           que você já lidou com este evento e nenhum outro
           script precisa se preocupar com ele.

           Este evento é invocado quando uma tecla (teclado)
           é pressionada no Scene.

           Parâmetros:

                          ● event - uma tabela Lua que contém
                               os seguintes atributos
                                               ○ key - Cadeia de
                                                    caracteres
                                                    contendo a letra do
                                                    teclado que foi
                                                    pressionada
                                               ○ keyCode – Código
                                                    numérico da tecla
                                                    que foi
                                                    pressionada
                                                    (algumas teclas,
                                                    como F7, por
                                                    exemplo, não
                                                    representam uma
                                                    letra, daí a
                                                    necessidade do
                                                    keyCode)
                                               ○ shiftKey - true se a
                                                    tecla shift estiver
                                                    pressionada.
                                               ○ ctrlKey - true se a
                                                    tecla control
                                                    estiver
                                                    pressionada.
                                               ○ altKey - true se a
                                                    tecla alt estiver
                                                    pressionada.
                                               ○ cmdKey - true se a
                                                    tecla command
                                                    (macOS) estiver
                                                    pressionada.
                                               ○ ctrlOrCmdKey -
                                                    No macOS: true se
                                                    a tecla command
                                                    estiver
                                                    pressionada.
                                                    Outros
                                                    dispositivos: true
onKeyUp                                                         se a tecla control
onBeforeDrawBkgLayer                                            estiver
onBeforeDrawGridLayer                                           pressionada.
onBeforeDrawObjsLayer
                       Observações:

                                 ● Se você alterar o valor de key e/ou
                                      keyCode, a mudança é incorporada.
                                      Caso queira suprimir/ignorar a tecla
                                      que acabou de ser pressionada, atribua
                                      event.key = "" e event.keyCode = 0.

                                 ● Se a combinação de teclas pressionada
                                      puder ser um atalho, então event.key
                                      virá com valor "" (string vazio) e
                                      event.keyCode com valor diferente de
                                      0.

                                 ● Se a combinação de teclas pressionada
                                      puder ser tratada como um caractere
                                      exibível, event.key vira com uma string
                                      contendo apenas este caracter e
                                      event.keyCode virá com valor igual a 0.

                       Este evento é invocado quando uma tecla (teclado)
                       é liberada.

                       Parâmetros:

                                      ● event - uma tabela Lua que contém
                                           as mesmas propriedades descritas
                                           no evento onKeyDown mas com
                                           informações sobre a tecla liberada.

                       Evento de renderização. Quando estiver neste
                       evento, utilize os métodos de renderização do
                       viewport para realizar pinturas na tela do usuário.
                       Não realize tarefas pesadas neste evento!

                       Este evento é invocado antes do RRPG pintar a
                       camada background do scene.

                       Evento de renderização. Quando estiver neste
                       evento, utilize os métodos de renderização do
                       viewport para realizar pinturas na tela do usuário.
                       Não realize tarefas pesadas neste evento!

                       Este evento é invocado depois do RRPG pintar a
                       camada background e antes de pintar o grid do
                       scene.

                       Evento de renderização. Quando estiver neste
                       evento, utilize os métodos de renderização do
                       viewport para realizar pinturas na tela do usuário.
onBeforeDrawTokensLayer  Não realize tarefas pesadas neste evento!
onAfterDrawLayers
onStartDrop              Este evento é invocado depois do RRPG pintar o
                         grid e antes de pintar a camada objetos do scene.

                         Evento de renderização. Quando estiver neste
                         evento, utilize os métodos de renderização do
                         viewport para realizar pinturas na tela do usuário.
                         Não realize tarefas pesadas neste evento!

                         Este evento é invocado depois do RRPG pintar a
                         camada objetos e antes de pintar a camada tokens
                         do scene.

                         Evento de renderização. Quando estiver neste
                         evento, utilize os métodos de renderização do
                         viewport para realizar pinturas na tela do usuário.
                         Não realize tarefas pesadas neste evento!

                         Este evento é invocado depois do RRPG pintar a
                         camada tokens.

                         Evento que é chamado quando alguém arrasta uma
                         informação (drag) em cima do scene e você deseja
                         informar quais ações ou dados existem em um
                         determinado ponto do tabuleiro.

                         Parâmetros:

                                   ● drop - Objeto Drop o qual você deve
                                        preencher as informações para o RRPG
                                        acasalar o drag com o drop.

                                   ● x - Numero contendo a posição do eixo
                                        X, em métrica de tela, de onde o drop
                                        está tentando ser feito.

                                   ● y - Numero contendo a posição do eixo
                                        y, em métrica de tela, de onde o drop
                                        está tentando ser feito.

                                   ● drag - Objeto Drag representando a
                                        informação que está sendo arrastada.
                                        Você não deve alterar as propriedades
                                        deste objeto.

                                   ● event - uma tabela Lua que contém os
                                        seguintes atributos:
                                                        ○ x – Numero contendo a
                                                             posição do eixo X, em
                                                             métrica de tela, de
                                                             onde o drop está
                                                             tentando ser feito.
                                                        ○ y – Numero contendo a
                                                             posição do eixo y, em
                                                                                         métrica de tela, de
                                                                                         onde o drop está
                                                                                         tentando ser feito.
                                                                                    ○ shiftKey – true se a
                                                                                         tecla shift estiver
                                                                                         pressionada.
                                                                                    ○ ctrlKey – true se a
                                                                                         tecla control estiver
                                                                                         pressionada.
                                                                                    ○ altKey – true se a tecla
                                                                                         alt estiver pressionada.
                                                                                    ○ cmdKey - true se a
                                                                                         tecla command
                                                                                         (macOS) estiver
                                                                                         pressionada.
                                                                                    ○ ctrlOrCmdKey - No
                                                                                         macOS: true se a tecla
                                                                                         command estiver
                                                                                         pressionada. Outros
                                                                                         dispositivos: true se a
                                                                                         tecla control estiver
                                                                                         pressionada.
                                                                                    ○ isTouch - true se este
                                                                                         evento foi disparado
                                                                                         por causa de um toque
                                                                                         em um display
                                                                                         touchscreen.

                                                     Por favor, consulte Arrastando-e-Soltando
                                                     Informações / Drag and Drop para conhecer
                                                     melhor sobre o processo drag and drop.

Exemplos

Exemplo 1 - Um plugin que detecta quando o Viewport de um scene muda
require("scene.lua");

SceneLib.registerPlugin(

function (scene, attachment)

        scene.viewport.onChange =

        function()

                local r = scene.viewport:screenToWorld({left=0,

top=0,

right=scene.viewport.width,

bottom=scene.viewport.height});

                local texto = "O Viewport mudou..\n" ..

                                                      "Dimensões da tela: " ..
scene.viewport.width .. " por " ..

                             scene.viewport.height .. "\n" ..

                                                      "Posicao do Scroll: " ..
scene.viewport.worldX .. " por " ..

                             scene.viewport.worldY .. "\n" ..

                             "Região do Scene que é exibido neste

viewport: " ..

                             string.format("[(left %f, top %f)(right

%f, bottom %f)]",

                                   r.left, r.top, r.right,
        r.bottom);

                                      showMessage(texto);
                              end;
                end);

Exemplo 2 - Um plug-in que descobre em qual célula do grid o usuário clicou

        require("scene.lua");

        SceneLib.registerPlugin(
                function (scene, attachment)
                       -- Manipular o evento onMouseUp do Viewport afim de detectar

        o click do mouse

                       scene.viewport.onMouseUp =
                              function (event)
                                      -- Converter coordenada de tela do click para

        coordenada de mundo
                                      local wx, wy = scene.viewport:screenToWorld(event.x,
                                                                                                                      event.y);

      -- Converter coordenada de mundo para coordenada do

grid
                                      local i, j = scene.grid:worldToCell(wx, wy);

                                      -- Exibir uma Mensagem sobre a célula clicada
                                      showMessage("Click na célula [Linha " .. i ..

                                                           ", Coluna " .. j .. "]");
                              end;
                end);

Exemplo 3 - Um plug-in que adiciona/remove uma marca personalizada quando o usuário clica nos itens
do scene.
require("scene.lua");

SceneLib.registerPlugin(
       function (scene, attachment)

-- Manipular o evento OnMouseDown do Viewport

              scene.viewport.onMouseDown = function(event)
                     -- Usuário clicou no Scene
                     -- Transformar as coordenadas de tela em métrica de mundo
                     local worldX, worldY =

scene.viewport:screenToWorld(event.x, event.y);

            -- Localizar o item que o usuário clicou
            local item = scene.items:itemAtPoint(worldX, worldY);

            if item ~= nil then
                   -- Encontrou um item na posição clicada.
                   local NOME_MINHA_MARCA = "MarcaExemplo";

            -- Localizar uma operação gráfica neste item com o

nosso nome

                             local opGrafica =
item.canvas:findByName(NOME_MINHA_MARCA);
                             if opGrafica == nil then
                                    --[[ A operação gráfica da minha marca ainda não
                                           existe neste token/item. Vamos criar ]]

                                    opGrafica = item.canvas:addBitmap();
                                    opGrafica.name = NOME_MINHA_MARCA;
                                  -- Abaixo, URL da imagem da nossa marca.
                                    opGrafica.url =
"https://wiki.teamfortress.com/w/images/d/dd/Bleed_drop.png?
t=20110425044341";
                                    opGrafica.x = 0.25;
                                    opGrafica.width = 0.3;
                                    opGrafica.y = -0.1;
                                    opGrafica.height = 0.3;
                                    opGrafica.z = 10;
                             else
                                    -- Vamos apagar nossa operação gráfica
previamente criada
                                    opGrafica:delete();
                             end;
                     end;
              end;
end);

Item sem a marca

                  Item com a marca

Estrutura SceneRect

(Conteúdo desta página não consta no documento original.)
```
