# Biblioteca firedrive

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca FireDrive

       A biblioteca fireDrive provê funções para manipular e gerenciar o fireDrive do usuário. O
       FireDrive é um recurso do Firecast que permite armazenar arquivos na nuvem, compartilhar e
       utilizar arquivos compartilhados por outros usuários.
       Todas as funções estão contidas na table/variável "FireDrive" da unidade "fireDrive.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "fireDrive.lua"
    require("fireDrive.lua");

    -- Agora é possível acessar as funções da biblioteca
    FireDrive.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Estrutura FireDriveItem

  Algumas funções desta biblioteca retornam um ou mais FireDriveItem(s). Um FireDriveItem é
  tabela lua contém detalhes de um arquivo/diretório existente no FireDrive do usuário.
  O FireDriveItem é uma tabela Lua que contém as seguintes propriedades/atributos:

                                 ○ id - Número que identifica unicamente este item.
                                 ○ name - Cadeia de caracteres contendo o nome do arquivo/diretório. Se

                                      o caminho do arquivo for "/diretorio/subpasta/arquivo.txt", esta
                                      propriedade conterá "arquivo.txt"
                                 ○ isDir - Um booleano, onde true significa que o item é um diretório e
                                      false significa que o item é um arquivo.
                                 ○ kind - Uma cadeia de caracteres que identifica o tipo deste item. Pode
                                      conter um dos seguintes valores:

                                                      ■ "dir" - Um diretório
                                                      ■ "file" - Um arquivo simples
                                                      ■ "plugin" - Um arquivo de plug-in
                                 ○ parentId - Id único que identifica em qual diretório este item se
                                      encontra. Se o arquivo estiver na raiz do FireDrive (exemplo:
                                      "/arquivo.txt"), este atributo contém nil.
                                 ○ size - Número identificando quantos bytes este arquivo ocupa no
                                      FireDrive do usuário.
                                 ○ isShared - Booleano, onde true significa que este item está
                                      compartilhado com todos do Firecast, ou false significando que o item
                                      não está acessível para outros.
                                 ○ isMine - Booleano, onde true significa que o usuário criou o item, e false
                                      significa que o item foi criado por outra pessoa e foi importado.

                                 ○ sharedId - Número que identifica este item unicamente e globalmente
                                      no Firecast. É utilizado para compartilhar arquivos com outras pessoas
                                      do programa.

                                 ○ keyWords - Cadeia de caracteres contendo as palavras chaves do item
                                 ○ description - Cadeia de caracteres contendo a descrição do item
                                 ○ url - Se for um arquivo, contém a URL para baixar seus dados.
                                 ○ mimeType - Se for um arquivo, contém o MIME/Content-Type do

                                      arquivo. (Exemplos: "image/jpeg", "image/png", "text/plain", etc..);
                                 ○ urlThumb64 - Se preenchido, contém A URL de uma imagem thumbnail

                                      do item. Este thumbnail cabe em quadrado de 64x64 de forma a manter
                                      o aspecto da imagem.

Funções da biblioteca FireDrive

    function FireDrive.getFiles(directory[, callback[, failureCallback]])

       Obtém a lista de arquivos e diretórios que estão dentro de uma pasta no FireDrive do usuário.

       Parâmetros:

                                 ○ directory - Uma cadeia de caracteres contendo um caminho de uma
                                      pasta que existe no FireDrive do usuário. O conteúdo desta pasta será
                                      enumerada. Exemplos:
                                                      ■ Se quiser enumerar o conteúdo da raiz do FireDrive,
                                                           utilize "/"
                                                      ■ Se quiser enumerar o conteúdo da pasta "imagens",
                                                           utilize "/imagens".
                                                      ■ Se quiser enumerar o conteúdo da subpasta
                                                           "medievais" da pasta "imagens", utilize
                                                           "/imagens/medievais"

                                 ○ (OPCIONAL) callback - uma função que será chamada quando a lista de
                                      arquivos/diretórios tiver sido obtida com sucesso. Esta função recebe
                                      em seu primeiro parâmetro um arranjo de FireDriveItem

                                 ○ (OPCIONAL) failureCallback - uma função que será chamada quando a
                                      lista de arquivos/diretórios não puder ser obtida. Ela recebe em seu
                                      primeiro parâmetro o motivo da falha.

       Observações:

                                 ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                      LUA continua sua execução normal enquanto a comunicação com o
                                      servidor é feita em segundo plano. Se quiser obter o resultado, você
                                      deve informar uma função "callback" que será chamada quando a
                                      operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

function FireDrive.refresh([, callback[, failureCallback]])

   Durante a execução, o FireDrive mantém algumas informações em cache na memória, como a
   lista dos arquivos de cada pasta do FireDrive. Esta função força a atualização destas
   informações que estão guardas em cache na memória.

   Parâmetros:

                             ○ (OPCIONAL) callback - uma função que será chamada quando a
                                  atualização tiver sido executada com sucesso.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada quando a
                                  atualização falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

   Observações:

                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "callback" que será chamada quando a
                                  operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

function FireDrive.getFileInfo(fileName[, callback[, failureCallback]])

   Obtém informações de um arquivo ou diretório existente no FireDrive do usuário.

   Parâmetros:

                             ○ fileName - Uma cadeia de caracteres contendo o caminho de um
                                  arquivo/diretório que existe no FireDrive do usuário. Serão retornadas
                                  as informações deste arquivo.

                             ○ (OPCIONAL) callback - uma função que será chamada quando as
                                  informações tiverem sido obtidas com sucesso. Esta função recebe em
                                  seu primeiro parâmetro um FireDriveItem com as informações do
                                  arquivo ou nil caso não exista.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                                  operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

   Observações:
                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "callback" que será chamada quando a
                                  operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

function FireDrive.upload(destFileName, stream[, successCallback[,

progressCallback[, failureCallback[, mimeType]]]])

   Efetua o upload de um conteúdo/arquivo para o FireDrive do usuário.

   Parâmetros:

                             ○ destFileName - Uma cadeia de caracteres contendo o caminho de um
                                  arquivo no FireDrive do usuário onde os dados serão salvos.

                             ○ stream - Um objeto Stream contendo os dados que serão enviados e
                                  salvos no servidor.

                             ○ (OPCIONAL) successCallback - uma função que será chamada quando
                                  o upload tiver sido feito com sucesso. Esta função recebe em seu
                                  primeiro parâmetro um FireDriveItem com as informações do arquivo
                                  no servidor.

                             ○ (OPCIONAL) progressCallback - uma função que será chamada de
                                  tempos em tempos informando o progresso do envio do arquivo. A
                                  função recebe 2 parâmetros: currentBytes e maxBytes, representando,
                                  respectivamente, quantos bytes já foram enviados e quantos bytes
                                  serão enviados no final das contas.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                                  operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

                             ○ (OPCIONAL) mimeType - Uma cadeia de caracteres contendo o
                                  mimeType/contentType do dados. Exemplos: "image/jpeg",
                                  "image/png", "text/plain", etc... Se não informado, o fireDrive
                                  automaticamente definirá o mimeType com base na extensão do
                                  arquivo destino.

   Observações:

                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "successCallback" que será chamada quando
                                  a operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

                             ○ Se o arquivo já existir no FireDrive do usuário, esta função sobrescreve
                                  seu conteúdo e não reporta falha.

function FireDrive.quickUpload(suggestedFileName, mimeType, stream[,
successCallback[, progressCallback[, failureCallback]]])

   Efetua o upload de um conteúdo/arquivo para o FireDrive do Firecast de forma descomplicada
   que será armazenado temporariamente.

   Parâmetros:

                             ○ suggestedFileName - Uma cadeia de caracteres contendo uma
                                  sugestão de nome de arquivo para ser armazenado.
                                           Pode ser nil: neste caso, o FireDrive criará um nome aleatório
                                  para o upload.

                             ○ mimeType - Uma cadeia de caracteres contendo o
                                  mimeType/contentType do dados. Exemplos: "image/jpeg",
                                  "image/png", "text/plain", etc...
                                           Pode ser passado nil como parâmetro: Neste caso, o fireDrive
                                  automaticamente definirá o mimeType com base na extensão de
                                  "suggestedFileName".

                             ○ stream - Um objeto Stream contendo os dados que serão enviados e
                                  salvos no servidor.

                             ○ (OPCIONAL) successCallback - uma função que será chamada quando
                                  o upload tiver sido feito com sucesso. Esta função recebe em seu
                                  primeiro parâmetro um FireDriveItem com as informações do arquivo
                                  no servidor.

                             ○ (OPCIONAL) progressCallback - uma função que será chamada de
                                  tempos em tempos informando o progresso do envio do arquivo. A
                                  função recebe 2 parâmetros: currentBytes e maxBytes, representando,
                                  respectivamente, quantos bytes já foram enviados e quantos bytes
                                  serão enviados no final das contas.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                                  operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

   Observações:

                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "successCallback" que será chamada quando
                                  a operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

                             ○ O upload é armazenado em um espaço temporário do Firecast. Ele não
                                  será visto na pasta FireDrive do usuário.

                             ○ Lembre-se: Este upload tem características temporárias. O Firecast
                                  poderá excluir o upload, sem aviso prévio, após algum tempo.

                             ○ Não é possível fazer o upload se ambos os parâmetros
                                  "suggestedFileName" e "mimeType" não forem informados corretamente.
                                  Ao menos um deles deve ser informado corretamente.

function FireDrive.createDirectory(directoryName, [, callback[,
failureCallback]])

   Cria um diretório no FireDrive do usuário.

   Parâmetros:

                             ○ directoryName - Uma cadeia de caracteres contendo o caminho do
                                  diretório que será criado no FireDrive do usuário.

                             ○ (OPCIONAL) callback - uma função que será chamada quando o
                                  diretório tiver sido criado com sucesso. Esta função recebe em seu
                                  primeiro parâmetro um FireDriveItem com as informações do diretório
                                  no servidor.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                                  operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

   Observações:

                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "callback" que será chamada quando a
                                  operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

                             ○ Se o diretório já existir no FireDrive do usuário, ele é preservado no
                                  servidor sem alterações e a função "callback" é invocada sinalizando
                                  êxito.

function FireDrive.delete(destFileName, [, callback[, failureCallback]])

   Exclui um arquivo ou diretório do FireDrive do usuário.

   Parâmetros:

                             ○ destFileName - Uma cadeia de caracteres contendo o caminho do
                                  arquivo ou diretório existente no FireDrive do usuário que será
                                  removido;

                             ○ (OPCIONAL) callback - uma função que será chamada quando a
                                  operação tiver sido realizada com sucesso.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                                  operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

   Observações:

                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "callback" que será chamada quando a
                                  operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.
                             ○ Se for removido um diretório, todo seu conteúdo, pastas e sub-pastas
                                  serão excluídos juntos com esta operação.

function FireDrive.rename(existingFileName, newFileName [, callback[,

failureCallback]])

   Renomeia/move um arquivo ou diretório do FireDrive do usuário.

   Parâmetros:

                             ○ existingFileName - Uma cadeia de caracteres contendo o caminho do
                                  arquivo ou diretório existente no FireDrive do usuário que será
                                  renomeado/movido;

                             ○ newFileName - Uma cadeia de caracteres contendo o novo caminho do
                                  arquivo/diretório. Este parâmetro deve conter o novo caminho
                                  completo do arquivo/diretório.

                             ○ (OPCIONAL) callback - uma função que será chamada quando a
                                  operação tiver sido realizada com sucesso.

                             ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                                  operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                                  falha.

   Observações:

                             ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                                  LUA continua sua execução normal enquanto a comunicação com o
                                  servidor é feita em segundo plano. Se quiser obter o resultado, você
                                  deve informar uma função "callback" que será chamada quando a
                                  operação em segundo plano for bem sucedida. Se quiser tratar erros,
                                  você deve informar uma função "failureCallback" que será chamada
                                  quando alguma falha ocorrer.

                             ○ O valor "newFileName" deve conter o novo caminho completo do
                                  arquivo. É possível mover o arquivo através deste método, basta
                                  especificar uma outra pasta para o parâmetro "newFileName",
                                  exemplo: existingFileName="/pasta1/x.txt" e
                                  newFileName="/nova_pasta/x.txt".

function FireDrive.getSpaceInfo(callback[, failureCallback]);

   Retorna as informações de espaço do FireDrive do usuário.

   Parâmetros:

                             ○ callback - Uma função que será invocada quando as informações de
                                  espaço do FireDrive forem obtidas. A função recebe em seu primeiro
                                  parâmetro uma tabela Lua com as seguintes propriedades:
Observações:                      ■ used - Quantidade de bytes usados no armazenamento
                                       do FireDrive do usuário

                                  ■ total - Quantidade total de bytes que o usuário pode
                                       armazenar no FireDrive.

              ○ (OPCIONAL) failureCallback - uma função que será chamada se a
                   operação falhar. Ela recebe em seu primeiro parâmetro o motivo da
                   falha.

              ○ Esta função é assíncrona, isto é, ela retorna imediatamente e o código
                   LUA continua sua execução normal enquanto a comunicação com o
                   servidor é feita em segundo plano. Se quiser obter o resultado, você
                   deve informar uma função "callback" que será chamada quando a
                   operação em segundo plano for bem sucedida. Se quiser tratar erros,
                   você deve informar uma função "failureCallback" que será chamada
                   quando alguma falha ocorrer.
```
