# Biblioteca utils

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca Utils

       A biblioteca gui provê funções relacionadas às interfaces Lua Form.
       Todas as funções estão contidas na unidade "utils.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "utils.lua"
    require("utils.lua");
    -- Agora é possível acessar as funções da biblioteca
    Utils.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);
    FUNCAO_DA_BIBLIOTECA2(Parametro1, Parametro2, ...);

Funções da biblioteca utils

function clearInterval(intervalId)
ou
function Utils.clearInterval(intervalId)

   Cancela o temporizador que setInterval havia previamente configurado.
   Parâmetros:

                             ○ intervalId - O identificador retornado pela função setInterval.

function clearTimeout(timeoutId)
ou
function Utils.clearTimeout(timeoutId)

   Cancela o temporizador que setTimeout havia previamente configurado.
   Parâmetros:

                             ○ timeoutId - O identificador retornado pela função setTimeout.

function Utils.compareStringPtBr(strLeft, strRight)

   Realiza comparação entre duas cadeias de caracteres de forma case-insensitive e ignorando
   acentuações

   Retorna:

                             ○ Número menor que 0 se strLeft for lexicograficamente menor que
                                  strRight

                             ○ 0 se strLeft for lexicograficamente igual a strRight
                             ○ Número maior que 0 se strLeft for lexicograficamente maior que

                                  strRight

function lowercase(str)

Converte e retorna um string em caixa baixa (lower case)
Parâmetros:

                         ○ str - a cadeia de caracteres que deseja converter para caixa baixa.

Retorno:

          ○ uma cadeia de caracteres

function uppercase(str)

Converte e retorna um string em caixa alta (upper case)
Parâmetros:

                         ○ str - a cadeia de caracteres que deseja converter para caixa alta.

Retorno:
                             ○ uma cadeia de caracteres

function Utils.generateUniqueString()

   Gera e retorna uma cadeia de caracteres globalmente única, isto é, um texto que nunca mais
   será gerado novamente por esta função
   Retorno:

                             ○ Uma cadeia de caracteres única, ótima para ser usada como
                                  identificador.

function isnumber(value)
ou
function isNumber(value)

   Retorna true se o parâmetro "value" for um número, senão retorna false.

function round(value)

   Arredonda "value" para o numero inteiro mais próximo e o retorna.

function removerAcentos(str)
ou
function Utils.removerAcentos(str)

   Retorna o texto passado em "str" sem sua acentuação.

function Utils.removerFmtChat(str[, removerSmileys])

   Retorna o texto passado em "str" sem os caracteres de formatação de cores/negrito/itálico que
   o RRPG aceita no chat.
   Parâmetros:

                             ○ str - Cadeia de caracteres contendo o texto a ser processado
                             ○ (OPCIONAL) removerSmileys - Booleano indicando se deve remover os

                                  smileys/memes do texto também. Se omitido, o valor padrão é false.
   Retorno:

                             ○ Cadeia de caracteres sem as tags de formatação.
function setInterval(callbackFunction, interval [, parametersToCallbackFunction])
ou
function Utils.setInterval(callbackFunction, interval [, parametersToCallbackFunction])

   setInterval chama uma função qualquer após em intervalos de tempo especificado em
   milisegundos.

   Parâmetros:

                             ○ callbackFunction - A função que será chamada no intervalo definido.
                             ○ interval - O intervalo de tempo em milisegundos que callbackFunction

                                  será chamada.
                             ○ (OPCIONAL) parametersToCallbackFunction - Uma lista de

                                  parâmetros que serão repassados para a callbackFunction quando ela
                                  for chamada.

   Retorno:

                             ○ Retorna um valor que poderá ser usado na função clearInterval para
                                  cancelar o setInterval.

   Observações:

                             ○ A função "callbackFunction" é executada inúmeras vezes até que algum
                                  dos seguintes eventos aconteça:
                                                  ■ O plug-in seja descarregado.
                                                  ■ A função clearInterval seja executada passando em seu
                                                       parâmetro o valor retornado por setInterval.
                                                  ■ A função informada em "callbackFunction" retorne
                                                       explicitamente false.

                             ○ Se você deseja executar "callbackFunction" apenas uma vez após um
                                  determinado tempo, use a função setTimeout.

function setTimeout(callbackFunction, interval [, parametersToCallbackFunction])
ou
function Utils.setTimeout(callbackFunction, interval [,
parametersToCallbackFunction])

   setTimeout chama uma função qualquer após uma quantidade específica de milisegundos se
   passarem.

   Parâmetros:

                             ○ callbackFunction - A função que será chamada.
                             ○ interval - O tempo de espera até que a função seja chamada, em

                                  milisegundos.
Retorno:      ○ (OPCIONAL) parametersToCallbackFunction - Uma lista de
Observações:       parâmetros que serão repassados para a callbackFunction quando ela
                   for chamada.

              ○ Retorna um valor que poderá ser usado na função clearTimeout para
                   prevenir a função "callbackFunction" de ser chamada.

              ○ A função "callbackFunction" é executada somente 1 vez. Se você
                   precisar que ela seja chamada constantemente, use a função setInterval

function Utils.sortPtBrArray(array)

   Dado um array de strings (uma tabela lua indexada de 1 a n), ordena os valores
   lexicograficamente de forma case insensitive e ignorando acentuações.
   Retorno:

                             ○ Não há retorno. O próprio array estará ordenado no fim desta função.

function totable(str)
ou
function strToTable(str)
ou
function Utils.strToTable(str)

   Converte o texto passado em "str" para uma tabela lua. O texto deve seguir o mesmo padrão
   que você usa ao declarar uma tabela lua quando está programando.
   Exemplo: "{nome='joão', idade=10, filhos={}}"

function tableToStr(table [, pretty])
ou
function Utils.tableToStr(table [, pretty])

Converte uma tabela LUA para string.

Parâmetros:

                         ○ table - a tabela lua que deseja converter para texto
                         ○ (OPCIONAL) pretty - se true, converte para um texto legível... Se

                               omitido ou se false, converte para um texto que ocupa o menor espaço
                               o possível.
Retorno:

          ○ Uma cadeia de caracteres que corresponde à tabela.

function Utils.binaryEncode(destArray, format, value [, startIndex])

Codifica um determinado valor em um formato binário.

Parâmetros:

                         ○ destArray - Uma tabela lua que receberá os BYTES da codificação
                               binária.

                         ○ format - Uma cadeia de caracteres identificando qual o formato binário
                               deve ser utilizado. Veja Formatos Binários para saber quais são os
                               formatos disponíveis.

                         ○ value - O valor que será codificado.
                         ○ (OPCIONAL) startIndex - Um número identificando em qual posição de

                               "destArray" os bytes devem ser escritos. Se omitido, o valor 1 será
                               utilizado.

Retorno:

                         ○ Um número contendo quantos bytes foram inseridos em destArray.

Observações:

                         ○ Cada BYTE da representação binária é colocado em uma posição de
                               "destArray". Se um determinado formato binário ocupar 4 bytes, após a
                               chamada da função destArray[1] conterá o valor do primeiro byte,
                               destArray[2] o valor do segundo byte, destArray[3] o valor do terceiro
                               byte e destArray[4] o valor do quarto byte.

Formatos Binários:

Formato   Qt  Descrição

          d.

          de

          By

          te

          s

"u8"      1   Um número entre 0 e 255 codificado

              como Unsigned Integer de 8 Bits

              (também conhecido como Byte)

"s8"      1   Um número entre -128 a 127

              codificado como Signed Integer de 8

              Bits.

"u16"     2   Um número entre 0 e 65535

              codificado como Unsigned Integer de
               16 bits (Também conhecido como
               Word) no padrão LittleEndian.

"s16"     2    Um número entre -32768 e 32767
"u32"
               codificado como Signed Integer de 16
"s32"
               bits no padrão LittleEndian.
"u64"
"s64"     4    Um número entre 0 e 4294967295
"float"
"double"       codificado como Unsigned Integer de
"ansi"
"utf8"         32 bits (Também conhecido como
"utf16"
               DoubleWord) no padrão

               LittleEndian.

          4    Um número entre -2147483648 e

               2147483647 codificado como Signed

               Integer de 32 bits no padrão

               LittleEndian

          8    Um número entre 0 e (2^64) - 1

               codificado como Unsigned Integer de

               64 bits (Também conhecido como

               QuadWord) no padrão LittleEndian

          8    Um número entre -2^63 a (2^63) - 1

               codificado como Signed Integer de 64

               bits no padrão LittleEndian.

          4    Um número de ponto flutuante de 4

               bytes no padrão IEEE 754.

          8    Um número de ponto flutuante de 8

               bytes no padrão IEEE 754.

          Va   Uma cadeia de caracteres codificada

          ria  em ANSI sem o terminador nulo.

          Va   Uma cadeia de caracteres codificada

          ria  em UTF-8 sem o terminador nulo.

          Va   Uma cadeia de caracteres codificada

          ria  em UTF-16 sem o terminador nulo.
function Utils.binaryDecode(sourceArray, format [, startIndex [, length]])

   Interpreta um valor que está codificado em um formato binário.

   Parâmetros:

                             ○ sourceArray - Uma tabela lua que contém os BYTES da codificação
                                  binária.

                             ○ format - Uma cadeia de caracteres identificando em qual formato
                                  binário o valor está codificado. Veja Formatos Binários para saber quais
                                  são.

                             ○ (OPCIONAL) startIndex - Um número identificando a partir de qual
                                  posição de "sourceArray" os bytes devem ser lidos para a decodificação.
                                  Se omitido, o valor 1 será utilizado.

                             ○ (OPCIONAL) length - Quantos bytes à partir de "startIndex" devem ser
                                  usados para a decodificação. Se omitido, o valor (#sourceArray -
                                  startIndex + 1) será utilizado.

   Retorno:

                             ○ A função retorna 2 valores:
                                                  ■ O valor decodificado ou nil se não foi possível
                                                       decodificar
                                                  ■ A quantidade de bytes usados para a decodificação do
                                                       valor.

   Observações:

                             ○ Cada BYTE da representação binária deve estar em uma posição de
                                  "sourceArray". Se um determinado formato binário ocupar 4 bytes,
                                  sourceArray[1] deve conter o valor do primeiro byte, sourceArray[2] o
                                  valor do segundo byte, sourceArray[3] o valor do terceiro byte e
                                  sourceArray[4] o valor do quarto byte.

function Utils.getBinarySize(format)

  Retorna quantos bytes um determinado formato binário ocupa.

  Parâmetros:

                             ○ format - Uma cadeia de caracteres identificando o formato binário que
                                  deseja consultar. Veja Formatos Binários para saber quais são.

   Retorno:

                             ○ Um número identificando a quantidade de bytes um determinado
                                  formato binário ocupa. Se um formato binário ocupar uma quantidade
                                  variada de bytes, o valor -1 é retornado.
function Utils.zlibCompress(sourceStream, destStream, [, level [, qtBytesInSource]])

  Lê dados de um objeto stream fonte e, usando a biblioteca zLib, o compacta escrevendo o
  resultado em outro objeto stream.

  Parâmetros:

                             ○ sourceStream - Um objeto stream representando os dados a serem
                                  compactados.

                             ○ destStream - Um objeto stream que receberá o conteúdo compactado.
                             ○ (OPCIONAL) level - Define o nível da compactação. Pode ser

                                                  ■ "none" - Não haverá compactação no final das contas
                                                  ■ "fastest" - Compactação rápida
                                                  ■ "default" - Modo em que balanceia velocidade e taxa de

                                                       compressão. Este é o modo padrão quando não for
                                                       definido o nível.
                                                  ■ "max" - Modo com maior taxa de compressão.
                             ○ (OPCIONAL) qtBytesInSource - Quantos bytes serão lidos de
                                  "sourceStream" à partir de sua posição atual para a compactação.
                                  Quando não definido, todo o restante do sourceStream será lido para a
                                  compactação.

   Retorno:

                             ○ Um número identificando quantos bytes foram escritos em destStream

function Utils.zlibDecompress(sourceStream, destStream)

  Lê dados de um objeto stream fonte e, usando o a biblioteca zLib, o descompacta escrevendo o
  resultado em outro objeto stream.

  Parâmetros:

                             ○ sourceStream - Um objeto stream contendo os dados a serem
                                  descompactados.

                             ○ destStream - Um objeto stream que receberá o conteúdo
                                  descompactado.

   Observações:

                             ○ Esta função descompacta um "bloco compactado" por completo. Não
                                  tem como antecipar quantos bytes serão lidos de "sourceStream" nem
                                  quantos bytes serão escritos em "destStream" utilizando esta função.
                                  No fim da chamada, destStream conterá todo o dado descompactado e
                                  a posição de "sourceStream" apontará para o primeiro byte
                                  subsequente do conteúdo que foi processado.

   Retorno:

                             ○ Um número identificando quantos bytes foram escritos em destStream
function Utils.zlibCompressAsync(sourceStream, destStream, level, qtBytesInSource, onFinishCallbac
onErrorCallback)

  Lê dados de um objeto stream fonte e, usando a biblioteca zLib, o compacta escrevendo o
  resultado em outro objeto stream.

  A compactação se dá de forma assíncrona, isto é, em "background". Ótimo para compactar
  streams grandes e não "congelar" o programa durante o processo.

  Parâmetros:

                             ○ sourceStream - Um objeto stream representando os dados a serem
                                  compactados.

                             ○ destStream - Um objeto stream que receberá o conteúdo compactado.
                             ○ level - Define o nível da compactação. Pode ser

                                                  ■ "none" - Não haverá compactação no final das contas
                                                  ■ "fastest" - Compactação rápida
                                                  ■ "default" - Modo em que balanceia velocidade e taxa de

                                                       compressão. Este é o modo padrão quando não for
                                                       definido o nível.
                                                  ■ "max" - Modo com maior taxa de compressão.
                             ○ qtBytesInSource - Quantos bytes serão lidos de "sourceStream" à
                                  partir de sua posição atual para a compactação.
                             ○ onFinishCallback - Uma função que será invocada quando a
                                  compactação finalizar.
                             ○ onErrorCallback - Uma função que será invocada quando a
                                  compactação retornar um erro. A mensagem de erro é passada no
                                  primeiro parâmetro desta função.

   Observações:

                             ○ IMPORTANTE: Durante a compactação assíncrona, seu código não
                                  deve fazer nenhuma operação em sourceStream e nem em destStream,
                                  senão o planeta explodirá e 2d6 erros estranhos surgirão.

function Utils.zlibDecompressAsync(sourceStream, destStream, onFinishCallback, onErrorCallback)

  Lê dados de um objeto stream fonte e, usando o a biblioteca zLib, o descompacta escrevendo o
  resultado em outro objeto stream.

  A descompactação se dá de forma assíncrona, isto é, em "background". Ótimo para
  descompactar streams grandes e não "congelar" o programa durante o processo.

  Parâmetros:

                             ○ sourceStream - Um objeto stream contendo os dados a serem
                                  descompactados.

                             ○ destStream - Um objeto stream que receberá o conteúdo
                                  descompactado.
Observações:  ○ onFinishCallback - Uma função que será invocada quando a
                   descompactação finalizar.

              ○ onErrorCallback - Uma função que será invocada quando a
                   descompactação retornar um erro. A mensagem de erro é passada no
                   primeiro parâmetro desta função.

              ○ Esta função descompacta um "bloco compactado" por completo. Não
                   tem como antecipar quantos bytes serão lidos de "sourceStream" nem
                   quantos bytes serão escritos em "destStream" utilizando esta função.
                   No fim da chamada, destStream conterá todo o dado descompactado e
                   a posição de "sourceStream" apontará para o primeiro byte
                   subsequente do conteúdo que foi processado.

              ○ IMPORTANTE: Durante a descompactação assíncrona, seu código não
                   deve fazer nenhuma operação em sourceStream e nem em destStream,
                   senão o planeta explodirá e 2d6 erros estranhos surgirão.

function Utils.newMemoryStream()

  Cria e retorna um objeto stream que armazena os dados na memória RAM do dispositivo.

   Observações:

                             ○ Os dados armazenados no Memory Stream não são salvos em nenhum
                                  lugar e são perdidos quando o código não mais estiver usando o Stream
                                  ou quando o RRPG fechar.

                             ○ Ótimo para fazer processamento de dados temporários.
                             ○ Enquanto estiver em uso, os dados ocupam memória RAM do

                                  dispositivo.

   Retorno:

                             ○ Um objeto stream

function Utils.newTempFileStream()

Cria e retorna um objeto stream que armazena os dados em um arquivo temporário no
dispositivo do usuário.

 Observações:

                           ○ Um arquivo temporário é criado no dispositivo do usuário e é
                                automaticamente apagado quando não for mais utilizado.

                           ○ Ótimo para fazer processamento de dados temporários.
                           ○ Enquanto estiver em uso, os dados ocupam espaço de armazenamento

                                do dispositivo (HD, SSD, Memory Card, etc..).

 Retorno:

                           ○ Um objeto stream
function tryFinally(tryCallback, finallyCallback)
ou
function Utils.tryFinally(tryCallback, finallyCallback)

  LUA não possui um operador try-finally para tratamento de exceções. Esta função é uma
  alternativa para o comportamento try-finally que o LUA não provê nativamente.
  Executa a função "tryCallback", e:

                             ○ Se ocorrer algum erro na execução, a função "finallyCallback" é
                                  invocada e o erro é levantado logo após.

                             ○ Se não ocorrer erro na execução, a função "finallyCallback" é invocada e
                                  a execução continua normalmente.

   Parâmetros:
                             ○ tryCallback - Uma função que será invocada.
                             ○ finallyCallback - Uma função que sempre será invocada após a
                                  execução de "tryCallback", mesmo havendo erros de execução.

function colorToRGBA(color)
ou
function Utils.colorToRGBA(color)

  Dado uma cor no formato string de cor, retorna os tons de Red, Green, Blue e Alpha da cor
   Parâmetros:

                             ○ Color - um string de cor contendo a cor que deseja decompor
   Retorno:

                             ○ 4 números representando, respectivamente os tons de Red, Green,
                                  Blue e Alpha da cor. Os tons são números entre 0.0 e 1.0

function RGBAToColor(r, g, b, a)
ou
function Utils.RGBAToColor(r, g, b, a)

  Dado tons de cores Red, Green, Blue e Alpha, retorna um string de cor que representa a cor.
  Parâmetros:

                             ○ r - Tom de Red, número entre 0.0 e 1.0
                             ○ g - Tom de Green, número entre 0.0 e 1.0
                             ○ b - Tom de Blue, número entre 0.0 e 1.0
Retorno:                  ○ a - Tom de Alpha, número entre 0.0 e 1.0. Se omitido, o valor é
                               considerado 1.0

                          ○ Um string de cor

Objeto Stream

  Um objeto stream contém uma sequência de dados genéricos, possui um início e um fim e você
  estará sempre em algum lugar entre estes dois pontos.

  Usando stream, você pode ler e/ou escrever em vários tipos de armazenamentos, como um arquivo,
  uma memória dinâmica, etc..

  Um stream representa uma sequência de BYTES que podem ser acessadas de forma sequencial ou
  aleatória (isto é, você pode ler o inicio de um stream, pular para seu final para ler mais dados, voltar
  ao meio do stream, etc..)

  Exemplos de operações típicas em um stream:

                                 ○ Ler 1 byte. Da próxima vez que você ler, você obterá o byte posterior, e
                                      assim por diante.

                                 ○ Ler vários bytes
                                 ○ Mover a posição atual do cursor no stream para, da próxima vez que

                                      você ler, obter os bytes à partir desta nova posição.
                                 ○ Escrever 1 byte.
                                 ○ Escrever vários bytes.

Formas de instanciar um objeto stream

  Existem várias maneiras de obter um objeto stream. Algumas delas são:

                                 ○ Criar um stream temporário que reside na memória RAM através da
                                      função utils.newMemoryStream

                                 ○ Criar um stream temporário que reside no HD do dispositivo através da
                                      função utils.newTempFileStream

                                 ○ Abrir ou criar um arquivo no HD virtual usando a função vhd.openFile
                                 ○ Baixar um conteúdo da internet através da função internet.download
                                 ○ Realizar uma requisição HTTP e obter a resposta através da

                                      propriedade responseStream do objeto HTTPRequest

Características

Propriedades e atributos

Propriedade               Tipo     Descrição

size                      Integer  Contém o tamanho atual
                                   do stream em quantidade
position        Integer             de bytes.

remainingBytes  Integer             A posição do cursor do
md5             String              stream.

sha1            String              onde o valor 0 representa
                                    o primeiro byte do stream.

                                    Todas as operações de
                                    leitura e escrita são feitas
                                    nesta posição.

                                    Quantos bytes ainda
                                    podem ser lidos no stream
                                    à partir da posição atual.

                                    Uma cadeia de caracteres
                                    contendo o Hash MD5 de
                                    todo o conteúdo do
                                    stream. O Hash é
                                    calculado na hora de obter
                                    o valor da propriedade.

                                    Uma cadeia de caracteres
                                    contendo o Hash SHA1 de
                                    todo o conteúdo do
                                    stream. O Hash é
                                    calculado na hora de obter
                                    o valor da propriedade.

Métodos                             Descrição
   Método
   stream:read(destArray, qtBytes)  Efetua a leitura de bytes à partir da position
                                    atual do stream.

                                    Parâmetros:

                                                                   ○ destArray - Uma
                                                                        tabela lua que
                                                                        receberá os bytes
                                                                        lidos do stream. Os
                                                                        valores são
                                                                        armazenados em
                                                                        índices de 1 a N,
                                                                        onde N =
                                                                        quantidade de
                                                                        bytes lidos.
                             Retorno:     ○ qtBytes - Um
                             Importante:       número contendo
                                               a quantidade de
                                               bytes que devem
                                               ser lidos à partir
                                               desta posição.

                                          ○ Um número
                                               contendo quantos
                                               bytes realmente
                                               foram lidos do
                                               stream e
                                               preenchidos em
                                               destArray

                                          ○ A position do
                                               stream é avançada
                                               automaticamente
                                               após a chamada
                                               desta função
                                               conforme a
                                               quantidade de
                                               bytes lidos.

                                          ○ Nem sempre é
                                               possível ler a
                                               quantidade de
                                               bytes informada
                                               no parâmetro
                                               qtBytes. Você
                                               DEVE analisar o
                                               número retornado
                                               pela função a fim
                                               de saber quantos
                                               bytes realmente
                                               foram lidos.

stream:write(sourceArray [,  Efetua a escrita de bytes na position atual do
qtBytes])                    stream.

                             Parâmetros:

                                                            ○ sourceArray - Uma
                                                                 tabela lua que
                                                                 contém os bytes
                                                                 que devem ser
                                                                 escritos no stream.
                                                                 Os valores devem
                                                                 estar armazenados
                                                                 em índices de 1 a
Retorno:          N, onde N =
Importante:       quantidade de
                  bytes que serão
                  escritos.
             ○ (OPCIONAL)
                  qtBytes - Quantos
                  bytes do
                  sourceArray
                  devem ser escritos
                  no stream. Se
                  omitido, o length
                  do array
                  (#sourceArray)
                  será usado.

             ○ Um número
                  contendo quantos
                  bytes realmente
                  foram escritos no
                  stream.

             ○ A position do
                  stream é avançada
                  automaticamente
                  após a chamada
                  desta função
                  conforme a
                  quantidade de
                  bytes escritos.

             ○ Os valores em
                  sourceArray
                  devem ser
                  números! Para
                  cada valor em
                  sourceArray, se for
                  menor que 0, o
                  byte 0 será
                  gravado e se for
                  maior que 255, o
                  byte 255 será
                  gravado. Se em
                  algum dos índices
                  de sourceArray
                  não contiver um
                  número válido, o
                  byte 0 é escrito no
                  stream.
stream:close()                        Fecha o stream imediatamente e libera os
stream:writeBinary(format, valor1     recursos que foram previamente alocados.
[, valor2 [, valor3 [, valorN...]]])
                                      Após esta chamada, nenhuma operação do
stream:readBinary(format [, qt])      stream estará mais disponível.

                                      Escreve um valor codificado em binário na
                                      posição atual do stream.

                                      Parâmetros:

                                                                     ○ format - Cadeia de
                                                                          caracteres
                                                                          identificando qual
                                                                          formatação binária
                                                                          deve ser usada.
                                                                          Veja Formatos
                                                                          Binários para
                                                                          saber quais são os
                                                                          possíveis
                                                                          formatos.

                                                                     ○ valor1 - O valor a
                                                                          ser codificado e
                                                                          escrito

                                                                     ○ (OPCIONAL)
                                                                          valor2, valor3,
                                                                          valorN, etc... -
                                                                          Outros valores
                                                                          que também
                                                                          devem ser
                                                                          codificados e
                                                                          escritos no stream.

                                      Retorno:

                                                                     ○ Um número
                                                                          contendo quantos
                                                                          bytes foram
                                                                          escritos no stream.

                                      Importante:

                                                                     ○ A position do
                                                                          stream é avançada
                                                                          automaticamente
                                                                          após a chamada
                                                                          desta função
                                                                          conforme a
                                                                          quantidade de
                                                                          bytes escritos.

                                      Efetua a leitura de valores codificados em
binário na posição atual do stream.

Parâmetros:

                               ○ format - Cadeia de
                                    caracteres
                                    identificando em
                                    qual formatação
                                    binária o valor está
                                    codificado. Veja
                                    Formatos Binários
                                    para saber quais
                                    são os possíveis
                                    formatos.

                               ○ (OPCIONAL) qt -
                                    Um número
                                    identificando
                                    QUANTOS valores
                                    codificados devem
                                    ser lidos. Se
                                    omitido, o valor 1
                                    será utilizado.

Retorno:

                               ○ Retorna os valores
                                    decodificados ou
                                    nil se não foi
                                    possível
                                    decodificar.

Importante:

                               ○ A position do
                                    stream é avançada
                                    automaticamente
                                    após a chamada
                                    desta função
                                    conforme a
                                    quantidade de
                                    bytes lidos

                               ○ Se especificado os
                                    formatos "ansi',
                                    "utf8" ou "utf16",
                                    todo o restando do
                                    stream é lido como
                                    uma cadeia de
                                    caracteres e o
                                    parâmetro "qt" é
                                    ignorado como se
                                    o valor 1 tivesse
                                    sido passado para
stream:readAsBase64([qtBytes])                                        ele.
stream:writeBase64(str)
stream:copyFrom(stream, qtBytes)  Lê bytes do stream e retorna uma cadeia de
                                  caracteres representando os dados
                                  codificados em Base64.

                                  Parâmetros:

                                                                 ○ (OPCIONAL)
                                                                      qtBytes - Um
                                                                      número definindo
                                                                      quantos bytes do
                                                                      stream devem ser
                                                                      lidos à partir da
                                                                      posição atual e
                                                                      codificados. Se
                                                                      omitido, o restante
                                                                      dos dados do
                                                                      stream será lido.

                                  Retorno:

                                                                 ○ Uma cadeia de
                                                                      caracteres
                                                                      representando os
                                                                      dados codificados
                                                                      em Base64

                                  Decodifica dados previamente codificados em
                                  Base64 e os escreve na posição atual do
                                  stream.

                                  Parâmetros:

                                                                 ○ str - Uma cadeia de
                                                                      caracteres
                                                                      contendo os dados
                                                                      codificados em
                                                                      Base64.

                                  Retorno:

                                                                 ○ Um número
                                                                      contendo quantos
                                                                      bytes foram
                                                                      escritos no
                                                                      Stream.

                                  Copia o conteúdo de um outro objeto stream
                                  dentro deste stream.

                                  Parâmetros:
                   Retorno:  ○ stream - um objeto
                                  stream de onde os
                                  dados serão
                                  copiados.

                             ○ qtBytes - um
                                  número
                                  representando
                                  quantos bytes
                                  serão copiados à
                                  partir da posição
                                  atual do
                                  parâmetro
                                  "stream".

                             ○ Um número
                                  contendo quantos
                                  bytes realmente
                                  foram copiados
                                  para este stream.

Exemplos
Exemplo 1 - .....
```
