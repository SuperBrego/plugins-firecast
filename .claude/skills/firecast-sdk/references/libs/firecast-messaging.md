# Biblioteca firecast-messaging

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca Firecast.Messaging

       A biblioteca Firecast.Messaging contém funções que tratam as notificações que o Firecast
       dispara para todos os plug-ins através de mensagens.
       Em resumo, existem 2 tipos de eventos que o SDK 3 permite o programador "tratar":

                                 ○ Eventos de tags/controles - São eventos específicos de cada controle.
                                 ○ Mensagens do Firecast - São acontecimentos que são compartilhado

                                      com todos os plugins instalados, pois podem ser de interesse de todos.
                                      Exemplos: Quando a conexão do RRPG cai, quando o usuário entra em
                                      uma nova mesa, etc..
       Esta biblioteca auxilia na manipulação do segundo tipo de evento descrito acima.
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "firecast.lua"
    require("firecast.lua");

    -- Agora é possível acessar as funções da biblioteca
    Firecast.Messaging.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca Firecast.Messaging

    function Firecast.Messaging.newReceiver(messageName, callbackFunction
[, filters])

Cria e retorna um objeto que representa a "escuta" de mensagens eventos.

Parâmetros:

                         ○ messageName - uma cadeia de caracteres definindo qual mensagem-
                               evento a escuta deve ouvir. Para saber quais mensagens você pode
                               escutar, veja Lista de Mensagens Eventos do Firecast.

                         ○ callbackFunction - uma função que será invocada sempre que a escuta
                               captar uma mensagem. Quando invocada, a função recebe no primeiro
                               parâmetro uma tabela/objeto lua contendo as propriedades da
                               mensagem. Cada mensagem-evento possui sua própria lista de
                               atributos e você deve, portanto, consultar Lista de Mensagens-Eventos
                               do Firecast para mais detalhes..

                         ○ (OPCIONAL) filters - Uma tabela/objeto Lua contendo filtros que a
                               escuta deve verificar para decidir se deve invocar "callbackFunction" ou
                               não. Exemplo:
                                              ■ Filters= {from="Login"}. A escuta só disparará
                                                   "callbackFunction" se a mensagem possuir um atributo
                                                   de nome "from" com conteúdo igual a "Login".

Retorno:      ○ Um objeto representando a escuta instalada ou nil caso falhe
Observações:
              ○ Mantenha referência ao objeto retornado enquanto a escuta for
Exemplo:           necessária. Se o objeto for liberado da memória pelo coletor de lixo, a
                   escuta será desinstalada automaticamente.

              ○ A função não falha se você informar, no parâmetro "messageName",
                   uma identificação de mensagem não esteja na lista Lista de Mensagens-
                   Eventos do Firecast, mas, provavelmente, a escuta nunca irá disparará a
                   função "callbackFunction".

              ○ É possível cancelar a escuta de 3 maneiras:
                                  ■ Invocar a função receiverObj:disable() do objeto
                                       retornado, conforme exemplo abaixo
                                  ■ Retornar explicitamente false na "callbackFunction"
                                  ■ Deixar o coletor de lixo do Lua coletar o objeto,
                                       eventualmente.

              ○ A diferença básica entre Firecast.Messaging.newReceiver e
                   Firecast.Messaging.listen é a forma de gerenciar o ciclo de vida da
                   escuta.
                           require("firecast.lua");

                           local receiverObj =
                           Firecast.Messaging.newReceiver("SessionLost",

                                                                       function (msg)
                                                                                     -- This

                           function will be called when the Firecast
                           connection is lost

                           showMessage("The connect was lost!");
                                                                       end);

                           -- To disable the receiver:
                           receiverObj:disable(); -- disable right now
                           receiverObj = nil; -- let the garbage
                           collector disable the receiver

function Firecast.listen(messageName, callbackFunction [, filters])
ou
function Firecast.Messaging.listen(messageName, callbackFunction [,
filters])

   Instala uma "escuta" de mensagens eventos.
   Parâmetros:

                             ○ messageName - uma cadeia de caracteres definindo qual mensagem-
                                  evento a escuta deve ouvir. Para saber quais mensagens você pode
                                  escutar, veja Lista de Mensagens Eventos do Firecast.

                             ○ callbackFunction - uma função que será invocada sempre que a escuta
                                  captar uma mensagem. Quando invocada, a função recebe no primeiro
                                  parâmetro uma tabela/objeto lua contendo as propriedades da
                                  mensagem. Cada mensagem-evento possui sua própria lista de
                                  atributos e você deve, portanto, consultar Lista de Mensagens-Eventos
                                  do Firecast para mais detalhes..

                             ○ (OPCIONAL) filters - Uma tabela/objeto Lua contendo filtros que a
                                  escuta deve verificar para decidir se deve invocar "callbackFunction" ou
                                  não. Exemplo:
                                                  ■ Filters= {from="Login"}. A escuta só disparará
                                                       "callbackFunction" se a mensagem possuir um atributo
                                                       de nome "from" com conteúdo igual a "Login".
Retorno:      ○ Um número identificando a escuta instalada ou nil caso falhe. Você
Observações:       pode utilizar este valor na função Firecast.Messaging.unlisten para
                   cancelar a escuta .
Exemplo:
              ○ A função não falha se você informar, no parâmetro "messageName",
                   uma identificação de mensagem não esteja na lista Lista de Mensagens-
                   Eventos do Firecast, mas, provavelmente, a escuta nunca irá disparará a
                   função "callbackFunction".

              ○ É possível cancelar a escuta de 2 maneiras:
                                  ■ Invocar a função Firecast.Messaging.unlisten passando
                                       o valor retornado por esta função
                                       (rrpg.messaging.listen) como parâmetro;
                                  ■ Retornar explicitamente false na "callbackFunction"

              ○ A diferença básica entre Firecast.Messaging.newReceiver e
                   Firecast.Messaging.listen é a forma de gerenciar o ciclo de vida da
                   escuta.

require("firecast.lua");

Firecast.Messaging.listen("SessionLost",
              function (detalhesDaMensagem)
                             -- Esta função será chamada

quando a conexão do RRPG for perdida
                             showMessage("A conexão foi

perdida!");
              end);

function Firecast.listenOnce(messageName, callbackFunction [, filters])
ou
function Firecast.Messaging.listenOnce(messageName, callbackFunction [,
filters])

   Instala uma "escuta" de mensagens eventos. O funcionamento é idêntico à da função
   Firecast.Messaging.listen, porém a escuta é automaticamente desinstalada após captar 1
   mensagem.
function Firecast.unlisten(listenerId)
ou
function Firecast.Messaging.unlisten(listenerId)

   Desinstala uma "escuta" que foi previamente instalada pela função Firecast.Messaging.listen ou
   pela função Firecast.Messaging.listenOnce.

   Parâmetros:

                             ○ listenerId - Identificação da escuta a ser desinstalada. A identificação da
                                  escuta é retornada pela função que instala escutas
                                  (Firecast.Messaging.listen ou Firecast.Messaging.listenOnce)

function Firecast.groupOnceListeners(listenerId1 [, listenerId2 [, listenerId3 [, listenerIdN...]]
ou
function Firecast.Messaging.groupOnceListeners(listenerId1 [, listenerId2 [, listenerId3 [,
listenerIdN...]]])

   Agrupa "escuta" de mensagens-eventos do tipo once (àquela que capta somente 1 mensagem).
   Quando OnceListeners são agrupados, a característica de se desinstalar automaticamente após
   receber a primeira mensagem é "expandida" para o grupo. Isto é, quando o Listener1 captar
   uma mensagem e se desinstalar, o Listener2, Listener3 e ListenerN são automaticamente
   desinstalados juntos.

   Esta função é especialmente útil em situações que possam resultar 2 ou mais mensagens-
   eventos distintas. Exemplo: O código requisitou a criação de 1 novo personagem em uma
   mesa... duas coisas podem acontecer: O servidor pode responder à requisição ou a conexão com
   o rrpg pode cair. Nesta situação, devemos instalar uma escuta "Quando o servidor responder",
   uma escuta "Quando a conexão cair" e agrupá-las. Note que se o servidor responder, não
   estaremos mais interessados se a conexão cair e vice-versa.

   Parâmetros:

                             ○ listenerId1, listenerId2, listenerId3, listenerId4, listenerId5,
                                  listenerIdN... As identificações de escuta que queira agrupar. Este valor
                                  é retornado pela função Firecast.Messaging.listenOnce.
                                                  ■ Este é um parâmetro "vararg", isto é, você pode passar
                                                       quantos valores quiser. Exemplo de chamadas válidas:
                                                       Firecast.Messaging.groupOnceListeners(id1, id2) ou
                                                       rrpg.messaging.groupOnceListeners(id1, id2, id3, id4,
                                                       id5, id7, id8).
Lista de Mensagens-Eventos do RRPG

                                 ○ Mensagens de Conexão - Mensagens eventos que são disparadas
                                      quando o estado da conexão com o RRPG server é alterado (Ex: uma
                                      perda de conexão)

                                 ○ Mensagens do Gerenciador de Plugins - Mensagens eventos que são
                                      disparadas pelo gerenciador de plug-ins do RRPG (Exemplo: Um plug-in
                                      foi instalado, um plug-in foi desinstalado, etc..).

                                 ○ Mensagens de Chat - Mensagens eventos que são disparadas pelas
                                      interfaces de Chat do RRPG.

                                 ○ Mensagens de Estado das Mesas - Mensagens eventos que são
                                      disparados quando ocorre a alteração de algum estado das Mesas dos
                                      usuários

Mensagens de Conexão

        "SessionLost"

                Mensagem enviada quando o RRPG perder definitivamente a conexão com o servidor.

        "SessionStarted"

                Mensagem enviada quando o RRPG conseguir estabelecer uma conexão com o servidor.

        "SessionLogin"

                Mensagem enviada quando o processo de Login do usuário for concluído com êxito.
      Quando esta mensagem-evento for enviada, significa que o usuário está logado e algumas
      informações sobre sua conta e lista de contatos também estão disponíveis.

        "SessionStarting"

                Mensagem enviada quando o RRPG iniciar o processo de estabelecimento de uma nova
      conexão com o servidor.

        "SessionStartFailure"

                Mensagem enviada quando o RRPG não conseguir estabelecer uma nova conexão com o
      servidor.

                Propriedades da mensagem:
                                                      ■ reason - uma cadeia de caracteres contendo a razão da
                                                           conexão ter falhado.

        "SessionBroken"
                O link da conexão foi quebrada, isto é, a conexão TCP/IP com o servidor foi desfeita. Mas
      não está tudo perdido ainda: Talvez seja possível reestabelecer a conexão, e o RRPG vai tentar
      isso!

        "SessionWillTryToFix"

                O RRPG tentará recuperar o link quebrado da conexão daqui a alguns milisegundos!
                Parâmetros:

                                                      ■ waitTime - Um número contendo quantos milisegundos
                                                           o RRPG vai esperar até a tentativa de recuperação.

        "SessionTryingToFix"

                O RRPG tentará recuperar o link quebrado da conexão AGORA!

        "SessionFixed"

                O RRPG conseguiu recuperar o link da conexão. A conexão está normal agora!

        "SessionFixFailure"

                Uma tentativa de recuperar o link da conexão falhou... Se a mensagem
      "SessionWillTryToFixIn" for disparada logo a seguir, então o RRPG continuará tentando
      consertar o link. Se a mensagem "SessionLost" for disparada logo a seguir, então o RRPG não vai
      mais tentar recuperar o link.

Estados de Conexão do RRPG
       As mensagens-eventos sobre a conexão do RRPG são disparadas conforme o seguinte fluxo:
Mensagens do Gerenciador de Plugins

        "PluginInstalled"

                Mensagem enviada quando um plug-in for instalado no RRPG Firecast.

                Parâmetros:

                                                      ■ moduleId - Cadeia de caracteres contendo a
                                                           identificação do plug-in

        "PluginUninstalled"

                Mensagem enviada quando um plug-in for desinstalado do RRPG Firecast

                Parâmetros:

                                                      ■ moduleId - Cadeia de caracteres contendo a
                                                           identificação do plug-in que foi desinstalado.

Mensagens de Chat

        "ChatMessage"

                Enviada quando uma mensagem de chat for recebida ou enviada.

                Parâmetros da Mensagem:

                                                      ■ chat - Objeto Chat onde a mensagem foi recebida ou
                                                           enviada.

                                                      ■ mine - Booleano, onde true significa que a mensagem
                                                           foi enviada pelo usuário atual do rrpg e false significa
                                                           uma mensagem enviada por outro usuário.

                                                      ■ type - Contém o tipo da mensagem e pode ser um dos
                                                           seguintes valores:
                                                                           ● "standard" - Uma mensagem de texto
                                                                                normal
                                                                           ● "asNarrator" - Uma mensagem de texto
                                                                                como Narrador.
                                                                           ● "asNPC" - Uma mensagem de texto
                                                                                como NPC
                                                                           ● "action" - Uma mensagem de texto ação
                                                                                (/me)
                                                                           ● "laugh" - Uma risada do RRPG (/rir)
                                                                           ● "dice" - Uma rolagem de dados
Observações:         ■ content - Cadeia de caracteres contendo o texto
                          principal da mensagem. Se tipo for "dice", contém a
                          mensagem adicional que acompanha a rolagem.

                     ■ (OPCIONAL) npc - Se o tipo da mensagem for "asNPC",
                          contém o nome do NPC da mensagem.

                     ■ (OPCIONAL) roll - Se o tipo da mensagem for "dice",
                          contém o Objeto Rolagem com detalhes da rolagem
                          feita.

                     ■ (OPCIONAL) room - Se a mensagem foi enviada em um
                          chat ligado a uma mesa, contém o Objeto Mesa da
                          mesma.

                     ■ (OPCIONAL) player - Se a mensagem foi enviada em um
                          chat ligado a uma mesa, contém o Objeto Jogador de
                          quem enviou a mensagem.

                     ■ (OPCIONAL) pvtPlayer - Se a mensagem foi enviada em
                          uma janela PVT, contém o Objeto Jogador do PVT
                          aberto.

                     ■ Se o usuário do Firecast for um usuário Silver, esta
                          mensagem-evento não é enviada. Esta mensagem-
                          evento só é enviada se o usuário for um assinante do
                          Firecast.

                     ■ Prefira usar a mensagem evento ChatMessageEx ao
                          invés desta.

"ChatMessageEx"

          The "ChatMessageEx" event is triggered by Firecast when a message is either sent or
received in a chat.

          Fields:

                                                ■ chat - Chat Object indicating the chat where the
                                                     message was sent or received.

                                                ■ mine - Boolean; Indicates whether the message was
                                                     sent by the current user.

                                                ■ logRec - LogRec table containing all details about the
                                                     message.

          Remarks:

                                                ■ This event is dispatched exclusively for Premium users.
                                                ■ Not all messages dispatched by this event are visible to

                                                     the user, such as when someone is typing.

"HandleChatCommand"

          Mensagem enviada quando o usuário digitar um comando no chat que não é conhecido
pelo RRPG, dando a chance ao plug-in de tratá-lo.
          Por, exemplo, quando o usuário digitar no chat: "/atacar orbe de fogo", onde "atacar" é o
comando e "orbe de fogo" é o parâmetro.

          Parâmetros da Mensagem:

                                                ■ command - Cadeia de caracteres contendo o nome do
                                                     comando que o usuário digitou.

                                                ■ parameter - Cadeia de caracteres contendo o
                                                     parâmetro do comando.

                                                ■ chat - Objeto Chat onde o comando foi digitado.
                                                ■ (OPCIONAL) room - Se o comando for digitado em um

                                                     chat ligado a uma mesa, contém o Objeto Mesa da
                                                     mesma, senão contém nil.
                                                ■ (OPCIONAL) player - Se o comando for digitado em
                                                     uma janela PVT, contém o Objeto Jogador com quem o
                                                     usuário está conversando, senão contém nil.

          Retorno:

                                                ■ "response = {handled = true}" para sinalizar ao RRPG
                                                     que o comando foi devidamente tratado e que não
                                                     precisa mais continuar sua busca por alguém que trate
                                                     este comando.

          Observações:

                                                ■ Se o usuário do RRPG for um usuário Silver, esta
                                                     mensagem não é enviada. Esta mensagem-evento só é
                                                     enviada se o usuário for um assinante do RRPG.

                                                ■ Recomendamos que trate também a mensagem evento
                                                     "ListChatCommands"

          Exemplo: Tratando o comando /versao

                   rrpg.messaging.listen("HandleChatCommand",
                                  function (message)
                                                 if message.command == "versao"

                   then
                                                               -- Tratar o comando

                   /versão

                   message.chat:enviarMensagem("A Minha versão é
                   1.0");

                   message.chat:escrever("Este texto é só para o
                   usuário");

                                                               -- Sinalizar ao Firecast
                   que o comando foi tratado com sucesso
                                   message.response =

{handled = true};
                             end;

              end);

 "ListChatCommands"

          Mensagem enviada quando o usuário digitar "/help" ou "/?" no chat, permitindo o plug-in
informar ao usuário a existência de comandos suportados.

          Parâmetros:

                                                ■ chat - Objeto Chat onde o help será exibido.
                                                ■ (OPCIONAL) room - Se o help for ser exibido em um

                                                     chat ligado a uma mesa, contém o Objeto Mesa da
                                                     mesma, senão contém nil.
                                                ■ (OPCIONAL) player - Se o help for ser exibido em uma
                                                     janela PVT, contém o Objeto Jogador com quem o
                                                     usuário está conversando, senão contém nil.

          Retorno:

                                                ■ response = Um arranjo de tabelas, onde cada tabela
                                                     representa um comando e possui as seguintes
                                                     propriedades:
                                                                    ● command - Uma cadeia de caracteres
                                                                          contendo o comando , exemplo:
                                                                          "/meuComando"
                                                                    ● description - Uma cadeia de caracteres
                                                                          contendo a descrição do comando,
                                                                          exemplo: "Faz isso, isso e aquilo"

          Observações:

                                                ■ Este evento ocorre apenas para informar ao usuário
                                                     quais comandos o plug-in possui, tornando necessário
                                                     também tratara mensagem-evento
                                                     "HandleChatCommand" se quiser fazer o comando
                                                     realmente funcionar.

                                                ■ Se o usuário do RRPG for um usuário Silver, esta
                                                     mensagem não é enviada. Esta mensagem-evento só é
                                                     enviada se o usuário for um assinante do RRPG.

          Exemplo 1: Informando, ao RRPG, a existência do comando /versao

                   rrpg.messaging.listen("ListChatCommands",

                                  function(message)
                                                 message.response =
                   {{command="/versao", description="Mostra a versão
                   do plug-in"}};

                                  end);

          Exemplo 2: Informando, ao RRPG, vários comandos:

                   rrpg.messaging.listen("ListChatCommands",
                                  function(message)
                                                 message.response =

                   {{command="/comando1", description="Este comando
                   faz uma coisa"},

                   {command="/comando2", description="Este comando
                   faz duas coisas"},

                   {command="/comando3", description="Este comando
                   faz tres coisas"}};

                                  end);

 "HandleChatTextInput"

          Evento enviado quando o usuário confirma o envio de um comando/mensagem para um
chat, dando oportunidade para o plug-in alterar ou ajustar o texto de entrada antes que seja
processado pelo RRPG.

          Parâmetros da Mensagem:
                                                ■ chat - Objeto Chat onde a mensagem será enviada.
                                                ■ text - Cadeia de caracteres contendo o texto de entrada
                                                     que o usuário digitou.
                                                ■ isCommand - True se o usuário informou um texto para
                                                     um comando do RRPG (aqueles que começam com o
                                                     caracter "/").
                                                ■ (OPCIONAL) room - Se a mensagem estiver prestes a
                                                     ser enviada a um chat ligado a uma mesa, contém o
                                                     Objeto Mesa da mesma.
                                                ■ (OPCIONAL) pvtPlayer - Se a mensagem estiver
                                                     prestes a ser enviada em uma janela PVT, contém o
                                                     Objeto Jogador do PVT aberto.

          Retorno:
                                                      ■ Se o plug-in quiser substituir o texto por outro, o
                                                           programador deverá atribuir "message.response =
                                                           {newText = <<novo texto que será utilizado>>}" para
                                                           sinalizar ao RRPG que o texto de entrada deve ser
                                                           substítuido pelo conteudo de newText.

                Alerta:

                                                      ■ Tenha consciência do parametro
                                                           "message.isCommand" desta mensagem! Se o usuário
                                                           digitar um comando (por exemplo "/nick NovoNick"),
                                                           nem toda substituíção de texto deve ser feita, ou deve
                                                           ser feita de forma consciente para não atrapalhar a
                                                           experiência do usuário com o programa!

                Observações:

                                                      ■ O RRPG apenas envia esta mensagem-evento se uma
                                                           das duas seguintes condições forem satisfeitas:
                                                                           ● O usuário logado é um assinante pago
                                                                                do RRPG.
                                                                           ● O usuário logado não é assinante pago
                                                                                do RRPG, a mensagem está prestes a
                                                                                ser enviada em uma mesa onde o
                                                                                criador é Gold Plus.

                Exemplo: Um plug-in que substitui o texto "CA" por "Categoria de Armadura" nos textos
      digitados pelo usuário.

                             RRPG.listen('HandleChatTextInput',

                                     function(message)

                                            message.response =

                                                   {newText = string.gsub(message.text,
                             "CA", "Categoria de Armadura") };

                                     end);

Mensagens de Estado das Mesas

        "MesaJoined"

                Enviada quando alguém entrar em alguma mesa no RRPG.

                Parâmetros da Mensagem:

                                                      ■ room - Objeto Mesa representando a mesa onde o
                                                           jogador entrou.

                                                      ■ me - Booleano, onde true significa que o usuário atual
                                                           do RRPG foi quem entrou na mesa.
                                                      ■ player - Objeto Jogador representando quem entrou na
                                                           mesa.

        "MesaParted"

                Enviada quando alguém sair de alguma mesa do RRPG.
                Parâmetros da Mensagem:

                                                      ■ room - Objeto Mesa representando a mesa que o
                                                           jogador saiu.

                                                      ■ me - Booleano, onde true significa que o usuário atual
                                                           do RRPG foi quem saiu da mesa.

                                                      ■ player - Objeto Jogador representando quem saiu da
                                                           mesa.

                                                      ■ (OPCIONAL) text - Cadeia de caracteres contendo,
                                                           opcionalmente, um texto deixada pelo usuário no
                                                           momento da saída.

                                                      ■ isKick - Booleano, onde true significa que o jogador saiu
                                                           da mesa por causa de um kick.

                                                      ■ (OPCIONAL) responsible - Quando "isKick" for true,
                                                           este campo contem o Objeto Jogador representando
                                                           quem realizou o kick. Observação: Se este atributo vier
                                                           nil durante um kick, significa que o sistema RRPG
                                                           kickou o usuário.
```
