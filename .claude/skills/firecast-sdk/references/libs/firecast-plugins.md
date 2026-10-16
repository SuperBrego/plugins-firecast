# Biblioteca firecast-plugins

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca Firecast.Plugins

       A biblioteca Firecast.Plugins contém funções relacionadas aos plug-ins instalados no Firecast.
       Todas as funções estão contidas na table/variável "Firecast.Plugins" da unidade "plugins.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "plugins.lua"
    require("plugins.lua");

    -- Agora é possível acessar as funções da biblioteca
    Firecast.Plugins.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções de Gerenciamento de Plugins

    function Firecast.Plugins.getInstalledDataTypes()
Retorna a lista de DataTypes instalados no Firecast.
Parâmetros:

    Não há parâmetros

Retorno:

          ○ Um array (uma tabela Lua indexada de 1 a N) de objetos, onde cada
               objeto representa um DataType instalado e possuem, cada um, os

               seguintes atributos:
                              ■ moduleId - Cadeia de caracteres identificando qual
                                   plug-in instalou o dataType.
                              ■ dataType - Cadeia de caracteres identificando o
                                   dataType
                              ■ formType - Cadeia de caracteres identificando o
                                   formType. Veja atributo formType da tag form para

                                   saber quais são os possíveis valores deste atributo.
                              ■ title - Cadeia de caracteres que identifica o dataType de

                                   forma intuitiva para o usuário.

function Firecast.Plugins.getInstalledPlugins()

Retorna a lista de plug-ins SDK 3 instalados no Firecast.
Parâmetros:

    Não há parâmetros

Retorno:

          ○ Um array (uma tabela Lua indexada de 1 a N) de objetos, onde cada
               objeto representa um Plug-in instalado e possuem, cada um, os

               seguintes atributos:
                              ■ moduleId - Cadeia de caracteres com a identificação
                                   única do plug-in.
                              ■ name - Cadeia de caracteres contendo o nome do plug-
                                   in.
                              ■ version - Cadeia de caracteres contendo a versão do
                                   plug-in.
                              ■ description - Cadeia de caracteres contendo a
                                   descrição do plug-in.
                              ■ author - Cadeia de caracteres contendo informações
                                   sobre o autor do plug-in.
                              ■ site - Cadeia de caracteres contendo informações do
                                   website relacionado ao plug-in.
                              ■ contact - Cadeia de caracteres contendo informações
                                   sober como entra em contato com o autor do plug-in.
                                                  ■ fileName - Cadeia de caracteres contendo o nome do
                                                       arquivo ".rpk" relacionado a este plug-in. Este atributo
                                                       contém apenas o nome curto do arquivo e não descreve
                                                       sua localização no HD. Exemplos: "DnD.rpk",
                                                       "Vampiros.rpk", etc..

                                                  ■ compilationTimestamp - A data e hora (UTC) em que o
                                                       plugin foi compilado. Este atributo é representado por
                                                       um número inteiro, contendo quantos segundos se
                                                       passaram desde UNIX Epoch (01 de janeiro de 1970)

                                                  ■ compilationTimestampStr - A data e hora (UTC) em que
                                                       o plugin foi compilado. Este atributo é representado em
                                                       uma cadeia de caracteres de tamanho fixo no formato
                                                       "ddmmyyyyhhnnss" (onde "nn" são os minutos)

                                                  ■ compilationDigest - Uma cadeia de caracteres contento
                                                       o hash SHA-1 do conteúdo do plugin. Um plugin pode
                                                       ser compilado mais de uma vez, e, por isso,
                                                       compilationTimestamp pode variar sem que o conteúdo
                                                       do plugin mude. É seguro afirmar que se
                                                       compilationDigest não mudar, então o conteúdo do
                                                       plugin não mudou. Este campo está presente em plugins
                                                       compilados com o SDK 3.5+.

function Firecast.Plugins.getInstalledTablesDock()

Retorna a lista de "Table's Dock"/janelas acopláveis instalados no Firecast.
Parâmetros:

    Não há parâmetros

Retorno:

          ○ Um array (uma tabela Lua indexada de 1 a N) de objetos, onde cada
               objeto representa um Table's Dock que o usuário pode utilizar em suas

               mesas, cada um, os seguintes atributos:
                              ■ moduleId - Cadeia de caracteres identificando qual
                                   plug-in instalou o TablesDock.
                              ■ name - Cadeia de caracteres contendo o nome do
                                   formulário
                              ■ dataType - Cadeia de caracteres identificando o
                                   dataType do formulário TablesDock
                              ■ title - Cadeia de caracteres que identifica o Table's
                                   Dock de forma intuitiva para o usuário.

function Firecast.Plugins.getRPKDetails(stream)
   Retorna algumas informações sobre um stream contendo um plug-in SDK3 (arquivo de
   extensão .rpk).

   Parâmetros:

                             ○ stream - Um objeto Stream que possui o conteúdo do arquivo ".rpk"

   Retorno:

                             ○ Se o parâmetro "stream" contiver um arquivo .rpk válido, a função
                                  retorna uma tabela lua com os seguintes atributos:
                                                  ■ moduleId - Cadeia de caracteres contendo o
                                                       identificador único do plug-in
                                                  ■ name - Cadeia de caracteres contendo o nome do plug-
                                                       in
                                                  ■ version - Cadeia de caracteres contendo a versão do
                                                       plug-in
                                                  ■ description - Cadeia de caracteres contendo a
                                                       descrição do plug-in.
                                                  ■ author - Cadeia de caracteres contendo a identificação
                                                       do autor do plug-in.
                                                  ■ site - Cadeia de caracteres contendo informações sobre
                                                       o website do plug-in.
                                                  ■ contact - Cadeia de caracteres contendo informações
                                                       sobre como contatar o autor do plug-in.
                                                  ■ minApiVersion - Número contendo qual a versão de API
                                                       do SDK3 mínima para este plug-in rodar.
                                                  ■ sdkVersion - Cadeia de caracteres contendo qual a
                                                       versão do SDK3 o plug-in foi compilado.
                                                  ■ compilationTimestamp - A data e hora (UTC) em que o
                                                       plugin foi compilado. Este atributo é representado por
                                                       um número inteiro, contendo quantos segundos se
                                                       passaram desde UNIX Epoch (01 de janeiro de 1970)
                                                  ■ compilationTimestampStr - A data e hora (UTC) em que
                                                       o plugin foi compilado. Este atributo é representado em
                                                       uma cadeia de caracteres de tamanho fixo no formato
                                                       "ddmmyyyyhhnnss" (onde "nn" são os minutos)
                                                  ■ compilationDigest - Uma cadeia de caracteres contento
                                                       o hash SHA-1 do conteúdo do plugin. Um plugin pode
                                                       ser compilado mais de uma vez, e, por isso,
                                                       compilationTimestamp pode variar sem que o conteúdo
                                                       do plugin mude. É seguro afirmar que se
                                                       compilationDigest não mudar, então o conteúdo do
                                                       plugin não mudou. Este campo está presente em plugins
                                                       compilados com o SDK 3.5+.

                             ○ Se o parâmetro "stream" não contiver um arquivo rpk válido, a função
                                  retorna nil.

   Observações:

                             ○ A função começa a ler o stream à partir da posição 0.

function Firecast.Plugins.installPlugin(stream [,
    ignoreIfOlder])

       Instala um plug-in SDK3 no Firecast.

       Parâmetros:
                                 ○ stream - Um objeto Stream que possui o conteúdo do arquivo ".rpk" que
                                      deseja instalar.
                                 ○ (OPCIONAL) ignoreIfOlder - Booleano indicando se a função deve
                                      ignorar a instalação caso exista uma versão mais nova já instalada deste
                                      plug-in. Se omitido, o parâmetro possui valor false.

       Retorno:
                                 ○ Se a instalação for bem sucedida, a função retorna "true". Se a
                                      instalação não for bem sucedida, retorna "false" e uma cadeia de
                                      caracteres contendo o motivo da falha.

       Observações:
                                 ○ A função começa a ler o stream à partir da posição 0.
                                 ○ Por motivo de segurança, apenas plug-ins autorizados conseguem
                                      gerenciar os plug-ins do Firecast.
                                 ○ Se o plug-in já estiver instalado: o plug-in é descarregado, a atualização
                                      é instalada, e a nova versão é carregada novamente.

    function Firecast.Plugins.uninstallPlugin(moduleId)

       Desinstala um plug-in SDK3 que está atualmente instalado no Firecast.

       Parâmetros:
                                 ○ moduleId - Cadeia de caracteres identificando qual plug-in deseja
                                      desinstalar. Cada plug-in possui um moduleId, que é uma identificação
                                      única do mesmo.

       Retorno:
                                 ○ Se a instalação for bem sucedida, a função retorna "true". Se a
                                      instalação não for bem sucedida, retorna "false" e uma cadeia de
                                      caracteres contendo o motivo da falha.

       Observações:
                                 ○ Por motivo de segurança, apenas plug-ins autorizados conseguem
                                      gerenciar os plug-ins do Firecast.

Intercomunicação de plug-ins.

       Os plug-ins do Firecast podem comunicar entre si afim de realizar pedidos, coordenar ações,
       informar algum ocorrido, etc..
   Todas as mensagens de plugins são compostas por:

                             ○ identificação do plug-in destinatário.
                             ○ nome da mensagem.
                             ○ conteúdo da mensagem.

    Antes de receber mensagens, o plug-in deve registrar uma "escuta" através da função
   Firecast.Plugins.listenPM informando o nome da mensagem que ouvirá e uma função que será
   chamada para tratá-la.. Durante o tratamento da mensagem recebida, o plug-in receptor pode
   enviar uma resposta para o plug-in emissor.

   Para enviar uma mensagem a outro plug-in, este deve utilizar a função Firecast.Plugins.sendPM
   informando a identificação do plug-in destinatário, o nome da mensagem, conteúdo, uma
   função callback de sucesso e uma função callback de falha.

function Firecast.Plugins.sendPM(moduleId, pmName, data [, callback,
failureCallback])

   Envia uma mensagem a outro plug-in instalado no Firecast.

   Parâmetros:

                             ○ moduleId - Uma cadeia de caracteres contendo a identificação única do
                                  módulo/plugin que receberá a mensagem. Este é o mesmo valor
                                  encontrado no arquivo module.xml de cada plug-in. Também é possível
                                  obter este valor através da função Firecast.Plugins.getInstalledPlugins.

                             ○ pmName - Uma cadeia de caracteres contendo o nome da mensagem.
                             ○ data - O corpo da mensagem, uma tabela lua que será transmitida ao

                                  plug-in destinatário.
                             ○ (OPCIONAL) callback - Uma função que será invocada quando o plug-in

                                  destinatário responder a esta mensagem. O primeiro parâmetro da
                                  função recebe os dados enviados pelo plug-in destinatário.
                             ○ (OPCIONAL) failureCallback - Uma função que será invocada quando
                                  ocorrer algum erro no envio e/ou processamento da mensagem. O
                                  primeiro parâmetro da função recebe os dados sobre a falha.

   Observações:

                             ○ Para saber se o envio foi bem sucedido, utilize o parâmetro "callback".
                             ○ Para saber se o envio não foi bem sucedido, utilize o parâmetro

                                  "failureCallback". A função failureCallback é invocada se o plugin
                                  destinatário não estiver instalado no Firecsat, se o plug-in destinatário
                                  não souber tratar mensagens de nome "pmName" ou se o ocorrer
                                  alguma falha de execução no plug-in que recebeu a mensagem.

function Firecast.Plugins.listenPM(pmName, callback)

   Instala uma escuta de mensagens de plugins.

   Parâmetros:
Observações:  ○ pmName - Uma cadeia de caracteres contendo o nome da mensagem
                   que esta escuta trata.

              ○ callback - Uma função que será disparada quando a escuta capturar
                   uma mensagem de nome igual a "pmName" e recebe, no primeiro
                   parâmetro, o corpo da mensagem. Esta informação é uma tabela LUA
                   contendo os mesmos dados que foram enviados pela função
                   Firecast.Plugins.sendPM acrescida da propriedade "moduleId" (a
                   identificação de qual plug-in enviou a mensagem).

              ○ Um plug-in só pode ter uma escuta para cada "pmName". Não é possível
                   instalar 2 escutas para a mensagem "TESTE", por exemplo.

              ○ Para enviar uma resposta a quem enviou a mensagem, a função
                   "callback" deve:
                                  ■ Se já tiver a resposta pronta, usar "return VALOR"; ...
                                       Este valor será transmitido para a função callback do
                                       plug-in emissor.
                                  ■ Se ainda não tiver a resposta pronta, deve, dentro da
                                       função "callback", invocar o método
                                       Firecast.Plugins.setLatePMReply() e, posteriormente,
                                       utilizar as funções Firecast.Plugins.replyPM ou
                                       Firecast.Plugins.replyPMFailure para enviar a resposta
                                       ao plug-in emissor.

function Firecast.Plugins.setLatePMReply(message)

   Ao receber uma mensagem, a escuta, instalada previamente pela função
   Firecast.Plugins.listenPM, pode invocar este método para sinalizar que ainda não tem a
   resposta para a mensagem e que a enviará posteriormente.

   Parâmetros:

                             ○ message - A mensagem cuja resposta deseja postergar. Esta informação
                                  é a mesma que foi recebida no primeiro parâmetro da função callback
                                  da escuta (ver Firecast.Plugins.listenPM).

   Observações:

                             ○ Você deve, em algum momento, invocar Firecast.Plugins.replyPM ou
                                  Firecast.Plugins.replyPMFailure para enviar uma resposta ao plug-in
                                  remetente. Utilizar setLatePMReply e não invocar
                                  Firecast.Plugins.replyPM e nem Firecast.Plugins.replyPMFailure faz
                                  com que o Firecast não libere os recursos envolvidos na comunicação,
                                  tornando seu plug-in um "devorador de memória RAM" ao longo do
                                  tempo.

function Firecast.Plugins.replyPM(message, data)
       Envia uma resposta ao remetente da mensagem inter-plugin.
       Parâmetros:

                                 ○ message - A mensagem que deseja responder. Esta informação é a
                                      mesma que foi recebida no primeiro parâmetro da função callback da
                                      escuta (ver Firecast.Plugins.listenPM).

                                 ○ data - O conteúdo da resposta. Pode ser um número, uma cadeia de
                                      caracteres, um booleano ou uma tabela lua. Esta informação será
                                      repassada no primeiro parâmetro da função "callback" de quem enviou
                                      a mensagem (ver Firecast.Plugins.sendPM)

    function Firecast.Plugins.replyPMFailure(message, data)

       Envia uma resposta de FALHA ao remetente da mensagem inter-plugin.
       Parâmetros:

                                 ○ message - A mensagem que deseja responder. Esta informação é a
                                      mesma que foi recebida no primeiro parâmetro da função callback da
                                      escuta (ver Firecast.Plugins.listenPM).

                                 ○ data - O conteúdo da resposta. Pode ser um número, uma cadeia de
                                      caracteres, um booleano ou uma tabela lua. Esta informação será
                                      repassada no primeiro parâmetro da função "failureCallback" de quem
                                      enviou a mensagem (ver Firecast.Plugins.sendPM
```
