# Biblioteca firecast

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca Firecast

       A biblioteca firecast contém funções relacionadas às mesas, personagens, envio de mensagens,
       rolagem de dados, etc..
       Todas as funções estão contidas na table/variável "Firecast" da unidade "firecast.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "firecast.lua"
    require("firecast.lua");
    -- Agora é possível acessar as funções da biblioteca
    Firecast.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca Firecast

    function Firecast.asyncOpenUserNDB(name[, options])

       Asynchronously open a per-user NodeDatabase that is physically stored in the Firecast server.
       Arguments:
                             ○ name - A string identifying which remote user NodeDatabase should be
                                  opened

                             ○ (OPTIONAL) options - A Lua table describing additional settings that
                                  may contain:
                                                  ■ create - a boolean. If true, the NodeDatabase can be
                                                       created if it does not exist. Default: false
                                                  ■ skipLoad - a boolean. If true, the returned Promise will
                                                       be resolved before the load process is finished. If true,
                                                       you will receive a “Loading node” instead of a “Loaded
                                                       node”. Default: false

   Return:
                             ○ a Promise for a Node Object. As default behavior, the Promise will be
                                  resolved after all data is downloaded and available to be used.

   Remarks:
                             ○ The content of NodeDatabases opened by this function is stored
                                  separately per-user. Each user will have their own copy of the
                                  NodeDatabase identified by the “name” argument

   Example:

          local promise = Firecast.asyncOpenUserNDB("exampleNodeDatabase",
        {create=true});

          local node = await(promise);
          -- variable node is ready to be used here

function Firecast.getRooms()
function Firecast.getMesas()

   Retorna a lista de objetos mesas representando as mesas em que o usuário está no momento.
   Parâmetros:

       Não há parâmetros

   Retorno:
                             ○ Um arranjo de objeto mesa, isto é, uma tabela lua indexada de 1 a N.

   Exemplo - Exibindo uma mensagem contendo o nome e o sistema de todas as mesas em que o
   usuário está:

                      local mesas = Firecast.getRooms();
                      local msg = "";
          for i = 1, #mesas, 1 do
                        local objMesa = mesas[i];

                        msg = msg .. objMesa.nome .. " (" ..
          objMesa.sistema .. ")\n";
          end;

          showMessage(msg);

function Firecast.findRoom(codigoInterno)
function Firecast.findMesa(codigoInterno)

Dado o código interno de uma mesa, localiza o objeto mesa de código interno correspondente.
Parâmetros:

    Não há parâmetros

Retorno:

             ○ Um objeto mesa ou nil caso não encontre.

function Firecast.parseRoll(stringDaRolagem)
function Firecast.interpretarRolagem(stringDaRolagem)

Dado uma cadeia de caracteres representando uma rolagem de dados (Exemplos: "1d20 + 5",
"1d20 + 1d10 - 5", etc..), retorna um objeto rolagem que contém as informações sobre a mesma.

Parâmetros:

                         ○ stringDaRolagem - cadeia de caracteres que deseja interpretar como
                               um objeto rolagem.

Retorno:     ○ Um Objeto Rolagem contendo a interpretação.
Observação:
             ○ Se stringDaRolagem não possuir uma cadeia de caracteres válida, o
                  novo objeto rolagem ainda será retornado, porém vazio.
function Firecast.getRoomOf(object)
function Firecast.getMesaDe(object)

Dado um objeto qualquer, a função tenta determinar à qual objeto mesa ele está ligado.

Parâmetros:

                         ○ object - O objeto que deseja tentar determinar à qual objeto mesa ele
                               pertence ou está ligado.

Retorno:      ○ Um Objeto Mesa, caso a função consiga determinar
Observações:  ○ nil, caso a função não consiga determinar

              ○ Os objetos que costumam ser passados como parâmetro à esta função,
                   são:
                                  ■ objeto Nodo. Se o NodeDatabase for de um
                                       personagem ou estiver ligado à uma mesa, a função
                                       retorna o objeto mesa.
                                  ■ objeto BibliotecaItem. A função retorna à qual mesa o
                                       item da biblioteca pertence.
                                  ■ objeto Personagem.
                                  ■ objeto Jogador.
                                  ■ objeto Chat
                                  ■ objeto form de formType Table's Dock
                                  ■ objeto Scene
                                  ■ Outros objetos que possam estar ligados à alguma
                                       mesa.

              ○ Também é possível passar um valor numérico para esta função. Se for
                   passado um valor numérico, esta função se comporta como a função
                   rrpg.findMesa.

function Firecast.getLibraryItemOf(objeto)
function Firecast.getBibliotecaItemDe(objeto)

Dado um objeto qualquer, a função tenta determinar à qual objeto BibliotecaItem ele está
ligado.

Parâmetros:

                         ○ objeto - O objeto que deseja tentar determinar à qual objeto
                               BibliotecaItem ele pertence ou está ligado.
Retorno:      ○ Um Objeto BibliotecaItem caso a função consiga determinar
Observações:  ○ nil, caso a função não consiga determinar

              ○ Os objetos que costumam ser passados como parâmetro à esta função,
                   são:
                                  ■ objeto Nodo. Se o NodeDatabase for de um item na
                                       biblioteca, a função retorna o objeto biblioteca item.
                                  ■ Outros objetos que possam estar ligados à biblioteca da
                                       mesa.

function Firecast.getCharacterOf(object)
function Firecast.getPersonagemDe(object)

Dado um objeto qualquer, a função tenta determinar à qual objeto Personagem ele está ligado.

Parâmetros:

                         ○ object - O objeto que deseja tentar determinar à qual objeto
                               Personagem ele pertence ou está ligado.

Retorno:      ○ Um Objeto Personagem caso a função consiga determinar
Observações:  ○ nil, caso a função não consiga determinar

              ○ Os objetos que costumam ser passados como parâmetro à esta função,
                   são:
                                  ■ objeto Nodo. Se o NodeDatabase for de um
                                       personagem, a função retorna o objeto personagem.
                                  ■ Outros objetos que possam estar ligados aos
                                       personagens da mesa.

function Firecast.getCurrentUser()

Retorna uma tabela contendo informações do usuário logado atualmente no Firecast.

Retorno:

              ○ Um tabela LUA contendo as seguintes propriedades/atributos:
                                  ■ isLogged - Boleano (true ou false) indicando se possui
                                       um usuário logado no momento.
                                                  ■ id - Se o usuário estiver logado, contém o identificador
                                                       interno do usuário.

                                                  ■ login - Se o usuário tiver logado, contém uma cadeia de
                                                       caracteres contendo seu login/username.

                                                  ■ isGold - Booleano (true ou false) indicando se o usuário
                                                       é assinante Firecast Gold

                                                  ■ isGoldPlus - Booleano (true ou false) indicando se o
                                                       usuário é assinante Firecast Platinum / RRPG Gold Plus

                                                  ■ isRuby - Booleano (true ou false) indicando se o usuário
                                                       é assinante Firecast Ruby

function Firecast.registerChatToolButton(params)

Registra um botão-ferramenta que será apresentado nos chats do Firecast.

Parâmetros:

                         ○ params - Uma tabela Lua contendo as seguintes propriedades do botão:
                                              ■ "hint" - Um string que será apresentado ao usuário
                                                   quando ele arrastar o mouse em cima do botão.
                                              ■ "icon" - Um string contendo o endereço da imagem que
                                                   será apresentada como ícone do botão.
                                              ■ "callback" - Uma função que será chamada quando o
                                                   usuário clicar no botão. Seu primeiro parâmetro recebe
                                                   um objeto Chat representado em qual chat o usuário
                                                   clicou no botão.
                                              ■ (OPCIONAL) "priority" - Se quiser sugerir a ordem dos
                                                   botões, informe um número em priority. Botões com
                                                   prioridade maior aparecem antes dos com prioridade
                                                   menor.
                                              ■ (OPCIONAL) "group" - Um string. Se quiser vários
                                                   botões ficarem juntos, você pode especificar o mesmo
                                                   valor em group para eles.
                                              ■ (OPCIONAL) "groupPriority" - Se quiser sugerir a
                                                   ordem do grupo de botões, informe um número nesta
                                                   propriedade. Grupos de botões com maior prioridade
                                                   aparecem antes dos grupos com menor prioridade.

Retorno:      ○ Um identificador do botão criado. Este valor pode ser usado na função
Observações:       Firecast.unregisterChatToolButton se quiser remover o botão.

              ○ O ícone informado poderá sofrer tratamento visual para se encaixar no
                   tema do Firecast. Use ícones com transparência e cuja "sombra" seja
                   capaz de remeter seu significado.

              ○ O botão só será apresentado se:
                                  ■ O usuário for assinante Gold.
          ■ Ou o usuário não for pagante e estiver em mesa cujo
               dono seja assinante Gold+/Platina.

Exemplo:

          local params = {};
          params.hint = "This button do @@localized.text.id";
          params.icon = "/icons/myIcon.png";
          params.priority = 10;
          params.group = "myButtonGroup";

          params.callback =
                 function(chat)
                        -- the param "chat" contains good information

          to handle =)
                        showMessage("User clicked the button");

                 end;

          Firecast.registerChatToolButton(params);

function Firecast.parseTalemark(text[, talemarkOptions])

Parse and break down a talemark string, the markup language used by Firecast's chats.

Arguments:

                         ○ text - A string, the text to be parsed.
                         ○ (Optional) talemarkOptions - A TalemarkOptions table containing

                               parameters of how Firecast should color, format, and parse the string

Retorno:

          ○ A TalemarkTag table containing the root tag for the parsed text.

function Firecast.unregisterChatToolButton(toolButtonId)
Desregistra um botão-ferramenta de chat previamente instalado pela função
Firecast.registerChatToolButton.

Parâmetros:

                         ○ toolButtonId - O identificador retornado pela função
                               Firecast.registerChatToolButton.

Objeto Mesa

  Este objeto representa uma mesa aberta no Firecast.

Herança

            O Objeto Mesa possui todas as características de um WrappedObject. Veja:
                           ● Objeto WrappedObject

Características

  Além das características herdadas, o Objeto Mesa também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                         Descrição

audioPlayer               AudioPlayer object           (Read-only) Contains the
                                                       AudioPlayer object utilized for
                                                       playing audio within the room.

                                                       Audio played through this object
                                                       will also be broadcasted to all
                                                       online players.

                                                       For local playback only, consider
                                                       using Audio.defaultPlayer instead.

codigoInterno             Integer                      Somente leitura, contém o código
                                                       interno da mesa que é usado para
                                                       identificá-la unicamente em todo o
                                                       RRPG Firecast.

firecastURI               String                       (Read-only) A string containing the
                                                       shareable Firecast URI for this
                                                       room.

                                                       You can use this URI with the
                                                       GUI.asyncOpenFirecastURI()
                                                       function.
nome              String             Somente leitura, contém o nome
msgStatus         String             da mesa.
site              String
logotipo          String             Somente leitura, contém a
sistema           String             mensagem de status da mesa.
msgBoasVindas     String
isRestrito18Anos  Boolean            Somente leitura, contém o
                                     endereço do site da mesa.
haVagas           Boolean
                                     Somente leitura, contém a URL da
isModerada        Boolean            imagem logotipo da mesa.

podeTablesDock    Boolean            Somente leitura, contém o sistema
                                     de RPG da mesa.
jogadores         Arranjo de Objeto
                  Jogador            Somente leitura, contém o texto da
                                     mensagem de boas vindas da mesa.

                                     Somente leitura, contém true se a
                                     mesa estiver marcada como não
                                     recomendada para menores de 18
                                     anos.

                                     Somente leitura, contém true se a
                                     mesa estiver marcada como há
                                     vagas.

                                     Somente leitura, contém true se a
                                     mesa estiver marcada como
                                     Moderada.

                                     Somente leitura, contém true se a
                                     mesa pode exibir Table's Dock do
                                     usuário. É true quando o criador da
                                     mesa é Gold Plus ou quando o
                                     usuário local é assinante Gold.

                                     Somente leitura, contém um
                                     arranjo de Objeto Jogador
                                     representando todos os usuários
                                     que estão conectados na mesa no
                                     momento.

                                     Um arranjo é uma tabela lua
                                     indexada de 1 a N, onde N é o
                                     comprimento da tabela (operador
                                     # no lua)
meuJogador  Objeto Jogador                Somente leitura, contém o Objeto
or          Objeto                        Jogador do usuário que está
me          BibliotecaItem                usando o Firecast.
library
or          Objeto Chat                   Somente leitura, contém o objeto
biblioteca  Objeto Chat                   BibliotecaItem raiz da biblioteca
                                          da mesa.
chat
                                          A raiz da biblioteca é aquela pasta
activeChat                                que tem no topo da mesma, de
                                          nome "Biblioteca".

                                          Somente leitura, contém o Objeto
                                          Chat da interface de bate papo
                                          principal da mesa.

                                          Somente leitura, contém o Objeto
                                          Chat da mesa que está atualmente
                                          ativo/focado na interface.

Métodos                                   Descrição
   Método
   mesa:isType(typeName)                  Retorna true se passado "mesa" como
                                          parâmetro.
   mesa:findBibliotecaItem(codigoInterno
   )                                      Dado um número código interno, localiza
                                          o objeto BibliotecaItem que possui
   mesa:findJogador(loginOuCodigoInter    "codigoInterno" igual ao valor passado no
   no)                                    parâmetro "codigoInterno".

                                          Retorna um objeto BibliotecaItem ou nil
                                          caso não encontre.

                                          Dado um login de usuário ou seu código
                                          interno, localiza o objeto Jogador
                                          correspondente representando o jogador
                                          atualmente na mesa.

                                          Retorna um objeto Jogador ou nil caso
                                          não encontre.

                                          Observação: A função retorna nil se o
                                          usuário não estiver na mesa no momento,
                                          mesmo quando o parâmetro passado for
                                          um login ou um código interno válido.
mesa:requestSetModerada(moderada)  Requisita a ativação/desativação da mesa
                                   moderada.

                                   Parâmetros:

                                                                  ○ moderada -
                                                                       Booleano,
                                                                       onde true
                                                                       significa
                                                                       "Ativar a mesa
                                                                       moderada" e
                                                                       false
                                                                       "Desativar a
                                                                       mesa
                                                                       moderada".

                                   Observações:

                                                                  ○ A alteração do
                                                                       comportamen
                                                                       to "mesa
                                                                       moderada" só
                                                                       ocorre após o
                                                                       servidor
                                                                       Firecast
                                                                       aprovar a
                                                                       mudança.
mesa:abrirNDBDeMesa(nome,  FUNÇÃO DESCONTINUADA! Utilize a
callback[, opcoes])        função mesa:asyncOpenRoomNDB ao
                           invés desta.

                           Abre um NodeDatabase da mesa que está
                           fisicamente armazenado no servidor do
                           Firecast.

                           Parâmetros:

                                                          ○ nome - Cadeia
                                                               de caracteres
                                                               que identifica
                                                               qual
                                                               NodeDatabas
                                                               e remoto da
                                                               mesa deve ser
                                                               aberto.

                                                          ○ callback - Uma
                                                               função que
                                                               será invocada
                                                               quando o
                                                               NodeDatabas
                                                               e for
                                                               carregado ou
                                                               quando
                                                               ocorrer um
                                                               erro no
                                                               carregamento.
                                                                              ■
                                                                              Q

                                                                              ■
                                                                              Q

                                                          ○ (OPCIONAL)
                                                               opcoes - Uma
                                                               tabela lua
                                                               contendo as
                                                               seguintes
                                                               opções extras
                                                               de
                                                               carregamento
                                                               do
                                                               nodedatabase
                                                               :
                                                                              ■
                                                                              (O

                                                                              ■
                                                                              (O
Observações:

              ○ Esta função é
                   assíncrona,
                   isto é, o
                   código LUA
                   continua sua
                   execução
                   normal
                   enquanto o
                   NDB é
                   carregado em
                   segundo
                   plano. É
                   preciso
                   informar o
                   parâmetro
                   "callback"
                   para obter o
                   NodeDatabas
                   e carregado.

              ○ Cada mesa
                   possui seu
                   próprio
                   conjunto de
                   NodeDatabas
                   es que
                   existem
                   independente
                   mente das
                   outras mesas.

              ○ Alterações
                   feitas no
                   NodeDatabas
                   e aberto por
                   esta função
                   são
                   automaticame
                   nte
                   sincronizadas
                   com os outros
                   usuários que
                   também
                   abriram o
                   mesmo
                   NodeDatabas
                   e.

              ○ Se o usuário
                   sair da mesa, o
                   NodeDatabas
     e terá sua
     conexão
     cortada e não
     mais
     sincronizará
     as alterações.
○ Por padrão, os
     usuários com
     o modo
     +mestre
     podem ler e
     alterar o
     NodeDatabas
     e de mesa
     enquanto os
     demais
     usuários
     podem apenas
     ler valores.
○ Para abrir um
     NodeDatabas
     e de mesa,
     uma das
     seguintes
     afirmativas
     deve ser
     verdadeira:

                    ■
                    O

                    ■
                    O
mesa:asyncCreateGroupPVT(logins[,  Asynchronously creates a group private
params])                           chat with the specified users within this
                                   room.

                                   Arguments:

                                             ● logins - An array of strings
                                                  containing the usernames to
                                                  be invited to the group private
                                                  chat.

                                             ● (Optional) params - A Lua table
                                                  that may contain the following
                                                  optional fields:
                                                                  ○ autoFocus - A
                                                                       Boolean;
                                                                       "true" means
                                                                       Firecast
                                                                       should try to
                                                                       focus the open
                                                                       interface,
                                                                       while "false"
                                                                       means to open
                                                                       without
                                                                       focusing it.
                                                                       Default:
                                                                       "false".

                                   Return:

                                             ● A Promise to a Chat object

                                   Remarks:

                                             ● The argument "logins" must
                                                  not be empty and must
                                                  identify users that are in the
                                                  room. You don't need to put
                                                  the current user login in that
                                                  array.

                                             ● It is not possible to create a
                                                  private group chat with just
                                                  the current user in it; there
                                                  must be at least one other
                                                  user.

                                   Example:

                                       local room =
                                       Firecast.getRoomOf(sheet);

                                       local promise =
                                       room:asyncCreateGroupPVT({"Alysso
mesa:asyncOpenRoomNDB(name[,      nRPG", "AnotherUser"});
options])
                                  local chat = await(promise);

                                  chat:write("Hello!");

                              Asynchronously open a room
                              NodeDatabase which is physically stored
                              on the Firecast server

                              Arguments:

                                        ● name - A string identifying the
                                             remote NodeDatabase in this
                                             room to be opened

                                        ● (Optional) options - A Lua table
                                             describing additional settings
                                             that may contain:
                                                             ○ create - a
                                                                  boolean. If
                                                                  true, the
                                                                  NodeDatabas
                                                                  e can be
                                                                  created if it
                                                                  does not exist.
                                                                  Default: false.
                                                             ○ skipLoad - a
                                                                  boolean. If
                                                                  true, the
                                                                  returned
                                                                  Promise will
                                                                  be resolved
                                                                  before the
                                                                  load process is
                                                                  finished. If
                                                                  true, you will
                                                                  receive a
                                                                  “Loading
                                                                  node” instead
                                                                  of a “Loaded
                                                                  node”.
                                                                  Default: false

                              Return:

                                        ● a Promise for a Node Object.
                                             Unless options.skipLoad is true,
                                             the Promise resolves after all
                                             data is downloaded and
                                             available for use.

                              Remarks:
          ● The content of
               NodeDatabases opened by
               this function is stored
               separately per-room. Each
               room will have their own copy
               of the NodeDatabase
               identified by the “name”.

          ● To open a room
               NodeDatabase, one of the
               following must be true:
                               ○ The current
                                    user is a Gold
                                    subscriber; or
                               ○ The room
                                    creator is a
                                    Platinum
                                    subscriber.

Example:

    local promise =
    room:asyncOpenRoomNDB('myNDBId',
    {create=true});

    local node = await(promise);

    -- variable node is ready to be
    used here
mesa:asyncOpenUserRoomNDB(name[  Asynchronously open a per-user
, options])                      NodeDatabase within this room, which is
                                 physically stored on the Firecast server

                                 Arguments:

                                           ● name - A string identifying the
                                                remote user NodeDatabase in
                                                this room to be opened

                                           ● (Optional) options - A Lua table
                                                describing additional settings
                                                that may contain:
                                                                ○ create - a
                                                                     boolean. If
                                                                     true, the
                                                                     NodeDatabas
                                                                     e can be
                                                                     created if it
                                                                     does not exist.
                                                                     Default: false.
                                                                ○ skipLoad - a
                                                                     boolean. If
                                                                     true, the
                                                                     returned
                                                                     Promise will
                                                                     be resolved
                                                                     before the
                                                                     load process is
                                                                     finished. If
                                                                     true, you will
                                                                     receive a
                                                                     “Loading
                                                                     node” instead
                                                                     of a “Loaded
                                                                     node”.
                                                                     Default: false

                                 Return:

                                           ● a Promise for a Node Object.
                                                Unless options.skipLoad is true,
                                                the Promise resolves after all
                                                data is downloaded and
                                                available for use.

                                 Remarks:

                                           ● The content of
                                                NodeDatabases opened by
                                                this function is stored
                                                separately for each user and
                                                each room. Each user in the
mesa:asyncOpenPVT(login[, params])                 room will have their own copy
                                                   of the NodeDatabase
                                                   identified by the specified
                                                   "name."

                                    Example:

                                        local promise =
                                        room:asyncOpenUserRoomNDB("myId",
                                        {create=true});

                                        local node = await(promise);

                                        -- variable node is ready to be
                                        used here

                                    Asynchronously opens a private chat with
                                    the specified user within this room.

                                    Arguments:

                                              ● login - A string containing the
                                                   username of the user you
                                                   want to open the PVT Chat.

                                              ● (Optional) params - A Lua table
                                                   that may contain the following
                                                   optional fields:
                                                                   ○ autoFocus - A
                                                                        Boolean;
                                                                        "true" means
                                                                        Firecast
                                                                        should try to
                                                                        focus the open
                                                                        interface,
                                                                        while "false"
                                                                        means to open
                                                                        without
                                                                        focusing it.
                                                                        Default:
                                                                        "false".

                                                                   ○ mode - One of
                                                                        the following
                                                                        strings:
                                                                                       ■
                                                                                       "g

                                                                                       ■
                                                                                       "g

                                    Return:
mesa:getChats()                                    ● A Promise to a Chat object

                                         Example:

                                             local room =
                                             Firecast.getRoomOf(sheet);
                                             local promise =
                                             room:asyncOpenPVT("AlyssonRPG",
                                             {autoFocus=true});
                                             local chat = await(promise);
                                             chat:write("Hello!");

                                         Returns all chat objects that belong to this
                                         room.

                                         Arguments:

                                              None

                                         Return:
                                                   ● An array of Chat object

Exemplos

Exemplo 1 - Exibindo uma mensagem com o nome e sistema de todas as mesas que o usuário está
dentro.

local mesas = rrpg.getMesas();
local msg = "";

for i = 1, #mesas, 1 do
              local objMesa = mesas[i];

          msg = msg .. objMesa.nome .. " (" .. objMesa.sistema .. ")\n";

end;

if msg ~= "" then
              showMessage(msg);

else
              showMessage("O usuário não está em nenhuma mesa");

end;
Objeto Jogador

  Este objeto representa um usuário em uma mesa aberta no RRPG Firecast.

  Observações:

                                 ○ Se um mesmo usuário estiver em mais de 1 mesa ao mesmo tempo,
                                      existirá 1 Objeto Jogador distinto para cada mesa em que ele estiver.

Herança

            O Objeto Jogador possui todas as características de um WrappedObject. Veja:
                           ● Objeto WrappedObject

Características

  Além das características herdadas, o Objeto Jogador também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo         Descrição

mesa                      Objeto Mesa  Somente leitura, contém o
                                       Objeto Mesa que
                                       representa em qual mesa
                                       este usuário está.

id                        Integer      Somente leitura, contém o

                                       identificador interno do

                                       usuário.

login                     String       Somente leitura, contém o
                                       login do usuário.

nick                      String       Somente leitura, contém o
avatar          String   nick do usuário.
capa            String
isGold          Boolean  Somente leitura, contém a
isGoldPlus      Boolean  URL da imagem de seu
isRuby          Boolean  avatar.
isAusente       Boolean
                         Somente leitura, contém a
isCnxDormente   Boolean  URL da imagem de capa do
                         usuário.
isSessaoMobile  Boolean
                         Somente leitura, contém
isEspectador    Boolean  true se o usuário for um
isJogador       Boolean  assinante RRPG Gold.

                         Somente leitura, contém
                         true se o usuário for um
                         assinante RRPG Gold Plus.

                         Somente leitura, contém
                         true se o usuário for um
                         assinante RRPG Ruby.

                         Somente leitura, contém
                         true se o usuário estiver
                         aparentemente ausente
                         do computador.

                         Somente leitura, contém
                         true se a conexão do
                         usuário está dormente,
                         isto é, o usuário perdeu a
                         conexão com o RRPG e
                         está tentando a recuperar
                         de volta.

                         Somente leitura, contém
                         true se o usuário estiver
                         conectado usando um
                         dispositivo móvel
                         (celular/tablet)

                         Somente leitura, contém
                         true se o usuário está no
                         modo Espectador na mesa.

                         Somente leitura, contém
                         true se o usuário estiver
isMestre             Boolean             com o modo +jogador na
                                         mesa.
isJuggernaut         Boolean
                                         Somente leitura, contém
isMudo               Boolean             true se o usuário estiver
                                         com o modo +mestre na
isCego               Boolean             mesa.

haveVoice ou         Boolean             Somente leitura, contém
haveVoz              Integer             true se o usuário estiver
                                         com o modo +juggernaut
codigoInterno                            na mesa.

personagemPrincipal  Integer             Somente leitura, contém
                                         true se o usuário estiver
                                         com o modo +mudo na
                                         mesa.

                                         Somente leitura, contém
                                         true se o usuário estiver
                                         com o modo +cego na
                                         mesa.

                                         Somente leitura, contém
                                         true se o usuário estiver
                                         com o modo +voz na mesa.

                                         Somente leitura, contém
                                         um número que identifica
                                         o jogador naquela mesa.

                                         Somente leitura, o código
                                         interno do item do
                                         personagem principal do
                                         jogador na mesa.

                                         Este valor é o mesmo valor
                                         da propriedade
                                         "codigoInterno" dos
                                         objetos BibliotecaItem

                                         O valor -1 significa que o
                                         jogador não tem
                                         personagem.

Métodos                       Descrição
   Método
jogador:isType(typeName)      Retorna true se passado "jogador" como
jogador:requestSetCego(cego)  parâmetro.

jogador:requestSetMudo(mudo)  Requisita a alteração da propriedade isCego
                              do jogador.

                              Parâmetros:

                                                             ○ cego - Booleano,
                                                                  onde true
                                                                  significa colocar
                                                                  o modo "+cego"
                                                                  e false colocar o
                                                                  modo "-cego".

                              Observações:

                                                             ○ A alteração do
                                                                  comportamento
                                                                  só ocorre após o
                                                                  servidor RRPG
                                                                  aprovar a
                                                                  mudança.

                                                             ○ Esta função não
                                                                  faz nada se o
                                                                  usuário do plug-
                                                                  in não for
                                                                  assinante do
                                                                  RRPG.

                              Requisita a alteração da propriedade
                              isMudo do jogador.

                              Parâmetros:

                                                             ○ mudo -
                                                                  Booleano, onde
                                                                  true significa
                                                                  colocar o modo
                                                                  "+mudo" e false
                                                                  colocar o modo
                                                                  "-mudo".

                              Observações:

                                                             ○ A alteração do
                                                                  comportamento
                                                                  só ocorre após o
                                                                  servidor RRPG
                                                                  aprovar a
jogador:requestSetVoz(voz)                                              mudança.
                                                                   ○ Esta função não
jogador:requestSetJogador(isJogado
r)                                                                      faz nada se o
                                                                        usuário do plug-
                                                                        in não for
                                                                        assinante do
                                                                        RRPG.

                                    Requisita a alteração da propriedade
                                    haveVoice do jogador.

                                    Parâmetros:

                                                                   ○ voz - Booleano,
                                                                        onde true
                                                                        significa colocar
                                                                        o modo "+voz" e
                                                                        false colocar o
                                                                        modo "-voz".

                                    Observações:

                                                                   ○ A alteração do
                                                                        comportamento
                                                                        só ocorre após o
                                                                        servidor RRPG
                                                                        aprovar a
                                                                        mudança.

                                                                   ○ Esta função não
                                                                        faz nada se o
                                                                        usuário do plug-
                                                                        in não for
                                                                        assinante do
                                                                        RRPG.

                                    Requisita a alteração da propriedade
                                    isJogador do usuário.

                                    Parâmetros:

                                                                   ○ isJogador -
                                                                        Booleano, onde
                                                                        true significa
                                                                        colocar o modo
                                                                        "+jogador" e
                                                                        false colocar o
                                                                        modo "-
                                                                        jogador".

                                    Observações:

                                                                   ○ A alteração do
jogador:requestKick();                                                 comportamento
                                                                       só ocorre após o
jogador:requestSetBarValue(index,                                      servidor RRPG
currentValue, maxValue)                                                aprovar a
                                                                       mudança.
                                                                  ○ Esta função não
                                                                       faz nada se o
                                                                       usuário do plug-
                                                                       in não for
                                                                       assinante do
                                                                       RRPG.

                                   Requisita o kick (expulsão) do jogador da
                                   mesa.

                                   Observações:

                                                                  ○ O kick só ocorre
                                                                       após o servidor
                                                                       RRPG aprová-lo.

                                                                  ○ Esta função não
                                                                       faz nada se o
                                                                       usuário do plug-
                                                                       in não for
                                                                       assinante do
                                                                       RRPG.

                                   Requisita a alteração de valores em uma das
                                   barrinhas de status do jogador.

                                   Parâmetros:

                                                                  ○ index - um
                                                                       número que
                                                                       varia de 1 a 4,
                                                                       indicando qual
                                                                       barrinha deseja-
                                                                       se alterar os
                                                                       valores.

                                                                  ○ currentValue -
                                                                       Um número
                                                                       representando o
                                                                       novo valor atual
                                                                       da barrinha ou
                                                                       nil se não quiser
                                                                       alterar este
                                                                       campo.

                                                                  ○ maxValue - Um
                                                                       número
                                                                       representando o
                                                                       novo valor
                                     Observações:       máximo da
                                                        barrinha ou nil
                                                        se não quiser
                                                        alterar este
                                                        campo.

                                                   ○ A alteração só
                                                        ocorre após o
                                                        servidor RRPG
                                                        aprová-la.

                                                   ○ Esta função não
                                                        faz nada se o
                                                        usuário do plug-
                                                        in não for
                                                        assinante do
                                                        RRPG e o dono
                                                        da mesa atual
                                                        não for
                                                        assinante do
                                                        Gold Plus.

jogador:requestSetEditableLine(inde  Requisita a alteração de texto de uma das
x, text)                             linhas digitáveis do jogador.

                                     Parâmetros:

                                                                    ○ index - um
                                                                         número que
                                                                         varia de 1 a 2,
                                                                         indicando de
                                                                         qual linha se
                                                                         deve alterar o
                                                                         texto.

                                                                    ○ text - Uma
                                                                         cadeia de
                                                                         caracteres/texto
                                                                         contendo o novo
                                                                         texto que será
                                                                         aplicao à linha
                                                                         digitável
                                                                         especificada..

                                     Observações:

                                                                    ○ A alteração só
                                                                         ocorre após o
                                                                         servidor RRPG
                                                                         aprová-la.

                                                                    ○ Esta função não
                                                                         faz nada se o
                                                                         usuário do plug-
jogador:getBarValue(index)                                      in não for
                                                                assinante do
                                                                RRPG e o dono
                                                                da mesa atual
                                                                não for
                                                                assinante do
                                                                Gold Plus.

                            Retorna os valores atuais de uma das
                            barrinhas de status do jogador.

                            Parâmetros:

                                                           ○ index - um
                                                                número que
                                                                varia de 1 a 4,
                                                                indicando de
                                                                qual barrinha se
                                                                deseja obter
                                                                informações.

                            Retorno:

                                 Esta função retorna 3 valores na
                                 seguinte ordem:

                                                           ○ currentValue -
                                                                Um número,
                                                                valor atual da
                                                                barrinha

                                                           ○ maxValue - Um
                                                                número, valor
                                                                máximo da
                                                                barrinha

                                                           ○ percent - Um
                                                                número,
                                                                percentual da
                                                                barrinha

                            Observações:

                                                           ○ Se index indicar
                                                                uma barrinha
                                                                que não está
                                                                ativa na mesa, os
                                                                três valores
                                                                retornados
                                                                (currentValue,
                                                                maxValue e
                                                                percent) serão
                                                                nil.

                                                           ○ Se o usuário
                                                                atual não tiver
jogador:getEditableLine(index)                                      permissões para
                                                                    ver os números
                                                                    da barinha (isto
                                                                    é, a visibilidade
                                                                    está protegida),
                                                                    currentValue e
                                                                    maxValue serão
                                                                    retornados
                                                                    como nil
                                                                    enquanto
                                                                    percent trará
                                                                    uma
                                                                    porcentagem
                                                                    válida.

                                Exemplo:

                                     local atual, maximo, percent =
                                     player:getBarValue(1);

                                Retorna os o texto atual de uma das linhas
                                digitáveis do jogador.

                                Parâmetros:

                                                               ○ index - um
                                                                    número que
                                                                    varia de 1 a 2,
                                                                    indicando de
                                                                    qual linha se
                                                                    deseja obter
                                                                    informações.

                                Retorno:

                                                               ○ Uma cadeia de
                                                                    caracteres/texto
                                                                    contendo o que
                                                                    está escrito na
                                                                    linha digitável
                                                                    especificada.

Exemplos

Exemplo 1 - Uma ficha que exibe uma mensagem com a lista de Login e Nick dos jogadores que estão na
mesa
<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">

              <button>
                             <event name="onClick">
                                           local msg = "";
                                           local mesaDoPersonagem = rrpg.getMesaDe(sheet);
                                           local jogadores = mesaDoPersonagem.jogadores;

                                           for i = 1, #jogadores, 1 do
                                                          local objJogador = jogadores[i];
                                                          msg = msg .. objJogador.nick .. " (" ..

objJogador.login .. ")\n";
                                           end;

                                           showMessage(msg);
                             </event>
              </button>
</form>

Neste exemplo, também foram usados:
                         ○ função rrpg.GetMesaDe
                         ○ propriedade jogadores do Objeto Mesa

Objeto Rolagem

       Este objeto contém informações sobre uma rolagem de dados que ocorreu ou que poderá
       ocorrer.

       Você pode criar um objeto rolagem utilizando a função rrpg.interpretarRolagem

Características

Propriedades e atributos

Propriedade               Tipo              Descrição

tipo                      Enumerado:        Somente leitura, contém o

                                ● "direta"  tipo da rolagem.
possuiAlgumDado            ● "storyteller"  "direta" - Rolagem de
                                            dados padrão.
asString         Boolean
isRolado                                    "storyteller" - Rolagem de
resultado        String                     dados storyteller.
ops              Boolean                    Quantidade de dados cuja
                 Integer                    face seja maior ou igual a
                 Arranjo de Objetos         algum numero e que um
                 OperacaoRolagem            resultado natural 1 anula
                                            um sucesso

                                            Somente leitura, contém
                                            true se a rolagem possuir
                                            pelo menos um dado de
                                            qualquer face.

                                            Exemplo:

                                            Na rolagem "+5" a
                                            propriedade conteria
                                            false, enquanto na
                                            rolagem "d6 + 5" conteria
                                            true.

                                            Somente leitura, contém a
                                            rolagem como uma cadeia
                                            de caracteres.

                                            Somente leitura, contém
                                            true se a rolagem já foi
                                            executada e possui o
                                            resultado, ou false se
                                            ainda não.

                                            Somente leitura, contém o
                                            valor resultado da
                                            rolagem se ela já tiver sido
                                            feita. Se a rolagem ainda
                                            não tiver executada,
                                            contém 0.

                                            Contém a lista de
                                            operações "aritméticas"
                                            da rolagem.

                                            É um arranjo de
                                            tabelas/objetos, isto é,
                                            uma tabela lua indexada
                                            de 1 a N, onde cada
                                            posição possui uma tabela
                                   conforme a operação...

                                   Veja Lista de Operações
                                   de Rolagens

Métodos                            Descrição
   Método
   rolagem:interpretarString(str)  Dado uma cadeia de caracteres representando
                                   uma rolagem de dados (Exemplos: "1d20 + 5",
   rolagem:concatenar(outraRolage  "1d20 + 1d10 - 5", etc..), atualiza as informações
   m)                              da rolagem de dados.

   rolagem:rolarLocalmente()       Observação: Se "str" não contiver um texto de
                                   uma rolagem válida, o objeto rolagem é
                                   resetado.

                                   Adiciona ao final desta rolagem de dados as
                                   operações "aritméticas" de outra rolagem,
                                   juntando-as.

                                   Parâmetros:

                                                                  ○ outraRolagem - uma
                                                                       cadeia de caracteres
                                                                       ou um outro objeto
                                                                       rolagem que será
                                                                       concatenada.

                                   Retorno:

                                                                  ○ Retorna o próprio
                                                                       objeto rolagem.

                                   Executa a rolagem localmente. Esta função
                                   realiza os sorteios e demais operações sem
                                   haver necessidade do usuário estar em uma
                                   mesa.

                                   Observações:

                                             ● Após a chamada desta função, o
                                                  resultado pode ser acessado através
                                                  das propriedades "resultado" e
                                                  "ops". Este resultado não será
                                                  exibido em lugar algum
                                                  automaticamente e depende de
                                                  você tratá-lo conforme desejar.

                                             ● Se você executar este método em
                                                  uma rolagem que já foi rolada, o
                                    resultado anterior será sobrescrito
                                    com novos resultados.

Operações de Rolagem (Cada item do arranjo Rolagem.ops)
  Cada operação de rolagem é uma tabela lua com as seguintes propriedades:

Propriedade  Tipo                       Descrição

tipo         Enumerado:                 Determina qual é a

                      ● "dado"          operação.

                      ● "imediato"      "dado" - Um grupo de

                      ● "soma"          dados a serem rolados

                      ● "subtracao"     "imediato" - Um número
                      ● "comparacao"    constante especificado
                      ● "ordenacao"     pelo usuário.
                      ● "desconhecido"

                                        "comparacao" - Uma
                                        comparação entre
                                        números/dados.

                                        "ordenacao" - Pedido para
                                        ordenar o resultado de
                                        forma decrescente.

                                        Os demais valores são
                                        autoexplicativos.

quantidade   Integer                    Quando o tipo == "dado",
                                        determina quantos dados
                                        da face informada serão
                                        rolados.

face         Integer ou String          Quando tipo == "dado",

                                        contém qual é face dos

                                        dados..

                                        Exemplos:

                                                 ●4
                                                 ●6
                                                 ●8
                                                 ● 10
                                                 ● "F" (dado

                                                      fudge)

resultados   Arranjo de Integer         Quando tipo == "dado" e
                                        se a rolagem já tiver sido
                                        feita, contém um arranjo
comparacao  String   de números
valor       Integer  representando o resultado
                     individual de cada dado na
                     operação.

                     Quando tipo ==
                     "comparacao", contém
                     qual é o comparador.

                     Quando tipo ==
                     "imediato" contém o valor
                     do número constante
                     literal informado.

Exemplos

Exemplo 1 - Uma ficha que rola dados na mesa

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <button>
                                 <event name="onClick">
                                                local rolagem =

    rrpg.interpretarRolagem(sheet.ataqueDoPersonagem);

                                                if not rolagem.possuiAlgumDado then
                                                              -- se o usuario não tiver preenchido qual

    dado rolar,
                                                              -- vamos adicionar um 1d20 + na "fórmula

    da rolagem"
                                                              rolagem =

    rrpg.interpretarRolagem("1d20"):concatenar(rolagem);
                                                end;

                                                local mesaDoPersonagem = rrpg.getMesaDe(sheet);
                                                mesaDoPersonagem.chat:rolarDados(rolagem, "Ataque
    do personagem");
                                 </event>
                   </button>
</form>

Exemplo 2 - Rolar localmente e exibir uma mensagem personalizada.

local msg = "";

-- Interpretar uma rolagem, digamos: 4d6 + 2d4 + d20 + 5
local rolagem = rrpg.interpretarRolagem("4d6 + 2d4 + d20 + 5");

-- Executar a rolagem localmente
rolagem:rolarLocalmente();

-- Loop para navegar em cada uma das operações da rolagem
for i = 1, #rolagem.ops, 1 do

              local operacao = rolagem.ops[i];

              -- Vamos verificar que tipo de operação é esta.

              if operacao.tipo == "dado" then
                             -- Adicionar à mensagem informações sobre este conjunto de

dados.
                             msg = msg .. operacao.quantidade .. "d" .. operacao.face

.. ": \n ";

                             -- Loop percorrendo cada um dos resultados individuais
deste conjunto de dados.

                             for j = 1, #operacao.resultados, 1 do
                                           msg = msg .. " " .. operacao.resultados[j];

                             end;

                       msg = msg .. "\n";
         elseif operacao.tipo == "imediato" then

                       msg = msg .. "Valor imediato: " .. operacao.valor .. "\n";
         end;

end;

-- Concatenar à mensagem o resultado final da rolagem
msg = msg .. "------------------- \nResultado Final: " ..
 rolagem.resultado;
 -- Exibir a mensagem que montamos.
 showMessage(msg);

Exemplo 3 - Uma ficha fazendo um teste (de resistência, por exemplo) e postando o resultado na
mesa.
<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFTeste">

              <script>
                             local function realizarTesteDeResistencia()
                                           -- obter a mesa do personagem
                                           local mesaDoPersonagem = rrpg.getMesaDe(sheet);

usar o valor 0      -- se o usuário não preencheu modificador, vamos
                    sheet.modificador = sheet.modificador or 0;

                                           mesaDoPersonagem.chat:rolarDados("1d20 + " ..
sheet.modificador, "Teste de Resistência",

                                                          function (rolado)
                                                                        -- A dificuldade do teste é 15

                           if rolado.resultado >= 15 then

mesaDoPersonagem.chat:enviarMensagem("SUCESSO =) você tirou " ..
rolado.resultado);

                                                                        else

mesaDoPersonagem.chat:enviarMensagem("FALHA =/ você tirou " ..
rolado.resultado);

                                                                        end;

                    end);

              end;
</script>

              <button onClick="realizarTesteDeResistencia()"/>
</form>

Objeto BibliotecaItem

  Este objeto representa um item na biblioteca de uma mesa no RRPG Firecast.
Herança

            O Objeto BibliotecaItem possui todas as características de um WrappedObject. Veja:
                           ● Objeto WrappedObject

Características

  Além das características herdadas, o Objeto BibliotecaItem também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo                   Descrição

room                      Objeto Mesa            Somente leitura, contém o
mesa                                             Objeto Mesa que representa em
                                                 qual mesa este item está.

parent                    Objeto BibliotecaItem  Somente leitura, contém o
pai                                              objeto BibliotecaItem que é pai
                                                 deste item.

                                                 Observação: Se o item for raiz
                                                 da biblioteca, esta propriedade
                                                 conterá nil.

children                  Arranjo de Objeto      Contém um arranjo de Objetos
filhos                    BibliotecaItem         BibliotecaItem representando
                                                 os sub-itens deste item.

                                                 Um arranjo é uma tabela lua
                                                 indexada de 1 a N.

tipo                      Enumerado:             Somente leitura, contém que

                                ● "biblioteca    tipo de item este é.

                                "                "biblioteca" - diretório raiz da

                                ● "diretorio"    biblioteca.

                                ● "personag

                                     em"         "diretorio" - uma pasta na
                                ● "imagem"       biblioteca
                                ● "sceneUni

                                tClass"

                                ● "scene2"       "personagem" - Um personagem
                                ● "scene3"

                                                 "imagem" - Uma imagem
                                                 (implementação futura)

                                                 "sceneUnitClass" - Um item do
codigoInterno  Integer         Scene2
name           String
nome           String          "scene2" - Um tabuleiro de
firecastURI    String          Scene 2
               Objeto Jogador
ownerLogin                     "scene3" - Um tabuleiro/grid de
loginDono      String          Scene 3

owner                          Somente Leitura, contém o
dono                           código interno que identifica
                               este item de biblioteca
creatorLogin                   unicamente no RRPG Firecast.

                               Somente leitura, contém o nome
                               do item da biblioteca.

                               Para alterar esta propriedade,
                               utilize o método asyncUpdate
                               deste objeto.

                               (Read-only) A string containing
                               the shareable Firecast URI for
                               this library item.

                               You can use this URI with the
                               GUI.asyncOpenFirecastURI()
                               function.

                               Somente leitura, contém o login
                               Firecast do usuário que é dono
                               deste item.

                               Para alterar esta propriedade,
                               utilize o método asyncUpdate
                               deste objeto.

                               Somente leitura, contém o o
                               objeto Jogador do dono deste
                               item.

                               Observação: Se o dono não
                               estiver na mesa no momento,
                               esta propriedade conterá nil.
                               Utilize a propriedade
                               "loginDono" para descobrir o
                               login do dono mesmo se ele não
                               estiver na mesa.

                               Somente leitura, contém o login
                               do usuário que criou este item.
loginCriador         Objeto Jogador              Somente leitura, contém o
                                                 objeto Jogador do usuário que
creator                                          criou este item.
criador
                                                 Observação: Se o criador não
visible              Boolean                     estiver na mesa no momento,
visivel                                          esta propriedade conterá nil.
                                                 Utilize a propriedade
recursiveVisible     Boolean                     "loginCriador" se você quiser
                                                 descobrir quem criou o item
visivelRecursivamen                              mesmo se ele não estiver na
te                                               mesa.

Métodos                                          Somente leitura, contém true se
   Método                                        o item estiver marcado para ser
   bibliotecaItem:asyncCreateChar(charParams)    visível a todos da mesa.

                                                 Observação: Esta propriedade
                                                 pode conter true mas o item não
                                                 estar de fato visível a todos. Isto
                                                 ocorre quando o item está
                                                 dentro de um item pai que está
                                                 escondido.

                                                 Para descobrir se o item está
                                                 realmente visível a todos, utilize
                                                 a propriedade
                                                 "visivelRecursivamente".

                                                 Para alterar esta propriedade,
                                                 utilize o método asyncUpdate
                                                 deste objeto.

                                                 Somente leitura, contém true se
                                                 o item está realmente visível a
                                                 todos da mesa.

                                               Descrição

                                               Asynchronously creates a
                                               character in the room.

                                               Parameters:

                                                         ● charParams - A Lua
table with the
following fields:

               ○ name -
                    String
                    contai
                    ning
                    the
                    name
                    of the
                    new
                    charac
                    ter to
                    be
                    create
                    d.

               ○ dataT
                    ype -
                    String
                    identif
                    ying
                    the
                    sheet
                    templ
                    ate
                    the
                    new
                    charac
                    ter
                    will
                    use.
                    Refer
                    to
                    forms
                    dataT
                    ype
                    for
                    details
                    .

               ○ (Optio
                    nal)
                    visible
                    -A
                    boole
                    an
                    value;
                    set to
                    true if
                    the
                                    new
                                    charac
                                    ter
                                    should
                                    be
                                    visible
                                    to all,
                                    false
                                    other
                                    wise.
                                    Defaul
                                    t: true.

                               ○ (Optio
                                    nal)
                                    owner
                                    Login -
                                    A
                                    string
                                    contai
                                    ning
                                    the
                                    user
                                    accou
                                    nt
                                    name
                                    that
                                    will
                                    own
                                    the
                                    new
                                    charac
                                    ter. nil
                                    design
                                    ates
                                    an
                                    NPC.
                                    Defaul
                                    t: nil

Returns:

          ● A Promise object for
               the newly created
               Objeto Personagem

Remarks:

          ● The character will be
               created within the
               'BibliotecaItem'
bibliotecaItem:asyncCreateDir(dirParams)                 object that received
                                                         the function call

                                                    ● This function is only
                                                         applicable if the
                                                         'BibliotecaItem'
                                                         object receiving the
                                                         function call has the
                                                         attribute "tipo" set to
                                                         "diretorio" or
                                                         "biblioteca".

                                          Asynchronously creates a
                                          directory in the room llibrary.

                                          Parameters:

                                                    ● dirParams - A table
                                                         with the following
                                                         fields:
                                                                         ○ name -
                                                                              String
                                                                              contai
                                                                              ning
                                                                              the
                                                                              name
                                                                              of the
                                                                              new
                                                                              direct
                                                                              ory to
                                                                              be
                                                                              create
                                                                              d.

                                                                         ○ (Optio
                                                                              nal)
                                                                              visible
                                                                              -A
                                                                              boole
                                                                              an
                                                                              value;
                                                                              set to
                                                                              true if
                                                                              the
                                                                              new
                                                                              direct
                                                                              ory
                                                                              should
                                                                              be
                                                                              visible
                                                                              to all,
bibliotecaItem:asyncCreateScene3(gridParam                                      false
s)                                                                              other
                                                                                wise.
                                                                                Defaul
                                                                                t: true.

                                            Returns:

                                                      ● A Promise object for
                                                           the newly created
                                                           Objeto BibliotecaItem

                                            Remarks:

                                                      ● The directory will be
                                                           created within the
                                                           'BibliotecaItem'
                                                           object that received
                                                           the function call

                                                      ● This function is only
                                                           applicable if the
                                                           'BibliotecaItem'
                                                           object receiving the
                                                           function call has the
                                                           attribute "tipo" set to
                                                           "diretorio" or
                                                           "biblioteca".

                                            Asynchronously creates a grid in
                                            the room.

                                            Parameters:

                                                      ● gridParams - A table
                                                           with the following
                                                           fields:
                                                                           ○ name -
                                                                                String
                                                                                contai
                                                                                ning
                                                                                the
                                                                                name
                                                                                of the
                                                                                new
                                                                                grid to
                                                                                be
                                                                                create
                                                                                d.

                                                                           ○ (Optio
                                                                                nal)
bibliotecaItem:asyncDelete()                                      visible
                                                                  -A
                                                                  boole
                                                                  an
                                                                  value;
                                                                  set to
                                                                  true if
                                                                  the
                                                                  new
                                                                  grid
                                                                  should
                                                                  be
                                                                  visible
                                                                  to all,
                                                                  false
                                                                  other
                                                                  wise.
                                                                  Defaul
                                                                  t: true.

                              Returns:

                                        ● A Promise object for
                                             the newly created
                                             Objeto BibliotecaItem

                              Remarks:

                                        ● The grid will be
                                             created within the
                                             'BibliotecaItem'
                                             object that received
                                             the function call

                                        ● This function is only
                                             applicable if the
                                             'BibliotecaItem'
                                             object receiving the
                                             function call has the
                                             attribute "tipo" set to
                                             "diretorio" or
                                             "biblioteca".

                              Asynchronously delete this
                              bibliotecaItem.

                              Parameters:

                              None
bibliotecaItem:asyncMoveTo(newParent)  Returns:
bibliotecaItem:asyncUpdate(changes)
                                                 ● A promise that tracks
                                                      the asynchronous
                                                      process.

                                       Asynchronously move this
                                       BibliotecaItem to a new location
                                       in the library tree hierarchy.

                                       Parameters:

                                                 ● newParent - Another
                                                      BibliotecaItem object
                                                      representing the new
                                                      parent for this
                                                      BibliotecaItem

                                       Returns:

                                                 ● A promise that tracks
                                                      the asynchronous
                                                      process.

                                       Remarks

                                                 ● This operation only
                                                      works if the
                                                      newParent parameter
                                                      has the attribute
                                                      "tipo" set to
                                                      "diretorio" or
                                                      "biblioteca"."

                                       Asynchronously update the
                                       attributes of this BibliotecaItem.

                                       Parameters:

                                                 ● changes - A table
                                                      representing the
                                                      attributes you wish to
                                                      modify. It may contain
                                                      the following fields:
                                                                      ○ (Optio
                                                                           nal)
                                                                           name -
                                                                           String
                                                                           contai
                                                                           ning
     the
     new
     name
     for
     this
     Bibliot
     ecaIte
     m.

○ (Optio
     nal)
     visible
     -A
     boole
     an
     value;
     set to
     true if
     the
     Bibliot
     ecaIte
     m
     should
     be
     visible
     to all,
     false
     other
     wise.

○ (Optio
     nal)
     editio
     nBloc
     ked -
     A
     boole
     an
     value;
     set to
     true if
     charac
     ter
     editio
     n
     should
     be
     blocke
     d,
     false
     other
     wise.
     Only
     applic
     able
     to
     charac
     ters.

○ (Optio
     nal)
     owner
     Login -
     A
     string
     contai
     ning
     the
     user
     accou
     nt
     name
     that
     will
     own
     the
     charac
     ter.
     Use an
     empty
     string
     "" to
     design
     ate an
     NPC.
     Only
     applic
     able
     to
     charac
     ters.

○ (Optio
     nal)
     bar0V
     al
     (Optio
     nal)
     bar1V
     al
     (Optio
     nal)
     bar2V
     al
     (Optio
     nal)
     bar3V
     al - A
     numb
     er,
     repres
     enting
     the
     new
     curren
     t value
     for the
     corres
     pondi
     ng
     charac
     ter
     bar.
     Only
     applic
     able
     to
     charac
     ters.

○ (Optio
     nal)
     bar0M
     ax
     (Optio
     nal)
     bar1M
     ax
     (Optio
     nal)
     bar2M
     ax
     (Optio
     nal)
     bar3M
     ax - A
     numb
     er,
     indica
     ting
     the
     new
     maxim
     um
     value
     for the
     corres
     pondi
     ng
     charac
     ter
     bar.
     Only
     applic
     able
     to
     charac
     ters.

○ (Optio
     nal)
     edtLin
     e0
     (Optio
     nal)
     edtLin
     e1 - A
     string,
     indica
     ting
     the
     new
     conte
     nt for
     the
     corres
     pondi
     ng
     charac
     ter
     editab
     le line.
     Only
     applic
     able
     to
     charac
     ters.

○ (Optio
     nal)
     avatar
     -A
     string,
bibliotecaItem:isType(typeName)                                      denoti
                                                                     ng the
                                                                     new
                                                                     image
                                                                     URL
                                                                     for the
                                                                     charac
                                                                     ter
                                                                     avatar
                                                                     . Only
                                                                     applic
                                                                     able
                                                                     to
                                                                     charac
                                                                     ters.

                                 Returns

                                           ● A promise that tracks
                                                the asynchronous
                                                process.

                                 Remarks:

                                           ● All fields inside
                                                "changes" parameter
                                                are optional. Its
                                                presence means you
                                                want to change that
                                                attribute while its
                                                absence means to
                                                keep it unchanged.

                                 Retorna true se passado
                                 "bibliotecaItem" como parâmetro.

Exemplos
Exemplo 1 - Obter todos os nomes de todos os itens na biblioteca de uma mesa
local function obterNomesRecursivo(bibItem)
              local itensFilhos = bibItem.children;
              local nomes = bibItem.name;
              local i;

              for i = 1, #itensFilhos, 1 do
                             local bibItemFilho = itensFilhos[i];
                             local nomesDoFilho = obterNomesRecursivo(bibItemFilho) or

"";

            if nomesDoFilho ~= "" then
                          nomes = nomes .. "\n" .. nomesDoFilho;

            end;

      end;

      return nomes;

end;

local nomesDeTodosOsItens = obterNomesRecursivo(umObjetoMesa.biblioteca);
showMessage(nomesDeTodosOsItens);

Objeto Personagem

  Este objeto representa um personagem na biblioteca de uma mesa no RRPG Firecast.

Herança

            O Objeto Personagem possui todas as características de um Objeto BibliotecaItem. Veja:
                           ● Objeto BibliotecaItem
                           ● Objeto WrappedObject

Características

  Além das características herdadas, o Objeto Personagem também possui as seguintes
  características:
Propriedades e atributos  Tipo     Descrição
   Propriedade            String
   dataType                        Somente leitura, contém o
                                   dataType da ficha do
editionBlocked            Boolean  personagem, isto é, em
escritaBloqueada                   qual formato de dados
                                   está a ficha do
avatar                    String   personagem.

bar0Val                   Integer  Somente leitura, contém
bar1Val                   Integer  true se a ficha do
bar2Val                   String   personagem estiver com
bar3Val                            marcada como edição
                                   bloqueada.
bar0Max
bar1Max                            Para alterar esta
bar2Max                            propriedade, utilize o
bar3Max                            método asyncUpdate
                                   deste objeto.
edtLine0
                                   Somente leitura, contém a
                                   URL da imagem do
                                   personagem.

                                   Para alterar esta
                                   propriedade, utilize o
                                   método asyncUpdate
                                   deste objeto.

                                   Read-only, the current
                                   value for the
                                   corresponding character
                                   bar.

                                   To modify this attribute,
                                   utilize this object's
                                   asyncUpdate method.

                                   Read-only, the maximum
                                   value for the
                                   corresponding character
                                   bar.

                                   To modify this attribute,
                                   utilize this object's
                                   asyncUpdate method.

                                   Read-only, content for the
   edtLine1                                         corresponding character
                                                    editable line.
Métodos                                             To modify this attribute,
   Método                                           utilize this object's
   personagem:isType(typeName)                      asyncUpdate method.

                                Descrição

                                Retorna true se passado "personagem" como parâmetro.
personagem:asyncOpenNDB([options]  Asynchronously opens the NodeDatabase of the character.
)
                                   Arguments:

                                             ● (Optional) options - A Lua table describing additional
                                                  settings that may contain:
                                                                  ○ skipLoad - a boolean. If true, the returned
                                                                       Promise will be resolved before the load
                                                                       process is finished. If true, you will receive
                                                                       “Loading node” instead of a “Loaded node”.
                                                                       Default: false

                                   Return:

                                             ● a Promise for a Node Object. Unless options.skipLoad is true
                                                  the Promise resolves after all data is downloaded and
                                                  available for use.

                                   Remarks:

                                             ● Each character possesses only one NodeDatabase.
                                             ● Changes made to the NodeDatabase opened by this

                                                  function are automatically synchronized with other users
                                                  who have also opened the same NodeDatabase.
                                             ● If the user leaves the room, the NodeDatabase will have its
                                                  connection dropped and will no longer synchronize change
                                             ● By default, users with +GM mode and the character owner
                                                  can read and write the NodeDatabase, while other users ca
                                                  only read.

                                   Example:

                                       local promise = character:asyncOpenNDB();

                                       local node = await(promise);

                                       -- variable node is ready to be used here
personagem:loadSheetNDB(callback)  FUNÇÃO DESCONTINUADA! Utilize a função
                                   personagem:asyncLoadNDB() ao invés desta.

                                   Abre um NodeDatabase do personagem que está fisicamente
                                   armazenado no servidor do RRPG.

                                   Parâmetros:

                                                                  ○ callback - Uma função que será invocada
                                                                       quando o NodeDatabase for carregado ou
                                                                       quando ocorrer um erro no carregamento.
                                                                                      ■ Quando o carregamento fo
                                                                                            bem sucedido, a função
                                                                                            callback será chamada
                                                                                            contendo o Objeto Nodo
                                                                                            raiz do NodeDatabase no
                                                                                            primeiro parâmetro. Este
                                                                                            node é o mesmo equivalen
                                                                                            ao "sheet" do lua form de
                                                                                            fichas.
                                                                                      ■ Quando ocorrer algum erro
                                                                                            no carregamento, a função
                                                                                            callback será chamada
                                                                                            contendo nil no primeiro
                                                                                            parâmetro.

                                   Observações:

                                                                  ○ Esta função é assíncrona, isto é, o código
                                                                       LUA continua sua execução normal
                                                                       enquanto o NDB é carregado em segundo
                                                                       plano. É preciso informar o parâmetro
                                                                       "callback" para obter o NodeDatabase
                                                                       carregado.

                                                                  ○ Cada personagem possui apenas um
                                                                       NodeDatabase.

                                                                  ○ Alterações feitas no NodeDatabase aberto
                                                                       por esta função são automaticamente
                                                                       sincronizadas com os outros usuários que
                                                                       também abriram o mesmo NodeDatabase,
                                                                       inclusives com a ficha aberta localmente (s
                                                                       tiver aberta).

                                                                  ○ Se o usuário sair da mesa, o NodeDatabase
                                                                       terá sua conexão cortada e não mais
                                                                       sincronizará as alterações.

                                                                  ○ Por padrão, os usuários com o modo
                                                                       +mestre e o dono do personagem podem le
                                                                       e alterar o NodeDatabase enquanto os
                                                                       demais usuários podem apenas ler valores.

                                                                  ○ A função "callback" pode demorar um pouc
                                                                       para ser chamada, pois um download
                                                                       precisará ser feito se o nodedatabase do
                                                                       personagem ainda não foi carregado
Objeto SceneUnitClass

  Este objeto representa um item de scene 2 na biblioteca de uma mesa no RRPG Firecast.

Herança

            O Objeto SceneUnitClass possui todas as características de um Objeto BibliotecaItem.
  Veja:

                           ● Objeto BibliotecaItem
                           ● Objeto WrappedObject

Características

  Além das características herdadas, o Objeto SceneUnitClass também possui as seguintes
  características:

Propriedades e atributos

Propriedade               Tipo                      Descrição

tamanhoX                  Double                    (Somente leitura) Contém
                                                    quantos metros o item
                                                    ocupa em sua largura no
                                                    tabuleiro de combate.

tamanhoY                  Double                    (Somente leitura) Contém
                                                    quantos metros o item
                                                    ocupa em sua altura no
                                                    tabuleiro de combate.

camada                    Enumerado:                (Somente leitura) Contém
                                    ● "tokens"      em qual camada o item
                                    ● "objects"     pertence por padrão no
                                    ● "background"  tabuleiro de combate.

descricao                 String                    (Somente leitura) Contém
                                                    um texto descritivo do
                                                    item de scene.

urlImg                    String                    (Somente leitura) Contém
                                                    a URL da imagem do item
                                                    de scene.

facing                    Enumerado:                (Somente leitura) Contém
                                                    como o item deve se
snapToGrid               ● "rotate"     comportar quando for
direcaoImg               ● "drawArrow"  rotacionado no tabuleiro
layoutCenterX                           de combate.
               Boolean
layoutCenterY  Double                   "rotate" - Rotacionar
               Double                   também a imagem do
                                        item.
               Double
                                        "drawArrow" - Não
                                        rotacionar a imagem e
                                        desenhar uma seta
                                        indicando a direção do
                                        item.

                                        (Somente leitura) Contém
                                        true se o item deve se
                                        alinhar ao grid do
                                        tabuleiro de combate.

                                        (Somente leitura) Contém,
                                        em graus, a direção do
                                        conteúdo da imagem...
                                        Isto é, "para onde a
                                        imagem está apontando"

                                        (Somente leitura) Contém
                                        onde o CENTRO do token
                                        está na imagem no eixo X.

                                        Exemplos de valores:

                                        0.5 - O centro do token
                                        está no centro da imagem.

                                        1.0 - O centro do token
                                        está no canto da direita da
                                        imagem.

                                        0.0 - O centro do token
                                        está no canto esquerdo da
                                        imagem

                                        (Somente leitura) Contém
                                        onde o CENTRO do token
                                        está na imagem no eixo Y.

                                        Exemplos de valores:

                                        0.5 - O centro do token
                                        está no centro da imagem.
layoutTamX  Double                1.0 - O centro do token
                                  está no canto inferior da
layoutTamY  Double                imagem.

                                  0.0 - O centro do token
                                  está no canto superior da
                                  imagem

                                  (Somente leitura) Contém
                                  o tamanho da imagem em
                                  relação ao tamanho do
                                  token, no eixo X.

                                  Exemplos de valores:

                                  1.0 - A largura da imagem
                                  é a mesma que a largura
                                  do token.

                                  1.5 - A largura da imagem
                                  é 1.5x a largura do token

                                  0.5 - A largura da imagem
                                  é 0.5x a largura do token.

                                  (Somente leitura) Contém
                                  o tamanho da imagem em
                                  relação ao tamanho do
                                  token, no eixo Y.

                                  Exemplos de valores:

                                  1.0 - A altura da imagem é
                                  a mesma que a altura do
                                  token.

                                  1.5 - A altura da imagem é
                                  1.5x a altura do token

                                  0.5 - A altura da imagem é
                                  0.5x a altura do token.

Métodos                           Descrição
   Método
                                  Retorna true se passado "sceneUnitClass" como
   sceneUnitClass:isType(typeNam  parâmetro.
   e)
Objeto Chat

  Este objeto representa uma interface de batepapo no RRPG Firecast.

Herança

            O Objeto Chat possui todas as características de um WrappedObject. Veja:
                           ● Objeto WrappedObject

Características

  Além das características herdadas, o Objeto Chat também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                   Descrição

impersonation             Impersonation table    Represents the current UI
                                                 impersonation selected by the user
                                                 in the chat.

                                                 Remarks:

                                                           ● Not all chat types
                                                                allow impersonations.

                                                           ● Attempts to change
                                                                the UI impersonation
                                                                while the current user
                                                                does not have
                                                                permission to
                                                                impersonate will be
                                                                ignored. You can use
                                                                the setImpersonation
                                                                method if you need to
                                                                identify if the change
                                                                was accepted.

medium                    Medium table           (Read-only) Contains the
                                                 identification of the chat medium
                                                 to which this object is related.

room                      Objeto Mesa            (Somente leitura) Contém a mesa a
                                                 qual este chat pertence.

                                                 Importante: Pode ser nil se o chat
                                                 não pertencer a uma mesa.

participants              Array of Entity table  (Read-only) Contains the
                                                 identification of all participants in
talemarkOptions  TalemarkOptions     this chat
                 table
                                     Contains the Talemark options
                                     used when the user sends
                                     messages to this chat.

                                     Remarks:

                                               ● Assigning nil to this
                                                    property will reset the
                                                    Talemark options to
                                                    the user settings.

Métodos                              Descrição
   Método
   chat:asyncInvite(logins)          Asynchronously invites users to this chat.

   chat:asyncQueryLogRecs([params])  Arguments:

                                               ● logins - An array of strings
                                                    containing the usernames to
                                                    be invited to the group private
                                                    chat.

                                     Return:

                                               ● A Promise object to track the
                                                    operation

                                     Remarks:

                                               ● This method works with group
                                                    private chats only. It is
                                                    possible to check what kind of
                                                    chat this is by accessing the
                                                    value of "medium" property.

                                     Asynchronously queries the log for
                                     messages stored on the server

                                     Arguments:

                                                                    ○ (Optional)
                                                                         params - A
                                                                         QueryLogRecs
                                                                         Params table
                                                                         describing
                                                                         how to fetch
                                                                         the LogRecs. If
                                                                         missing, the
                                       Return:        latest
                                       Remarks:       messages from
                                                      the chat will
                                                      be fetched.

                                                 ○ A promise for
                                                      a
                                                      QueryLogRecs
                                                      Response
                                                      table.

                                                 ○ This function
                                                      retrieves
                                                      messages from
                                                      the server's
                                                      log. To read
                                                      local
                                                      messages, use
                                                      the method
                                                      chat:readLogR
                                                      ecs() instead.

chat:asyncRoll(expression[, message[,  Asynchronously executes a dice roll in the
params]])                              chat.

                                       Arguments:

                                                                      ○ expression - A
                                                                           string
                                                                           containing the
                                                                           expression of
                                                                           the roll, such
                                                                           as "1d20 + 5,"
                                                                           or a Roll
                                                                           Object.

                                                                      ○ (Optional)
                                                                           message - A
                                                                           string
                                                                           containing an
                                                                           additional
                                                                           message
                                                                           describing the
                                                                           roll.

                                                                      ○ (Optional)
                                                                           params - A
                                                                           SendMessage
                                                                           Parameters
                                                                           table
                                Return:              containing
                                                     parameters of
                                                     the message.

                                                ○ A promise for
                                                     three pieces of
                                                     information in
                                                     the following
                                                     order:
                                                                    ■
                                                                    A

                                                                    ■
                                                                    A

                                                                    ■
                                                                    A

                                Remarks:        ○ See also the
                                Short example:       Example 3

                                 local promise =
                                chat:asyncRoll("1d20 + 5");

                                 local n, rollObject, logRec =
                                await(promise);

                                 -- the variables n,
                                rollObject, and logRec contain
                                the return values of the
                                promise.

chat:asyncSendAction(content[,  Asynchronously sends an action message
params])                        to the chat.

                                Arguments:

                                                               ○ content - A
                                                                    string
                                                                    containing the
                                                                    action
                                                                    message to be
                                                                    sent.

                                                               ○ (Optional)
                                                                    params - A
                                                                    SendMessage
                                                                    Parameters
                                                                    table
                                      Return:       containing
                                                    parameters of
                                                    the message.

                                               ○ A promise for
                                                    a LogRec table
                                                    that describes
                                                    the sent
                                                    message.

chat:asyncSendLaugh([params])         Asynchronously sends a laugh message to
chat:asyncSendStd(content[, params])  the chat.

                                      Arguments:

                                                                     ○ (Optional)
                                                                          params - A
                                                                          SendMessage
                                                                          Parameters
                                                                          table
                                                                          containing
                                                                          parameters of
                                                                          the message.

                                      Return:

                                                                     ○ A promise for
                                                                          a LogRec table
                                                                          that describes
                                                                          the sent
                                                                          message.

                                      Asynchronously sends a standard message
                                      to the chat.

                                      Arguments:

                                                                     ○ content - A
                                                                          string
                                                                          containing the
                                                                          standard
                                                                          message to be
                                                                          sent.

                                                                     ○ (Optional)
                                                                          params - A
                                                                          SendMessage
                                                                          Parameters
                                                                          table
                                                                          containing
                                                                          parameters of
                          Return:       the message.

                                   ○ A promise for
                                        a LogRec table
                                        that describes
                                        the sent
                                        message.

chat:enviarMensagem(msg)  Envia uma mensagem comum para o chat,
chat:enviarAcao(acao)     como se o usuário a tivesse digitado.
chat:enviarRisada()
                          Parâmetros:

                                                         ○ msg - a
                                                              mensagem
                                                              que deseja
                                                              enviar no chat.

                          Observações:

                                                         ○ Prefira usar a
                                                              função
                                                              chat:asyncSen
                                                              dStd() ao invés
                                                              desta.

                          Enviar uma mensagem como uma ação
                          para o chat.

                          Parâmetros:

                                                         ○ acao - a
                                                              mensagem
                                                              que deseja
                                                              enviar no chat
                                                              com
                                                              formatação de
                                                              ação.

                          Observações:

                                                         ○ Prefira usar a
                                                              função
                                                              chat:asyncSen
                                                              dAction() ao
                                                              invés desta.

                          Enviar uma típica risada do RRPG para o
                          chat.

                          Observações:
chat:enviarMensagemNPC(npc, msg)                                 ○ Prefira usar a
chat:enviarNarracao(narracao)                                         função
                                                                      chat:asyncSen
                                                                      dLaugh() ao
                                                                      invés desta.

                                  Envia uma mensagem para o chat como se
                                  um NPC estivesse falando.

                                  Parâmetros:

                                                                 ○ npc - cadeia de
                                                                      caracteres
                                                                      contendo o
                                                                      nome do NPC

                                                                 ○ msg - a
                                                                      mensagem
                                                                      que deseja
                                                                      enviar no chat.

                                  Observação:

                                                                 ○ Apenas o
                                                                      mestre da
                                                                      mesa
                                                                      consegue
                                                                      enviar
                                                                      mensagens
                                                                      como NPC.

                                                                 ○ Prefira usar a
                                                                      função
                                                                      chat:asyncSen
                                                                      dStd() ao invés
                                                                      desta.

                                  Enviar uma mensagem como narrador
                                  para o chat.

                                  Parâmetros:

                                                                 ○ narracao - a
                                                                      mensagem
                                                                      que deseja
                                                                      enviar no chat
                                                                      com
                                                                      formatação de
                                                                      narração.

                                  Observação:

                                                                 ○ Apenas o
                                                                      mestre da
chat:readLogRecs()                                      mesa
                                                        consegue
                                                        enviar
                                                        narrações.
                                                   ○ Prefira usar a
                                                        função
                                                        chat:asyncSen
                                                        dStd() ao invés
                                                        desta.

                    Reads the messages of the chat.

                    Arguments:

                         None

                    Return:

                                                   ○ Array of
                                                        LogRec table

                    Remarks:

                                                   ○ Only messages
                                                        already
                                                        available on
                                                        the Firecast
                                                        client are
                                                        returned. This
                                                        function does
                                                        not query the
                                                        server. To
                                                        query the
                                                        server, use the
                                                        method
                                                        chat:asyncQue
                                                        ryLogRecs()
                                                        instead.

                                                   ○ The returned
                                                        array is
                                                        already sorted
                                                        in the same
                                                        way the user
                                                        sees the
                                                        messages on
                                                        the interface.

                                                   ○ Messages that
                                                        are in the
                                                        process of
                                                        being sent or
                                                        have failed to
                                                        send are not
chat:rolarDados(rolagem [, msg,                                      returned by
calllback])                                                          this function.
                                                                ○ This function
                                                                     also reads the
                                                                     generic
                                                                     system log
                                                                     messages
                                                                     written to the
                                                                     chat.

                                 Envia uma rolagem de dados para o chat.

                                 Parâmetros:

                                                                ○ rolagem - um
                                                                     Objeto
                                                                     Rolagem ou
                                                                     uma cadeia de
                                                                     caracteres
                                                                     contendo a
                                                                     rolagem de
                                                                     dados.

                                                                ○ (OPCIONAL)
                                                                     msg - Uma
                                                                     mensagem
                                                                     para
                                                                     acompanhar a
                                                                     rolagem de
                                                                     dados.

                                                                ○ (OPCIONAL)
                                                                     callback - Uma
                                                                     função que
                                                                     será invocada
                                                                     após a rolagem
                                                                     ser executada
                                                                     no chat. A
                                                                     função recebe
                                                                     no primeiro
                                                                     parâmetro um
                                                                     NOVO Objeto
                                                                     Rolagem
                                                                     contendo o
                                                                     resultado da
                                                                     rolagem.

                                 Observações:

                                                                ○ Esta função
                                                                     tem
                                                                     comportament
                                                                     o assíncrono.
                                                                     Isto é, a função
chat:setImpersonation(impersonation)                                      retorna
                                                                          imediatament
                                                                          e e o resto do
                                                                          código
                                                                          continua
                                                                          sendo
                                                                          executado
                                                                          enquanto a
                                                                          rolagem é feita
                                                                          em segundo
                                                                          plano. Depois
                                                                          de algum
                                                                          tempo, quando
                                                                          o RRPG já
                                                                          souber o
                                                                          resultado, é
                                                                          que a função
                                                                          "callback" será
                                                                          invocada.
                                                                     ○ A função
                                                                          callback pode
                                                                          não ser
                                                                          invocada se a
                                                                          rolagem não
                                                                          for
                                                                          autorizada/rea
                                                                          lizada pelo
                                                                          RRPG.
                                                                          Exemplo de
                                                                          situações: A
                                                                          mesa está
                                                                          moderada e o
                                                                          usuário não
                                                                          possui o modo
                                                                          +voz para
                                                                          rolar dados, a
                                                                          conexão com o
                                                                          servidor caiu
                                                                          antes da
                                                                          rolagem ser
                                                                          realizada, etc..
                                                                     ○ Prefira usar a
                                                                          função
                                                                          chat:asyncRoll
                                                                          () ao invés
                                                                          desta.

                                      Veja também o exemplo 2.

                                      Attempts to change the UI impersonation
chat:write(text [, breakLine,         selected by the user in the chat.
allowSmileys])
                                      Arguments:
or
                                                                     ○ impersonation
chat:escrever(texto [, quebrarLinha,                                      -A
permitirSmileys])                                                         Impersonation
                                                                          table
                                                                          describing the
                                                                          new
                                                                          impersonation
                                                                          to use.

                                      Return:

                                                                     ○ A Boolean;
                                                                          Indicates if the
                                                                          change was
                                                                          accepted, and
                                                                          the
                                                                          impersonation
                                                                          was
                                                                          incorporated
                                                                          into the UI.

                                      Escreve/Imprime um texto no chat. O
                                      texto não é enviado para ninguém e só é
                                      exibido para o usuário que está usando o
                                      Firecast.

                                      Parâmetros:

                                                                     ○ text - cadeia
                                                                          de caracteres
                                                                          contendo o
                                                                          texto que deve
                                                                          ser impresso
                                                                          no chat.

                                                                     ○ (OPCIONAL)
                                                                          breakLine -
                                                                          Este
                                                                          parâmetro é
                                                                          ignorado no
                                                                          Firecast 8+

                                                                     ○ (OPCIONAL)
                                                                          allowSmileys -
                                                                          Booleano
                                                                          indicando se o
                                                                          RRPG deve
                                                                          interpretar
                                                                          smileys neste
                                                                          texto. Se
                                       Observações:                  omitido, o
                                                                     valor padrão
                                                                     true é
                                                                     assumido.

                                                                ○ Para mais
                                                                     opções,
                                                                     verifique o
                                                                     método
                                                                     chat:writeEx()

chat:writeEx(text[, talemarkOptions])  Write/print a text in the chat. The text is
                                       not sent; only the local user can see the
                                       text.

                                       Arguments:

                                                                      ○ text - A string
                                                                           containing the
                                                                           text to be
                                                                           printed.

                                                                      ○ (Optional)
                                                                           talemarkOptio
                                                                           ns - A
                                                                           TalemarkOpti
                                                                           ons table
                                                                           containing
                                                                           how Firecast
                                                                           should color
                                                                           and format the
                                                                           text. If missing,
                                                                           Firecast will
                                                                           use a default
                                                                           TalemarkOpti
                                                                           ons.

                                       Return:

                                                                      ○ A Boolean
                                                                           indicating if
                                                                           the operation
                                                                           was concluded
                                                                           successfully.

Exemplos
Exemplo 1 - Uma ficha enviando um Hello World para a sua mesa.

        <?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">

              <button>
                             <event name="onClick">
                                           local minhaMesa = Firecast.getRoomOf(sheet);
                                           local chat = minhaMesa.chat;

                                           chat:enviarMensagem("Olá mundo!!!!");
                             </event>
              </button>
</form>

Exemplo 2 - Uma ficha fazendo um teste (de resistência, por exemplo) e postando o resultado na
mesa.

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmTeste">

              <script>
                             local function realizarTesteDeResistencia()
                                           -- obter a mesa do personagem
                                           local mesaDoPersonagem =

Firecast.getRoomOf(sheet);

vamos usar o valor 0  -- se o usuário não preencheu modificador,
                      sheet.modificador = sheet.modificador or 0;

                                           mesaDoPersonagem.chat:rolarDados("1d20 + " ..
sheet.modificador, "Teste de Resistência",

                                                          function (rolado)
                                                                        -- A dificuldade do teste é

15

                      if rolado.resultado >= 15

then

mesaDoPersonagem.chat:enviarMensagem("SUCESSO =) você tirou " ..
rolado.resultado);

                                                                        else
mesaDoPersonagem.chat:enviarMensagem("FALHA =/ você tirou " ..
rolado.resultado);

                                                                        end;

                    end);

              end;
</script>

              <button onClick="realizarTesteDeResistencia()"/>
</form>

Example 3 - Using asyncRoll

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmTest">

           <script>
                   local function mindCheck()
                          -- Get the room
                          local room = Firecast.getRoomOf(sheet);

                          -- Start the roll
                          local promise = room.chat:asyncRoll("1d20 + " ..
    tostring(sheet.mind or 0));

                          -- Await for the roll to conclude
                          local resultNumber = await(promise);

                          -- Compare the result
                          if resultNumber >= 15 then

                                 room.chat:write("Success!");
                          else

                                 room.chat:write("Failure!");
                          end;
              end;
       </script>

       <button onClick="mindCheck()"/>
</form>

Objeto WrappedObject

  Objeto que representa algo no RRPG Firecast, é como uma classe pai abstrata e não faz sentido sua
  existência por si só.

  Exemplo de objetos que são/herdam de WrappedObject:

                                 ○ O objeto Mesa é um WrappedObject
                                 ○ O objeto BibliotecaItem é um WrappedObject
                                 ○ O objeto Personagem é um WrappedObject
                                 ○ etc...

Características

  Todos objetos que são WrappedObject possuem as seguintes características:

Propriedades e atributos

Propriedade               Tipo          Descrição

objectID                  Integer       Propriedade somente
                                        leitura, contém um número
                                        único à qual objeto do
                                        RRPG Firecast este
                                        WrappedObject
                                        representa.

objectType                String        Propriedade somente
                                        leitura, contém qual tipo
                                        de objeto este
                                        WrappedObject
                                        representa.

                                        Exemplo de valores:

                                                  ● "mesa"
                                                  ● "jogador"
                                                  ● "bibliotecaIte

                                                       m"
isObjectAlive               Boolean            ● "personagem"
                                               ● "rolagem"
                                               ● "chatBase"
                                               ● "object"

                                     Propriedade somente
                                     leitura, contém "true" se o
                                     objeto ainda é válido no
                                     RRPG ou "false" se já não é
                                     mais válido.

Métodos                              Descrição
   Método
   objeto:isType(typeName)           Retorna true se o objeto é do tipo "typeName",
                                     senão retorna false.
```
