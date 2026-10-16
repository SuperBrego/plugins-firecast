# Biblioteca internet

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca Internet

       Biblioteca que contém funções relacionadas à internet/intranet, como: downloads, requisições
       HTTP, etc..
       Todas as funções estão contidas na unidade "internet.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "internet.lua"
    require("internet.lua");

    -- Agora é possível acessar as funções da biblioteca
    Internet.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca Internet

    function Internet.asyncDownload(url[, cacheMode[, progressCallback]])

Asynchronously downloads a file from the internet.

Arguments:

                         ○ url - String containing the URL address of the file, like
                               "http://www.website.com/directory/file.png".

         ○ (Optional) cacheMode - One of the following strings:
                             ■ "alwaysUseCache" - If the file already exists in the
                                  cache, Firecast will return the content without even
                                  communicating with the internet. This is the default

                                  mode.
                             ■ "checkForModification" - If the file already exists in the

                                  cache, Firecast will check the remote server for changes

                                  to the content before deciding to use the local cache or

                                  download the content.
                             ■ "alwaysDownload" - Firecast will not use the local

                                  cache and will always download content from the

                                  remote server.

         ○ (Optional) progressCallback - A function that will be called multiple
              times to report the download progress. This function takes 2

              parameters:
                             ■ downloadedBytes - How many bytes have already been
                                  downloaded.
                             ■ totalBytes - How many bytes the file has in total.

Return:
Remarks:  ○ A Promise for two pieces of information in the following order:
Example:                      ■ A Stream object with the downloaded file content.
                              ■ A String containing the content type / mime type of the
                                   downloaded file, like 'image/png', 'text/html', and so on

          ○ Internet URL addresses must start with "http://" or "https://".
          ○ File addresses that are located inside the VHD (plugin's virtual HD) are

               also accepted.
          ○ If you explicitly return false in a progressCallback call, the download

               will be aborted.
          ○ The download process is queued in the Firecast download manager and

               therefore the download may experience a wait before actually starting.

local promise =
Internet.asyncDownload("https://www.address.com/file.txt");

local stream, contentType = await(promise);

showMessage(contentType .. ": " .. tostring(stream.size));

function Internet.download(url [, finishCallback [, errorCallback [, progressCallback [,

cacheMode]]]])

   Realiza o download de um arquivo da internet.

   Parâmetros:

                             ○ url - Cadeia de caracteres contendo a URL do arquivo (Exemplo:
                                  http://www.site.com.br/pasta/arquivo.png).
                                                  ■ URL de arquivos que estão na internet devem começar
                                                       com "http://" ou "https://"
                                                  ■ Endereços de arquivos que estão localizados no HD
                                                       virtual do plug-in também são aceitos.

                             ○ (OPCIONAL) finishCallback - Uma função que será invocada quando o
                                  download estiver terminado. Esta função recebe os seguintes 2
                                  parâmetros:
                                                  ■ stream - Um objeto Stream possuindo o conteúdo do
                                                       arquivo baixado.
                                                  ■ contentType - Uma cadeia de caracteres identificando o
                                                       MimeType/tipo do conteúdo.. Exemplos:
                                                       "application/octet-stream", "image/png", "text/html",
                                                       etc..

                             ○ (OPCIONAL) errorCallback - Uma função que será invocada se ocorrer
                                  algum erro no download. A Mensagem de erro é passada no primeiro
Retorno:           parâmetro desta função.
Observações:
              ○ (OPCIONAL) progressCallback - Uma função que será invocada várias
Exemplo 1:         vezes para informar o progresso do download. Esta função recebe 2
                   parâmetros:
                                  ■ downloadedBytes - Quantos bytes já foram baixados.
                                  ■ totalBytes - Quantos bytes o arquivo possui no total.

              ○ (OPCIONAL) cacheMode - Pode ser passado um dos seguintes valores
                   e significados:
                                  ■ "alwaysUseCache" - Se o arquivo já existir no cache, o
                                       Firecast irá retornar o conteúdo sem mesmo se
                                       comunicar com a internet. Este é o modo padrão.
                                  ■ "checkForModification" - Se o arquivo já existir no
                                       cache, o Firecast irá verificar no servidor remoto se
                                       houve alterações no conteúdo antes de decidir usar o
                                       cache local ou baixar o conteúdo.
                                  ■ "alwaysDownload" - O Firecast não usará o cache local
                                       e sempre baixará o conteúdo do servidor remoto.

              ○ A função retorna um identificador de download. Este valor pode ser
                   utilizado para invocar o método Internet.stopDownload caso queira
                   abortar o download.

              ○ A função não espera o download terminar e continua a execução do
                   código enquanto o download é feito em paralelo.

              ○ Para ter acesso ao conteúdo baixado, utilize o parâmetro
                   finishCallback.

              ○ Invocar esta função faz com que a URL seja enfileirada no gerenciador
                   de downloads do Firecast, e, portanto, o download pode passar por uma
                   espera antes de realmente começar.

              ○ Retornar explicitamente "false" na função progressCallback faz com
                   que o download seja abortado.

              ○ Este método utiliza um sistema de cache de arquivos para evitar usar a
                   internet com arquivos que já foram recentemente baixados.

              ○ Se o arquivo estiver pronto no sistema de cache de arquivos, a função
                   "finishCallback" poderá ser invocada imediatamente, antes mesmo da
                   função "Internet.download" retornar.

              ○ Este método, quando possível, faz "resume", isto é, ele consegue fazer
                   download à partir de um ponto que havia parado recentemente.
                  Internet.download("http://www.rrpg.com.br/
                  arquivo.png",

                                function(stream, contentType)
                                               -- esta função será chamada

                  quando o download terminar
                                               -- o conteúdo do arquivo baixado

                  está em stream.
                                end,

                                function (errorMsg)
                                               -- esta função será chamada

                  quando ocorrer algum erro no download.
                                               -- errorMsg possui a msg de erro

                                end,

                                function (downloaded, total)
                                               -- esta função será chamada

                  constantemente.
                                               -- dividir "downloaded" por

                  "total" lhe dará uma porcentagem do download.
                                end);

Exemplo 2 - checkForModification

                  Internet.download("http://www.rrpg.com.br/
                  arquivo.png",

                                function(stream, contentType)
                                               -- esta função será chamada

                  quando o download terminar
                                               -- o conteúdo do arquivo baixado

                  está em stream.
                                end,

                                function (errorMsg)
                                               -- esta função será chamada

                  quando ocorrer algum erro no download.
                                               -- errorMsg possui a msg de erro

                                end,
                                     function (downloaded, total)
                                                   -- esta função será chamada

                      constantemente.
                                                   -- dividir "downloaded" por

                      "total" lhe dará uma porcentagem do download.
                                     end, "checkForModification");

function Internet.stopDownload(downloadId)

   Aborta um download que foi iniciado pela função Internet.download
   Parâmetros:

                             ○ downloadId - a identificação do download a ser abortado. Este valor é
                                  retornado pela função Internet.download

function Internet.newHTTPRequest([method [, url]])

   Cria e retorna um objeto HTTPRequest, usado para troca de dados com um servidor através de
   protocolo HTTP ou HTTPS.
   Parâmetros:

                             ○ (OPCIONAL) method - Uma cadeia de caracteres identificando o
                                  método/verbo HTTP utilizado nesta requisição. Os valores aceitos são:
                                                  ■ "GET" (valor padrão, se o parâmetro for omitido)
                                                  ■ "POST"
                                                  ■ "PUT"
                                                  ■ "PATCH"
                                                  ■ "TRACE"
                                                  ■ "HEAD"
                                                  ■ "OPTIONS"
                                                  ■ "DELETE"

                             ○ (OPCIONAL) url - A URL da requisição HTTP. Este valor pode ser
                                  alterado posteriormente no objeto HTTPRequest.

   Retorno:
                             ○ Um objeto HTTPRequest representando a requisição.

   Observações:
                             ○ As requisições HTTP são permitidas se ao menos uma das seguintes
                                  afirmativas for verdadeira:
                                                  ■ O usuário atual é assinante Gold/Platinum/Ruby; ou
                                                  ■ O usuário atual está em uma mesa cujo criador é
                                                       assinante Platinum.

                             ○ Esta função apenas cria o objeto HTTPRequest e não a envia. Você deve
                                  utilizar o método "send" do objeto para, de fato, enviar a requisição.

function Internet.httpEncode(str)

   Codifica um texto para que possa ser usado como URL em requisições HTTP.
   Parâmetros:

                             ○ str - A cadeia de caracteres que deseja codificar.
   Retorno:

                             ○ Uma cadeia de caracteres contendo o texto codificado.

function Internet.httpDecode(str)

   Decodifica os caracteres/códigos de URL contidas no texto passado.
   Parâmetros:

                             ○ str - A cadeia de caracteres que deseja decodificar.
   Retorno:

                             ○ Uma cadeia de caracteres contendo o texto decodificado.

Objeto HTTPRequest

  O Objeto HTTPRequest é utilizado para a troca de dados com um servidor usando protocolo HTTP
  ou HTTPS.

  É excelente para integrar o plug-in com alguma api REST, baixar ou enviar informações para um
  servidor da World Wide Web.

  Para instanciar um Objeto HTTPRequest, utilize a função internet.newHTTPRequest

Restrições:

                          ○ As requisições HTTP são permitidas apenas se o usuário do rrpg for um
                               membro GOLD.

Características

Propriedades e atributos
Propriedade   Tipo     Descrição
url           String
                       Define a URL para onde a requisição
method        String   HTTP será direcionada.

status        Integer  Exemplo:

statusText    String             ● "http://www.google.com/
                                      xx/document.txt"
responseText  String
                                 ● "https://www.rrpg.com.br/
                                      apiexemplo"

                       A URL deve iniciar com "http://" ou
                       "https://"

                       Define o método/verbo HTTP que será
                       utilizado na requisição.

                       Os possíveis valores são:

                                 ● "GET" (padrão)
                                 ● "POST"
                                 ● "PUT"
                                 ● "PATCH"
                                 ● "TRACE"
                                 ● "HEAD"
                                 ● "OPTIONS"
                                 ● "DELETE"

                       Um número contendo o status da
                       resposta http. (Exemplos: 200 para ok,
                       404 para não encontrado, etc..)

                       Consulte
                       http://www.w3.org/Protocols/rfc2616/
                       rfc2616-sec10.html para saber quais
                       são os possíveis status.

                       Uma cadeia de caracteres contendo o
                       texto-status-resposta da requisição
                       HTTP.

                       Diferente da propriedade "status", este
                       valor contém o texto completo da
                       resposta (Exemplos: "200 OK", "404
                       NOT FOUND").

                       Contém o corpo da resposta
                       interpretada como texto.

                       O "charset" do cabeçalho de resposta
responseStream              Objeto Stream  "Content-Type" é levado em
                                           consideração antes de retornar o texto.

                                           Contém o corpo da resposta em um
                                           objeto stream. Muito útil quando a
                                           resposta dada pelo servidor for binária.

Métodos                                    Descrição
   Método
   request:send([content])                 Inicia o envio da requisição HTTP. Antes de chamar
                                           esta função, a URL e todos os cabeçalhos devem ser
                                           informados pela função setRequestHeader.

                                           Parâmetros:

                                                                          ○ (OPCIONAL) content -
                                                                               Uma cadeia de
                                                                               caracteres ou um objeto
                                                                               stream contendo os
                                                                               dados que serão
                                                                               enviado ao servidor. Se
                                                                               não informado, a
                                                                               requisição é feita com
                                                                               corpo vazio.

                                           Observações:

                                                                          ○ A requisição é
                                                                               assíncrona. Isto é, a
                                                                               função send retorna
                                                                               imediatamente e o
                                                                               código LUA continua
                                                                               sua execução normal
                                                                               enquanto a
                                                                               comunicação com o
                                                                               servidor é feita em
                                                                               segundo plano. Para
                                                                               obter a resposta,
                                                                               manipule os eventos
                                                                               onResponse e onError
                                                                               antes de chamar este
                                                                               método.

                                                                          ○ Se o parâmetro content
                                                                               for uma cadeia de
                                                                               caracteres, o "charset"
                                                                               do cabeçalho de
                                                                               requisição "Content-
                                                                               Type" é levado em
request:setRequestHeader(heade                                      consideração para a
r, value)                                                           codificação do texto.

request:getRequestHeader(heade  Altera o valor de um cabeçalho de requisição HTTP.
r)                              Você deve enviar setRequestHeader antes de
                                invocar o método send.

                                Parâmetros:

                                                               ○ header - Cadeia de
                                                                    caracteres
                                                                    representando o nome
                                                                    do cabeçalho. Exemplos:
                                                                    "Content-Type" ,
                                                                    "Content-Encoding",
                                                                    etc..

                                                               ○ value - Cadeia de
                                                                    caracteres com o valor
                                                                    que deve ser associado
                                                                    ao cabeçalho.

                                Observações:

                                                               ○ Para saber mais sobre
                                                                    os cabeçalhos HTTP,
                                                                    veja
                                                                    http://www.w3.org/Pro
                                                                    tocols/rfc2616/rfc2616
                                                                    -sec14.html.

                                                               ○ Se este método for
                                                                    chamado várias vezes
                                                                    alterando o mesmo
                                                                    cabeçalho, o valor da
                                                                    última chamada
                                                                    prevalecerá.

                                Obtém o valor de um cabeçalho de requisição HTTP.

                                Parâmetros:

                                                               ○ header - cadeia de
                                                                    caracteres
                                                                    representando o nome
                                                                    do cabeçalho.

                                Retorno:

                                                               ○ Uma cadeia de
                                                                    caracteres, contendo o
                                                                    valor do cabeçalho.
request:getResponseHeader(head   Obtém o valor de um cabeçalho de resposta da
er)                              requisição HTTP.

request:getAllResponseHeaders()  Parâmetros:
request:abort();
request:open(method, url);                                      ○ header - cadeia de
                                                                     caracteres
                                                                     representando o nome
                                                                     do cabeçalho de
                                                                     resposta.

                                 Retorno:

                                                                ○ Uma cadeia de
                                                                     caracteres, contendo o
                                                                     valor do cabeçalho, ou ""
                                                                     (cadeia de caracteres
                                                                     vazia) se o cabeçalho
                                                                     não existir na resposta.

                                                                ○ Para saber mais sobre
                                                                     os cabeçalhos HTTP,
                                                                     veja
                                                                     http://www.w3.org/Pro
                                                                     tocols/rfc2616/rfc2616
                                                                     -sec14.html.

                                 Retorna uma cadeia de caracteres contendo todos
                                 os cabeçalhos da resposta HTTP de uma só vez.

                                 Aborta a requisição HTTP que está sendo feita.

                                 Inicializa a requisição HTTP

                                 Parâmetros:

                                                                ○ method - Uma cadeia de
                                                                     caracteres identificando
                                                                     o método/verbo HTTP
                                                                     utilizado nesta
                                                                     requisição. Os valores
                                                                     aceitos são:
                                                                                    ■ "GET"
                                                                                    ■ "POST"
                                                                                    ■ "PUT"
                                                                                    ■ "PATCH
                                                                                          "
                                                                                    ■ "TRACE
                                                                                          "
                                                                                    ■ "HEAD"
                                                                                    ■ "OPTIO
                                                                                          NS"
                   Observação:                      ■ "DELET
                                                         E"

                                ○ url - A URL da
                                     requisição HTTP

                                ○ O uso deste método não
                                     é obrigatório. É apenas
                                     um "doce" para aqueles
                                     que estão acostumados
                                     com a requisição HTTP
                                     do JavaScript.

Eventos            Descrição
   Nome do evento
   onResponse      Este evento é invocado quando a requisição HTTP concluir
                   sem erros. Após este evento, as propriedades de resposta
   onError         estarão disponíveis no objeto (como, por exemplo, status,
                   statusText, responseText, etc..).

                   Observação:

                                                  ○ Se o servidor retornar status
                                                       4xx (algum erro de requisição)
                                                       ou 5xx (algum erro do servidor),
                                                       o evento "onError" será
                                                       disparado ao invés de
                                                       "onResponse"

                   Este evento é disparado quando ocorrer um erro na
                   requisição HTTP.

                   Parâmetros:

                                                  ○ errorMsg - Uma cadeia de
                                                       caracteres contendo
                                                       informações sobre o erro.

                   Observação:

                                                  ○ Se o servidor retornar status
                                                       4xx (algum erro de requisição)
                                                       ou 5xx (algum erro do servidor),
                                                       o evento "onError" será
                                                       disparado ao invés de
                                                       "onResponse"
onReceiveProgress  Evento que é disparado frequentemente a fim de informar
onSendProgress     o progresso de download da requisição HTTP.

                   Parâmetros:

                                                  ○ currentBytes - Um número
                                                       indicando quantos bytes já
                                                       foram baixados

                                                  ○ maxBytes - Um número
                                                       indicando quantos bytes serão
                                                       baixados no final das contas.

                   Evento que é disparado frequentemente a fim de informar
                   o progresso de upload da requisição HTTP.

                   Parâmetros:

                                                  ○ currentBytes - Um número
                                                       indicando quantos bytes já
                                                       foram enviados.

                                                  ○ maxBytes - Um número
                                                       indicando quantos bytes serão
                                                       enviados no final das contas.

Exemplos

Exemplo 1 - Baixar o "index.html" de um site.

    require("internet.lua");

    local requisicao = internet.newHTTPRequest("GET",
    "http://www.rrpg.com.br/");

    requisicao.onResponse =
                   function()
                                 showMessage("Conteúdo: " .. requisicao.responseText);
                   end;

    requisicao.onError =
                   function(errorMsg)
                                 showMessage("Ops! Ocorreu algum erro: " .. errorMsg);
                   end;

    requisicao:send();
Exemplo 2 - Fazer um upload de um arquivo, receber outro arquivo, rastreando o progresso.

    require("internet.lua");
    require("vhd.lua");

local requisicao = internet.newHTTPRequest("POST",
"http://www.rrpg.com.br/REST_API/URL");

requisicao.onResponse =
              function()
                             local streamResposta = requisicao.responseStream;
                             local tipoRetornado = requisicao:getResponseHeader("Content-

Type");
                             local arquivoDestino;

"w+");        if tipoRetornado == "image/png" then
                            arquivoDestino = vhd.openFile("/baixado.png", "w+");

              else
                            arquivoDestino = vhd.openFile("/baixado.outraExtensao",

              end;

              arquivoDestino:copyFrom(streamResposta, streamResposta.size);
              arquivoDestino:close();

        end;

requisicao.onError =
              function(errorMsg)
                             showMessage("Ops! Ocorreu algum erro: " .. errorMsg);
              end;

requisicao.onSendProgress =
                             function(currentBytes, maxBytes)
                                           local porcentagem;

              if maxBytes ~= 0 then
                            porcentagem = (currentBytes / maxBytes) * 100;

              else
                            porcentagem = 0;

              end;
enviados                 --- porcentagem contém quantos % do arquivo já foram
           end;

requisicao.onReceiveProgress =
                             function(currentBytes, maxBytes)
                                           local porcentagem;

           if maxBytes ~= 0 then
                         porcentagem = (currentBytes / maxBytes) * 100;

           else
                         porcentagem = 0;

           end;

recebido.                --- porcentagem contém quantos % do arquivo já foi
           end;

local arquivoAEnviar = vhd.openFile("/arquivoExistente.png", "r");
requisicao:setRequestHeader("Content-Type", "image/png");
requisicao:send(arquivoAEnviar);
```
