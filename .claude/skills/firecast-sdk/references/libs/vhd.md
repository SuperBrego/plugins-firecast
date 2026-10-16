# Biblioteca vhd

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca VHD

       A biblioteca vhd provê funções para manipular o HD Virtual do plug-in, como ler um arquivo,
       excluir, etc...
       Todas as funções estão contidas na table/variável "VHD" da unidade "vhd.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "vhd.lua"
    require("vhd.lua");
    -- Agora é possível acessar as funções da biblioteca
    VHD.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca vhd

    function VHD.copyFile(srcFileName, dstFileName)

       Copy the file in the virtual HD
       Arguments:

                                 ○ srcFileName - String containing the path to the existing source file
                                 ○ dstFileName - String containing the path of the new file
       Remarks:
                                 ○ The paths are expanded using “vhd.expandFileName” before copying.
                                 ○ If the file “dstFileName” already exists, it will be replaced by the copied

                                      file.

    function VHD.expandFileName(shortFileName)

       Expande o nome curto de um arquivo a fim de ter sua localização em relação à raiz do HD
       virtual.
       Parâmetros:

                                 ○ shortFileName – o caminho encurtado de um arquivo a ser expandido.

       Retorno:
           Uma cadeia de caracteres, onde:
                                 ○ Se a cadeia de caracteres passada pelo parâmetro shortFileName
                                      iniciar com o caractere “/”, a função simplesmente retorna o valor
                                      passado no parâmetro (pois o nome do arquivo já está expandido, isto é,
                                      já está em relação à raiz do HD virtual).
                                 ○ Caso contrário, a função procura pelo arquivo dentro de cada um dos
                                      diretórios de pesquisa (SEARCH PATHs) que foram previamente
                                      registrados (ver descrição da função “vhd.addSearchPath”).
                                                      ■ Caso encontre dentro de algum dos diretórios de
                                                           pesquisa, a função retorna o caminho completo
                                                           (expandido, com relação à raiz do HD virtual) do
                                                           arquivo.
                                                      ■ Caso não encontre o arquivo, a função retorna o mesmo
                                                           valor passado pelo parâmetro shortFileName.
                             ○ Esta função leva em consideração os aliases registrados pela função
                                  VHD.registerAlias, traduzindo o apelido e retornando o nome real do
                                  arquivo.

function VHD.addSearchPath(directory)

   Adiciona um diretório à lista de "diretórios de pesquisa" (SEARCH PATH) do HD Virtual.
   Parâmetros:

                             ○ directory - cadeia de caracteres contendo o caminho expandido (isto é,
                                  em relação à raiz do HD Virtual) do diretório.

   A função "vhd.expandFileName" utiliza estes diretórios de pesquisas na hora de expandir o
   nome curto de um arquivo.

function VHD.removeSearchPath(directory)

   Remove um diretório da lista de "diretórios de pesquisa" (SEARCH PATH) que havia sido
   previamente registrado através a função "vhd.addSearchPath".
   Parâmetros:

                             ○ directory - cadeia de caracteres contendo o caminho expandido (isto é,
                                  em relação à raiz do HD Virtual) do diretório.

function VHD.registerAlias(aliases)

   Registra aliases/apelidos para arquivos no VHD.
   Parâmetros:

                             ○ aliases - uma tabela lua contendo os aliases, onde cada par de chave-
                                  valor da tabela representa:
                                                  ■ chave - uma cadeia de caracteres representando o
                                                       aliases/apelido a ser criado
                                                  ■ valor - o nome do arquivo no VHD que o alias deve
                                                       traduzir.

   Observações:
                             ○ O alias funciona com a função VHD.expandFileName e com a função
                                  require do Lua.
                             ○ O alias é case-sensitive, isto é, "myFile" é diferente de "MyFile".
                             ○ O alias não pode começar com o caracter "/". O nome traduzido pode
                                  começar com "/"

   Exemplo:
            local aliases = {};
            aliases["mylua"] = "init.lua";
            aliases["myFile2"] = "secondFile.lua";

            VHD.registerAlias(aliases);
            require("myFile2");

function VHD.fileExists(fileName)

   Verifica se um arquivo existe no HD virtual.
   Parâmetros:

                             ○ fileName - cadeia de caracteres contendo o caminho a verificar.
   Retorno:

       Retorna true caso o arquivo exista ou false se não existir.
   Observação:

       Esta função expande o nome do arquivo (através de "vhd.expandFileName") antes de
   realizar a verificação.

function VHD.directoryExists(path)

   Verifica se um diretório existe no HD virtual.
   Parâmetros:

                             ○ path - cadeia de caracteres contendo o caminho a verificar.
   Retorno:

       Retorna true caso o diretório exista ou false se não existir.
   Observação:

       Esta função expande o caminho (através de "vhd.expandFileName") antes de realizar a
   verificação.

function VHD.openFile(fileName [, mode])

   Esta função abre um arquivo do HD virtual no modo especificado.
   Parâmetros:
Retorno:      ○ fileName - cadeia de caracteres contendo o nome do arquivo a abrir.
Observações:  ○ (OPCIONAL) mode - cadeia de caracteres definindo o modo em que o

                   arquivo será aberto.Pode ser um dos seguintes valores:
                                  ■ "r" - modo somente leitura (padrão se omitido). A
                                       função falhará se o arquivo não existir.
                                  ■ "w" - modo escrita/leitura preservando o contendo do
                                       arquivo (se existir). Se o arquivo não existir, a função
                                       cria o arquivo.
                                  ■ "a" - modo append. Equivalente ao modo "w", porém o
                                       objeto stream retornado é posicionado no fim do
                                       arquivo.
                                  ■ "w+" - modo escrita/leitura, o conteúdo do arquivo é
                                       apagado se ele existir. Se o arquivo não existir, a função
                                       cria o arquivo.

              ○ Caso a função obtenha êxito, retorna um Objeto Stream representando
                   o conteúdo do arquivo. Qualquer alteração feita no objeto stream é
                   refletida no arquivo.

              ○ Caso a função falhe, retorna nil e a mensagem de erro.

              ○ Esta função expande o nome do arquivo (através de
                   "vhd.expandFileName") antes de realizar a abertura.

              ○ Para fechar o arquivo que foi aberto, você deve invocar o método close
                   do objeto stream retornado. Se o objeto stream for coletado pelo
                   coletor de lixo, o arquivo também é fechado automaticamente.

              ○ Exceto para o modo "a", o objeto stream retornado aponta para o inicio
                   do arquivo.

              ○ Apenas o modo "r" é aceito para abrir arquivos que originalmente
                   vieram no plug-in. Não é possível alterar o conteúdo destes arquivos

function VHD.forceDirectory(directoryPath)

Esta função cria, se necessário, um ou mais diretórios especificado por directoryPath no HD
virtual.

Parâmetros:

                         ○ directoryPath - cadeia de caracteres contendo o caminho do diretório
                               a ser "forçado".

Retorno:

                         ○ Caso o diretório já exista e não foi preciso fazer nada, a função retorna
                               false.

                         ○ Caso o diretório não existia e a função conseguiu criá-lo, retorna true.
                         ○ Caso o diretório não exista mas a função também não consiga criá-lo,

                               um erro é levantado.
Observações:

              ○ O valor de "directoryPath" deve ser um caminho absoluto no VHD (isto
                   é, deve começar com o caracter "/")

              ○ A criação de diretório ocorre de forma recursiva. Isto é, ao especificar
                   "/diretorioNaoExistente1/diretorioA/diretorioB", a função irá criar

                   "/diretorioNaoExistente1" primeiro, depois "diretorioA" dentro de

                   "/diretorioNaoExistente1/", e, por fim, "diretorioB" dentro de

                   "/diretorioNaoExistente1/diretorioA/".

function VHD.deleteFile(fileName)

   Esta função remove um arquivo do HD virtual.

   Parâmetros:

                             ○ fileName - cadeia de caracteres contendo o caminho do arquivo a ser
                                  excluído.

   Observações:

                             ○ Esta função expande o nome do arquivo (através de
                                  "vhd.expandFileName") antes de realizar a remoção.

                             ○ Esta função não pode ser usada para remover diretórios.
                             ○ Não é possível apagar um arquivo que originalmente veio no plug-in.

                                  Não é possível alterar o conteúdo destes arquivos

function VHD.deleteDirectory(directoryPath)

   Esta função remove um diretório e todo seu conteúdo do HD virtual.

   Parâmetros:

                             ○ directoryPath - cadeia de caracteres contendo o caminho do diretório
                                  que será excluído.

   Observações:

                             ○ Esta função expande o caminho do diretório (através de
                                  "vhd.expandFileName") antes de realizar a remoção.

                             ○ Não é possível apagar um arquivo que originalmente veio no plug-in.
                                  Não é possível alterar o conteúdo destes arquivos.

                             ○ Esta função apaga o diretório e todo seu conteúdo recursivamente.

function VHD.enumerateContent(directoryPath)

Esta função retorna quais arquivos e diretórios estão dentro de um diretório no HD Virtual.
Parâmetros:
Retorno:      ○ directoryPath - cadeia de caracteres contendo o caminho do diretório
Observações:       que terá seu conteúdo enumerado.

              ○ Se "directoryPath" não conter um caminho válido de diretório, um erro
                   será lançado.

              ○ Senão, um array de strings será retornado, onde cada posição do
                   arranjo contém o nome do diretório/arquivo.

              ○ Esta função expande o caminho de directoryPath (através de
                   "vhd.expandFileName") antes de realizar a enumeração..

              ○ Esta função não enumera o conteúdo de forma recursiva. Isto é, se
                   existirem sub-diretórios, seus conteúdos não serão enumerados neste
                   retorno, apenas os itens que estão diretamente dentro de
                   "directoryPath".

              ○ O texto retornado no arranjo contém o nome do arquivo/diretório sem
                   incluir "barras" ou outra forma de expressar o diretório que se
                   encontra.
                                  ■ Exemplo: Se existirem dois arquivos (a.txt e b.txt) e um
                                       subdiretório ("/textos/histórias/") na pasta "/textos/", o
                                       retorno será:
                                                       ● {'a.txt', 'b.txt', 'histórias'}

              ○ Para saber se um item do arranjo retornado é diretório ou é arquivo,
                   utilize as funções VHD.fileExists e VHD.directoryExists
MACROS

  Macros são atalhos criados pelo usuário para comandos/textos que são repetidos frequentemente.
  Por exemplo: Se o personagem de D&D do usuário possui um ataque padrão, é conveniente criar
  uma macro de nome, digamos, "ataque" que faz:

        /r 1d20 + 5: Rolagem do
        Ataque
        /r 1d8 + 5: Rolagem do Dano

  Quando o usuário digitar "/ataque" no chat do RRPG, estes comandos serão executados.

Criando e editando suas macros

  digite "/macros" no chat do RRPG para abrir o gerenciador de macros!

Tipos de macros

  Existem dois tipos de macros no RRPG:
            ● Macros Simples
            ● Macros em Lua

  A macros simples contém comandos que são enviados para o chat, linha a linha. São extremamente
  fáceis e intuitivas de serem feitas, porém são limitadas.
  As macros em Lua contém código de programação Lua e requerem um pouco de conhecimento de
  programação, porem são flexíveis!
```
