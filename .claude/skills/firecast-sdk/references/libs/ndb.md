# Biblioteca ndb

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca NDB

       A biblioteca ndb provê funções para manipular NodeDatabases, como abrir um NodeDatabase,
       retornar o nó pai de um nó, etc..
       Todas as funções estão contidas na table/variável "NDB" da unidade "ndb.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "ndb.lua"
    require("ndb.lua");

    -- Agora é possível acessar as funções da biblioteca
    NDB.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca NDB
function NDB.load(fileName [, userName])

   Carrega um NodeDatabase que está localizado no HD Virtual do plug-in e retorna o nodo raiz.

   Parâmetros:

                                  ○ fileName – cadeia de caracteres identificando o nome do arquivo
                                  ○ [Opcional] userName – Se você desejar fazer controle de

                                        permissões em um NodeDatabase local, passe neste parâmetro
                                        uma cadeia de caracteres identificando o usuário que está abrindo o
                                        database. Normalmente não é preciso se preocupar com este
                                        parâmetro, e basta omitir seu valor na chamada da função.

   Retorno:

                                  ○ Retorna um Objeto Nodo, representado a raiz do NodeDatabase.
                                                       ■ Todas as alterações feitas neste nodo (e em seus
                                                            nodos filhos) serão salvas automaticamente no
                                                            arquivo passado no parâmetro “fileName”.

   Observações:

                                  ○ O parâmetro “fileName” é expandido (através da função
                                        “VHD.expandFileName”) antes de procurar o arquivo.

                                  ○ Caso o arquivo não exista, um novo é criado automaticamente.
                                                       ■ Se foi fornecido um caminho curto no parâmetro
                                                            “fileName” (não relativo à raiz do HD Virtual), então
                                                            o nome do arquivo é expandido em relação ao
                                                            diretório “/” (raiz do HD Virtual) antes da criação do
                                                            arquivo.

                                  ○ O formato do arquivo é XML.
                                  ○ Se o arquivo especificado fizer parte da pasta projeto do plug-in, o

                                        NodeDatabase será aberto em modo somente leitura.

function NDB.newMemNodeDatabase([initialContent])

   Cria um novo NodeDatabase temporário que reside apenas na memória. Quando o Firecast
   fecha, os dados salvos neste NodeDatabase são perdidos.

   Parâmetros:

                             ○ (Opcional) initialContent - Um objeto Stream contendo um arquivo
                                  XML. Se informado, o NodeDatabase retornado conterá os dados deste
                                  XML. Se não informado, será retornado um NodeDatabase vazio.

   Retorno:

                             ○ Um Objeto Nodo, representado a raiz do NodeDatabase temporário.

function NDB.newObserver(node)
   Cria um novo objeto NodeObserver para o nodo passado como parâmetro. Um NodeObserver
   é capaz de monitorar e notificar as mudanças ocorridas em um determinado Nodo de
   NodeDatabase.
   Parâmetros:

                             ○ node - Objeto nodo que deseja monitorar mudanças.
   Retorno:

                             ○ Um novo objeto NodeObserver

function NDB.newTransaction(node)

   Cria uma nova transação para controlar como as mudanças são salvas/compartilhadas em um
   NodeDatabase
   Parâmetros:

                             ○ node - um Objeto nodo do NodeDatabase que deseja controlar as
                                  mudanças.

   Retorno:
                             ○ Um objeto NodeTransaction

   Observações:
                             ○ Apenas criar um NodeTransaction não faz com que as mudanças sejam
                                  controladas. É preciso chamar o método NDB.pushTransaction para
                                  ativar a captura de mudanças para o controle.

function NDB.isNodeObject(value)

   Verifica se determinado valor é um objeto nodo.
   Parâmetros:

                             ○ value - O valor que deseja verificar se é um objeto nodo.
   Retorno:

                             ○ true se o valor passado é um objeto nodo válido
                             ○ false se o valor passado não for um objeto nodo válido.

function NDB.getRoot(node)

   Retorna o nodo raiz de um nodo, isto é, o nodo mais externo do NodeDatabase.
   Parâmetros:
Retorno:  ○ node - Um objeto nodo do qual se deseja obter a raiz.
          ○ Um objeto nodo representando o nodo raiz do NodeDatabase.

function NDB.getParent(node)

   Retorna o nodo pai de um nodo, isto é, o nodo que contém o nodo passado como parâmetro.
   Parâmetros:

                             ○ node - Um objeto nodo do qual se deseja obter o nodo pai.
   Retorno:

                             ○ Um objeto nodo representando o nodo pai ou nil se o parâmetro node
                                  for um nodo raiz.

function NDB.getChildNodes(node)

   Retorna todos os nodos filhos de um determinado nodo.
   Parâmetros:

                             ○ node - O objeto nodo do qual se deseja obter os nodos filhos.
   Retorno:

                             ○ Um arranjo (tabela/objeto LUA) onde cada índice, começando do 1,
                                  contém um objeto nodo filho do nodo passado como parâmetro.

function NDB.getAttributes(node)

   Retorna uma tabela contendo todos os atributos e valores de um determinado objeto nodo.
   Parâmetros:

                             ○ node - O objeto nodo do qual se deseja obter todos os atributos.
   Retorno:

                             ○ Uma tabela/objeto LUA contendo pares de
                                  nomeAtributo=valorAtributo.

   Observação:
                             ○ Esta função não retorna os nodos filhos do objeto nodo. Retorna apenas
                                  os atributos.

function NDB.getNodeName(node)
   Retorna o nome de um objeto nodo.
   Parâmetros:

                             ○ node - O objeto nodo de qual deseja obter o nome.
   Retorno:

                             ○ Uma cadeia de caracteres (string) contendo o nome do nodo ou nil se o
                                  parâmetro node não for um objeto nodo válido.

function NDB.getPersistedAttributeValue(node,
attributeName)

   Retorna o valor que está persistido/salvo no servidor de um atributo de um objeto nodo.
   Parâmetros:

                             ○ node - O objeto nodo de qual deseja obter o valor persistido.
                             ○ attributeName - Cadeia de caracteres contendo o nome do

                                  atributo/campo que se deseja obter o valor persistido.
   Retorno:

                             ○ O valor persistido ou nil caso não seja encontrado.
   Observações:

                             ○ Devido a existência de transações no NodeDatabase e também devido
                                  à caracteristica assíncrona do NodeDatabase, o valor dos atributos do
                                  NodeDatabases podem, temporariamente, não refletir ao valor salvo no
                                  servidor e nem ao valor que os outros usuários remotos tem acesso.

                             ○ Esta função retorna o valor que foi aprovado pelo servidor e que é
                                  conhecido pelos outros usuários remotos.

function NDB.createChildNode(node, childName)

   Cria um nodo filho dentro de um nodo.
   Parâmetros:

                             ○ node - O objeto nodo que receberá o novo nodo filho.
                             ○ childName - uma cadeia de caracteres (string) contendo o nome do

                                  novo nodo.
   Retorno:
                             ○ Um objeto nodo representando o nodo filho recém criado ou nil caso a
                                  operação falhe.

function NDB.deleteNode(node)

   Remove um nodo do Node Database.
   Parâmetros:

                             ○ node - O objeto nodo que deseja remover.
   Observações:

                             ○ Não é possível remover um nodo raiz do NodeDatabase.

function NDB.clearNode(node)

   Limpa um objeto nodo, isto é, remove todos os atributos e todos os nodos filhos de um
   determinado nodo.
   Parâmetros:

                             ○ node - O objeto nodo o qual deseja limpar.
   Observações:

                             ○ Diferente da função "ndb.deleteNode", esta função não remove o nodo
                                  passado como parâmetro do NodeDatabase.

function NDB.copy(destinationNode, sourceNode)

   Copia os dados de um node de NodeDatabase para outro node de NodeDatabase.
   Parâmetros:

                             ○ destinationNode - um Objeto nodo do NodeDatabase que será o
                                  destino da operação de cópia.

                             ○ sourceNode - um Objeto nodo do NodeDatabase que será a fonte da
                                  operação de cópia.

   Observações:
                             ○ Os dados de destinationNode serão apagados antes da cópia começar.

function NDB.beginUpdate(node)
   Coloca o Node Database em estado de "em alterações". Enquanto estiver neste estado, as
   sincronizações de dados e notificações/eventos referentes a alterações no NodeDatabase
   serão adiadas até que este saia do modo "em alterações".

   Alterar o NodeDatabase para o modo de alterações pode melhorar a performance de
   procedimentos que fazem várias alterações consecutivas no mesmo.

   Para tirar o NodeDatabase do estado "em alterações", invoque a função NDB.endUpdate.

   Parâmetros:
                             ○ node - Um objeto nodo cujo NodeDatabase deseja colocar no modo "em
                                  alterações".

   Observações:
                             ○ Você pode invocar beginUpdate mais de uma vez no mesmo
                                  NodeDatabase. Para cada chamada de NDB.beginUpdate, deve haver
                                  uma chamada de NDB.endUpdate para fazer com que o NodeDatabase
                                  saia do estado "em alterações".
                             ○ Apesar de ser passado um objeto nodo no parâmetro, o NodeDatabase
                                  inteiro será colocado no estado em alterações.

function NDB.endUpdate(node)

   Faz com que o NodeDatabase saia do modo "em alterações" que havia sido previamente
   ativado pela função NDB.beginUpdate.

   Ao sair do modo "em alterações", as mudanças feitas serão sincronizadas e os devidos
   eventos/notificações serão invocadas!

   Parâmetros:
                             ○ node - Um objeto nodo cujo NodeDatabase deseja retirado do modo
                                  "em alterações".

   Observações:
                             ○ Para cada chamada de NDB.beginUpdate, deve haver uma chamada de
                                  NDB.endUpdate para fazer com que o NodeDatabase saia do estado
                                  "em alterações".
                             ○ Apesar de ser passado um objeto nodo no parâmetro, o NodeDatabase
                                  inteiro será retirado do modo "em alterações".

function NDB.getState(node)

   Retorna o estado de um NodeDatabase

   Parâmetros:
                             ○ node - Um objeto nodo cujo NodeDatabase deseja verificar o estado.
Retorno:

          ○ Uma cadeia de caracteres, podendo ser:
                              ■ "open" - O NodeDatabase está aberto e funcional
                              ■ "opening" - O NodeDatabase está abrindo/carregando
                              ■ "closed" - O NodeDatabase está fechado. Algum erro de
                                   carregamento pode ter ocorrido ou a conexão com o

                                   armazenamento foi perdida.

function NDB.onReady(node, callback[, failCallback])

   Monitora um NodeDatabase e notifica o programador quando ele estiver pronto para ser usado

   Parâmetros:

                             ○ node - Um objeto nodo cujo NodeDatabase deseja monitorar o estado.
                             ○ callback - Um método que será chamado quando o objeto nodo estiver

                                  pronto para ser usado, isto é, ele foi completamente carregado e está
                                  pronto para ter seus dados acessados.
                             ○ (OPCIONAL) failCallback - Um método que será chamado se ocorrer
                                  algum erro durante o carregamento do NodeDatabase.

   Observações:

                             ○ Às vezes, apenas ter a referência ao objeto nodo não significa que ele já
                                  está pronto para ser usado. Algumas vezes ocorre um carregamento de
                                  dados em segundo plano pela internet e, enquanto ocorre este
                                  carregamento, o objeto nodo não aceita operações. Esta é uma boa
                                  maneira de saber quando o nodeDatabase está de fato pronto!

                             ○ Quando node já estiver carregado, callback será chamado
                                  imediatamente após um delay de 1 milisegundo.

                             ○ Quando node estiver carregando, callback será chamado quando o
                                  processo de carregamento chegar ao fim.

function NDB.pushTransaction(node, transaction)

Ativa uma transação em um NodeDatabase.

Parâmetros:

                         ○ node - um Objeto nodo do NodeDatabase que deseja controlar as
                               mudanças.

                         ○ transaction - um objeto NodeTransaction previamente criado pela
                               função NDB.newTransaction que controlará as próximas mudanças no
                               NodeDatabase.

Observações:

                         ○ Após ativar uma transação, todas as alterações que ocorrerem no
                               NodeDatabase serão mantidas localmente e não serão compartilhadas
                               automaticamente com os outros usuários. Você deverá controlar o que
                                      acontecerá com estas mudanças ao invocar "transaction:rollback()" se
                                      quiser desfazê-las ou "transaction:commit()" para confirmá-las e
                                      compartilhar-lhas com os outros usuários.
                                 ○ Para cada chamada de NDB.pushTransaction(), deve haver uma
                                      chamada de NDB.popTransaction().

    function NDB.popTransaction(node)

       Desativa a última transação ativada em um NodeDatabase pela função NDB.pushTransaction

       Parâmetros:
                                 ○ node - um Objeto nodo do NodeDatabase que deseja para de controlar
                                      as mudanças.

       Observações:
                                 ○ Para cada chamada de NDB.pushTransaction(), deve haver uma
                                      chamada de NDB.popTransaction().
                                 ○ Se antes de chamar pushTransaction o NodeDatabase já estava sendo
                                      controlado por alguma transação, esta transação será restaurada.
                                 ○ Apenas invocar este método não é o suficiente para realizar o controle
                                      das mudanças. Você o invocar o método "rollback()" da transaction se
                                      quiser desfazer as mudanças capturadas ou invocar o método
                                      "commit()" da transaction para confirmar e compartilhar as mudanças
                                      capturadas.

    function NDB.getServerUTCTime(node)

       Retorna a data e hora do servidor do NodeDatabase em UTC (Coordinated Universal Time)

       Parâmetros:
                                 ○ node - um Objeto nodo do NodeDatabase que deseja consultar o
                                      servidor.

       Retorno:
                                 ○ Um número de ponto flutuante contendo quantos dias se passaram
                                      desde 30/12/1899 00:00. Exemplo: 2.75 representa a data 01/01/1900
                                      18:00

       Observações:
                                 ○ A função retorna imediatamente, mas o valor retornado é um valor
                                      aproximado, podendo ser diferente do horário do servidor de fato em
                                      alguns segundos.

Funções de persistência de dados do NodeDatabase
    function NDB.exportXML(node)

       Salva o conteúdo de um node de NodeDatabase como XML
       Parâmetros:

                                 ○ node - um Objeto nodo do NodeDatabase que se deseja salvar os dados.
       Retorno:

                                 ○ Uma cadeia de caracteres representando o conteúdo do Node e nodes
                                      filhos como um XML (codificado em UTF-8)

    function NDB.importXML(destinationNode, xmlString)

       Carrega os dados de um XML em um node de NodeDatabase.
       Parâmetros:

                                 ○ destinationNode - um Objeto nodo do NodeDatabase onde os dados
                                      serão carregados.

                                 ○ xmlString - Uma cadeia de caracteres cujo conteúdo é o XML contendo
                                      os dados a serem carregados.

       Observações:
                                 ○ Os dados de destinationNode serão apagados antes da importação.

Funções de gerenciamento de permissões do NodeDatabase

       NodeDatabases permitem definir permissões aos usuários, podendo, por exemplo, selecionar
       quais pessoas poderão alterar um Objeto Nodo e/ou quais pessoas não poderão saber da
       existência de algum Objeto Nodo.

    function NDB.setPermission(node, selKind, selId, permission, allowance)

       Define uma permissão a alguém a um Objeto nodo.
       Parâmetros:

                                 ○ node - Objeto nodo o qual deseja definir a permissão.
                                 ○ selKind - Selector Kind, uma cadeia de caracteres podendo ser "group"

                                      ou "user". A combinação dos parâmetros selKind + selId define a quem
                                      esta permissão deve ser aplicada.
                                 ○ selId - Selector Id, uma cadeia de caracteres contendo a identificação do
                                      usuário ou grupo de usuários a quem esta permissão deve ser aplicada.

                                                      ■ se selKind for "user", selId contém o login do usuário
                                                           RRPG que deseja conceder/negar a permissão.
                    ■ se selKind for "group", selId pode conter um dos
                         seguintes valores:
                                         ● "todos" - A permissão será aplicada a
                                              TODOS do RRPG
                                         ● "mestresAux" - A permissão será a
                                              aplicada a todos os mestres auxiliares

                                              da mesa.
                                         ● "mestres" - A permissão será aplicada a

                                              todos que possuírem o modo +mestre

                                              na mesa.
                                         ● "jogadores" - A permissão será aplicada

                                              a todos que possuírem o modo +jogador

                                              na mesa.
                                         ● "espectadores" - A permissão será

                                              aplicada a todos que forem

                                              espectadores na mesa.
                                         ● "criadorDaMesa" - A permissão será

                                              aplicada em quem tiver criado a mesa.
                                         ● "criador" - A permissão será aplicada

                                              em quem criou o NodeDatabase (Válido

                                              somente se for node for de um

                                              NodeDatabase de um personagem)
                                         ● "dono" - A permissão será aplicada em

                                              quem for dono do NodeDatabase

                                              (Válido somente se for node for de um

                                              NodeDatabase de um personagem)
                                         ● "cegos" - A permissão será aplicada em

                                              quem tiver o modo +cego na mesa.
                                         ● "mudos" - A permissão será aplicada em

                                              quem tiver o modo +mudo na mesa.
                                         ● "voices" - A permissão será aplicada em

                                              quem tiver o modo +voz na mesa.
○ permission - Uma cadeia de caracteres identificando qual permissão

     está sendo definida e pode conter um dos seguintes valores:
                    ■ "read" - Permissão para ler valores de atributos do
                         objeto nodo e permissão para saber que o objeto nodo

                         existe.
                    ■ "write" - Permissão para escrever valores de atributos

                         no objeto nodo.
                    ■ "createChild" - Permissão para criar Objetos Nodos

                         filhos ao objeto nodo passado em parâmetro.
                    ■ "delete" - Permissão para apagar Objetos Nodos.
                    ■ "readPermissions" - Permissão para ler as permissões

                         do objeto nodo (Uma meta-permissão).
                    ■ "writePermissions" - Permissão para definir permissões

                         no objeto nodo (Uma meta-permissão).
                    ■ "writeMetaPermissions" - Permissão para definir meta-

                         permissões no nodo. Quem possui esta permissão é

                         capaz de escolher quem pode gerenciar permissões!

                         (Uma meta-permissão)
Observações:  ○ allowance - Define se a permissão é concedida ou negada. Pode ser um
                   dos seguintes valores:
                                  ■ "allow" - Esta cadeia de caracteres define que a
                                       permissão é concedida.
                                  ■ "deny" - Esta cadeia de caracteres define que a
                                       permissão é negada.
                                  ■ "strongAllow" - Esta cadeia de caracteres define que a
                                       permissão é concedida. A diferença entre "allow" e
                                       "strongAllow" se dá quando um usuário for afetado por
                                       "deny" e "allow/strongAllow" ao mesmo tempo: Se o
                                       usuário for afetado por "deny" e "allow" ao mesmo
                                       tempo, "deny" prevalece. Se for afetado por "deny" e
                                       "strongAllow" ao mesmo tempo, "strongAllow"
                                       prevalece.
                                  ■ nil - Nil significa: Remover, não definir, não conceder e
                                       nem negar esta permissão: A permissão será herdada
                                       do objeto nodo Pai do objeto passado como parâmetro.

              ○ Se selKind for "user" e selId não identificar um usuário válido do RRPG,
                   está função falhará.

              ○ As permissões funcionam de forma herdada: Isto é, todos os nodos
                   filhos do "node" também respeitarão esta permissão se ela não for
                   redefinida no filho.

              ○ Se em um mesmo nodo um usuário for afetado ao mesmo tempo por
                   uma definição de permissão deny e por uma definição de permissão
                   allow, "deny" prevalecerá por ser mais forte que "allow". Se em um
                   mesmo nodo um usuário for afetado ao mesmo tempo por uma
                   definição de permissão deny e por uma definição de permissão
                   strongAllow, "strongAllow" prevalecerá por ser mais forte que "deny".
                                  ■ Exemplos de uso em que um usuário pode ser afetado
                                       por mais de uma definição de permissão:
                                                       ● Você quer que todos os jogadores
                                                            consigam ver um nodo, exceto José:
                                                            Adiciona-se uma permissão "group
                                                            jogadores read allow" e uma permissão
                                                            "user José read deny". Mesmo fazendo
                                                            parte do grupo Jogadores, José não terá
                                                            permissão de leitura por deny ser mais
                                                            forte que allow.
                                                       ● Se você quer que NENHUM jogador
                                                            consiga ver um nodo, exceto José:
                                                            Adiciona-se uma permissão "group
                                                            jogadores read deny" e uma permissão
                                                            "user José read strongAllow". Mesmo
                                                            fazendo parte do grupo Jogadores, José
                                                            terá permissão de leitura por
                                                            strongAllow ser mais forte que deny.

              ○ Mesmo que você não defina permissões, todo NodeDatabase possui um
                   conjunto de permissões básicos que são herdados em todos os Nodos
                   caso não sejam redefinidos.
           ○ Por segurança:
                               ■ Esta função possui um gatilho que não permite o
                                    usuário remover sua própria permissão de "read",
                                    "readPermissions", "writePermissions" e
                                    "writeMetaPermissions" quando for possuidor de tais
                                    permissões.
                               ■ Para conceder/negar permissões "read", "write",
                                    "createChild" e "delete", o usuário atual deve possuir a
                                    permissão "writePermissions". Para conceder/negar as
                                    meta-permissões "readPermissions",
                                    "writePermissions" e "writeMetaPermissions", o
                                    usuário deve possuir também a permissão
                                    "writeMetaPermissions". Por padrão, apenas o criador
                                    da sala possui "writeMetaPermissions" e todos os
                                    mestres possuem "writePermissions".
                               ■ Um Super Usuário não é afetado por nenhuma definição
                                    de permissão de usuário e tem acesso total. Quando um
                                    usuário for o criador da mesa e estiver com o modo
                                    +mestre nesta mesma mesa, ele é considerado um
                                    Super Usuário.

Exemplos:

-- Não permitir nem os jogadores e nem os espectadores
verem os valores de Sheet
NDB.setPermission(sheet, "group", "jogadores", "read",
"deny");
NDB.setPermission(sheet, "group", "espectadores", "read",
"deny");

-- Desfazer as permissões acima, voltando para valores
padrões/herdados.
NDB.setPermission(sheet, "group", "jogadores", "read",
nil);
NDB.setPermission(sheet, "group", "espectadores", "read",
nil);

-- Permitir que +jogadores possam alterar valores de
sheet
NDB.setPermission(sheet, "group", "jogadores", "write",
"allow");

-- Permitir que o usuário AlyssonRPG tenha permissões de
mestre:
NDB.setPermission(sheet, "user", "AlyssonRPG", "read",
                "allow");

                NDB.setPermission(sheet, "user", "AlyssonRPG", "write",

                "allow");

                NDB.setPermission(sheet, "user", "AlyssonRPG",

                "createChild", "allow");

                NDB.setPermission(sheet, "user", "AlyssonRPG", "delete",

                "allow");

                NDB.setPermission(sheet, "user", "AlyssonRPG",

                "readPermissions", "allow");

                NDB.setPermission(sheet, "user", "AlyssonRPG",

                "writePermissions", "allow");

function NDB.getPermission(node, selKind, selId, permission)

   Retorna a definição de uma permissão de alguém de um Objeto nodo que foi previamente
   definida pelo método NDB.setPermission

   Parâmetros:

                             ○ node - Objeto nodo o qual deseja consultar a permissão.
                             ○ selKind - Selector Kind, uma cadeia de caracteres podendo ser "group"

                                  ou "user". A combinação dos parâmetros selKind + selId define de quem
                                  a permissão deve ser consultada.
                             ○ selId - Selector Id, uma cadeia de caracteres contendo a identificação do
                                  usuário ou grupo de usuários de quem a permissão deve ser consultada.

                                                  ■ se selKind for "user", selId contém o login do usuário
                                                       RRPG que deseja consultar a permissão.

                                                  ■ se selKind for "group", selId pode conter um dos
                                                       seguintes valores:
                                                                       ● "todos" - Permissão que foi aplicada a
                                                                            TODOS do RRPG
                                                                       ● "mestresAux" - Permissão que foi
                                                                            aplicada a todos os mestres auxiliares
                                                                            da mesa.
                                                                       ● "mestres" - Permissão que foi aplicada a
                                                                            todos que possuírem o modo +mestre
                                                                            na mesa.
                                                                       ● "jogadores" - Permissão que foi
                                                                            aplicada a todos que possuírem o modo
                                                                            +jogador na mesa.
                                                                       ● "espectadores" - Permissão que foi
                                                                            aplicada a todos que forem
                                                                            espectadores na mesa.
                                                                   ● "criadorDaMesa" - Permissão que foi
                                                                        aplicada em quem tiver criado a mesa.

                                                                   ● "criador" - Permissão que foi aplicada
                                                                        em quem criou o NodeDatabase (Válido
                                                                        somente se for node for de um
                                                                        NodeDatabase de um personagem)

                                                                   ● "dono" - Permissão que foi aplicada em
                                                                        quem for dono do NodeDatabase
                                                                        (Válido somente se for node for de um
                                                                        NodeDatabase de um personagem)

                                                                   ● "cegos" - Permissão que foi aplicada em
                                                                        quem tiver o modo +cego na mesa.

                                                                   ● "mudos" - Permissão que foi aplicada
                                                                        em quem tiver o modo +mudo na mesa.

                                                                   ● "voices" - Permissão que foi aplicada
                                                                        em quem tiver o modo +voz na mesa.

                         ○ permission - Uma cadeia de caracteres identificando qual permissão
                               está sendo consultada e pode conter um dos seguintes valores:
                                              ■ "read" - Permissão para ler valores de atributos do
                                                   objeto nodo e permissão para saber que o objeto nodo
                                                   existe.
                                              ■ "write" - Permissão para escrever valores de atributos
                                                   no objeto nodo.
                                              ■ "createChild" - Permissão para criar Objetos Nodos
                                                   filhos ao objeto nodo passado em parâmetro.
                                              ■ "delete" - Permissão para apagar Objetos Nodos.
                                              ■ "readPermissions" - Permissão para ler as permissões
                                                   do objeto nodo (Uma meta-permissão).
                                              ■ "writePermissions" - Permissão para definir permissões
                                                   no objeto nodo (Uma meta-permissão).
                                              ■ "writeMetaPermissions" - Permissão para definir meta-
                                                   permissões no nodo. Quem possui esta permissão é
                                                   capaz de escolher quem pode gerenciar permissões!
                                                   (Uma meta-permissão)

Retorno:

    A função pode retornar um dos 4 abaixo:

                         ○ "allow" - Cadeia de caracteres que informa que a permissão foi
                               concedida

                         ○ "deny" - Cadeia de caracteres que informa que a permissão foi negada.
                         ○ "strongAllow" - Cadeia de caracteres que informa que a permissão é

                               concedida. A diferença entre "allow" e "strongAllow" se dá quando um
                               usuário for afetado por "deny" e "allow/strongAllow" ao mesmo tempo:
                               Se o usuário for afetado por "deny" e "allow" ao mesmo tempo, "deny"
                               prevalece. Se for afetado por "deny" e "strongAllow" ao mesmo tempo,
                               "strongAllow" prevalece.
                         ○ nil - Nil significa que a permissão não foi definida, não foi concedida e
                               nem negada: A permissão está sendo herdada do objeto nodo Pai do
                               objeto passado como parâmetro
Observações:

              ○ Esta função retorna se há uma definição de permissão em determinado
                   nodo mas não analisa a herança de permissões. Caso queira testar se o
                   usuário possui permissão, seja por uma definição local ou herdada,
                   utilize o método NDB.testPermission

function NDB.testPermission(node, permission)

   Realiza um teste de permissão: Verifica se o usuário atual possui determinada permissão em um
   objeto nodo, seja permissão herdada ou permissão definida localmente.

   Parâmetros:

                             ○ node - Objeto nodo o qual deseja testar a permissão.
                             ○ permission - Uma cadeia de caracteres identificando qual permissão

                                  está sendo testada e pode conter um dos seguintes valores:
                                                  ■ "read" - Permissão para ler valores de atributos do
                                                       objeto nodo e permissão para saber que o objeto nodo
                                                       existe.
                                                  ■ "write" - Permissão para escrever valores de atributos
                                                       no objeto nodo.
                                                  ■ "createChild" - Permissão para criar Objetos Nodos
                                                       filhos ao objeto nodo passado em parâmetro.
                                                  ■ "delete" - Permissão para apagar Objetos Nodos.
                                                  ■ "readPermissions" - Permissão para ler as permissões
                                                       do objeto nodo (Uma meta-permissão).
                                                  ■ "writePermissions" - Permissão para definir permissões
                                                       no objeto nodo (Uma meta-permissão).
                                                  ■ "writeMetaPermissions" - Permissão para definir meta-
                                                       permissões no nodo. Quem possui esta permissão é
                                                       capaz de escolher quem pode gerenciar permissões!
                                                       (Uma meta-permissão)

   Retorno:

                             ○ Booleano true se o usuário possui permissão, senão false.

function NDB.enumPermissions(node)

Retorna todas as permissões que foram definidas em um determinado objeto nodo.

Parâmetros:
                         ○ node - Objeto nodo o qual deseja enumerar as permissão.

Retorno:
                         ○ Um array (tabela Lua indexada de 1 a #retorno), onde cada item é uma
                               tabela contendo as seguintes propriedades:
■ selKind - Selector Kind, uma cadeia de caracteres
     podendo ser "group" ou "user". A combinação dos

     parâmetros selKind + selId define a quem a permissão é

     aplicada.
■ selId - Selector ID, uma cadeia de caracteres contendo a

     identificação do usuário ou grupo de usuários a quem a

     permissão é aplicada.
                    ● se selKind for "user", selId contém o
                         login do usuário RRPG a quem a

                         permissão é aplicada.
                    ● se selKind for "group", selId pode

                         conter um dos seguintes valores:
                                         ○ "todos" - Permissão que
                                              foi aplicada a TODOS

                                              do RRPG
                                         ○ "mestresAux" -

                                              Permissão que foi

                                              aplicada a todos os

                                              mestres auxiliares da

                                              mesa.
                                         ○ "mestres" - Permissão

                                              que foi aplicada a todos

                                              que possuírem o modo

                                              +mestre na mesa.
                                         ○ "jogadores" - Permissão

                                              que foi aplicada a todos

                                              que possuírem o modo

                                              +jogador na mesa.
                                         ○ "espectadores" -

                                              Permissão que foi

                                              aplicada a todos que

                                              forem espectadores na

                                              mesa.
                                         ○ "criadorDaMesa" -

                                              Permissão que foi

                                              aplicada em quem tiver

                                              criado a mesa.
                                         ○ "criador" - Permissão

                                              que foi aplicada em

                                              quem criou o

                                              NodeDatabase (Válido

                                              somente se for node for

                                              de um NodeDatabase

                                              de um personagem)
                                         ○ "dono" - Permissão que

                                              foi aplicada em quem

                                              for dono do

                                              NodeDatabase (Válido

                                              somente se for node for

                                              de um NodeDatabase

                                              de um personagem)
                                         ○ "cegos" - Permissão que
                                              foi aplicada em quem

                                              tiver o modo +cego na

                                              mesa.
                                         ○ "mudos" - Permissão

                                              que foi aplicada em

                                              quem tiver o modo

                                              +mudo na mesa.
                                         ○ "voices" - Permissão

                                              que foi aplicada em

                                              quem tiver o modo +voz

                                              na mesa.
■ permission - Uma cadeia de caracteres identificando

     qual permissão foi aplicada e pode conter um dos

     seguintes valores:
                    ● "read" - Permissão para ler valores de
                         atributos do objeto nodo e permissão

                         para saber que o objeto nodo existe.
                    ● "write" - Permissão para escrever

                         valores de atributos no objeto nodo.
                    ● "createChild" - Permissão para criar

                         Objetos Nodos filhos ao objeto nodo

                         passado em parâmetro.
                    ● "delete" - Permissão para apagar

                         Objetos Nodos.
                    ● "readPermissions" - Permissão para ler

                         as permissões do objeto nodo (Uma

                         meta-permissão).
                    ● "writePermissions" - Permissão para

                         definir permissões no objeto nodo (Uma

                         meta-permissão).
                    ● "writeMetaPermissions" - Permissão

                         para definir meta-permissões no nodo.

                         Quem possui esta permissão é capaz de

                         escolher quem pode gerenciar

                         permissões! (Uma meta-permissão)
■ allowance - Define se a permissão foi concedida ou

     negada. Pode conter um dos seguintes valores:
                    ● "allow" - Esta cadeia de caracteres
                         define que a permissão foi concedida.
                    ● "deny" - Esta cadeia de caracteres
                         define que a permissão foi negada.
                    ● "strongAllow" - Esta cadeia de
                         caracteres define que a permissão é

                         concedida. A diferença entre "allow" e

                         "strongAllow" se dá quando um usuário

                         for afetado por "deny" e

                         "allow/strongAllow" ao mesmo tempo:

                         Se o usuário for afetado por "deny" e

                         "allow" ao mesmo tempo, "deny"

                         prevalece. Se for afetado por "deny" e
                                     "strongAllow" ao mesmo tempo,
                                     "strongAllow" prevalece.

function NDB.resetPermissions(node)

   Exclui todas as definições de permissões em um determinado objeto nodo.
   Parâmetros:

                             ○ node - Objeto nodo que deseja limpar as definições de permissões.

function NDB.editPermissions(node)

       Apresenta uma interface padrão para o usuário editar as permissões de um Node do
       NodeDatabase
       Parâmetros:

                                 ○ node - Objeto nodo que o usuário editará as permissões.

Funções de comunicação através do NodeDatabase

       NodeDatabases permitem o envio e recebimento de mensagens aos usuários que estão
       acessando o mesmo NodeDatabase.

    function NDB.broadcastMessage(node, messageId, message[, loopBack])

Envia uma mensagem a todos os outros usuários que estão com o nodeDatabase aberto.

Parâmetros:

                         ○ node - Objeto nodo do NodeDatabase a qual deseja enviar uma
                               mensagem

                         ○ messageId - Uma cadeia de caracteres contendo a identificação da
                               mensagem.

                         ○ message - A mensagem a ser transmitida. Aqui são aceitos textos,
                               tabelas lua, números e booleanos.

                         ○ (OPICIONAL) loopBack - Informa se quer que esta mensagem seja
                               retransmitida para você mesmo. Valor padrão: false

Observações:

                         ○ A mensagem enviada é entregue a todos os outros usuários conectados
                               no NodeDatabase.

                         ○ Para receber as mensagens recebidas, o usuário destinatário deve ter
                               previamente invocado a função NDB.newBroadcastListener
function NDB.newBroadcastListener(node, messageId, callback)

Cria uma escuta de mensagens para receber mensagens postadas pela função
NDB.broadcastMessage.

Parâmetros:   ○ node - Objeto nodo do NodeDatabase do qual deseja receber
                   mensagens.
Retorno:
Observações:  ○ messageId - Uma cadeia de caracteres contendo a identificação das
                   mensagens que deseja receber. Deve ser igual ao messageId usado na
                   função NDB.broadcastMessage.

              ○ callback - Uma função que será invocada ao receber mensagens. Esta
                   função recebe três parâmetros na seguinte ordem:
                                  ■ sender - Cadeia de caracteres contendo o login do
                                       usuário que enviou a mensagem
                                  ■ messageId - Cadeia de caracteres contendo a
                                       identificação da mensagem recebida
                                  ■ message - A mensagem que foi postada.

              ○ Retorna um objeto representando o Listener.

              ○ Importante: Mantenha referência ao objeto retornado por esta função
                   enquanto quiser que a escuta esteja ativa. Se o coletor de lixo LUA
                   coletar este objeto, a escuta é destruída e a função callback não será
                   mais invocada.

              ○ Se quiser destruir a escuta imediatamente, invoque a função destroy do
                   objeto retornado.... obj:destroy();

              ○ Nos casos das fichas e janelas acopláveis, o RRPG mantém
                   nodeDatabases carregados mesmo após o usuário fechar a janela da
                   ficha. Por este motivo, a função callback pode ser invocada para uma
                   ficha que não possui mais janela. Se fizer uso de mensagens, esteja
                   preparado para este comportamento.

Objeto Nodo

       Um Objeto Nodo é uma tabela LUA com um comportamento diferenciado que representa um
       nó/nodo de um NodeDatabase. Suas principais características são:

                 ● Aparentam ser uma tabela/objeto LUA normal. Isto é, você pode ler e atribuir
                       propriedades como faria com qualquer outra tabela/objeto LUA.
                 ● Todas as alterações feitas no objeto nodo são salvas e sincronizadas
                       automaticamente com as outras pessoas que estão acessando o mesmo
                       NodeDatabase.

                 ● Quando outras pessoas alteram atributos do nodo, o seu objeto nodo recebe e
                       reflete tais alterações automaticamente.

                 ● Não é possível atribuir uma “função” a uma propriedade do nodo.
                 ● Quando se atribui uma tabela LUA a uma propriedade do nodo, uma cópia recursiva

                       de todos os valores é realizada.
                 ● O nome dos atributos são case-insensitive, isto é, não são diferenciadas letras

                       minúsculas das maiúsculas (Ex: “nome” e “NoME” representam o mesmo atributo do
                       nodo).

Alterando atributos de um Objeto Nodo

       Para alterar um atributo de um Objeto Nodo basta fazer uma atribuição como você faria em
       qualquer outra tabela/objeto Lua.
       Exemplo:

    require("ndb.lua");
    local nodoRaiz = ndb.load("MeuNodeDatabase.xml");

    --[[ nodoRaiz é um Objeto Nodo --]]

    nodoRaiz.atributo1 = "valor em string";
    nodoRaiz.atributo2 = 2;
    nodoRaiz.atributo3 = true;
    nodoRaiz.atributoDeOutroNome = 6.7;

    nodoRaiz["atributo5"] = "outro valor em string";
    nodoRaiz["atributo6"] = 9999;
    nodoRaiz["atributo7"] = false;

       Não tem mistério! Você atribui normalmente.... Só não são aceitos function como valores.
       As alterações são salvas automaticamente no documento.

Lendo atributos de um Objeto Nodo.

       Mais uma vez, não há mistério: Basta acessar normalmente como uma tabela LUA qualquer.
       Exemplo:
    require("ndb.lua");
    local nodoRaiz = ndb.load("MeuNodeDatabase.xml");

    --[[ nodoRaiz é um Objeto Nodo --]]

      showMessage(nodoRaiz.atributo1);

    if nodoRaiz.atributo2 == 2 then
                   -- faz alguma coisa....

    end;

    nodoRaiz.atributo200 = nodoRaiz.atributo3;
    nodoRaiz.atributo250 = nodoRaiz.atributo2 + 50;

    local valor = nodoRaiz["atributoDeOutroNome"];
    valor = nodoRaiz["atributo3"];

Removendo um atributo de um Objeto Nodo

       Basta atribuir nil ao atributo que deseja remover.
       Exemplo:

    require("ndb.lua");
    local nodoRaiz = ndb.load("MeuNodeDatabase.xml");

    --[[ nodoRaiz é um Objeto Nodo --]]

    nodoRaiz.atributoQueDesejoRemover = nil;
    nodoRaiz.atributo1 = nil;
    nodoRaiz["atributo2"] = nil;

       As alterações são salvas automaticamente no documento.

Criando um Objeto Nodo filho

       Basta atribuir uma tabela a uma propriedade....
       Exemplo:
    require("ndb.lua");
    local nodoRaiz = ndb.load("MeuNodeDatabase.xml");

    --[[ nodoRaiz é um Objeto Nodo --]]

    -- Após a linha abaixo, nodoRaiz.nodoFilho será um Objeto Nodo filho de "nodoRaiz" de nome "nodoFi
    nodoRaiz.nodoFilho = {};

    -- Na linha abaixo, nodoRaiz.nodoFilho2 será um Objeto Nodo filho de "nodoRaiz" de nome "nodoFilho
    -- Além disso, o novo Objeto Nodo já possuirá os valores nome="Meu Nome" e idade=7.
    nodoRaiz.nodoFilho2 = {nome="Meu Nome", idade=7};

      -- Como nodoRaiz.nodoFilho é um Objeto Nodo, você pode criar um nodo filho "nodoNeto" dentro de
      --"nodoRaiz.nodoFilho" facilmente:
    nodoRaiz.nodoFilho.nodoNeto = {};

    -- E pode atribuir propriedades a ele normalmente, pois "nodoNeto" também é um Objeto Nodo.
    nodoRaiz.nodoFilho.nodoNeto.atributoDoNeto = "Valor";

       As alterações são salvas automaticamente no documento.

Deletando um Objeto Nodo

       basta atribuir nil ou usar a função "ndb.deleteNode(nodo)"
       Exemplo:

    require("ndb.lua");
    local nodoRaiz = ndb.load("MeuNodeDatabase.xml");

    --[[ nodoRaiz é um Objeto Nodo --]]

    -- apagando o nodo "nodoFilho" e todos seus filhos recursivamente do nodo raiz
    nodoRaiz.nodoFilho = nil;

    -- apgando usando a função ndb.deleteNode(node)
    ndb.deleteNode(nodoRaiz.nodoFilho2);

       As alterações são salvas automaticamente no documento.

Duplicando um Objeto Nodo
       Basta fazer uma atribuição simples...
       Exemplo:

    require("ndb.lua");
    local nodoRaiz = ndb.load("MeuNodeDatabase.xml");

    --[[ nodoRaiz é um Objeto Nodo --]]

    -- criando um nodo filho com valores padrões:
    nodoRaiz.nodoFilho = {nome="José", idade=75, corFavorita="red", nodoNeto={}};

    -- duplicando o nodo filho.
    nodoRaiz.nodoClone = nodoRaiz.nodoFilho;

       As alterações são salvas automaticamente no documento.

Outras operações em um Objeto Nodo

                                 ○ Obter o nome do objeto nodo: ndb.getNodeName(nodo);
                                 ○ Limpar o conteúdo do objeto nodo: ndb.clearNode(nodo);
                                 ○ Obter o nodo pai: ndb.getParent(nodo);

Objeto NodeObserver

  Este objeto representa um NodeObserver, um mecanismo capaz de monitorar e notificar mudanças
  que ocorrerem em um determinado Nodo do NodeDatabase.

Como instanciar um NodeObserver

            É possível instanciar um NodeObserver através do método NDB.newObserver

Características

  O objeto NodeObserver possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                                Descrição

enabled                   Boolean                             Determina se o
                                                              NodeObserve está ativo e
                                                              se pode disparar eventos
node                   objeto Nodo  notificando mudanças.
                                    Valor padrão: true

                                    Somente leitura, contém o
                                    objeto Nodo que está
                                    sendo monitorado pelo
                                    NodeObserver

Eventos                             Descrição
   Nome do evento
   onChildAdded                     Este evento é invocado quando um objeto
                                    nodo filho é criado no nodo que está sendo
   onChildRemoved                   monitorado.

   onDeepChildAdded                 Parâmetros:

   onDeepChildRemoved                                              ○ node - O objeto
                                                                        nodo filho que foi
                                                                        criado.

                                    Este evento é invocado quando um objeto
                                    nodo filho é deletado do nodo que está sendo
                                    monitorado.

                                    Parâmetros:

                                                                   ○ node - O objeto
                                                                        nodo filho que foi
                                                                        removido.

                                    Este evento é invocado quando um objeto
                                    nodo filho é criado no nodo que está sendo
                                    monitorado ou em algum de seus filhos
                                    (monitoramento recursivo).

                                    Parâmetros:

                                                                   ○ node - O objeto
                                                                        nodo filho que foi
                                                                        criado.

                                    Este evento é invocado quando um objeto
                                    nodo filho é deletado do nodo que está sendo
                                    monitorado ou de algum de seus filhos
                                    (monitoramento recursivo).

                                    Parâmetros:
onChanged                                     ○ node - O objeto
onDeepChanged                                      nodo filho que foi
                                                   removido.

               Este evento é invocado quando o valor de
               algum atributo do nodo que está sendo
               monitorado é alterado.

               Parâmetros:

                                              ○ node - O objeto
                                                   nodo onde
                                                   ocorreu a
                                                   mudança do do
                                                   valor.

                                              ○ attribute -
                                                   Cadeia de
                                                   caracteres
                                                   contendo o nome
                                                   do atributo que
                                                   mudou.

                                              ○ oldValue - Antigo
                                                   valor do atributo.

               Este evento é invocado quando o valor de
               algum atributo do nodo ou nodo filho do
               nodo que está sendo monitorado é alterado
               (monitoramento recursivo).

               Parâmetros:

                                              ○ node - O objeto
                                                   nodo onde
                                                   ocorreu a
                                                   mudança do do
                                                   valor.

                                              ○ attribute -
                                                   Cadeia de
                                                   caracteres
                                                   contendo o nome
                                                   do atributo que
                                                   mudou.

                                              ○ oldValue - Antigo
                                                   valor do atributo.
onPersistedChanged  Este evento é invocado quando ocorre uma
                    mudança de valor no servidor de algum
                    atributo do nodo que está sendo monitrado.

                    Parâmetros:

                                                   ○ node - O objeto
                                                        nodo onde
                                                        ocorreu a
                                                        mudança do do
                                                        valor no servidor.

                                                   ○ attribute -
                                                        Cadeia de
                                                        caracteres
                                                        contendo o nome
                                                        do atributo que
                                                        mudou.

                                                   ○ oldValue - Antigo
                                                        valor de servidor
                                                        do atributo.

                    Observações:

                              ● Devido a existência de
                                   transações no NodeDatabase e
                                   também devido à característica
                                   assíncrona do NodeDatabase, o
                                   valor dos atributos do
                                   NodeDatabases podem,
                                   temporariamente, não refletir ao
                                   valor salvo no servidor e nem ao
                                   valor que os outros usuários
                                   remotos tem acesso.

                              ● Este evento é chamado quando
                                   alguma alteração é confirmada
                                   no lado do Servidor, persistida e
                                   disponibilizada para todos os
                                   outros usuários remotos.

                              ● O valor persistido pode ser
                                   obtido através da função
                                   NDB.getPersistedAttributeValue
                                   ()
onDeepPersistedChanged  Este evento é invocado quando ocorre uma
onUserChanged           mudança de valor no servidor de algum
                        atributo do nodoou nodo filho que está sendo
                        monitrado (monitoramento recursivo).

                        Parâmetros:

                                                       ○ node - O objeto
                                                            nodo onde
                                                            ocorreu a
                                                            mudança do do
                                                            valor no servidor.

                                                       ○ attribute -
                                                            Cadeia de
                                                            caracteres
                                                            contendo o nome
                                                            do atributo que
                                                            mudou.

                                                       ○ oldValue - Antigo
                                                            valor de servidor
                                                            do atributo.

                        Observações:

                                  ● Devido a existência de
                                       transações no NodeDatabase e
                                       também devido à característica
                                       assíncrona do NodeDatabase, o
                                       valor dos atributos do
                                       NodeDatabases podem,
                                       temporariamente, não refletir ao
                                       valor salvo no servidor e nem ao
                                       valor que os outros usuários
                                       remotos tem acesso.

                                  ● Este evento é chamado quando
                                       alguma alteração é confirmada
                                       no lado do Servidor, persistida e
                                       disponibilizada para todos os
                                       outros usuários remotos.

                                  ● O valor persistido pode ser
                                       obtido através da função
                                       NDB.getPersistedAttributeValue
                                       ()

                        Este evento é invocado quando o valor de
                        algum atributo do nodo que está sendo
                        monitorado é alterado porque o usuário
                        local alterou o conteúdo do do campo, seja
                        editando ele visualmente ou através de
                        código Lua.

                        Parâmetros:
onDeepUserChanged                                 ○ node - O objeto
                                                       nodo onde
                                                       ocorreu a
                                                       mudança do do
                                                       valor.

                                                  ○ attribute -
                                                       Cadeia de
                                                       caracteres
                                                       contendo o nome
                                                       do atributo que
                                                       mudou.

                                                  ○ oldValue - Antigo
                                                       valor do atributo.

                   Observações:

                             ● Lembre-se, este evento será
                                  disparado apenas quando o
                                  usuário local alterar o valor de
                                  algum dos campos do nodo
                                  monitorado.

                   Este evento é invocado quando o valor de
                   algum atributo do nodo ou nodo filho que
                   está sendo monitorado é alterado porque o
                   usuário local alterou o conteúdo do do
                   campo, seja editando ele visualmente ou
                   através de código Lua (monitoramento
                   recursivo).

                   Parâmetros:

                                                  ○ node - O objeto
                                                       nodo onde
                                                       ocorreu a
                                                       mudança do do
                                                       valor.

                                                  ○ attribute -
                                                       Cadeia de
                                                       caracteres
                                                       contendo o nome
                                                       do atributo que
                                                       mudou.

                                                  ○ oldValue - Antigo
                                                       valor do atributo.

                   Observações:

                             ● Lembre-se, este evento será
                                  disparado apenas quando o
                                  usuário local alterar o valor de
                                  algum dos campos do nodo ou
onDeleted                                       nodo filho monitorado.
onPermissionListChanged
                                 Este evento é invocado quando o objeto
onDeepPermissionListChanged      nodo que está sendo monitorado é apagado.

onFinalPermissionsCouldBeChange  Parâmetros:
d
                                                                ○ node - O objeto
                                                                     nodo que foi
                                                                     removido.

                                 Este evento é invocado quando definições de
                                 permissões de acesso são inseridas ou
                                 removidas do objeto nodo que está sendo
                                 monitorado.

                                 Parâmetros:

                                                                ○ node - O objeto
                                                                     nodo que sofreu
                                                                     alteração na lista
                                                                     de definições de
                                                                     permissões.

                                 Este evento é invocado quando definições de
                                 permissões de acesso são inseridas ou
                                 removidas do objeto nodo que está sendo
                                 monitorado ou em algum de seus nodos filhos
                                 (monitoramento recursivo).

                                 Parâmetros:

                                                                ○ node - O objeto
                                                                     nodo que sofreu
                                                                     alteração na lista
                                                                     de definições de
                                                                     permissões.

                                 Este evento é invocado quando as
                                 permissões finais de acesso a este nodo
                                 podem ter sofrido alterações porque uma
                                 permissão em um nodo pai foi
                                 removida/inserida e, por consequência, pode
                                 ter sido herdada pelo nodo que está sendo
                                 monitorado, ou as permissões finais podem
                                 ter sofrido alterações porque o usuário
                                 mudou de grupo de permissões (Exemplo: O
                                 usuário atual virou +mestre).

                                 Parâmetros:
onStateChanged                                                          ○ node - O objeto
                                                                             nodo que pode
                                                                             ter sofrido
                                                                             alteração nas
                                                                             permissões finais.

                                         Este evento é invocado quando o estado de
                                         carregamento do node (ver ndb.getState)
                                         muda.

                                         Parâmetros:

                                                                        ○ node - O objeto
                                                                             nodo que sofreu
                                                                             mudança no
                                                                             estado de
                                                                             carregamento.

Observações:

                ○ Se um NodeObserver não for mais acessível pelo código e for destruído
                     pela coleta de lixos do Lua, os eventos não serão mais disparados.

Exemplos
Exemplo 1 - Monitorando um Node "sheet"

self.observer = ndb.newObserver(sheet);

self.observer.onChildAdded =
              function(node)
                             -- Esta função será chamada quando um novo Nodo Filho for

criado em sheet
              end;

self.observer.onChildRemoved =
              function(node)
                             -- Esta função será chamada quando um nodo Filho for

removido de sheet
              end;

self.observer.onChanged =
              function(node, attribute, oldValue)
                             -- Esta função será chamada quando algum atributo de sheet

mudar de valor
                    -- attribute possui o nome do atributo que sofreu

alteração
              end;

Objeto NodeTransaction

  Este objeto representa uma transação em um NodeDatabase, um mecanismo que dá maior controle
  ao programador sobre as mudanças locais.

  Uma Transação é um objeto que armazena localmente todas as mudança realizadas em um
  NodeDatabase para que você possa decidir, mais tarde, se quer descartá-las ou confirmá-las.

Como instanciar um NodeTransaction

            É possível instanciar um NodeTransaction através do método ndb.newTransaction

Observação importante:

  Apenas criar um NodeTransaction não faz com que os dados sejam controlados. É preciso também
  utilizar os métodos ndb.pushTransaction e ndb.popTransaction para isso.

Características

  O objeto NodeTransaction possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                                   Descrição

Métodos                         Descrição
   Nome do método
   transaction:commit()         Confirma as mudanças que estavam
                                armazenadas localmente.

                                Ao realizar Commit, os dados serão salvos
                                em arquivo/Servidor RRPG e
                                compartilhados com os demais usuários.
transaction:rollback()            Desfaz as mudanças que estavam
transaction:createUndoData()      armazenadas localmente.

transaction:applyUndoData(undoDa  Cria um objeto NodeUndoData que contem
ta)                               as instruções necessário para desfazer todas
                                  as mudanças que estão armazenadas
                                  localmente.

                                  Você pode, então, depois, decidir se deseja
                                  desfazer as mudanças guardadas utilizando
                                  o método transaction:applyUndoData

                                  Observações:

                                            ● Armazenar o NodeUndoData é
                                                 uma ótima forma de criar
                                                 recursos parecidos com o
                                                 famoso "ctrl+z"

                                            ● Esta função deve ser chamada
                                                 antes de invocar "commit" para
                                                 ter o efeito esperado.

                                  Aplica as instruções de um objeto
                                  NodeUndoData para desfazer mudanças
                                  previamente feitas.

                                  Parâmetros:

                                            ● undoData - O objeto
                                                 NodeUndoData que contém o
                                                 material/instruções para
                                                 desfazer mudanças, criado
                                                 previamente pela função
                                                 transaction:createUndoData()

                                  Observações:

                                            ● Após invocar este método, ainda
                                                 é necessário invocar "commit"
                                                 para que os dados sejam de fato
                                                 desfeitos

                                            ● Materiais de undo devem ser
                                                 aplicados na ordem reversa que
                                                 ocorreram e apenas uma vez.
                                                 Desfazer mudanças fora de
                                                 ordem ou mais de uma vez leva a
                                                 um comportamento indefinido

Exemplos
Exemplo 1 - Exemplo de uso do Transaction

              local tr1 = ndb.newTransaction(sheet);
              local tr2 = ndb.newTransaction(sheet);

              sheet.nome = "Maria"; -- Mudança 1

              ndb.pushTransaction(sheet, tr1);
              sheet.idade = 20; -- Mudança 2

              ndb.pushTransaction(sheet, tr2);
              sheet.nome = "Ana"; -- Mudança 3
              ndb.popTransaction(sheet);

              sheet.altura = "1.60m"; -- Mudança 4
              ndb.popTransaction(sheet);

              tr2:rollback();

              --[[
                      Ao final da execução:
                      * Mudança 1 -
                             Será salva e compartilhada com todos, pois foi

              realizada fora de qualquer transação.

                      * Mudanças 2 e 4 -
                             Será mantida APENAS localmente e ninguém mais

              enxergará as mudanças, pois foram feitas na transação "tr1" e
              esta não recebeu nem commit e nem rollback.

                             Esta mudança local existirá enquanto o objeto "tr1"
              existir. Quando ele for destruído pelo coletor de lixo do Lua,
              as mudanças serão desfeitas.

                      * Mudança 3 -
                             Será desfeita pois foi realizada na transação "tr2" e

              ela recebeu uma chamada de "rollback"
              ]]--
Exemplo 2 - Perguntando ao usuário se ele deseja salvar mudanças feitas

                        local tr = ndb.newTransaction(sheet);

                        ndb.pushTransaction(sheet, tr);
                        sheet.nome = "maria";
                        sheet.idade = 20;
                        sheet.altura = "1.60m"
                        ndb.popTransaction(sheet);

                        dialogs.confirmYesNo("Deseja salvar as alterações?",
                               function(resposta)
                                      if resposta then
                                              tr:commit();
                                      else
                                              tr:rollback();
                                      end;
                               end);

Objeto NodeUndoData

  Este objeto representa um material de "desfazer" de um NodeDatabase, uma estrutura que permite
  criar mecanismos parecidos com o famoso "ctrl+z"

  NodeUndoData armazena internamente as informações necessárias para desfazer alguma
  mudança no NodeDatabase.

  Para aplicar o material de "desfazer", você pode invocar o método transaction:applyUndoData
  passando o objeto NodeUndoData.

Como instanciar um NodeUndoData

            É possível instanciar um NodeUndoData através do método transaction:createUndoData

Características

  O objeto NodeUndoData possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                                Descrição
Métodos            Descrição
   Nome do método

Exemplos
```
