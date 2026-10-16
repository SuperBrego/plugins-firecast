# Biblioteca system

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca System

       Biblioteca que contém funções para lidar com o dispositivo do usuário e outras funcionalidades
       básicas.
       Todas as funções estão contidas na unidade "system.lua".
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "system.lua"
    require("system.lua");

    -- Agora é possível acessar as funções da biblioteca
    System.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca System

    function System.setClipboardText(text)

       Altera o conteúdo do Clipboard/Área de Transferência do sistema operacional (ctrl+c).
       Parâmetros:
Retorno:  ○ text - Cadeia de caracteres contendo o novo conteúdo que será
               colocado no Clipboard do usuário.

          ○ Caso consiga alterar o conteúdo do clipboard, retorna true, senão
               retorna false.

function System.getClipboardText()

   Retorna o conteúdo do Clibpboard/Área de Transferência do sistema operacional (ctrl+c)
   Retorno:

                             ○ Uma cadeia de caracteres caso haja um texto no clipboard ou nil.

function System.readClipboardAsDragNDrop(callback, [options])

Read the device clipboard as a drag-and-drop operation. Helpful to read multiple clipboard
formats (such as files and images).

Parameters:

                         ○ callback - a function that will be called to handle the drag-and-drop
                               operation. The callback will receive the following parameters:
                                              ■ drop - The Drop Object that you must fill in the
                                                   information so Firecast can match the drag to the drop.
                                              ■ x - The number passed in "options.x" or 0
                                              ■ y - The number passed in "options.y" or 0
                                              ■ drag - The Drag Object representing the clipboard data.
                                                   You must not change the properties of this object.

                         ○ (Optional) options - a table that may contain the following attributes:
                                              ■ (Optional) x -The "x" position that the callback function
                                                   will receive
                                              ■ (Optional) y -The "y" position that the callback function
                                                   will receive.

Returns:

                         ○ true if the operation had a match or false instead.

Remarks:

                         ○ The callback function is called immediately. The drag object is valid only
                               inside the callback execution.

                         ○ The drag and drop operation works exactly in the same way the
                               onStartDrop event that all visual tags have.

                         ○ Please read Dragging and Dropping Information to learn more about
                               the drag-and-drop process.
function System.getScreenSize()

   Retorna as dimensões da tela do dispositivo do usuário.
   Retorno:

                             ○ Retorna dois números: largura e altura da tela em pontos lógicos.
   Exemplo:

          local largura, altura =
          system.getScreenSize();

function System.isMobile()

   Retorna se o plugin está rodando no Firecast Mobile.
   Retorno:

                             ○ Retorna true se o plugin está rodando no App do FireCastMobile ou
                                  false se está rodando no RRPG de computador

function System.getTickCount()

    Retorna um número contendo há quantos milisegundos o dispositivo do usuário está ligado.
    Ótimo para calcular o tempo decorrido entre operações.

SDK3 API Version Functions

Version history  Minor      Description
   Major

87               0          SDK 3.6 (Firecast 8+)

87               1          SDK 3.6b (Firecast 8.5+)

87               2          SDK 3.6c (Firecast 8.6+)

87               3          SDK 3.6d (Firecast 8.8+)
87  4  SDK 3.6e (Firecast 8.11+)

88  0  SDK 3.7 (Firecast 8.12+)

Identical major versions possess compatibility with each other.

For example, you can compile a plugin using SDK3.6b (87.1), and it will still run fine on an SDK 3.6
(87.0) running API because the two have the same major version.

function System.checkAPIVersion(major, [minor])

   Checks if the current running SDK3 API version is greater or equal to a specific version.
   Parameters:

                             ○ major - The major version integer to check.
                             ○ (Optional) minor - The minor version integer to check. When omitted, 0

                                  is used by default
   Returns:

                             ○ true if the current running SDK3 API version is greater or equal to the
                                  specified version; false otherwise.

   Remarks:
                             ○ You may want to check the SDK3 API version history.

function System.getAPIVersion()

   Gets the current running SDK3 API version.
   Returns:

                             ○ An integer number in the same format returned by the function
                                  System.makeAPIVersionNumber

   Remarks:
                             ○ You may want to check the SDK3 API version history.

function System.makeAPIVersionNumber(major, [minor])

    Make an API version integer number that you can use to compare versions.
    Parameters:

                             ○ major - The major version integer
Returns:  ○ (Optional) minor - The minor version integer. When omitted, 0 is used
Remarks:       by default

          ○ An integer number. It's a 32 bits where the upper 16 bits contain the
               major version, and the lower 16 bits hold the minor version.

          ○ You may want to check the SDK3 API version history.
```
